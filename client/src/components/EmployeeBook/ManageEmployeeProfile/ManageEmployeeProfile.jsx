import React, { useState, useEffect } from "react";
import MaterialTable from "@material-table/core";
import Grid from "@mui/material/Grid";
import Typography from "@mui/material/Typography";
import Button from "@mui/material/Button";
import useMediaQuery from "@mui/material/useMediaQuery";

const ManageEmployeeProfile = ({
    userRole,
    updatedEmployeesList,
    fetchUpdatedEmployeesList,
    history
}) => {
    const isMobile = useMediaQuery("(max-width:767px)");

    useEffect(() => {
        fetchUpdatedEmployeesList();
    }, [fetchUpdatedEmployeesList]);

    const columns = [
        {
            title: "Employee Id",
            field: "employeeId"
        },
        {
            title: "Employee Name",
            field: "employeeName"
        },
        {
            title: "Email Id",
            field: "emailId"
        },
        {
            title: "Designation",
            field: "designation"
        },
        {
            title: "Project",
            field: "project"
        },
        {
            title: "Updated Date",
            field: "updatedDate"
        },
        {
            title: "Action",
            field: "viewButton",
            render: rowData => (
                <Button
                    variant="contained"
                    sx={{
                        marginRight: !isMobile && "20px",
                        marginBottom: isMobile && "10px",
                        width: isMobile ? "100%" : "auto"
                    }}
                    onClick={() => {
                        history.push(
                            `/employeebook/manage-employee/${rowData.employeeId}`
                        );
                    }}
                >
                    View
                </Button>
            )
        }
    ];
    return (
        (userRole?.roleName === "Admin" || userRole?.roleName === "HR") && (
            <>
                <Typography
                    m="10px 0"
                    textAlign="center"
                    variant="h4"
                    backgroundColor="#f3eeed"
                    borderRadius="30px"
                    margin="20px"
                    width="95%"
                >
                    Manage Employee Profile
                </Typography>
                <Grid
                    container
                    columns={{ xs: 12 }}
                    margin="20px"
                    margin-left="50px"
                    margin-top="-50px"
                >
                    <MaterialTable
                        columns={columns}
                        data={updatedEmployeesList}
                        options={{
                            toolbar: false,
                            maxBodyHeight: "100%",
                            actionsColumnIndex: -1,
                            pageSize: 5,
                            paging: true,
                            headerStyle: {
                                backgroundColor: "#17072b",
                                color: "#fff",
                                textOverflow: "ellipsis",
                                overflow: "hidden"
                            }
                        }}
                        style={{
                            maxHeight: "100%",
                            width: "95%",
                            overflowY: "auto"
                        }}
                        localization={{
                            body: {
                                emptyDataSourceMessage:
                                    "No employee request exists to update profile !!"
                            }
                        }}
                    />
                </Grid>
            </>
        )
    );
};

export default ManageEmployeeProfile;
