import { connect } from "react-redux";

import { getDashboardData } from "../../../redux/common/actions";
import {
    GetBarData,
    GetBoxData,
    GetBarDataTeamWise,
    GetBarDataCategoryWise,
    GetBarDataCategoryTeamWiseScore,
    GetLineDataEmployeeWiseTrend,
    GetBarDataCategoryTeamWiseScoreByTeamName,
    GetScoreNotMaintainedBoxData
} from "rootpath/services/SkillMatrix/Dashboard/DashboardService";
import Dashboard from "rootpath/components/SkillMatrix/Dashboard/Dashboard";
import {
    ClientListApi,
    ClientTeamsApi,
    TeamEmployeesListApi
} from "rootpath/services/SkillMatrix/MasterService/MasterService";
import { GetEmployeeRole } from "rootpath/services/SkillMatrix/EmployeeService/EmployeeService";
import { selectClasses } from "@mui/material";
import { getEmployeeTypeList } from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import { getEmployeeType, setLoader } from "rootpath/redux/common/actions";
const mapStateToProps = state => {
    const dashBoard = state.skillMatrixOps.dashBoard || [];
    return {
        barData: dashBoard.barData || [],
        lineData: dashBoard.lineData || [],
        expert: dashBoard.expert || [],
        needTraining: dashBoard.needTraining || [],
        goodDataEmployee: dashBoard.goodDataEmployee || [],
        averageEmployee: dashBoard.averageEmployee || [],
        clients: dashBoard.clients || [],
        barDataCategoryWise: dashBoard.barDataCategoryWise || [],
        barDataTeamWiseScore: dashBoard.barDataTeamWiseScore || [],
        clientTeamList: dashBoard.clientTeamList || [],
        employeeList: dashBoard.employeeList || [],
        scoreNotAvailable: dashBoard.scoreNotAvailable || [],
        selectedClient: dashBoard.selectedClient,
        selectedTeam: dashBoard.selectedTeam,
        selectedEmployee: dashBoard.selectedEmployee,
        activeTrendClient: dashBoard.activeTrendClient,
        selectedFunctionType: dashBoard.selectedFunctionType,
        empListType: state.skillMatrixOps.employeeType || [],
        isLoading: state.skillMatrixOps.isLoading || false
    };
};

