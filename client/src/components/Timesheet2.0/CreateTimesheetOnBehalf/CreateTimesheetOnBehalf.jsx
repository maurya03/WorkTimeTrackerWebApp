import React, { useEffect, useState } from "react";
import FormControl from "@mui/material/FormControl";
import Dropdown from "rootpath/components/Timesheet2.0/Common/Dropdown";
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import TextField from "@mui/material/TextField";
import Autocomplete from "@mui/material/Autocomplete";
import TimesheetCreatorContainer from "rootpath/components/Timesheet2.0/TimesheetCreator/TimesheetCreatorContainer";

const CreateTimesheetOnBehalf = ({
    timesheetEmployees,
    clients,
    fetchClientList,
    fetchTimesheetEmployee
}) => {
    const [selectedEmployee, setSelectedEmployee] = useState("");
    const [selectedClient, setSelectedClient] = useState("");

    useEffect(() => {
        fetchClientList();
    }, [fetchClientList]);

    useEffect(() => {
        if (clients.length > 0) {
            setSelectedClient(clients[0].id);
            fetchTimesheetEmployee(clients[0].id);
        }
    }, [clients]);

    useEffect(() => {
        if (timesheetEmployees.length > 0) {
            setSelectedEmployee(timesheetEmployees[0].employeeId);
        }
    }, [timesheetEmployees]);

    const handleClientChange = e => {
        fetchTimesheetEmployee(e);
        setSelectedClient(e);
    };
    return (
        <>
            <Box
                marginTop="20px"
                maxWidth="110vw"
                marginLeft="auto"
                className="container"
            >
                <Box
                    display="flex"
                    alignItems="center"
                    justifyContent="2px"
                    marginTop="2px"
                >
                    <Typography
                        variant="h5"
                        fontWeight="600"
                        margin="20px 0 0 0"
                    >
                        Create Timesheet on Behalf
                    </Typography>
                </Box>
                <Box
                    display="flex"
                    justifyContent="left"
                    position="relative"
                    left="20px"
                    top="20px"
                >
                    <Box display="flex" position="relative" marginRight="40px">
                        <Typography
                            margin="30px 0 0 0"
                            fontWeight="600"
                            position="relative"
                        >
                            Client:
                        </Typography>
                        <FormControl
                            style={{
                                minWidth: 120,
                                left: "12px",
                                width: "200px"
                            }}
                        >
                            <Dropdown
                                onDropdownChange={event => {
                                    handleClientChange(event.target.value);
                                }}
                                bindingData={clients}
                                keyName="id"
                                value="clientName"
                                defaultValue={selectedClient}
                                isDisabled={false}
                            />
                        </FormControl>
                    </Box>
                    <Box display="flex" position="relative" marginRight="40px">
                        <Typography
                            margin="30px 0 0 0"
                            fontWeight="600"
                            position="relative"
                        >
                            Employee:
                        </Typography>
                        <FormControl
                            style={{
                                minWidth: 120,
                                left: "12px",
                                width: "200px"
                            }}
                        >
                            <Autocomplete
                                options={timesheetEmployees.map(
                                    employee => employee.employeeName
                                )}
                                sx={{ width: 300 }}
                                renderInput={employee => (
                                    <TextField
                                        {...employee}
                                        label="Search Employee"
                                        InputProps={{
                                            ...employee.InputProps,
                                            type: "search"
                                        }}
                                    />
                                )}
                            />
                        </FormControl>
                    </Box>
                </Box>
                <TimesheetCreatorContainer />
            </Box>
        </>
    );
};

export default CreateTimesheetOnBehalf;
