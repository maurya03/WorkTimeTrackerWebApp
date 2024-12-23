import React, { useEffect, useState } from "react";
import MaterialTable from "@material-table/core";
import Select from "@mui/material/Select";
import MenuItem from "@mui/material/MenuItem";
import Save from "@material-ui/icons/Save";
import FormControl from "@mui/material/FormControl";
import IconButton from "@mui/material/IconButton";
import CustomAlert from "rootpath/components/CustomAlert";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import { ValidateUpdate } from "rootpath/components/Timesheet/TimesheetManagerMapping/TimesheetMappingValidation";
import Typography from "@mui/material/Typography";
import styles from "rootpath/components/SkillMatrix/SkillMatrixDashboard/Dashboard.css";
import { Box } from "@mui/material";

const TimesheetMappingRole = ({
    clients,
    title,
    teams,
    employeeDetails,
    fetchClientList,
    fetchClientTeamsList,
    fetchEmployeeDetailsByTeamId,
    updateTimesheetEmployee,
    bulkUpdateEmployeeDetails,
    setShowAlert,
    alert,
    managerList,
    approverId1List,
    approverId2List
}) => {
    const [activeClient, setActiveClient] = useState("");
    const [activeTeam, setActiveTeam] = useState("");
    const [selectedValues, setSelectedValues] = useState([]);
    const [checkBoxState, setCheckBoxState] = useState(false);
    const [rowData, setRowData] = useState(null);
    const [empDetails, setEmpDetails] = useState(null);
    const [isLoading, setIsloading] = useState(false);
    useEffect(() => {
        setEmpDetails(employeeDetails);
        handleCheckBoxState();
    }, [employeeDetails]);

    useEffect(() => {
        fetchEmployeeDetailsByTeamId();
        fetchClientList();
        fetchClientTeamsList();
    }, [fetchEmployeeDetailsByTeamId, fetchClientList, fetchClientTeamsList]);

    useEffect(() => {
        clients.length > 0 && setActiveClient(clients[0]);
    }, [clients]);

    useEffect(() => {
        teams.length > 0 && setActiveTeam(teams[0]);
    }, [teams]);

    useEffect(() => {
        if (rowData !== null) {
            updatedCheckBoxStatus(rowData);
        }
    }, [rowData, checkBoxState]);

    const updatedCheckBoxStatus = rowData => {
        if (!rowData) return;
        const updatedEmpDetails = empDetails.map(obj => ({
            ...obj,
            tableData:
                obj.employeeId === rowData.employeeId
                    ? { ...obj.tableData, checked: checkBoxState }
                    : obj.tableData || {}
        }));
        setEmpDetails(updatedEmpDetails);
    };

    const handleApproveClick = async (rowData, selectedValues) => {
        setCheckBoxState(false);
        const message = ValidateUpdate(rowData);
        if (message.length == 0) {
            const result = await updateTimesheetEmployee({
                EmployeeId: rowData.employeeId,
                TeamId: rowData.teamId,
                TimesheetManagerId:
                    selectedValues[rowData.employeeId]?.timesheetManagerId ||
                    rowData.timesheetManagerId,
                EmployeeName: rowData.employeeName,
                TimesheetApproverId1:
                    selectedValues[rowData.employeeId]?.timesheetApproverId1 ||
                    rowData.timesheetApproverId1,
                TimesheetApproverId2:
                    selectedValues[rowData.employeeId]?.timesheetApproverId2 ||
                    rowData.timesheetApproverId2
            });
            if (result.success)
                setShowAlert(
                    true,
                    "success",
                    "Employee Role updated successfully!"
                );
            else setShowAlert(true, "error", "Error updating Employee Role");
        } else {
            setShowAlert(true, "error", message[0].error);
        }
        setSelectedValues([]);
    };

    const handleCheckBoxState = () => {
        const updatedEmpDetails = employeeDetails.map(emp => ({
            ...emp,
            tableData: { ...emp.tableData, checked: checkBoxState }
        }));
        setEmpDetails(updatedEmpDetails);
    };

    const handleClientChange = async e => {
        setIsloading(true);
        setCheckBoxState(false);
        const {
            target: { value }
        } = e;
        const selectedClient = clients.filter(cl => cl.id === value);
        setActiveClient(selectedClient[0]);
        await fetchClientTeamsList(value);
        await fetchEmployeeDetailsByTeamId(null, value);
        setIsloading(false);
        setSelectedValues([]);
    };

    const handleTeamChange = async e => {
        setIsloading(true);
        setCheckBoxState(false);
        const {
            target: { value }
        } = e;
        const selectedTeam = teams.filter(tm => tm.id === value);
        setActiveTeam(selectedTeam[0]);
        await fetchEmployeeDetailsByTeamId(value, activeClient.id);
        setIsloading(false);
        setSelectedValues([]);
    };

    const handleChange = (event, rowData, type) => {
        setRowData(rowData);
        setCheckBoxState(true);
        if (
            event.target.value === "Manager" ||
            event.target.value === "Approver1" ||
            event.target.value === "Approver2"
        )
            event.target.value = 0;
        const detail = empDetails.map(emp => {
            if (emp.employeeId === rowData.employeeId) {
                return {
                    ...emp,
                    [type]: event.target.value
                };
            }
            return emp;
        });
        setSelectedValues(prevState => ({
            ...prevState,
            [rowData.employeeId]: {
                ...prevState[rowData.employeeId],
                [type]: event.target.value
            }
        }));
        setEmpDetails(detail);
    };

    const handleSaveAll = async () => {
        let errorMessages = [];
        const empResponseDetails = empDetails
            .map(rowData => {
                if (rowData.tableData.checked) {
                    rowData.tableData.checked = false;
                    const message = ValidateUpdate(rowData);
                    if (message.length == 0) {
                        return {
                            employeeId: rowData.employeeId,
                            teamId: rowData.teamId,
                            timesheetManagerId: rowData.timesheetManagerId,
                            employeeName: rowData.employeeName,
                            timesheetApproverId1: rowData.timesheetApproverId1,
                            timesheetApproverId2: rowData.timesheetApproverId2
                        };
                    } else {
                        errorMessages.push(message);
                        return null;
                    }
                }
            })
            .filter(item => item !== undefined);

        if (errorMessages.length == 0) {
            const result = await bulkUpdateEmployeeDetails(empResponseDetails);
            setSelectedValues([]);
            if (result.success)
                setShowAlert(
                    true,
                    "success",
                    "Employees Role updated successfully!"
                );
            else setShowAlert(true, "error", "Error updating Employees Role");
        } else {
            setShowAlert(
                true,
                "error",
                "CheckBox has been checked and dropdown hasn't been selected."
            );
        }
    };

    const isRowSelectedAndChanged = rowData => {
        if (Object.keys(selectedValues).length > 1) {
            return false;
        } else {
            return selectedValues[rowData.employeeId];
        }
    };

    const columns = [
        {
            title: "Employee Name",
            field: "employeeName",
            width: "90px",
            sortable: true
        },
        {
            title: "Manager",
            field: "managerName",
            width: "90px",
            render: rowData => (
                <FormControl size="small" sx={{ m: 1, width: 150 }}>
                    <Select
                        value={
                            selectedValues[rowData.employeeId]
                                ?.timesheetManagerId ||
                            rowData.timesheetManagerId ||
                            "Manager"
                        }
                        inputProps={{ "aria-label": "Without label" }}
                        onChange={event => {
                            handleChange(event, rowData, "timesheetManagerId");
                        }}
                        MenuProps={{
                            anchorOrigin: {
                                vertical: "center",
                                horizontal: "center"
                            },
                            transformOrigin: {
                                vertical: "center",
                                horizontal: "center"
                            }
                        }}
                    >
                        <MenuItem value="Manager">Select Manager</MenuItem>

                        {managerList &&
                            managerList
                                .filter(
                                    emp => emp.employeeId !== rowData.employeeId
                                )
                                .map(emp => (
                                    <MenuItem
                                        key={emp.employeeId}
                                        value={emp.employeeId}
                                    >
                                        {emp.employeeName}
                                    </MenuItem>
                                ))}
                    </Select>
                </FormControl>
            )
        },
        {
            title: "Approver1",
            field: "approver1Name",
            width: "90px",
            render: rowData => (
                <FormControl size="small" sx={{ m: 1, width: 150 }}>
                    <Select
                        value={
                            selectedValues[rowData.employeeId]
                                ?.timesheetApproverId1 ||
                            rowData.timesheetApproverId1 ||
                            "Approver1"
                        }
                        displayEmpty
                        inputProps={{ "aria-label": "Without label" }}
                        onChange={event =>
                            handleChange(event, rowData, "timesheetApproverId1")
                        }
                    >
                        <MenuItem value="Approver1">Select Approver 1</MenuItem>
                        {approverId1List &&
                            approverId1List.map(
                                emp =>
                                    emp.employeeId !== rowData.employeeId && (
                                        <MenuItem
                                            key={emp.employeeId}
                                            value={emp.employeeId}
                                        >
                                            {emp.employeeName}
                                        </MenuItem>
                                    )
                            )}
                    </Select>
                </FormControl>
            )
        },
        {
            title: "Approver2",
            field: "approver2Name",
            width: "90px",
            render: rowData => (
                <FormControl size="small" sx={{ m: 1, width: 150 }}>
                    <Select
                        value={
                            selectedValues[rowData.employeeId]
                                ?.timesheetApproverId2 ||
                            rowData.timesheetApproverId2 ||
                            "Approver2"
                        }
                        displayEmpty
                        inputProps={{ "aria-label": "Without label" }}
                        onChange={event =>
                            handleChange(event, rowData, "timesheetApproverId2")
                        }
                    >
                        <MenuItem value="Approver2">Select Approver 2</MenuItem>
                        {approverId2List &&
                            approverId2List.map(
                                emp =>
                                    emp.employeeId !== rowData.employeeId && (
                                        <MenuItem
                                            key={emp.employeeId}
                                            value={emp.employeeId}
                                        >
                                            {emp.employeeName}
                                        </MenuItem>
                                    )
                            )}
                    </Select>
                </FormControl>
            )
        },
        {
            title: "Action",
            field: "approveButton",
            width: "90px",
            render: rowData => (
                <IconButton
                    disabled={!isRowSelectedAndChanged(rowData)}
                    onClick={() => handleApproveClick(rowData, selectedValues)}
                >
                    <Save style={{ color: "green" }} />
                </IconButton>
            ),
            headerStyle: {
                textAlign: "center"
            },
            sorting: false,
            filtering: false
        }
    ];

    return (
        <div className="container">
            {alert.setAlertOpen && Object.keys(alert).length > 0 && (
                <CustomAlert
                    open={alert.setAlertOpen}
                    severity={alert.severity}
                    message={alert.message}
                    className={styles.alertStyle}
                    onClose={() => setShowAlert(false, "", "")}
                ></CustomAlert>
            )}

            <div className={styles.contentHeader1}>
                <div title={`${title}`} className={styles.title}>
                    {title}
                </div>
            </div>
            <div className={styles.dependentContainer}>
                <label htmlFor="clientSelect" className={styles.label}>
                    Client:
                </label>
                <FormControl size="small" sx={{ m: 1, width: 200 }}>
                    <Select
                        id="clientSelect"
                        value={activeClient && activeClient.id}
                        onChange={handleClientChange}
                    >
                        {clients &&
                            clients.length > 0 &&
                            clients.map(emp => (
                                <MenuItem key={emp.id} value={emp.id}>
                                    {emp.clientName}
                                </MenuItem>
                            ))}
                    </Select>
                </FormControl>
                <label htmlFor="teamSelect" className={styles.label}>
                    Team:
                </label>
                <FormControl size="small" sx={{ m: 1, width: 200 }}>
                    <Select
                        id="teamSelect"
                        onChange={handleTeamChange}
                        value={activeTeam && activeTeam.id}
                    >
                        {teams &&
                            teams.length > 0 &&
                            teams.map(team => (
                                <MenuItem key={team.id} value={team.id}>
                                    {team.teamName}
                                </MenuItem>
                            ))}
                    </Select>
                </FormControl>
                {Object.keys(selectedValues).length > 1 && (
                    <Button
                        className={styles.contentHeaderButtons1}
                        handleClick={handleSaveAll}
                        value="Save"
                    />
                )}
            </div>
            {isLoading === false ? (
                <Box className={styles.table}>
                    <MaterialTable
                        columns={columns}
                        data={empDetails}
                        options={{
                            selection: true,
                            toolbar: false,
                            paging: true,
                            pageSize: 20,
                            showSelectAllCheckbox: false,
                            maxBodyHeight: "450px",
                            showTitle: false,
                            actionsColumnIndex: -1,
                            headerStyle: {
                                backgroundColor: "#17072b",
                                overflow: "hidden",
                                color: "#fff",
                                position: "sticky",
                                top: 0,
                                right: 0,
                                zIndex: 1,
                                overflowX: "hidden"
                            },
                            draggable: false,
                            cellStyle: {
                                maxWidth: "90px",
                                padding: "5px 5px",
                                textOverflow: "ellipsis",
                                overflow: "hidden",
                                whiteSpace: "nowrap"
                            }
                        }}
                        style={{
                            width: "100%"
                        }}
                    />
                </Box>
            ) : (
                <Typography
                    varient="body"
                    textAlign="center"
                    fontSize="20px"
                    mt="100px"
                >
                    Loading ...
                </Typography>
            )}
        </div>
    );
};
export default TimesheetMappingRole;
