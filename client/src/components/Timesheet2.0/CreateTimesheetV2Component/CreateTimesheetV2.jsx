import React, { useCallback, useEffect, useState } from "react";
import styles from "rootpath/components/Timesheet2.0/ViewTimesheetComponent/ViewTimesheet.css";
import {
    onComponentRender,
    onCancel,
    onDelete,
    onSave,
    onChange,
    onAddRow,
    onSubCategoryChange,
    onCategoryChange,
    onProjectChange
} from "rootpath/services/Timesheet2.0/CreateTimesheetService";
import CustomAlert from "rootpath/components/CustomAlert";
import debounce from "lodash.debounce";
import { Table, TableBody, TableContainer, TableHead } from "@material-ui/core";
import Box from "@mui/material/Box";
import {
    tableHeader,
    tableRowForSum
} from "rootpath/components/Timesheet2.0/CreateTimesheetV2Component/CreateConstants";
import CreateEditToolbar from "rootpath/components/Timesheet2.0/Common/CreateEditToolbar";
import CreateTimesheetV2Rows from "rootpath/components/Timesheet2.0/CreateTimesheetV2Component/CreateTimesheetV2Rows";
import { calculateDaySums } from "rootpath/services/Timesheet2.0/TimesheetService";
const CreateTimesheetV2 = ({
    employeeProject,
    timesheetCategories,
    timesheetSubCategories,
    selectedWeek,
    saveTimesheet,
    enabledStartDate,
    enabledEndDate,
    disableDates,
    handleDayClick,
    toggleCalenderDisplay,
    setToggleCalenderDisplay,
    isEditMode,
    handleCancelClick,
    showAlert,
    setShowAlert,
    modifiers,
    fetchManagerAndApprover,
    managerAndApprover,
    userRole,
    fetchRole
}) => {
    const [data, setData] = useState([]);
    const [selectedCategories, setSelectedCategories] = useState("");
    const [selectedSubcategories, setSelectedSubcategories] = useState("");
    const [showSaveCancel, setShowSaveCancel] = useState(false);
    const [errors, setErrors] = useState([]);
    const [duplicateErrors, setDuplicateErrors] = useState([]);

    useEffect(() => {
        if (
            timesheetCategories.length &&
            timesheetSubCategories.length &&
            employeeProject.length
        ) {
            onComponentRender(
                employeeProject,
                timesheetCategories,
                timesheetSubCategories,
                [],
                setData,
                setErrors,
                setDuplicateErrors,
                setSelectedCategories,
                setSelectedSubcategories
            );
        }
    }, [
        timesheetCategories,
        timesheetSubCategories,
        employeeProject,
        selectedWeek
    ]);

    useEffect(() => {
        fetchRole();
    }, [fetchRole]);

    useEffect(() => {
        userRole && fetchManagerAndApprover(userRole.employeeId);
    }, [userRole]);

    const debouncedTaskDescriptionChange = (value, id, index) => {
        debouncedHandleChange(id, "taskDescription", value, index);
    };
    const debouncedHandleChange = debounce((id, field, value, index) => {
        handleChange(id, field, value, index);
    });
    const debouncedHourChange = (event, id, day, index) => {
        const value = event.target.value;
        debouncedHandleChange(id, day, value, index);
    };

    const handleChange = (id, field, value, index) => {
        onChange(
            id,
            field,
            value,
            index,
            employeeProject,
            timesheetCategories,
            timesheetSubCategories,
            data,
            setSelectedCategories,
            setSelectedSubcategories,
            setShowSaveCancel,
            setData,
            setErrors,
            setDuplicateErrors,
            duplicateErrors,
            errors
        );
    };
    const handleProjectChange = useCallback(
        (event, id) => {
            onProjectChange(event, id, data, setData);
        },
        [data]
    );
    const handleCategoryChange = useCallback(
        (event, id, index) => {
            onCategoryChange(
                event,
                id,
                index,
                data,
                setData,
                setSelectedSubcategories,
                setSelectedCategories,
                timesheetSubCategories
            );
        },
        [timesheetCategories, timesheetSubCategories, data]
    );

    const handleSubCategoryChange = useCallback(
        (e, id, index) => {
            onSubCategoryChange(
                e,
                id,
                index,
                data,
                setData,
                setSelectedSubcategories
            );
        },
        [timesheetSubCategories, data]
    );
    const handleAddRow = () => {
        onAddRow(
            employeeProject,
            timesheetCategories,
            timesheetSubCategories,
            data,
            setData,
            setSelectedCategories,
            setSelectedSubcategories,
            setErrors
        );
    };

    const daySums = calculateDaySums(data);

    const handleSave = () => {
        onSave(
            setDuplicateErrors,
            setErrors,
            saveTimesheet,
            data,
            selectedWeek,
            isEditMode,
            handleCancelClick,
            daySums
        );
    };
    const handleCancel = () => {
        onCancel(
            employeeProject,
            timesheetCategories,
            timesheetSubCategories,
            data,
            setData,
            setErrors,
            setShowSaveCancel,
            setDuplicateErrors,
            setSelectedCategories,
            setSelectedSubcategories
        );
    };
    const handleDelete = (e, id, index) => {
        onDelete(
            e,
            id,
            index,
            data,
            selectedCategories,
            selectedSubcategories,
            duplicateErrors,
            errors,
            setData,
            setSelectedCategories,
            setSelectedSubcategories,
            setErrors,
            setDuplicateErrors,
            setShowSaveCancel
        );
    };
    return (
        <>
            {showAlert.setAlertOpen && Object.keys(showAlert).length > 0 && (
                <CustomAlert
                    open={showAlert.setAlertOpen}
                    severity={showAlert.severity}
                    message={showAlert.message}
                    className={styles.alertStyle}
                    onClose={() => setShowAlert(false, "", "")}
                ></CustomAlert>
            )}
            <Box margin="20px">
                <div title="Create Timesheet" className={styles.title}>
                    Create Timesheet
                </div>
                {userRole && userRole.roleName !== "Admin" && (
                    <div className={styles.name}>
                        Manager Name :{" "}
                        {managerAndApprover?.length &&
                            managerAndApprover[0]?.timesheetManagerName}
                    </div>
                )}
                {userRole && userRole.roleName !== "Admin" && (
                    <div className={styles.name}>
                        Approver Name :{" "}
                        {managerAndApprover?.length &&
                            managerAndApprover[0]?.timesheetApproverName}
                    </div>
                )}
                {selectedWeek?.from && selectedWeek?.to && (
                    <CreateEditToolbar
                        selectedWeek={selectedWeek}
                        handleAddRow={handleAddRow}
                        handleSave={handleSave}
                        handleCancel={handleCancel}
                        showSaveCancel={showSaveCancel}
                        enabledStartDate={enabledStartDate}
                        enabledEndDate={enabledEndDate}
                        disableDates={disableDates}
                        handleDayClick={handleDayClick}
                        toggleCalenderDisplay={toggleCalenderDisplay}
                        setToggleCalenderDisplay={setToggleCalenderDisplay}
                        modifiers={modifiers}
                    />
                )}
                <TableContainer>
                    <Table>
                        <TableHead style={{ backgroundColor: "#17072B" }}>
                            {tableHeader(data.length > 1)}
                        </TableHead>
                        <TableBody>
                            <CreateTimesheetV2Rows
                                data={data}
                                handleProjectChange={handleProjectChange}
                                handleCategoryChange={handleCategoryChange}
                                handleSubCategoryChange={
                                    handleSubCategoryChange
                                }
                                employeeProject={employeeProject}
                                debouncedTaskDescriptionChange={
                                    debouncedTaskDescriptionChange
                                }
                                errors={errors}
                                duplicateErrors={duplicateErrors}
                                timesheetCategories={timesheetCategories}
                                selectedCategories={selectedCategories}
                                selectedSubcategories={selectedSubcategories}
                                debouncedHourChange={debouncedHourChange}
                                handleDelete={handleDelete}
                                timesheetSubCategories={timesheetSubCategories}
                            />

                            {data &&
                                data.length > 0 &&
                                tableRowForSum(daySums, data.length > 1)}
                        </TableBody>
                    </Table>
                </TableContainer>
            </Box>
        </>
    );
};

export default CreateTimesheetV2;
