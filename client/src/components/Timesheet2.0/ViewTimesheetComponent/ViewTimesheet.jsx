import React, { useEffect } from "react";
import styles from "rootpath/components/Timesheet2.0/ViewTimesheetComponent/ViewTimesheet.css";
import CustomDialogBox from "rootpath/components/Timesheet2.0/Common/CustomDialogBox";
import CustomAlert from "rootpath/components/CustomAlert";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import DeleteIcon from "@material-ui/icons/Delete";
import ViewToolbar from "rootpath/components/Timesheet2.0/Common/ViewToolbar";
import {
    calculateDaySums,
    handleDelete
} from "rootpath/services/Timesheet2.0/TimesheetService";
import { removeDecimal } from "rootpath/components/Timesheet2.0/EditTimesheetV2Component/EditUtility";
import {
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow
} from "@material-ui/core";
import {
    tableHeader,
    tableRowForSum,
    days
} from "rootpath/components/Timesheet2.0/CreateTimesheetV2Component/CreateConstants";
import Tooltip from "@mui/material/Tooltip";
const ViewTimesheet = ({
    userRole,
    fetchRole,
    timesheetDetails,
    toolbarOptions,
    selectedWeek,
    enabledStartDate,
    enabledEndDate,
    disableDates,
    handleDayClick,
    handleEdit,
    setShowAlert,
    showAlert,
    setShowDialogBox,
    showDialogBox,
    onDelete,
    onSubmit,
    toggleCalenderDisplay,
    setToggleCalenderDisplay,
    validateTimesheetDetail,
    modifiers
}) => {
    useEffect(() => {
        return () => {
            setShowAlert(false);
        };
    }, []);
    useEffect(() => {
        fetchRole();
    }, [fetchRole]);
    const isTempEmployee = empId => {
        return empId.toLowerCase().includes("temp");
    };
    const daySums = calculateDaySums(timesheetDetails);
    const handleSubmit = () => {
        const validationErrors = isTempEmployee(userRole.employeeId)
            ? ""
            : validateTimesheetDetail(daySums);
        validationErrors.length == 0 &&
            setShowDialogBox(
                true,
                "Submit Timesheet",
                "Are you sure you want to submit the timesheet ?",
                confirmSubmit
            );
    };

    const confirmSubmit = () => {
        onSubmit(selectedWeek);
    };
    return (
        <>
            {showDialogBox.open && Object.keys(showDialogBox).length > 0 && (
                <CustomDialogBox
                    title={showDialogBox.title}
                    content={showDialogBox.content}
                    open={showDialogBox.open}
                    setOpen={() => setShowDialogBox(false)}
                    onConfirm={showDialogBox.onConfirm}
                ></CustomDialogBox>
            )}
            {showAlert.setAlertOpen && Object.keys(showAlert).length > 0 && (
                <CustomAlert
                    open={showAlert.setAlertOpen}
                    severity={showAlert.severity}
                    message={showAlert.message}
                    className={styles.alertStyle}
                    onClose={() => setShowAlert(false, "", "")}
                ></CustomAlert>
            )}
            <div className={styles.table}>
                <div title="View Timesheet" className={styles.title}>
                    View Timesheet
                </div>
                <ViewToolbar
                    toolbarOptions={toolbarOptions}
                    selectedWeek={selectedWeek}
                    handleSubmit={handleSubmit}
                    disableDates={disableDates}
                    handleDayClick={handleDayClick}
                    enabledStartDate={enabledStartDate}
                    enabledEndDate={enabledEndDate}
                    toggleCalenderDisplay={toggleCalenderDisplay}
                    setToggleCalenderDisplay={setToggleCalenderDisplay}
                    handleEdit={handleEdit}
                    modifiers={modifiers}
                />
                <TableContainer>
                    <Table>
                        <TableHead style={{ backgroundColor: "#17072B" }}>
                            {tableHeader(
                                timesheetDetails.length > 1 && toolbarOptions
                            )}
                        </TableHead>
                        {toolbarOptions ? (
                            <TableBody>
                                {timesheetDetails?.map((row, index) => (
                                    <TableRow key={row.id}>
                                        <TableCell>{row.projectName}</TableCell>
                                        <TableCell>
                                            {row.taskDescription}
                                        </TableCell>
                                        <TableCell>
                                            {row.categoryName}
                                        </TableCell>
                                        <TableCell>
                                            {row.subCategoryName}
                                        </TableCell>
                                        {days.map(day => {
                                            return (
                                                <TableCell>
                                                    {row[day] &&
                                                        removeDecimal(row[day])}
                                                </TableCell>
                                            );
                                        })}
                                        {timesheetDetails.length > 1 &&
                                            toolbarOptions && (
                                                <TableCell>
                                                    <Tooltip title="Delete">
                                                        <DeleteIcon
                                                            style={{
                                                                textAlign:
                                                                    "center"
                                                            }}
                                                            onClick={e =>
                                                                handleDelete(
                                                                    selectedWeek,
                                                                    e,
                                                                    row.timesheetDetailId,
                                                                    onDelete
                                                                )
                                                            }
                                                        />
                                                    </Tooltip>
                                                </TableCell>
                                            )}
                                    </TableRow>
                                ))}{" "}
                                {timesheetDetails.length > 0 &&
                                    tableRowForSum(
                                        daySums,
                                        timesheetDetails.length > 1 &&
                                            toolbarOptions
                                    )}
                            </TableBody>
                        ) : (
                            <Box
                                mt={2}
                                marginLeft={50}
                                width={500}
                                textAlign="center"
                            >
                                <Typography variant="h5" align="center">
                                    Timesheet already submitted!
                                </Typography>
                            </Box>
                        )}
                    </Table>
                </TableContainer>
            </div>
        </>
    );
};
export default ViewTimesheet;
