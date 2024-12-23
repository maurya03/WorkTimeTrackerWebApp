import React, { useCallback, useEffect, useState } from "react";
import CreateTimesheetV2Rows from "rootpath/components/Timesheet2.0/CreateTimesheetV2Component/CreateTimesheetV2Rows";
import styles from "rootpath/components/Timesheet2.0/ViewTimesheetComponent/ViewTimesheet.css";
import CustomAlert from "rootpath/components/CustomAlert";
import {
    onSave,
    onAddRow,
    onProjectChange,
    onSubCategoryChange,
    onCategoryChange,
    onChange
} from "rootpath/services/Timesheet2.0/CreateTimesheetService";
import { calculateDaySums } from "rootpath/services/Timesheet2.0/TimesheetService";
import debounce from "lodash.debounce";
import { Table, TableBody, TableContainer, TableHead } from "@material-ui/core";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import {
    tableHeader,
    tableRowForSum
} from "rootpath/components/Timesheet2.0/CreateTimesheetV2Component/CreateConstants";
import CreateEditToolbar from "rootpath/components/Timesheet2.0/Common/CreateEditToolbar";
import {
    onDelete,
    onEditRender
} from "rootpath/components/Timesheet2.0/EditTimesheetV2Component/EditUtility";
const EditTimesheetV2 = ({
    timesheetDetails,
    showAlert,
    setShowAlert,
    employeeProject,
    timesheetCategories,
    timesheetSubCategories,
    selectedWeek,
    handleCancelClick,
    saveTimesheet,
    deleteTimesheet,
    setToggleCalenderDisplay,
    toggleCalenderDisplay,
    isEditMode,
    statusId
}) => {
    const [data, setData] = useState([]);
    const [selectedCategories, setSelectedCategories] = useState([]);
    const [selectedSubcategories, setSelectedSubcategories] = useState([]);
    const [showSaveCancel, setShowSaveCancel] = useState(false);
    const [errors, setErrors] = useState([]);
    const [duplicateErrors, setDuplicateErrors] = useState([]);

    useEffect(() => {
        onEditRender(
            timesheetDetails,
            setData,
            setSelectedCategories,
            setSelectedSubcategories,
            setShowSaveCancel,
            setErrors,
            setDuplicateErrors
        );
    }, [timesheetCategories, timesheetSubCategories, employeeProject]);

    const debouncedHandleChange = debounce((id, field, value, index) => {
        handleChange(id, field, value, index);
    });
    const debouncedTaskDescriptionChange = (event, id, index) => {
        debouncedHandleChange(id, "taskDescription", event, index);
    };
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
            daySums,
            statusId
        );
    };
    const handleDelete = (e, id, index) => {
        onDelete(
            e,
            id,
            index,
            data,
            selectedWeek,
            deleteTimesheet,
            selectedCategories,
            selectedSubcategories,
            errors,
            setData,
            setSelectedCategories,
            setSelectedSubcategories,
            setErrors,
            setDuplicateErrors,
            duplicateErrors
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
                <div title="Edit Timesheet" className={styles.title}>
                    Edit Timesheet
                </div>
                {selectedWeek?.from && selectedWeek?.to && (
                    <CreateEditToolbar
                        selectedWeek={selectedWeek}
                        handleAddRow={handleAddRow}
                        handleSave={handleSave}
                        handleCancel={handleCancelClick}
                        showSaveCancel={showSaveCancel}
                        setToggleCalenderDisplay={setToggleCalenderDisplay}
                        toggleCalenderDisplay={toggleCalenderDisplay}
                    />
                )}
                <TableContainer>
                    {data.length > 0 && (
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
                                    selectedSubcategories={
                                        selectedSubcategories
                                    }
                                    debouncedHourChange={debouncedHourChange}
                                    handleDelete={handleDelete}
                                    timesheetSubCategories={
                                        timesheetSubCategories
                                    }
                                />
                                {data &&
                                    data.length > 0 &&
                                    tableRowForSum(daySums, data.length > 1)}
                            </TableBody>
                        </Table>
                    )}
                </TableContainer>
            </Box>
        </>
    );
};

export default EditTimesheetV2;
