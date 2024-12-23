import React, { useState, useEffect, useRef } from "react";
import css from "rootpath/styles/formStyles.css";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import { validateEmployee } from "rootpath/components/SkillMatrix/commonValidationFunction";
import { FormControl, Select, MenuItem, Typography, Box } from "@mui/material";
import CustomAlert from "rootpath/components/CustomAlert";
import { handleScrollToTop } from "rootpath/commonFunctions";
import {
    EmpPostApi,
    updateEmployee
} from "rootpath/services/SkillMatrix/EmployeeService/EmployeeService";

const AddEmployee = ({
    selectedTeam,
    setIsEdit,
    showDrawer,
    setShowDrawer,
    setaddEmployeeFormVisible,
    addEmployeeFormVisible,
    empItem,
    postEmp,
    fetchEmplist,
    selectedEmployee,
    onsubmit,
    empListType,
    employeeRoleList,
    fetchRoleList,
    employeeDesignationList,
    fetchDesignationList,
    teams,
    clients,
    fetchClientTeams,
    setShowAlert,
    showAlert,
    setActiveClient,
    setActiveTeam,
    fetchTeamList
}) => {
    const [employee, setEmployee] = useState({
        clientId: selectedTeam.clientId,
        teamId: selectedTeam ? selectedTeam.id : empItem.id,
        employeeName: selectedEmployee?.employeeName || "",
        bhavnaEmployeeId: selectedEmployee?.bhavnaEmployeeId || "",
        emailId: selectedEmployee?.emailId || "",
        type: selectedEmployee?.type || 1,
        role: selectedEmployee?.role || 1,
        designationId: selectedEmployee?.designationId || 1,
        isEditEmployeeId: selectedEmployee?.bhavnaEmployeeId ? false : true
    });
    const [errorMessage, setErrorMessage] = useState([]);

    useEffect(() => {
        fetchClientTeams(selectedTeam.clientId);
        fetchRoleList();
        fetchDesignationList();
    }, []);
    const formContainerRef = useRef(null);
    const handlechange = e => {
        setEmployee(prev => {
            return { ...prev, [e.target.id]: e.target.value };
        });
    };

    const closeDrawer = () => {
        setIsEdit(false);
        setShowDrawer(!showDrawer);
        setaddEmployeeFormVisible(!addEmployeeFormVisible);
    };

    const onClientChange = event => {
        fetchClientTeams(event.target.value);
        setEmployee({ ...employee, teamId: 0, clientId: event.target.value });
        setErrorMessage([]);
        const activeClient = clients.find(
            client => client.id === event.target.value
        );
        setActiveClient(activeClient);
        fetchTeamList(event.target.value);
    };
    const handleUpdateOrCreationError = result => {
        let errorArray = [];
        if (result.error.response?.data === null) {
            let errorMessage = "An unexpected error occurred.";
            errorArray.push({ error: errorMessage, field: "name" });
        } else {
            result.error.response.data.map(item => {
                errorArray.push({ error: item.errorMessage, field: "name" });
            });
        }
        const errorMessage = errorArray.map(error => error.error).join(", ");
        setShowAlert(true, "error", errorMessage);
    };

    const onSubmitClick = async () => {
        var validate = validateEmployee(employee);
        setErrorMessage(validate);
        if (validate.length === 0) {
            const result =
                Object.keys(selectedEmployee).length > 0
                    ? await updateEmployee(employee)
                    : await EmpPostApi(employee);

            if (result?.success) {
                setShowAlert(
                    true,
                    "success",
                    "Employee Added/Updated successfully!"
                );
                fetchEmplist(employee.teamId, employee.clientId);
                closeDrawer();
            } else {
                handleUpdateOrCreationError(result);
            }
        }
    };

    return (
        <div className={css.formDrawer}>
            <div className={css.formContainer} ref={formContainerRef}>
                {showAlert.severity === "error" &&
                    Object.keys(showAlert).length > 0 && (
                        <CustomAlert
                            open={showAlert.setAlert}
                            severity={showAlert.severity}
                            message={showAlert.message}
                            onClose={() =>
                                setShowAlert(
                                    false,
                                    showAlert.severity,
                                    showAlert.message
                                )
                            }
                            onScrollToTop={handleScrollToTop(formContainerRef)}
                        ></CustomAlert>
                    )}
                <label className={css.label}>Client Name</label>
                <div>
                    <FormControl
                        sx={{
                            m: 1,
                            minWidth: 140
                        }}
                        size="small"
                    >
                        <Select
                            id="clientId"
                            value={employee.clientId}
                            displayEmpty
                            onChange={onClientChange}
                        >
                            {clients.map(item => (
                                <MenuItem key={item.id} value={item.id}>
                                    {item.clientName}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </div>
                <label className={css.label}>Team Name</label>
                <div>
                    <FormControl
                        sx={{
                            m: 1,
                            minWidth: 140
                        }}
                        size="small"
                    >
                        <Select
                            id="teamId"
                            value={employee.teamId}
                            displayEmpty
                            onChange={e => {
                                setEmployee({
                                    ...employee,
                                    teamId: e.target.value
                                });
                                const activeTeam = teams.find(
                                    team => team.id === e.target.value
                                );
                                setActiveTeam(activeTeam);
                            }}
                        >
                            {teams.map(item => (
                                <MenuItem key={item.id} value={item.id}>
                                    {item.teamName}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </div>
                <label className={css.label}>Employee Name</label>
                <input
                    className={css.formInput}
                    id={"employeeName"}
                    defaultValue={selectedEmployee.employeeName}
                    type="text"
                    onChange={e => handlechange(e)}
                ></input>
                {errorMessage.map(
                    item =>
                        item.field === "Name" && (
                            <div className={css.errorMessages}>
                                <span>{item.error}</span>
                            </div>
                        )
                )}
                <label className={css.label}>Employee Id</label>
                <input
                    className={css.formInput}
                    id={"bhavnaEmployeeId"}
                    defaultValue={selectedEmployee.bhavnaEmployeeId}
                    type="text"
                    disabled={
                        selectedEmployee.bhavnaEmployeeId &&
                        selectedEmployee.bhavnaEmployeeId != ""
                            ? "disabled"
                            : ""
                    }
                    onChange={e => handlechange(e)}
                ></input>
                {errorMessage.map(
                    item =>
                        item.field === "bhavnaEmployeeId" && (
                            <div className={css.errorMessages}>
                                <span>{item.error}</span>
                            </div>
                        )
                )}
                <label className={css.label}>Email Id</label>
                <input
                    className={css.formInput}
                    id={"emailId"}
                    defaultValue={selectedEmployee.emailId}
                    type="text"
                    onChange={e => handlechange(e)}
                ></input>
                {errorMessage.map(
                    item =>
                        item.field === "emailId" && (
                            <div className={css.errorMessages}>
                                <span>{item.error}</span>
                            </div>
                        )
                )}
                <label className={css.label}>Function Type</label>

                <div>
                    <FormControl
                        sx={{
                            m: 1,
                            minWidth: 140
                        }}
                        size="small"
                    >
                        <Select
                            id="type"
                            value={employee.type}
                            displayEmpty
                            onChange={e =>
                                setEmployee({
                                    ...employee,
                                    type: e.target.value
                                })
                            }
                        >
                            {empListType.map(currentObject => (
                                <MenuItem
                                    key={currentObject.id}
                                    value={currentObject.id}
                                >
                                    {currentObject.function_Type}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </div>

                <Typography
                    fontSize="15px"
                    fontWeight="500"
                    fontFamily="inherit"
                    color="#17072B"
                >
                    Role
                </Typography>

                <Box>
                    <FormControl
                        sx={{
                            m: 1,
                            minWidth: 140
                        }}
                        size="small"
                    >
                        <Select
                            id="role"
                            value={employee.role}
                            displayEmpty
                            onChange={e =>
                                setEmployee({
                                    ...employee,
                                    role: e.target.value
                                })
                            }
                        >
                            {employeeRoleList.map(item => (
                                <MenuItem key={item.roleId} value={item.roleId}>
                                    {item.roleName}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </Box>

                <Typography
                    fontSize="15px"
                    fontWeight="500"
                    fontFamily="inherit"
                    color="#17072B"
                >
                    Designation
                </Typography>

                <Box>
                    <FormControl
                        sx={{
                            m: 1,
                            minWidth: 140
                        }}
                        size="small"
                    >
                        <Select
                            id="designationId"
                            value={employee.designationId}
                            displayEmpty
                            onChange={e =>
                                setEmployee({
                                    ...employee,
                                    designationId: e.target.value
                                })
                            }
                        >
                            {employeeDesignationList.map(item => (
                                <MenuItem key={item.id} value={item.id}>
                                    {item.designation}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </Box>
            </div>

            <div className={css.footer}>
                <Button
                    handleClick={() => closeDrawer()}
                    className={"btn btn-light " + css.cancelButton}
                    value="Cancel"
                />
                <Button
                    handleClick={() => onSubmitClick()}
                    className={"btn btn-light " + css.submitButton}
                    value="Save"
                />
            </div>
        </div>
    );
};

export default AddEmployee;
