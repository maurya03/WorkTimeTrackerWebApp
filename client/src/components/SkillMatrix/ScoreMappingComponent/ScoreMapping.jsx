import React, { useState, useLayoutEffect, useEffect, useRef } from "react";
import Stack from "@mui/material/Stack";
import Select from "@mui/material/Select";
import MenuItem from "@mui/material/MenuItem";
import styles from "rootpath/components/SkillMatrix/SkillMatrixDashboard/Dashboard.css";
import css from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreMapping.css";
import ScoreTable from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreTable";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import Menu from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreMappingSelectors/Menu/Menu";
import CustomAlert from "rootpath/components/CustomAlert";

const ScoreMapping = ({
    clients,
    clientTeams,
    employees,
    categories,
    fetchClientList,
    fetchTeamList,
    fetchEmployeeList,
    fetchCategoryList,
    skillMatrixData,
    fetchSkillMatrixData,
    fetchExpectedScore,
    expectedScoreMappings,
    newSubCategoryMapping,
    fetchClientScoreMapping,
    clientScoreMappingFunction,
    postEmployeeScores,
    postClientScores,
    identifier,
    showErrorMessage,
    setShowAlert,
    showAlert
}) => {
    const [activeClient, setActiveClient] = useState({});
    const [activeCategory, setActiveCategory] = useState({});
    const [activeTeam, setActiveTeam] = useState({});
    const [activeTeamEmployees, setActiveTeamEmployees] = useState([]);
    const [selectedEmployee, setSelectedEmployee] = useState("all");
    const [tableData, setTableData] = useState(params);
    const [dataToSave, setDataToSave] = useState([]);
    const [params, setParams] = useState([]);
    const [isButtonDisable, setIsButtonDisable] = useState(true);
    const [subCategoryMappings, setSubCategoryMappings] = useState([]);
    const dashboardRef = useRef();

    useEffect(() => {
        fetchClientList();
        fetchTeamList();
        fetchEmployeeList();
        fetchCategoryList();
        fetchSkillMatrixData();
        fetchClientScoreMapping();
    }, [
        fetchClientList,
        fetchTeamList,
        fetchCategoryList,
        fetchEmployeeList,
        fetchSkillMatrixData,
        fetchClientScoreMapping
    ]);

    useEffect(() => {
        const saveClient = findDefaultClient(clients, clientTeams, activeTeam);
        setActiveClient(saveClient);
        if (identifier === "clientScorePage") {
            getTeamWiseExpectedScore();
        } else {
            getSkillMatrixData();
            fetchEmployeeList(activeTeam.id);
            setSelectedEmployee("all");
        }
    }, [clients, activeTeam]);

    useEffect(() => {
        setActiveTeam(clientTeams[0] || "");
    }, [clientTeams]);

    useEffect(() => {
        setActiveTeamEmployees(employees || []);
    }, [employees]);

    useLayoutEffect(() => {
        dashboardRef.current.style.height = `${window.innerHeight - 140}px`;
    }, []);

    useEffect(() => {
        if (identifier === "employeeScorePage") {
            setTableData(skillMatrixData);
            setParams(skillMatrixData);
        } else {
            setTableData(subCategoryMappings);
            setParams(subCategoryMappings);
        }
    }, [skillMatrixData, subCategoryMappings]);

    useEffect(() => {
        activeCategory?.id &&
            clientScoreMappingFunction(activeCategory, expectedScoreMappings);
    }, [activeCategory, expectedScoreMappings]);

    useEffect(() => {
        setSubCategoryMappings(newSubCategoryMapping);
    }, [newSubCategoryMapping]);

    const getSkillMatrixData = async () => {
        await fetchSkillMatrixData(activeTeam.id, activeCategory.id);
    };

    const getTeamWiseExpectedScore = async () => {
        await fetchExpectedScore(activeTeam.id);
    };

    const findDefaultClient = (clients, clientTeams, activeTeam) => {
        const matchingClient = clients.find(
            client => client.id === activeTeam.clientId
        );
        const defaultClient =
            matchingClient ||
            (clientTeams.length > 0 &&
                clients.find(client => client.id === clientTeams[0]?.clientId));
        return defaultClient || {};
    };

    const handleSaveData = () => {
        if (identifier === "employeeScorePage") {
            postEmployeeScoringRecord(dataToSave);
        } else {
            let dataToSave = [];
            subCategoryMappings.forEach(subCategory => {
                dataToSave.push({
                    teamId: activeTeam.id,
                    subCategoryId: subCategory.id,
                    clientExpectedScore: subCategory.clientExpectedScore
                });
            });
            postClientScoringRecord(dataToSave);
        }
    };

    const postClientScoringRecord = async state => {
        var result = await postClientScores(state);
        if (result?.success) {
            getTeamWiseExpectedScore();
        } else {
            showErrorMessage(result);
        }
    };
    const postEmployeeScoringRecord = async state => {
        const result = await postEmployeeScores(state);
        if (result?.success) {
            getSkillMatrixData();
            setSelectedEmployee("all");
            setIsButtonDisable(false);
        } else {
            showErrorMessage(result);
        }
    };
    const handleCancel = () => {
        setTableData(params);
        setIsButtonDisable(true);
        identifier === "clientScorePage" &&
            clientScoreMappingFunction(activeCategory, expectedScoreMappings);
    };

    const handleClientChange = (client, team) => {
        setActiveClient(client);
        setActiveTeam(team);
        if (identifier === "employeeScorePage") {
            fetchCategoryList(team.id);
            fetchEmployeeList(team.id);
            setSelectedEmployee("all");
            fetchSkillMatrixData(team.id, activeCategory.id);
        }
        identifier === "clientScorePage" && fetchClientScoreMapping(team.id);
    };

    const handleCategoryChange = item => {
        setActiveCategory(item);
        identifier === "employeeScorePage" &&
            fetchSkillMatrixData(activeTeam.id, item.id);
        identifier === "clientScorePage" &&
            fetchClientScoreMapping(activeTeam.id);
    };

    const onEmployeeSelect = event => {
        const {
            target: { value }
        } = event;
        setSelectedEmployee(value);
        if (value !== "all") {
            let data = skillMatrixData;
            data = data.map(item => {
                const filteredEmployees = item.employeeList.filter(
                    emp => emp.bhavnaEmployeeId === value
                );
                return { ...item, employeeList: filteredEmployees };
            });
            setTableData(data);
            setParams(data);
        } else {
            setTableData(skillMatrixData);
            setParams(skillMatrixData);
        }
    };
    return (
        <div className="container">
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
                    ></CustomAlert>
                )}
            <div className={styles.contentHeader}>
                {identifier === "employeeScorePage" && (
                    <div className={styles.title}>Manage Employee Score</div>
                )}
                {identifier === "clientScorePage" && (
                    <div className={styles.title}>Manage Client Score</div>
                )}
                <div>
                    <Button
                        selected={isButtonDisable}
                        className={styles.contentHeaderButtons}
                        handleClick={() => {
                            handleCancel();
                        }}
                        value="Cancel"
                    />
                    <Button
                        selected={isButtonDisable}
                        className={styles.contentHeaderButtons}
                        handleClick={() => {
                            handleSaveData();
                        }}
                        value="Save"
                    />
                </div>
            </div>
            <Stack
                direction="row"
                alignItems="center"
                justifyContent="space-between"
                marginTop="10px"
            >
                <Menu
                    clients={clients}
                    clientTeams={clientTeams}
                    categories={categories}
                    activeClient={activeClient}
                    activeCategory={activeCategory}
                    setActiveCategory={setActiveCategory}
                    activeTeam={activeTeam}
                    fetchTeamList={fetchTeamList}
                    handleClientChange={handleClientChange}
                    handleCategoryChange={handleCategoryChange}
                    identifier={identifier}
                    setIsButtonDisable={setIsButtonDisable}
                />
                {identifier === "employeeScorePage" &&
                    activeTeamEmployees?.length > 0 && (
                        <Select
                            value={selectedEmployee}
                            displayEmpty
                            onChange={onEmployeeSelect}
                            sx={{ width: "200px" }}
                            size="small"
                        >
                            <MenuItem key="all" value="all">
                                All Employees
                            </MenuItem>
                            {activeTeamEmployees.map(emp => (
                                <MenuItem
                                    key={emp.bhavnaEmployeeId}
                                    value={emp.bhavnaEmployeeId}
                                >
                                    {emp.employeeName}
                                </MenuItem>
                            ))}
                        </Select>
                    )}
            </Stack>

            <div className={styles.dashboardView} ref={dashboardRef}>
                <div className={styles.tableHeading}>
                    {activeClient.clientName}
                    {" >> "}
                    {activeTeam.teamName}
                    {" >> "}
                    {activeCategory?.categoryName}
                </div>
                <div className={css.table}>
                    {(params && params.length > 0) ||
                    (subCategoryMappings && subCategoryMappings.length > 0) ? (
                        <ScoreTable
                            params={params}
                            setTableData={setTableData}
                            tableData={tableData}
                            setDataToSave={setDataToSave}
                            dataToSave={dataToSave}
                            identifier={identifier}
                            subCategoryMappings={subCategoryMappings}
                            setSubCategoryMappings={setSubCategoryMappings}
                            setIsButtonDisable={setIsButtonDisable}
                        />
                    ) : (
                        <div className={css.noRecords}>
                            There are no records to display
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};
export default ScoreMapping;
