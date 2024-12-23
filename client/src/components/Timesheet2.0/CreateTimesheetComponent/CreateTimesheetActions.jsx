import React from "react";
import AddCircle from "@mui/icons-material/AddCircle";
import Save from "@mui/icons-material/Save";
import CloseSharp from "@mui/icons-material/CloseSharp";
import Delete from "@mui/icons-material/Delete";
import css from "rootpath/components/Timesheet2.0/CreateTimesheetComponent/CreateTimesheet.css";
import {
    AddRow,
    CancelClick,
    SaveClick,
    DeleteRowClick
} from "rootpath/services/Timesheet2.0/TimesheetService";
export const tableActions = (
    setData,
    dataCopy,
    employeeProject,
    timesheetCategories,
    timesheetSubCategories,
    startDate,
    endDate
) => {
    return [
        {
            icon: () => <AddCircle />,
            tooltip: "Add Row",
            isFreeAction: true,
            onClick: () => {
                AddRow(
                    setData,
                    dataCopy,
                    employeeProject,
                    timesheetCategories,
                    timesheetSubCategories
                );
            }
        },
        {
            icon: () => <Save sx={{ color: "#008000" }} />,
            tooltip: "Save All",
            isFreeAction: true,
            onClick: () => {
                SaveClick(setData, dataCopy, startDate, endDate);
            }
        },
        {
            icon: () => <CloseSharp sx={{ color: "#FF0000" }} />,
            tooltip: "Cancel",
            isFreeAction: true,
            onClick: () => {
                CancelClick(setData, dataCopy);
            }
        },
        dataCopy.current.length > 1 && {
            icon: () => <Delete />,
            tooltip: "Delete",
            onClick: (event, rowData) => {
                DeleteRowClick(dataCopy, rowData.id, setData);
            }
        }
    ];
};
