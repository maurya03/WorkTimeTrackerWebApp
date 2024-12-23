import Box from "@mui/material/Box";
import DeleteIcon from "@material-ui/icons/Delete";
import { makeStyles } from "@material-ui/core";
import React from "react";
import EditIcon from "@material-ui/icons/Edit";
import Button from "@mui/material/Button";
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
export const ViewTimesheetColumns = () => {
    return [
        {
            title: "Project",
            field: "projectName",
            width: "10%"
        },
        {
            title: "Task title",
            field: "taskDescription",
            width: "20%",
            render: rowData => (
                <Box
                    title={rowData.taskDescription}
                    textAlign="left"
                    width="100%"
                    whiteSpace="nowrap"
                    overflow="hidden"
                    textOverflow="ellipsis"
                >
                    {rowData.taskDescription}
                </Box>
            )
        },
        {
            title: "Category",
            field: "categoryName",
            width: "10%"
        },
        {
            title: "SubCategory",
            field: "subCategoryName",
            width: "17%",
            render: rowData => (
                <Box
                    title={rowData.subCategoryName}
                    textAlign="left"
                    width="100%"
                    whiteSpace="nowrap"
                    overflow="hidden"
                    textOverflow="ellipsis"
                >
                    {rowData.subCategoryName}
                </Box>
            )
        },
        {
            title: "Sun",
            field: "sun",
            width: "5%"
        },
        {
            title: "Mon",
            field: "mon",
            width: "5%"
        },
        {
            title: "Tue",
            field: "tue",
            width: "5%"
        },
        {
            title: "Wed",
            field: "wed",
            width: "5%"
        },
        {
            title: "Thu",
            field: "thu",
            width: "5%"
        },
        {
            title: "Fri",
            field: "fri",
            width: "5%"
        },
        {
            title: "Sat",
            field: "sat",
            width: "5%"
        }
    ];
};
export const ViewTableActions = (handleEdit, handleSubmit, handleDelete) => {
    return [
        {
            // hidden: !toolbarOptions,
            icon: () => (
                <>
                    {" "}
                    <Box textAlign="left">
                        <DeleteIcon style={{ textAlign: "center" }} />
                    </Box>
                </>
            ),
            tooltip: "Delete",
            onClick: (e, rowData) => handleDelete(e, rowData.timesheetDetailId)
        },
        {
            // hidden: !toolbarOptions,
            icon: () => <EditIcon style={{ textAlign: "center" }} />,
            tooltip: "Edit",
            onClick: (e, rowData) => handleEdit(e, rowData),
            isFreeAction: true
        },
        {
            // hidden: !toolbarOptions,
            icon: () => (
                <Button
                    style={{
                        color: "white",
                        backgroundColor: "#17072B"
                    }}
                    onClick={handleSubmit}
                >
                    Submit
                </Button>
            ),
            isFreeAction: true
        }
    ];
};
export const ViewTableStyles = makeStyles(theme => ({
    root: {
        "& .css-1mbunh-MuiPaper-root": {
            boxShadow: "none"
        },
        "& .css-ig9rso-MuiToolbar-root": {
            height: 8
        },
        "& .css-11w94w9-MuiTableCell-root": {
            textAlign: "center"
        },
        "& .css-1ex1afd-MuiTableCell-root": {
            fontWeight: "800",
            fontSize: "large"
        }
    }
}));
export const submitPayload = (startDate, endDate, timesheetId) => {
    return {
        startDate: startDate,
        endDate: endDate,
        timesheetId: timesheetId,
        status: "Pending"
    };
};
export const emailPayload = (email, startDate, endDate, remarks) => {
    return [
        {
            emailId: email,
            weekStartDate: startDate,
            weekEndDate: endDate,
            remarks: remarks,
            status: "Submitted"
        }
    ];
};
