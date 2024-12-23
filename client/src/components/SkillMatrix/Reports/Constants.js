import React from "react";
import Checkbox from "@mui/material/Checkbox";
import Typography from "@mui/material/Typography";

const getColumnsByAllCategory = obj => {
    const staticColumns = ["CategoryName", "SubCategoryName"];

    let columnNames = Object.keys(obj);
    let columns = [];
    let columnObj;

    columnNames.forEach(col => {
        if (staticColumns.includes(col)) {
            columnObj = {
                title: col,
                field: col,
                sortable: false,
                cellStyle: {
                    padding: "6px 16px",
                    textOverflow: "ellipsis",
                    overflow: "hidden",
                    whiteSpace: "nowrap"
                }
            };
        } else if (col !== "TeamName") {
            columnObj = {
                title: col,
                field: col,
                render: row => {
                    return (
                        <Checkbox
                            checked={row[col] === 1 ? true : false}
                            disableRipple
                            sx={{ cursor: "default" }}
                        />
                    );
                },
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

const getColumnsByEmployeeScore = obj => {
    let columns = [];
    Object.keys(obj).forEach(col => {
        columns.push({
            title: col,
            field: col,
            render: rowData => {
                const value =
                    rowData[col] === null
                        ? "-"
                        : Number(rowData[col]) && col !== "ClientExpectedScore"
                        ? rowData[col] + "%"
                        : rowData[col];
                return <Typography>{value}</Typography>;
            },
            sortable: false,
            cellStyle: {
                padding: "6px 16px",
                textOverflow: "ellipsis",
                overflow: "hidden",
                whiteSpace: "nowrap"
            }
        });
    });

    return columns;
};

const getColumnsBySkillSegment = obj => {
    const columnNames = Object.keys(obj);
    let columns = [];
    let columnObj;

    if (columnNames != null) {
        columnNames.forEach(col => {
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
            columns.push(columnObj);
        });
    } else {
        columnObj = {};
    }
    return columns;
};

const exportAllCategoriesReport = (data, columns) => {
    return [
        columns.map(col => col.title),
        ...data.map(rowData => {
            return columns.map(col => {
                if (
                    col.field === "CategoryName" ||
                    col.field === "SubCategoryName"
                ) {
                    return rowData[col.field];
                } else {
                    return rowData[col.field] === 1 ? "TRUE" : "FALSE";
                }
            });
        })
    ];
};

const exportEmployeeScore = (data, columns) => {
    const constantColumns = [
        "ClientName",
        "TeamName",
        "EmployeeName",
        "CategoryName",
        "SubCategoryName",
        "ClientExpectedScore",
        "FunctionType"
    ];
    return [
        columns.map(col => col.title),
        ...data.map(rowData => {
            return columns.map(col => {
                if (constantColumns.includes(col.field)) {
                    return rowData[col.field];
                } else {
                    return rowData[col.field] === null
                        ? "-"
                        : rowData[col.field] + "%";
                }
            });
        })
    ];
};

const exportSkillSegmentReport = (data, columns) => {
    return [
        columns.map(col => col.title),
        ...data.map(rowData => {
            return columns.map(col => rowData[col.field]);
        })
    ];
};

export const getColumns = (obj, reportType) => {
    switch (reportType) {
        case "Report By All Categories":
            return getColumnsByAllCategory(obj);
        case "Report By Employee Score":
            return getColumnsByEmployeeScore(obj);
        case "Skill Segment By Categories":
            return getColumnsBySkillSegment(obj);
        default:
            return [];
    }
};

export const onExport = (data, columns, reportType) => {
    switch (reportType) {
        case "Report By All Categories":
            return exportAllCategoriesReport(data, columns);
        case "Report By Employee Score":
            return exportEmployeeScore(data, columns);
        case "Skill Segment By Categories":
            return exportSkillSegmentReport(data, columns);
    }
};

export const ReportTypes = [
    "Report By All Categories",
    "Report By Employee Score",
    "Skill Segment By Categories"
];

const currentDate = new Date();
const currentYear = currentDate.getFullYear();
export const Years = [currentYear - 1, currentYear, currentYear + 1];

export const Months = Object.freeze({
    January: 1,
    February: 2,
    March: 3,
    April: 4,
    May: 5,
    June: 6,
    July: 7,
    August: 8,
    September: 9,
    October: 10,
    November: 11,
    December: 12
});