const mapDispatchToProps = dispatch => ({
    fetchDashBoardList: async (
        activeClient,
        activeTeam,
        activeEmployee,
        functionType
    ) => {
        try {
            dispatch(setLoader(true));
            const employeeListType = await getEmployeeTypeList();
            employeeListType.splice(0, 0, { function_Type: "All", id: 0 });
            dispatch(getEmployeeType(employeeListType));
            let clients = await ClientListApi(1);
            const employeeRole = await GetEmployeeRole();

            if (employeeRole.roleName === "Admin") {
                clients.splice(0, 0, { clientName: "All", id: 0 });
            }
            let barData = [];
            let lineData = [];
            let expertEmpRecords = [];
            let needTraingData = [];
            let AverageData = [];
            let GoodDataEmployee = [];
            let barDataCategoryWise = [];
            let barDataTeamWiseScore = [];
            let clientTeamList = [];
            let employeeList = [];
            let scoreNotAvailable = [];
            let selectedClient = "";
            let selectedTeam = "";
            let selectedEmployee = "";
            const selectedFunctionType = functionType ? functionType : "All";
            if (clients.length > 0) {
                selectedClient = activeClient ? activeClient : clients[0].id;
                barData = await GetBarData(
                    selectedClient,
                    selectedFunctionType
                );
                barDataCategoryWise = await GetBarDataCategoryWise(
                    selectedClient,
                    selectedFunctionType
                );

                barDataTeamWiseScore = await GetBarDataCategoryTeamWiseScore(
                    selectedClient,
                    selectedFunctionType
                );
                needTraingData = await GetBoxData(
                    selectedClient,
                    1,
                    40,
                    selectedFunctionType
                );
                AverageData = await GetBoxData(
                    selectedClient,
                    40,
                    60,
                    selectedFunctionType
                );
                GoodDataEmployee = await GetBoxData(
                    selectedClient,
                    60,
                    80,
                    selectedFunctionType
                );
                expertEmpRecords = await GetBoxData(
                    selectedClient,
                    80,
                    1000,
                    selectedFunctionType
                );
                scoreNotAvailable = await GetScoreNotMaintainedBoxData(
                    selectedClient,
                    selectedFunctionType
                );

                clientTeamList = await ClientTeamsApi(
                    selectedClient,
                    selectedFunctionType
                );

                if (clientTeamList && clientTeamList.length > 0) {
                    clientTeamList.splice(0, 0, { teamName: "All", id: 0 });
                    selectedTeam = clientTeamList[0].id;
                    employeeList = await TeamEmployeesListApi(selectedTeam);
                    if (employeeList && employeeList.length > 0) {
                        employeeList.splice(0, 0, {
                            employeeName: "All",
                            bhavnaEmployeeId: "0"
                        });
                        selectedEmployee = employeeList[0].bhavnaEmployeeId;
                        lineData = await GetLineDataEmployeeWiseTrend(
                            clients[0].id,
                            clientTeamList[0].id,
                            employeeList[0].bhavnaEmployeeId,
                            selectedFunctionType
                        );
                    } else {
                        lineData = await GetLineDataEmployeeWiseTrend(
                            clients[0].id,
                            selectedTeam,
                            0,
                            selectedFunctionType
                        );
                    }
                } else {
                    lineData = await GetLineDataEmployeeWiseTrend(
                        0,
                        0,
                        0,
                        selectedFunctionType
                    );
                }
            }
            dispatch(
                getDashboardData({
                    clients: clients,
                    barData: barData,
                    lineData: lineData,
                    expert: expertEmpRecords,
                    needTraining: needTraingData,
                    goodDataEmployee: GoodDataEmployee,
                    averageEmployee: AverageData,
                    barDataCategoryWise: barDataCategoryWise,
                    barDataTeamWiseScore: barDataTeamWiseScore,
                    clientTeamList: clientTeamList,
                    employeeList: employeeList,
                    scoreNotAvailable: scoreNotAvailable,
                    selectedClient: activeClient
                        ? activeClient
                        : selectedClient,
                    selectedTeam: activeTeam ? activeTeam : selectedTeam,
                    selectedEmployee: activeEmployee
                        ? activeEmployee
                        : selectedEmployee,
                    activeTrendClient: activeClient
                        ? activeClient
                        : selectedClient,
                    selectedFunctionType: selectedFunctionType
                })
            );
        } finally {
            dispatch(setLoader(false));
        }
    },
    fetchClientScore: async (id, clients, functionType) => {
        try {
            dispatch(setLoader(true));
            const clientId = id ? id : clients[0].id;
            const selectedFunctionType = functionType ? functionType : "All";
            const barData = await GetBarData(clientId, selectedFunctionType);
            const barDataCategoryWise = await GetBarDataCategoryWise(
                clientId,
                selectedFunctionType
            );
            let lineData = [];
            const expertEmpRecords = await GetBoxData(
                clientId,
                80,
                1000,
                selectedFunctionType
            );
            const needTraingData = await GetBoxData(
                clientId,
                1,
                40,
                selectedFunctionType
            );
            const AverageData = await GetBoxData(
                clientId,
                40,
                60,
                selectedFunctionType
            );
            const GoodDataEmployee = await GetBoxData(
                clientId,
                60,
                80,
                selectedFunctionType
            );
            const scoreNotAvailable = await GetScoreNotMaintainedBoxData(
                clientId,
                selectedFunctionType
            );
            const barDataTeamWiseScore = await GetBarDataCategoryTeamWiseScore(
                clientId,
                selectedFunctionType
            );
            const clientTeamList = await ClientTeamsApi(
                clientId,
                selectedFunctionType
            );
            const selectedClient = clientId;
            let selectedTeam = "";
            let selectedEmployee = "";
            let employeeList = [];
            if (clientTeamList && clientTeamList.length > 0) {
                clientTeamList.splice(0, 0, { teamName: "All", id: 0 });
                selectedTeam = clientTeamList[0].id;
                employeeList = await TeamEmployeesListApi(selectedTeam);

                if (employeeList && employeeList.length > 0) {
                    employeeList.splice(0, 0, {
                        employeeName: "All",
                        bhavnaEmployeeId: "0"
                    });
                    selectedEmployee = employeeList[0].bhavnaEmployeeId;
                    lineData = await GetLineDataEmployeeWiseTrend(
                        clientId,
                        clientTeamList[0].id,
                        employeeList[0].bhavnaEmployeeId,
                        selectedFunctionType
                    );
                } else {
                    lineData = await GetLineDataEmployeeWiseTrend(
                        selectedClient,
                        selectedTeam,
                        0,
                        selectedFunctionType
                    );
                }
            } else {
                lineData = await GetLineDataEmployeeWiseTrend(
                    0,
                    0,
                    0,
                    selectedFunctionType
                );
            }
            dispatch(
                getDashboardData({
                    clients: clients,
                    barData: barData,
                    lineData: lineData,
                    expert: expertEmpRecords,
                    needTraining: needTraingData,
                    averageEmployee: AverageData,
                    goodDataEmployee: GoodDataEmployee,
                    barDataCategoryWise: barDataCategoryWise,
                    barDataTeamWiseScore: barDataTeamWiseScore,
                    clientTeamList: clientTeamList,
                    employeeList: employeeList,
                    scoreNotAvailable: scoreNotAvailable,
                    selectedClient,
                    selectedTeam,
                    selectedEmployee,
                    SelectedTrendClient: selectedClient,
                    selectedFunctionType: selectedFunctionType
                })
            );
        } finally {
            dispatch(setLoader(false));
        }
    },
    fetchBarDataTeamWise: async (
        teamName,
        clients,
        lineData,
        expertEmpRecords,
        needTraingData,
        goodDataEmployee,
        AverageData,
        barDataCategoryWise,
        barDataTeamWiseScore,
        chartType,
        barData,
        clientTeamList,
        employeeList,
        scoreNotAvailable,
        selectedClient,
        selectedTeam,
        selectedEmployee,
        functionType
    ) => {
        try {
            dispatch(setLoader(true));
            const id = selectedClient ? selectedClient : clients[0].id;
            const selectedFunctionType = functionType ? functionType : "All";
            let response = [];
            if (chartType == "TeamWise") {
                response = await GetBarDataTeamWise(
                    id,
                    teamName,
                    chartType,
                    selectedFunctionType
                );
            } else {
                response = await GetBarDataCategoryTeamWiseScoreByTeamName(
                    id,
                    teamName,
                    selectedFunctionType
                );
            }
            dispatch(
                getDashboardData({
                    clients: clients,
                    barData: chartType == "TeamWise" ? response : barData,
                    lineData: lineData,
                    expert: expertEmpRecords,
                    needTraining: needTraingData,
                    goodDataEmployee: goodDataEmployee,
                    averageEmployee: AverageData,
                    barDataCategoryWise: barDataCategoryWise,
                    barDataTeamWiseScore:
                        chartType == "ScoreWise"
                            ? response
                            : barDataTeamWiseScore,
                    clientTeamList: clientTeamList,
                    employeeList: employeeList,
                    scoreNotAvailable: scoreNotAvailable,
                    selectedClient: id,
                    selectedTeam,
                    selectedEmployee,
                    selectedFunctionType: selectedFunctionType
                })
            );
        } finally {
            dispatch(setLoader(false));
        }
    },
    fetchLineChartEmployeeWise: async (
        bhavnaEmployeeId,
        clients,
        expertEmpRecords,
        needTraingData,
        goodDataEmployee,
        AverageData,
        barDataCategoryWise,
        barDataTeamWiseScore,
        barData,
        clientTeamList,
        employeeList,
        scoreNotAvailable,
        selectedClient,
        selectedTeam,
        functionType
    ) => {
        try {
            dispatch(setLoader(true));
            const id = selectedClient ? selectedClient : clients[0].id;
            const teamid = selectedTeam ? selectedTeam : clientTeamList[0].id;
            const selectedFunctionType = functionType ? functionType : "All";
            const lineDataresponse = await GetLineDataEmployeeWiseTrend(
                id,
                teamid,
                bhavnaEmployeeId,
                selectedFunctionType
            );

            dispatch(
                getDashboardData({
                    clients: clients,
                    barData: barData,
                    lineData: lineDataresponse,
                    expert: expertEmpRecords,
                    needTraining: needTraingData,
                    goodDataEmployee: goodDataEmployee,
                    averageEmployee: AverageData,
                    barDataCategoryWise: barDataCategoryWise,
                    barDataTeamWiseScore: barDataTeamWiseScore,
                    clientTeamList: clientTeamList,
                    employeeList: employeeList,
                    scoreNotAvailable: scoreNotAvailable,
                    selectedClient: id,
                    selectedTeam: teamid,
                    selectedEmployee: bhavnaEmployeeId,
                    selectedFunctionType: selectedFunctionType
                })
            );
        } finally {
            dispatch(setLoader(false));
        }
    },
    fetchLineChartTrendDataTeamWise: async (
        teamId,
        clients,
        expertEmpRecords,
        needTraingData,
        goodDataEmployee,
        AverageData,
        barDataCategoryWise,
        barDataTeamWiseScore,
        barData,
        clientTeamList,
        scoreNotAvailable,
        selectedClient,
        activeTrendClient,
        functionType
    ) => {
        try {
            dispatch(setLoader(true));
            const id = activeTrendClient ? activeTrendClient : clients[0].id;
            const teamid = teamId ? teamId : clientTeamList[0].id;
            const selectedFunctionType = functionType ? functionType : "All";
            const employeeList = await TeamEmployeesListApi(teamid);

            let lineDataresponse = [];
            if (employeeList && employeeList.length > 0) {
                employeeList.splice(0, 0, {
                    employeeName: "All",
                    bhavnaEmployeeId: 0
                });
                lineDataresponse = await GetLineDataEmployeeWiseTrend(
                    id,
                    teamid,
                    employeeList[0].bhavnaEmployeeId,
                    functionType
                );
            } else {
                lineDataresponse = await GetLineDataEmployeeWiseTrend(
                    id,
                    teamid,
                    0,
                    functionType
                );
            }
            dispatch(
                getDashboardData({
                    clients: clients,
                    barData: barData,
                    lineData: lineDataresponse,
                    expert: expertEmpRecords,
                    needTraining: needTraingData,
                    goodDataEmployee: goodDataEmployee,
                    averageEmployee: AverageData,
                    barDataCategoryWise: barDataCategoryWise,
                    barDataTeamWiseScore: barDataTeamWiseScore,
                    clientTeamList: clientTeamList,
                    employeeList: employeeList,
                    scoreNotAvailable: scoreNotAvailable,
                    selectedClient: selectedClient,
                    selectedTeam: teamid,
                    selectedEmployee:
                        employeeList &&
                        employeeList.length > 0 &&
                        employeeList[0].bhavnaEmployeeId,
                    activeTrendClient: activeTrendClient,
                    selectedFunctionType: selectedFunctionType
                })
            );
        } finally {
            dispatch(setLoader(false));
        }
    },
    fetchLineChartTrendDataClientWise: async (
        teamId,
        clients,
        expertEmpRecords,
        needTraingData,
        goodDataEmployee,
        AverageData,
        barDataCategoryWise,
        barDataTeamWiseScore,
        barData,
        clientTeamList,
        scoreNotAvailable,
        selectedClient,
        activeTrendClient,
        functionType
    ) => {
        try {
            dispatch(setLoader(true));
            const id = activeTrendClient ? activeTrendClient : clients[0].id;
            const selectedFunctionType = functionType ? functionType : "All";

            clientTeamList = await ClientTeamsApi(id);
            if (clientTeamList && clientTeamList.length > 0) {
                clientTeamList.splice(0, 0, { teamName: "All", id: 0 });
            }
            const teamid = id && teamId ? teamId : 0;

            const employeeList = []; //await TeamEmployeesListApi(teamid);

            let lineDataresponse = [];

            lineDataresponse = await GetLineDataEmployeeWiseTrend(
                id,
                teamid,
                0,
                selectedFunctionType
            );

            dispatch(
                getDashboardData({
                    clients: clients,
                    barData: barData,
                    lineData: lineDataresponse,
                    expert: expertEmpRecords,
                    needTraining: needTraingData,
                    goodDataEmployee: goodDataEmployee,
                    averageEmployee: AverageData,
                    barDataCategoryWise: barDataCategoryWise,
                    barDataTeamWiseScore: barDataTeamWiseScore,
                    clientTeamList: clientTeamList,
                    employeeList: employeeList,
                    scoreNotAvailable: scoreNotAvailable,
                    selectedClient: selectedClient,
                    selectedTeam: teamid,
                    selectedEmployee:
                        employeeList &&
                        employeeList.length > 0 &&
                        employeeList[0].bhavnaEmployeeId,
                    activeTrendClient: activeTrendClient,
                    selectedFunctionType: selectedFunctionType
                })
            );
        } finally {
            dispatch(setLoader(false));
        }
    }
});

const DashboardContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(Dashboard);

export default DashboardContainer;
