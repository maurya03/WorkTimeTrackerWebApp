import React, { useEffect, useState } from "react";
import Box from "@mui/material/Box";
import TextField from "@mui/material/TextField";
import Autocomplete from "@mui/material/Autocomplete";
import Typography from "@mui/material/Typography";
import Stack from "@mui/material/Stack";
import Button from "@mui/material/Button";
import {
    updateSelectedRole,
    onOptionSelected
} from "rootpath/services/EmployeeBook/ManageUserAccessData.js";
import ReactGA from "react-ga4";

const ManageUserAccess = ({
    employees,
    fetchEmployees,
    roles,
    fetchRoles,
    updateEmployeeRole,
    userRole,
    fetchLoggedInUserRole,
    history
}) => {
    const [roleList, setRoleList] = useState(roles);
    const [employeeSelected, setEmployeeSelected] = useState({});

    useEffect(() => {
        ReactGA.send({
            hitType: "pageview",
            page: window.location.pathname,
            title: "EmployeeBook manage user access page"
        });
    }, []);

    useEffect(() => {
        fetchRoles();
    }, [fetchRoles]);

    useEffect(() => {
        fetchLoggedInUserRole();
    }, [fetchLoggedInUserRole]);

    useEffect(() => {
        fetchEmployees();
    }, [fetchEmployees, employeeSelected]);

    useEffect(() => {
        window.scrollTo(0, 0);
    }, []);

    const onEmployeeSelected = value => {
        if (value) {
            const updatedRoles = updateSelectedRole(roles, value);
            setRoleList(updatedRoles);
        }
        setEmployeeSelected(value);
    };

    const onCheckboxChecked = event => {
        if (event) {
            const updatedRoles = onOptionSelected(roleList, event);
            setRoleList(updatedRoles);
        }
    };

    const updateRoles = async () => {
        const postRole = roleList.find(x => x.isChecked === true);
        await updateEmployeeRole({
            roleId: postRole.roleId,
            employeeId: employeeSelected.employeeId
        });
    };

    ReactGA.event({
        category: "ManageUserAccess",
        action: "UpdateRoleUpdateTrigger",
        label: "Employee Role Update",
        value: 1
    });

    const handleHomeClick = () => {
        history.push("/employeebook/");
    };

    return userRole?.roleName === "Admin" ? (
        <Box className="container">
            <Typography
                m="10px 0"
                textAlign="center"
                variant="h4"
                backgroundColor="#f3eeed"
                borderRadius="30px"
                marginTop="20px"
                marginBottom="20px"
            >
                Manage Employee Permissions
            </Typography>
            <Stack direction="row" justifyContent="space-between">
                <Box
                    p="20px"
                    borderRadius="10px"
                    width="48%"
                    sx={{ backgroundColor: "#e8e7e7" }}
                >
                    <Autocomplete
                        onChange={(event, value) => onEmployeeSelected(value)} // prints the selected value
                        id="employee-select"
                        sx={{ width: 300, backgroundColor: "#fff" }}
                        options={employees}
                        autoHighlight
                        getOptionLabel={option => option.fullName}
                        renderOption={(props, option) => (
                            <Box
                                component="li"
                                sx={{ "& > img": { mr: 2, flexShrink: 0 } }}
                                {...props}
                            >
                                {option.fullName} ({option.emailId}) (EmpId -{" "}
                                {option.employeeId})
                            </Box>
                        )}
                        renderInput={params => (
                            <TextField
                                {...params}
                                label="Choose an Employee"
                                inputProps={{
                                    ...params.inputProps,
                                    autoComplete: "new-password" // disable autocomplete and autofill
                                }}
                            />
                        )}
                    />
                </Box>

                <Box
                    p="20px"
                    borderRadius="10px"
                    width="48%"
                    sx={{ backgroundColor: "#e8e7e7" }}
                >
                    <Box
                        p="40px"
                        borderRadius="10px"
                        height="290px"
                        marginBottom="20px"
                        sx={{
                            backgroundColor: "#fff",
                            boxShadow: "0px 35px 50px rgba(0, 0, 0, 0.2)"
                        }}
                    >
                        {roleList.map((role, index) => {
                            return (
                                <Box
                                    display="flex"
                                    alignItems="center"
                                    justifyContent="flex-start"
                                    key={index}
                                >
                                    <input
                                        name={role.roleId}
                                        value={role.roleId}
                                        type="checkbox"
                                        checked={role.isChecked}
                                        onChange={event => {
                                            onCheckboxChecked(event);
                                        }}
                                        disabled={
                                            !(
                                                employeeSelected &&
                                                Object.keys(employeeSelected)
                                                    .length > 0
                                            )
                                        }
                                    />
                                    <Typography
                                        variant="h6"
                                        fontSize="16px"
                                        marginLeft="10px"
                                    >
                                        {role.roleName}
                                    </Typography>
                                </Box>
                            );
                        })}
                    </Box>
                    <Button
                        variant="contained"
                        size="medium"
                        onClick={e => updateRoles(e)}
                    >
                        Update Role
                    </Button>
                </Box>
            </Stack>
        </Box>
    ) : (
        <Box className="container">
            <Typography m="20px 0" textAlign="center" variant="h6">
                You do not have permission for this page.
            </Typography>
            <Typography
                m="20px 0"
                textAlign="center"
                variant="h6"
                backgroundColor="#fff"
                onClick={handleHomeClick}
                sx={{ cursor: "pointer", "&:hover": { color: "Blue" } }}
            >
                Go To Home Page
            </Typography>
        </Box>
    );
};
export default ManageUserAccess;
