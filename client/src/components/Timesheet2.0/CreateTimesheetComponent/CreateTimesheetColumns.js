import React from "react";
import TextField from "@mui/material/TextField";
import Dropdown from "rootpath/components/Timesheet2.0/Common/Dropdown";
import css from "rootpath/components/Timesheet2.0/CreateTimesheetComponent/CreateTimesheet.css";
import {
    handleProjectChange,
    handleCategoryChange,
    handleSubCategoryChange,
    handleTaskTitleChange,
    handleTaskHourChange,
    isHoursFilled,
    isValidRow,
    isZeroHour,
    handleHoursInput
} from "rootpath/services/Timesheet2.0/TimesheetService";

const renderTextfield = (rowData, keyName, dataCopy) => {
    const hasError =
        isValidRow(rowData) && isHoursFilled(rowData)
            ? isZeroHour(rowData, keyName)
            : true;
    return (
        <TextField
            type="number"
            variant="standard"
            error={hasError}
            className={css.textField}
            InputProps={{ min: 0, max: 12 }}
            onChange={event => {
                handleTaskHourChange(event, rowData, dataCopy, keyName);
            }}
            onInput={handleHoursInput} // Add the event handler
        />
    );
};
export const headerStyles = {
    backgroundColor: "#17072b",
    color: "#fff",
    position: "sticky",
    top: 0,
    right: 0,
    zIndex: 1,
    overflowX: "hidden",
    "&:hover": {
        color: "#fff"
    }
};
export const tableOptions = {
    maxBodyHeight: "350px",
    search: false,
    actionsColumnIndex: -1,
    tableLayout: "fixed",
    paging: false,
    headerStyle: headerStyles,
    showTitle: false,
    draggable: false
};
export const createTimesheetColumns = (
    employeeProject,
    timesheetCategories,
    timesheetSubCategories,
    getFilteredSubcategories,
    setData,
    dataCopy
) => {
    return [
        {
            title: "Project",
            width: "12%",
            render: rowData => {
                return employeeProject.length === 1 ? (
                    <label>
                        {
                            employeeProject.find(
                                x => x[keyName] === rowData[keyName]
                            ).clientName
                        }
                    </label>
                ) : (
                    <Dropdown
                        onDropdownChange={event => {
                            handleProjectChange(
                                event,
                                rowData,
                                setData,
                                dataCopy
                            );
                        }}
                        bindingData={employeeProject}
                        keyName="projectId"
                        value="clientName"
                        defaultValue={rowData.projectId}
                        cssClass={css.catDropdown}
                    />
                );
            }
        },
        {
            title: "Task title",
            width: "20%",
            render: rowData => {
                const hasError =
                    Object.keys(rowData).length > 5
                        ? dataCopy.current[rowData.id]?.taskDescription
                            ? false
                            : true
                        : false;
                return (
                    <TextField
                        id={`tasktxt_${rowData.id}`}
                        multiline
                        maxRows={10}
                        error={hasError}
                        onChange={event => {
                            handleTaskTitleChange(
                                event,
                                rowData,
                                dataCopy,
                                employeeProject,
                                timesheetCategories,
                                timesheetSubCategories,
                                setData
                            );
                        }}
                    />
                );
            }
        },
        {
            title: "Category",
            width: "11%",
            render: rowData => {
                return timesheetCategories.length === 1 ? (
                    <label>
                        {
                            timesheetCategories.find(
                                x => x[keyName] === rowData[keyName]
                            ).timeSheetCategoryName
                        }
                    </label>
                ) : (
                    <Dropdown
                        onDropdownChange={event => {
                            handleCategoryChange(
                                event,
                                rowData,
                                setData,
                                dataCopy,
                                timesheetSubCategories
                            );
                        }}
                        rowData={rowData}
                        bindingData={timesheetCategories}
                        keyName="timeSheetCategoryId"
                        value="timeSheetCategoryName"
                        defaultValue={rowData.timeSheetCategoryId}
                        cssClass={css.catDropdown}
                    />
                );
            }
        },
        {
            title: "SubCategory",
            width: "17%",
            render: rowData => {
                const filteredSubcategories = getFilteredSubcategories(
                    timesheetSubCategories,
                    rowData.timeSheetCategoryId ??
                        timesheetCategories[0].timeSheetCategoryId
                );
                return filteredSubcategories.length === 1 ? (
                    <label>
                        {
                            filteredSubcategories.find(
                                x => x[keyName] === rowData[keyName]
                            ).timeSheetSubCategoryName
                        }
                    </label>
                ) : (
                    <Dropdown
                        onDropdownChange={event => {
                            handleSubCategoryChange(
                                event,
                                rowData,
                                setData,
                                dataCopy
                            );
                        }}
                        bindingData={filteredSubcategories}
                        keyName="timeSheetSubCategoryId"
                        value="timeSheetSubCategoryName"
                        defaultValue={rowData.timeSheetSubCategoryId}
                        cssClass={css.subCatDropdown}
                    />
                );
            }
        },
        {
            title: "Sun",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Sun", dataCopy)
        },
        {
            title: "Mon",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Mon", dataCopy)
        },
        {
            title: "Tue",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Tue", dataCopy)
        },
        {
            title: "Wed",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Wed", dataCopy)
        },
        {
            title: "Thu",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Thu", dataCopy)
        },
        {
            title: "Fri",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Fri", dataCopy)
        },
        {
            title: "Sat",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Sat", dataCopy)
        }
    ];
};
