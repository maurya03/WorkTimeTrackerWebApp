import React, { useEffect, useLayoutEffect, useState, useRef } from "react";
import styles from "rootpath/components/SkillMatrix/SkillMatrixDashboard/Dashboard.css";
import "react-horizontal-scrolling-menu/dist/styles.css";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import MaterialTable from "@material-table/core";
import { ArrowLeft, ArrowRight, Delete, Edit } from "@material-ui/icons";
import DrawerComponent from "rootpath/components/SkillMatrix/DrawerComponent/DrawerComponent";
import cx from "classnames";
import CustomAlert from "rootpath/components/CustomAlert";

const ClientDashboard = ({
    clients,
    clientTeams,
    fetchClientList,
    fetchTeamList,
    deleteClient,
    deleteTeam,
    title,
    fetchRole,
    userRole,
    showAlert,
    setShowAlert
}) => {
    const containerRef = useRef();
    const dashboardRef = useRef();
    const [selectedClient, setSelectedClient] = useState("");
    const [showDrawer, setShowDrawer] = useState(false);
    const [clientFormVisible, setclientFormVisible] = useState(false);
    const [showTeamForm, setTeamForm] = useState(false);
    const [clientTeamList, setClientTeamList] = useState([]);
    const [selectedTeam, setSelectedTeam] = useState({});
    const [isEdit, setIsEdit] = useState(false);
    const [isClientEdit, setIsClientEdit] = useState(false);

    useEffect(() => {
        fetchClientList();
        fetchTeamList();
        fetchRole();
        setShowAlert(false);
    }, [fetchClientList, fetchTeamList, fetchRole]);

    useEffect(() => {
        const newSelectedClient =
            clients.find(client => client.id === selectedClient.id) ||
            clients[0] ||
            "";
        setSelectedClient(newSelectedClient);
    }, [clients]);

    useEffect(() => {
        setClientTeamList(clientTeams || []);
    }, [clients, clientTeams]);

    useLayoutEffect(() => {
        dashboardRef.current.style.height = `${window.innerHeight - 120}px`;
    }, []);

    const columns = [
        {
            title: "Team Name",
            field: "teamName",
            sortable: true
        },
        {
            title: "Description",
            field: "teamDescription",
            sortable: true
        }
    ];

    const tableActions = [
        {
            icon: () => <Edit />,
            tooltip: "Edit",
            onClick: (e, rowData) => handleEditClick(e, rowData)
        },
        {
            icon: () => <Delete />,
            tooltip: "Delete",
            onClick: (e, rowData) => handleButtonClick(e, rowData)
        }
    ];
    const handleScroll = scrollAmount => {
        const newScrollPosition =
            containerRef.current.scrollLeft + scrollAmount;
        containerRef.current.scrollLeft = newScrollPosition;
    };

    const handleSelectedClient = client => {
        setSelectedClient(client);
        fetchTeamList(client.id);
        setShowAlert(false);
    };
    const addTeam = (e, row) => {
        if (row) {
            setIsEdit(true);
        } else {
            setIsEdit(false);
        }
        setShowDrawer(true);
        setTeamForm(true);
        fetchTeamList(selectedClient.id);
    };
    const handleEditClick = (e, row) => {
        addTeam(e, row);
        setSelectedTeam(row);
        setShowAlert(false);
    };
    const handleDeleteClient = async id => {
        if (confirm("Are you sure you want to delete this client?")) {
            const response = await deleteClient(id);
            await fetchClientList();
            await fetchTeamList();
            containerRef.current.scrollLeft = 0;
            if (response.success)
                setShowAlert(true, "success", "Client deleted successfully!");
            else
                setShowAlert(
                    true,
                    "error",
                    "Error deleting client. please delete dependent Teams!"
                );
        }
    };
    const handleButtonClick = async (e, row) => {
        if (confirm("Are you sure you want to delete this team?")) {
            const response = await deleteTeam(row.id);
            await fetchTeamList(row.clientId);
            if (response.success)
                setShowAlert(true, "success", "Team deleted successfully!");
            else setShowAlert(true, "error", "Error deleting team.");
        }
    };
    const openClientAddDrawer = client => {
        if (client) {
            setSelectedClient(client);
            setIsClientEdit(true);
            setShowAlert(false);
        } else {
            setIsClientEdit(false);
        }
        setShowDrawer(true);
        setclientFormVisible(!clientFormVisible);
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
                <div
                    title={`${title} - ${selectedClient.clientName}`}
                    className={styles.title}
                >
                    {title} - {selectedClient.clientName}
                </div>
                <div>
                    {Object.keys(userRole).length > 0 &&
                        userRole.roleName !== "Reporting_Manager" && (
                            <Button
                                className={styles.contentHeaderButtons}
                                handleClick={() => openClientAddDrawer()}
                                value="Add Client"
                            />
                        )}

                    <Button
                        className={styles.contentHeaderButtons}
                        handleClick={addTeam}
                        value="Add Team"
                    />
                </div>
            </div>

            <div className={styles.dashboardView} ref={dashboardRef}>
                <div
                    className={cx(
                        styles.clientContainer,
                        styles.topBottomMargin
                    )}
                >
                    <button
                        className={"btn btn-light" + styles.actionButton}
                        onClick={() => handleScroll(-200)}
                    >
                        <ArrowLeft />
                    </button>
                    <div ref={containerRef} className={styles.scrollClient}>
                        <div className={styles.contentBox}>
                            {clients.length > 0 &&
                                clients.map(client => (
                                    <div
                                        className={styles.scrollItems}
                                        key={client.clientName}
                                    >
                                        <Button
                                            title={client.clientName}
                                            className={
                                                (client.clientName ===
                                                selectedClient.clientName
                                                    ? "btn btn-primary "
                                                    : "btn btn-light ") +
                                                styles.clientButton
                                            }
                                            value={client.clientName}
                                            handleClick={() =>
                                                handleSelectedClient(client)
                                            }
                                        />
                                        {Object.keys(userRole).length > 0 &&
                                            userRole.roleName !==
                                                "Reporting_Manager" && (
                                                <div
                                                    className={
                                                        styles.scrollItemActions
                                                    }
                                                >
                                                    <span title="Edit Client">
                                                        <Edit
                                                            onClick={() => {
                                                                openClientAddDrawer(
                                                                    client
                                                                );
                                                                handleSelectedClient(
                                                                    client
                                                                );
                                                            }}
                                                        />
                                                    </span>
                                                    <span title="Delete Client">
                                                        <Delete
                                                            onClick={() => {
                                                                handleDeleteClient(
                                                                    client.id
                                                                );
                                                            }}
                                                        />
                                                    </span>
                                                </div>
                                            )}
                                    </div>
                                ))}
                        </div>
                    </div>
                    <button
                        className={"btn btn-light" + styles.actionButton}
                        onClick={() => handleScroll(200)}
                    >
                        <ArrowRight />
                    </button>
                </div>
                {/* <div className={styles.clientTeamContainer}>
                    <p>{selectedClient.clientName}</p>
                </div> */}
                <div className={styles.table}>
                    {clientTeamList.length > 0 ? (
                        <MaterialTable
                            columns={columns}
                            data={clientTeamList}
                            options={{
                                search: false,
                                toolbar: false,
                                actionsColumnIndex: -1,
                                pageSize: 10,
                                headerStyle: {
                                    backgroundColor: "#17072b",
                                    color: "#fff"
                                },
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

            {clients && clientFormVisible && showDrawer && (
                <DrawerComponent
                    showDrawer={showDrawer}
                    setShowDrawer={setShowDrawer}
                    setclientFormVisible={setclientFormVisible}
                    setShowAlert={setShowAlert}
                    clientFormVisible={clientFormVisible}
                    formHeaderTitle={
                        isClientEdit ? "Edit Client" : "Add Client"
                    }
                    setIsClientEdit={setIsClientEdit}
                    selectedClient={isClientEdit ? selectedClient : {}}
                />
            )}
            {showTeamForm && showDrawer && (
                <DrawerComponent
                    setShowAlert={setShowAlert}
                    showDrawer={showDrawer}
                    setShowDrawer={setShowDrawer}
                    setaddTeamFormVisible={setTeamForm}
                    addTeamFormVisible={showTeamForm}
                    parentid={selectedClient.id}
                    selectedClient={selectedClient}
                    setTeams={setClientTeamList}
                    formHeaderTitle={
                        isEdit
                            ? `Edit Team - ${selectedClient.clientName}`
                            : `Add Team - ${selectedClient.clientName}`
                    }
                    selectedTeam={isEdit ? selectedTeam : {}}
                    setIsEdit={setIsEdit}
                />
            )}
        </div>
    );
};

export default ClientDashboard;
