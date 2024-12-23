import React, { useEffect, useState } from "react";
import styles from "../SkillMatrix/SkillMatrixDashboard/Dashboard.css";
import MaterialTable from "@material-table/core";
import Button from "rootpath/components/SkillMatrix/Button/Button";

const RoleList = ({
    title,
    clients,
    teams,
    employees,
    fetchClientList,
    fetchClientTeamsList,
    fetchEmplist,
    postEmployeeRolesFunction
}) => {
    const [dataToSave, setDataToSave] = useState([]);
    const [employeees, setEmployeees] = useState([]);
    const [selectedClient, setSelectedClient] = useState("");
    const [selectedTeam, setSelectedTeam] = useState("");

    const handleChange = e => {
        setSelectedClient(e.target.value);
    };
    const handleChangeTeam = e => {
        const selectedTeam1 = teams.find(x => x.id == e.target.value);
        setSelectedTeam(selectedTeam1);
    };
    useEffect(() => {
        fetchClientList();
    }, [fetchClientList]);

    useEffect(() => {
        selectedTeam && fetchEmplist(selectedTeam.id);
    }, [selectedTeam]);

    useEffect(() => {
        setEmployeees(employees);
    }, [employees]);

    useEffect(() => {
        selectedClient && fetchClientTeamsList(selectedClient);
        setSelectedTeam("");
        setEmployeees([]);
    }, [selectedClient, fetchClientTeamsList]);

    const columns = [
        {
            title: "Employee Name",
            field: "employeeName",
            sortable: true
        },
        {
            title: "Admin",
            field: "Admin",
            render: rowData => (
                <input
                    onChange={() =>
                        handleClickCheck(
                            "Admin",
                            rowData.tableData.index,
                            rowData.roles[0].value
                        )
                    }
                    type="checkbox"
                    checked={rowData.roles[0].value}
                />
            )
        },
        {
            title: "Employee",
            field: "Employee",
            render: rowData => (
                <input
                    onChange={() =>
                        handleClickCheck(
                            "Employee",
                            rowData.tableData.index,
                            rowData.roles[1].value
                        )
                    }
                    type="checkbox"
                    checked={rowData.roles[1].value}
                />
            )
        },
        {
            title: "Reporting Manager",
            field: "Reporting_Manager",
            render: rowData => (
                <input
                    onChange={() =>
                        handleClickCheck(
                            "Reporting_Manager",
                            rowData.tableData.index,
                            rowData.roles[2].value
                        )
                    }
                    type="checkbox"
                    checked={rowData.roles[2].value}
                />
            )
        },
        {
            title: "Approver",
            field: "Approver",
            render: rowData => (
                <input
                    onChange={() =>
                        handleClickCheck(
                            "Approver",
                            rowData.tableData.index,
                            rowData.roles[3].value
                        )
                    }
                    type="checkbox"
                    checked={rowData.roles[3].value}
                />
            )
        }
    ];
    const handleClickCheck = (fieldName, rowIndex, val) => {
        const updatedEmployees = employeees.map((employee, index) => {
            if (index === rowIndex) {
                const updatedRoles = employee.roles.map(role => ({
                    id: role.id,
                    roleName: role.roleName,
                    value: role.roleName === fieldName ? !val : false
                }));
                dataToSave.push({ ...employee, roles: updatedRoles });
                setDataToSave(dataToSave);
                return {
                    ...employee,
                    roles: updatedRoles
                };
            }
            return employee;
        });
        setEmployeees(updatedEmployees);
    };

    const handleSave = () => {
        postEmployeeRolesFunction(dataToSave);
    };
    return (
        <div className="container">
            <div className={styles.contentHeader}>
                <div title={`${title}`} className={styles.title}>
                    {title}
                </div>
                <div>
                    <Button
                        className={styles.contentHeaderButtons}
                        handleClick={handleSave}
                        value="Save"
                    />
                </div>
            </div>
            <div className={styles.dashboardView}>
                <div className={styles.dependentContainer}>
                    <select
                        className={styles.dropdown}
                        defaultValue=""
                        value={selectedClient}
                        onChange={handleChange}
                    >
                        <option value="" hidden>
                            Select Client
                        </option>
                        {clients.length > 1 &&
                            clients.map(emp => (
                                <option key={emp.id} value={emp.id}>
                                    {emp.clientName}
                                </option>
                            ))}
                    </select>
                    <select
                        className={styles.dropdown}
                        defaultValue=""
                        onChange={handleChangeTeam}
                        value={selectedTeam.id}
                    >
                        <option value="" hidden>
                            Select Team
                        </option>
                        {teams.length > 0 &&
                            teams.map(team => (
                                <option key={team.id} value={team.id}>
                                    {team.teamName}
                                </option>
                            ))}
                    </select>
                </div>
                <div className={styles.table}>
                    <MaterialTable
                        columns={columns}
                        data={employeees}
                        options={{
                            search: false,
                            toolbar: false,
                            maxBodyHeight: "100%",
                            actionsColumnIndex: -1,
                            headerStyle: {
                                backgroundColor: "#17072b",
                                color: "#fff"
                            },
                            draggable: false
                        }}
                        style={{
                            height: "100%"
                        }}
                    />
                </div>
            </div>
        </div>
    );
};

export default RoleList;
