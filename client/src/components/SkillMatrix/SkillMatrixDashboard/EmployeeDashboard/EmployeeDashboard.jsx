import React, { useEffect, useLayoutEffect, useState, useRef } from "react";
import styles from "../Dashboard.css";
import ScoreMappingClient from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreMappingSelectors/ScoreMappingClient/ScoreMappingClient";
import ScoreMappingTeams from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreMappingSelectors/ScoreMappingTeams/ScoreMappingTeams";
import MaterialTable from "@material-table/core";
import { Delete, Edit } from "@material-ui/icons";
import DrawerComponent from "rootpath/components/SkillMatrix/DrawerComponent/DrawerComponent";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import cx from "classnames";
import CustomAlert from "rootpath/components/CustomAlert";
const EmployeeDashboard = ({
    title,
    clientTeams,
    fetchClientList,
    fetchTeamList,
    clients,
    employees,
    fetchEmplist,
    deleteEmployee,
    setShowAlert,
    fetchEmpTypeList,
    empListType,
    showAlert
}) => {
    const [activeClient, setActiveClient] = useState("");
    const [activeTeam, setActiveTeam] = useState("");
    const [activeEmploeeList, setActiveEmploeeList] = useState("");
    const [showDrawer, setShowDrawer] = useState(false);
    const [employeeFormVisible, setEmployeeFormVisible] = useState(false);
    const [isEdit, setIsEdit] = useState(false);
    const [selectedEmployee, setSelectedEmployee] = useState({});
    const dashboardRef = useRef();
    useEffect(() => {
        fetchClientList();
        fetchTeamList();
        fetchEmplist();
        fetchEmpTypeList();
        setShowAlert(false);
    }, [fetchClientList, fetchTeamList, fetchEmplist, fetchEmpTypeList]);

    useEffect(() => {
        setActiveClient(clients[0] || "");
    }, [clients]);

    useEffect(() => {
        setActiveTeam(clientTeams[0] || "");
    }, [clients, clientTeams]);

    useEffect(() => {
        setActiveEmploeeList(employees || []);
    }, [clients, clientTeams, employees]);

    useLayoutEffect(() => {
        dashboardRef.current.style.height = `${window.innerHeight - 120}px`;
    }, []);

    const columns = [
        {
            title: "Employee Id",
            field: "bhavnaEmployeeId",
            sortable: true
        },
        {
            title: "Employee Name",
            field: "employeeName",
            sortable: true
        },
        {
            title: "Email Id",
            field: "emailId",
            sortable: true
        },
        {
            title: "Type",
            field: "functionType",
            sortable: true
        }
    ];
    const handleDeleteClick = (e, row) => {
        if (
            confirm(
                `Are you sure you want to delete employee ${row.employeeName}`
            )
        ) {
            deleteEmployee(row.bhavnaEmployeeId).then(async () => {
                fetchEmplist(activeTeam.id);
            });
        }
    };
    const tableActions = [
        {
            icon: () => <Edit />,
            tooltip: "Edit",
            onClick: (e, rowData) => handleEditClick(e, rowData)
        },
        {
            icon: () => <Delete />,
            tooltip: "Delete",
            onClick: (e, rowData) => handleDeleteClick(e, rowData)
        }
    ];

    const addEmployee = row => {
        if (row) {
            setIsEdit(true);
        } else {
            setIsEdit(false);
        }
        setShowDrawer(true);
        setEmployeeFormVisible(!employeeFormVisible);
    };
    const handleEditClick = (e, row) => {
        addEmployee(row);
        setSelectedEmployee(row);
    };
    const openEmployeeAddDrawer = employee => {
        if (employee) {
            setIsEdit(true);
        } else {
            setSelectedEmployee({});
        }
        setShowDrawer(!showDrawer);
        setEmployeeFormVisible(!employeeFormVisible);
    };
    const onClientChange = async client => {
        setActiveClient(client);
        await fetchTeamList(client.id);
    };
    const onTeamChange = async team => {
        setActiveTeam(team);
        await fetchEmplist(team.id);
    };
    return (
        <div className="container">
            {showAlert.setAlert &&
                Object.keys(showAlert).length > 0 &&
                showAlert.severity === "success" && (
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
                    />
                )}
            <div className={styles.contentHeader}>
                <div title={`${title}`} className={styles.title}>
                    {title}
                </div>
                <div>
                    <Button
                        className={styles.contentHeaderButtons}
                        handleClick={() => openEmployeeAddDrawer()}
                        value="Add Employee"
                    />
                </div>
            </div>

            <div className={styles.dashboardView} ref={dashboardRef}>
                <h5 className={styles.heading}>Choose Client:</h5>
                {clients && clients.length > 0 && (
                    <ScoreMappingClient
                        clients={clients}
                        setActiveClient={onClientChange}
                        activeClient={activeClient}
                    />
                )}
                <h5 className={styles.heading}>Choose Team:</h5>
                {clientTeams && clientTeams.length > 0 && (
                    <ScoreMappingTeams
                        teams={clientTeams}
                        setActiveTeam={onTeamChange}
                        activeTeam={activeTeam}
                    />
                )}
                <div className={styles.tableHeading}>
                    {activeClient.clientName} &gt;&gt; {activeTeam.teamName}
                </div>
                <div className={cx(styles.table, styles.employeeTable)}>
                    {employees.length > 0 ? (
                        <MaterialTable
                            columns={columns}
                            data={employees}
                            options={{
                                search: true,
                                toolbar: true,
                                actionsColumnIndex: -1,
                                pageSize: 10,
                                headerStyle: {
                                    backgroundColor: "#17072b",
                                    color: "#fff"
                                },
                                showEmptyDataSourceMessage: true,
                                showTitle: false,
                                draggable: false
                            }}
                            actions={tableActions}
                            style={{
                                height: "100%"
                            }}
                        />
                    ) : (
                        <div className={styles.noRecords}>
                            There are no records to display
                        </div>
                    )}
                </div>
            </div>
            {employees && employeeFormVisible && showDrawer && (
                <DrawerComponent
                    setShowAlert={setShowAlert}
                    showDrawer={showDrawer}
                    setShowDrawer={setShowDrawer}
                    addEmployeeFormVisible={employeeFormVisible}
                    setIsEdit={setIsEdit}
                    setaddEmployeeFormVisible={setEmployeeFormVisible}
                    parentid={activeTeam.id}
                    formHeaderTitle={
                        isEdit
                            ? `Edit Employee - ${activeClient.clientName}`
                            : `Add Employee - ${activeClient.clientName}`
                    }
                    selectedTeam={activeTeam}
                    fetchEmplist={fetchEmplist}
                    selectedEmployee={selectedEmployee}
                    setActiveClient={setActiveClient}
                    setActiveTeam={setActiveTeam}
                    fetchTeamList={fetchTeamList}
                />
            )}
        </div>
    );
};
export default EmployeeDashboard;
