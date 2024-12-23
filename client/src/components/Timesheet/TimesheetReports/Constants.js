import React from "react";
import Checkbox from "@mui/material/Checkbox";

export const getColumns = obj => {
    const columnNames = Object.keys(obj);
    let columns = [];
    let columnObj;

    columnNames.forEach(col => {
        if (columnNames != null) {
            columnObj = {
                title: col.charAt(0).toUpperCase() + col.slice(1),
                field: col,
                sortable: false,
                cellStyle: {
                    padding: "6px 16px",
                    textOverflow: "ellipsis",
                    overflow: "hidden",
                    whiteSpace: "nowrap"
                }
            };
        } else {
            columnObj = {};
        }
        columns.push(columnObj);
    });
    return columns;
};

export const exportSubmissionReport = (data, columns) => {
    return [
        columns.map(col => col.title),
        ...data.map(rowData => {
            return columns.map(col => rowData[col.field]);
        })
    ];
};

export const onExport = (data, columns, reportType) => {
    switch (reportType) {
        case "Timesheet Submission Report":
            return exportSubmissionReport(data, columns);
        case "Timesheet Detail Report":
            return exportSubmissionReport(data, columns);
        // case "Timesheet Employee Submission Report":
        //     return exportSubmissionReport(data, columns);
    }
};

export const ReportTypes = [
    "Timesheet Submission Report",
    "Timesheet Detail Report"
    // "Timesheet Employee Submission Report"
];
