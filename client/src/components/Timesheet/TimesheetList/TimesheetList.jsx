import React, { useEffect, useState } from "react";
import styles from "rootpath/components/Timesheet/TimesheetList/TimesheetList.css";
import { Autocomplete, TextField, Chip } from "@mui/material";
import "react-day-picker/dist/style.css";
import { validationInput } from "rootpath/components/SkillMatrix/commonValidationFunction";
import debounce from "lodash.debounce";
import {
    alertSuccess,
    alertError,
    approved,
    pending,
    rejected,
    employee,
    timesheet_failed_error,
    timesheet_approved_success,
    timesheet_reject_success,
    admin
} from "rootpath/components/Timesheet/Constants";
import { getTitleText } from "rootpath/services/Timesheet2.0/TimesheetService";
import TimesheetListTableContainer from "rootpath/components/Timesheet/TimesheetListTable/TimesheetListTableContainer";
import ModalDialogContainer from "../ModalDialog/ModalDialogContainer";
import CustomAlert from "rootpath/components/CustomAlert";
import { formatDate } from "rootpath/services/TimeSheet/TimesheetDataService";

const TimesheetList = ({
    clients,
    fetchClientList,
    fetchTimesheetStatusWise,
    timesheet,
    status,
    userRole,
    updateTimesheetStatusByReviewer,
    setTimesheetId,
    selectedTimesheetClientArray,
    approverPending,
    startDate,
    endDate,
    selectedTimesheetClients,
    setSelectedClients,
    searchedText,
    setDateOnLoad,
    setSkipRows,
    handleClientChange,
    setSelectedTimesheetList,
    selectedTimesheetlist,
    setCheckboxState,
    setCheckboxStatus,
    checkboxState,
    handleModalOpen,
    handleModalClose,
    setTimesheetForDelete,
    setRemarks,
    remarks,
    timesheetForAction,
    setErrorMessage,
    setShowAlert,
    emptyTimesheet,
    alert,
    fetchManagerAndApprover,
    managerAndApprover
}) => {
    const [data, setData] = useState([]);
    const [isDetailPanel, setIsDetailPanel] = useState(true);
    const [loading, setLoading] = useState(false);
    const [showSelfRecordsOnly, setShowSelfRecordsOnly] = useState(false);

    const toggleSelfAndAdminRecords = event => {
        setShowSelfRecordsOnly(event.target.checked);
        fetchTimesheet(
            selectedTimesheetClients,
            startDate,
            endDate,
            searchedText,
            0,
            event.target.checked
        );
    };
    const handleTitleCheckboxChange = currentVal => {
        if (data.length > 0) {
            if (currentVal) {
                setCheckboxState([]);
                setSelectedTimesheetList([]);
                setCheckboxStatus(false);
            } else {
                setCheckboxState([]);
                const updatedCheckboxStates = [...checkboxState];
                setCheckboxStatus(true);
                data.forEach(rowData => {
                    handleCheckboxChange(
                        rowData.timesheetId,
                        updatedCheckboxStates
                    );
                });
            }
        }
    };
    const debouncedSetRemarks = debounce(value => {
        setRemarks(value);
    });
    const handleCheckboxChange = (index, selectAllCheckboxStates) => {
        const updatedCheckboxStates = selectAllCheckboxStates ?? [
            ...checkboxState
        ];
        updatedCheckboxStates[index] = !updatedCheckboxStates[index];
        setCheckboxState(updatedCheckboxStates);
        const filteredRow = Object.fromEntries(
            Object.entries(updatedCheckboxStates).filter(
                ([key, value]) => value !== undefined
            )
        );
        const checkList = Object.keys(filteredRow);
        let selectedList = [];
        checkList.map(item => {
            if (filteredRow[item]) {
                selectedList = [item, ...selectedList];
            }
        });
        if (data.length > 0 && selectedList.length === data.length) {
            setCheckboxStatus(true);
        } else if (selectedList.length === 0) {
            setCheckboxStatus(false);
        }
        setSelectedTimesheetList(selectedList);
    };
    const handleRejectConfirm = () => {
        const selectedTimesheet = [];
        selectedTimesheet.push(timesheetForAction.timesheetId);
        var validation = validationInput("Remarks", remarks.trim());
        if (validation.length === 0) {
            updateTimesheet(rejected, selectedTimesheet, data);
        } else {
            setErrorMessage(validation);
            setTimeout(() => {
                setErrorMessage([]);
            }, 3000);
        }
    };
    const handleSingleTimesheetApproveOrReject = (
        status,
        rowData,
        data,
        remarks
    ) => {
        const selectedTimesheet = [];
        selectedTimesheet.push(rowData.timesheetId);
        updateTimesheet(status, selectedTimesheet, data);
    };
    useEffect(() => {
        setIsDetailPanel(true);
        fetchClientList();
        setDateOnLoad(userRole);
        return () => {
            setTimesheetId(0);
            emptyTimesheet();
            setShowAlert(false);
        };
    }, [fetchClientList]);

    useEffect(() => {
        if (clients.length > 0) {
            setSelectedClients(clients || "");
        }
    }, [clients]);

    useEffect(() => {
        userRole && fetchManagerAndApprover(userRole.employeeId);
    }, [userRole]);

    useEffect(() => {
        setData(timesheet);
        setCheckboxState([]);
        setSelectedTimesheetList([]);
        setCheckboxStatus(false);
    }, [timesheet]);

    useEffect(() => {
        if (selectedTimesheetClients.length > 0) {
            startDate &&
                endDate &&
                fetchTimesheet(
                    selectedTimesheetClients,
                    startDate,
                    endDate,
                    searchedText,
                    0,
                    showSelfRecordsOnly
                );
            setSkipRows(0);
        }
    }, [startDate, endDate, selectedTimesheetClients, status, approverPending]);

    const fetchTimesheet = (
        clientId,
        startDate,
        endDate,
        searchedText,
        skipRows,
        toggleSelfRecords
    ) => {
        const data = {
            clientId: clientId,
            status: status,
            startDate: formatDate(startDate),
            endDate: formatDate(endDate),
            isApproverPending: approverPending,
            searchedText: searchedText,
            skipRows: skipRows,
            showSelfRecordsToggle: toggleSelfRecords
        };
        fetchTimesheetStatusWise(data);
    };

    const handleChange = (event, selectedClient) => {
        handleClientChange(selectedClient);
    };

    const handleApproveOrReject = status => {
        var validation = validationInput("Remarks", remarks);
        if (status === rejected && validation.length !== 0) {
            setErrorMessage(validation);
            setTimeout(() => {
                setErrorMessage([]);
            }, 3000);
            return;
        }
        updateTimesheet(status, selectedTimesheetlist, data);
    };
    const updateTimesheet = async (status, list, data) => {
        const result = await updateTimesheetStatusByReviewer(
            status,
            list,
            data,
            remarks
        );
        if (result) {
            setShowAlert(
                true,
                status === approved ? alertSuccess : alertError,
                status === approved
                    ? timesheet_approved_success
                    : timesheet_reject_success
            );
        } else {
            setShowAlert(true, alertError, timesheet_failed_error);
            return;
        }
        window.scrollTo(0, 0);
        handleClose();
        fetchTimesheet(
            selectedTimesheetClients,
            startDate,
            endDate,
            searchedText,
            0,
            showSelfRecordsOnly
        );
    };
    const handleClose = () => {
        handleModalClose();
        setTimesheetForDelete({});
        setSelectedTimesheetList([]);
        setCheckboxState([]);
        setCheckboxStatus(false);
        setRemarks("");
        setSkipRows(0);
    };
    const titleText = getTitleText(status, userRole, approverPending);

    return (
        <div
            className={"container " + styles.container}
            style={{ padding: "0px" }}
        >
            {alert.setAlertOpen && Object.keys(alert).length > 0 && (
                <CustomAlert
                    open={alert.setAlertOpen}
                    severity={alert.severity}
                    message={alert.message}
                    className={styles.alertStyle}
                    onClose={() => setShowAlert(false, "", "")}
                ></CustomAlert>
            )}

            <div className={styles.contentHeader}>
                <div title={titleText} className={styles.title}>
                    {titleText}
                </div>
                {userRole && userRole.roleName !== admin && approverPending && (
                    <div className={styles.name}>
                        Manager Name :
                        {managerAndApprover?.length &&
                            managerAndApprover[0]?.timesheetManagerName}
                    </div>
                )}
                {userRole && userRole.roleName !== admin && approverPending && (
                    <div className={styles.name}>
                        Approver Name :
                        {managerAndApprover?.length &&
                            managerAndApprover[0]?.timesheetApproverName}
                    </div>
                )}
                {userRole &&
                    userRole.roleName === admin &&
                    !approverPending &&
                    clients && (
                        <div className={styles.clientContainer}>
                            <label
                                key={"client_" + clients.id}
                                className={styles.clientLabel}
                            >
                                Select Client:{" "}
                            </label>
                            <Autocomplete
                                limitTags={3}
                                key={status}
                                size="small"
                                sx={{ width: "500px" }}
                                multiple
                                id="tags-outlined"
                                options={clients}
                                renderTags={(value, getTagProps) =>
                                    value.map((option, index) => (
                                        <Chip
                                            key={option.id}
                                            label={option.clientName}
                                            {...getTagProps({ index })}
                                            sx={{
                                                backgroundColor:
                                                    "#D3D3D3 !important",
                                                marginRight: 1,
                                                borderRadius: "25px !important"
                                            }}
                                        />
                                    ))
                                }
                                value={selectedTimesheetClientArray}
                                getOptionLabel={option => option.clientName}
                                onChange={handleChange}
                                filterSelectedOptions
                                renderInput={params => (
                                    <TextField {...params} />
                                )}
                            />
                        </div>
                    )}
            </div>
            <div>
                <div className={styles.containerTable}>
                    <TimesheetListTableContainer
                        setLoading={setLoading}
                        loading={loading}
                        status={status}
                        approverPending={approverPending}
                        data={data}
                        handleTitleCheckboxChange={handleTitleCheckboxChange}
                        handleCheckboxChange={handleCheckboxChange}
                        isDetailPanel={isDetailPanel}
                        setIsDetailPanel={setIsDetailPanel}
                        handleOpen={handleModalOpen}
                        handleSingleTimesheetApproveOrReject={
                            handleSingleTimesheetApproveOrReject
                        }
                        remarks={remarks}
                        showSelfRecordsOnly={showSelfRecordsOnly}
                        toggleSelfAndAdminRecords={toggleSelfAndAdminRecords}
                    />
                </div>
            </div>
            {userRole.roleName !== employee &&
                (status === pending || status === approved) &&
                selectedTimesheetlist.length > 0 &&
                !approverPending && (
                    <div className={styles.footer}>
                        <button
                            disabled={selectedTimesheetlist.length === 0}
                            onClick={handleModalOpen}
                            className={"btn btn-danger " + styles.rejectButton}
                        >
                            Reject
                        </button>
                        {status !== approved && (
                            <button
                                disabled={selectedTimesheetlist.length === 0}
                                onClick={() => handleApproveOrReject(approved)}
                                className={
                                    "btn btn-primary " + styles.approveButton
                                }
                            >
                                Approve
                            </button>
                        )}
                    </div>
                )}
            <ModalDialogContainer
                debouncedSetRemarks={debouncedSetRemarks}
                handleClose={handleClose}
                handleRejectConfirm={
                    Object.keys(timesheetForAction).length > 0
                        ? handleRejectConfirm
                        : handleApproveOrReject
                }
            />
        </div>
    );
};

export default TimesheetList;
