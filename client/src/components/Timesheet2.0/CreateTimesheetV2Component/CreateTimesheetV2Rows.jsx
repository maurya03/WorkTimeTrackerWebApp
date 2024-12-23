import React from "react";
import Dropdown2 from "rootpath/components/Timesheet2.0/Common/Dropdown2";
import {
    handleHoursInput,
    hasError,
    isZero
} from "rootpath/services/Timesheet2.0/CreateTimesheetService";
import { GetFilteredSubcategories } from "rootpath/services/Timesheet2.0/TimesheetService";
import css from "rootpath/components/Timesheet2.0/CreateTimesheetV2Component/CreateTimesheetV2.css";
import DeleteIcon from "@material-ui/icons/Delete";
import { removeDecimal } from "rootpath/components/Timesheet2.0/EditTimesheetV2Component/EditUtility";
import {
    TableCell,
    TableRow,
    TextField
} from "@material-ui/core";
import Tooltip from "@mui/material/Tooltip";
import CustomTextArea from "rootpath/components/Timesheet2.0/Common/CustomTextArea";
const CreateTimesheetV2Rows = ({
    data,
    handleProjectChange,
    handleCategoryChange,
    handleSubCategoryChange,
    employeeProject,
    debouncedTaskDescriptionChange,
    errors,
    duplicateErrors,
    timesheetCategories,
    selectedCategories,
    selectedSubcategories,
    debouncedHourChange,
    handleDelete,
    timesheetSubCategories
}) => {
    return (
        <>
            {" "}
            {data?.map((row, index) => (
                <TableRow key={row.id}>
                    <TableCell style={{ width: "10%", padding: "6px" }}>
                        <Dropdown2
                            onDropdownChange={event => {
                                handleProjectChange(event, row.id);
                            }}
                            bindingData={employeeProject}
                            keyName="projectId"
                            value="clientName"
                            defaultValue={row.projectId}
                            cssClass={css.catDropdown}
                        />
                    </TableCell>
                    <CustomTextArea
                        row={row}
                        index={index}
                        errors={errors}
                        duplicateErrors={duplicateErrors}
                        debouncedTaskDescriptionChange={
                            debouncedTaskDescriptionChange
                        }
                    />
                    <TableCell style={{ width: "10%", padding: "6px" }}>
                        <Dropdown2
                            onDropdownChange={event => {
                                handleCategoryChange(event, row.id, index);
                            }}
                            bindingData={timesheetCategories}
                            keyName="timeSheetCategoryId"
                            value="timeSheetCategoryName"
                            defaultValue={selectedCategories[index]}
                            cssClass={css.catDropdown}
                        />
                    </TableCell>
                    <TableCell style={{ width: "20%", padding: "6px" }}>
                        {selectedSubcategories[index] &&
                            GetFilteredSubcategories(
                                timesheetSubCategories,
                                selectedCategories[index]
                            ) && (
                                <Dropdown2
                                    onDropdownChange={event => {
                                        handleSubCategoryChange(
                                            event,
                                            row.id,
                                            index
                                        );
                                    }}
                                    bindingData={
                                        selectedSubcategories[index] &&
                                        GetFilteredSubcategories(
                                            timesheetSubCategories,
                                            selectedCategories[index]
                                        )
                                    }
                                    keyName="timeSheetSubCategoryId"
                                    value="timeSheetSubCategoryName"
                                    defaultValue={selectedSubcategories[index]}
                                    cssClass={css.subCatDropdown}
                                />
                            )}
                    </TableCell>
                    <TableCell style={{ width: "5%", padding: "6px" }}>
                        <TextField
                            className={css.textField}
                            type="number"
                            value={removeDecimal(row.sun)}
                            onInput={handleHoursInput}
                            onChange={e =>
                                debouncedHourChange(e, row.id, "sun", index)
                            }
                            error={
                                hasError(index, row, errors) ||
                                isZero(row, "sun")
                            }
                        />
                    </TableCell>
                    <TableCell style={{ width: "5%", padding: "6px" }}>
                        <TextField
                            className={css.textField}
                            value={removeDecimal(row.mon)}
                            type="number"
                            onInput={handleHoursInput}
                            onChange={e =>
                                debouncedHourChange(e, row.id, "mon", index)
                            }
                            error={
                                hasError(index, row, errors) ||
                                isZero(row, "mon")
                            }
                        />
                    </TableCell>
                    <TableCell style={{ width: "5%", padding: "6px" }}>
                        <TextField
                            className={css.textField}
                            value={removeDecimal(row.tue)}
                            type="number"
                            onInput={handleHoursInput}
                            onChange={e =>
                                debouncedHourChange(e, row.id, "tue", index)
                            }
                            error={
                                hasError(index, row, errors) ||
                                isZero(row, "tue")
                            }
                        />
                    </TableCell>
                    <TableCell style={{ width: "5%", padding: "6px" }}>
                        <TextField
                            className={css.textField}
                            value={removeDecimal(row.wed)}
                            type="number"
                            onInput={handleHoursInput}
                            onChange={e =>
                                debouncedHourChange(e, row.id, "wed", index)
                            }
                            error={
                                hasError(index, row, errors) ||
                                isZero(row, "wed")
                            }
                        />
                    </TableCell>
                    <TableCell style={{ width: "5%", padding: "6px" }}>
                        <TextField
                            className={css.textField}
                            type="number"
                            value={removeDecimal(row.thu)}
                            onInput={handleHoursInput}
                            onChange={e =>
                                debouncedHourChange(e, row.id, "thu", index)
                            }
                            error={
                                hasError(index, row, errors) ||
                                isZero(row, "thu")
                            }
                        />
                    </TableCell>
                    <TableCell style={{ width: "5%", padding: "6px" }}>
                        <TextField
                            className={css.textField}
                            type="number"
                            value={removeDecimal(row.fri)}
                            onInput={handleHoursInput}
                            onChange={e =>
                                debouncedHourChange(e, row.id, "fri", index)
                            }
                            error={
                                hasError(index, row, errors) ||
                                isZero(row, "fri")
                            }
                        />
                    </TableCell>
                    <TableCell style={{ width: "5%", padding: "6px" }}>
                        <TextField
                            className={css.textField}
                            type="number"
                            value={removeDecimal(row.sat)}
                            onInput={handleHoursInput}
                            onChange={e =>
                                debouncedHourChange(e, row.id, "sat", index)
                            }
                            error={
                                hasError(index, row, errors) ||
                                isZero(row, "sat")
                            }
                        />
                    </TableCell>
                    {data.length > 1 && (
                        <TableCell style={{ width: "5%", padding: "6px" }}>
                            <Tooltip title="Delete">
                                <DeleteIcon
                                    style={{ textAlign: "center" }}
                                    onClick={e =>
                                        handleDelete(e, row.id, index)
                                    }
                                />
                            </Tooltip>
                        </TableCell>
                    )}
                </TableRow>
            ))}{" "}
        </>
    );
};
export default CreateTimesheetV2Rows;
