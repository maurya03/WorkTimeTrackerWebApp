import { connect } from "react-redux";
import ScoreMapping from "./ScoreMapping";
import {
    getCategoryList,
    getClientsList,
    getClientsTeamsList,
    getSubCategoryList,
    getEmployeeList
} from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import {
    setClientTeams,
    setCategories,
    setClients,
    getEmpList,
    setSkillMatrixDataNew,
    setExpectedScoreMappings,
    newSubCategoryMapping,
    showAlert
} from "rootpath/redux/common/actions";
import {
    getSkillMatrixTableData,
    clientTeamScoreMapping,
    teamExpectedScoresListApi,
    PostEmployeeScoreMappings,
    PostClientScoreMappings
} from "rootpath/services/SkillMatrix/ScoreService/ScoreService";
import { GetCategoryListWithTeamScore } from "rootpath/services/SkillMatrix/CategoryService/CategoryService";

const mapStateToProps = state => {
    return {
        clients: state.skillMatrixOps.clients || [],
        categories: state.skillMatrixOps.categories || [],
        clientTeams: state.skillMatrixOps.teams || [],
        employees: state.skillMatrixOps.employee || [],
        skillMatrixData: state.skillMatrixOps.skillMatrixDataUpdated || [],
        expectedScoreMappings: state.skillMatrixOps.expectedScoreMappings || [],
        newSubCategoryMapping: state.skillMatrixOps.newSubCategoryMapping || [],
        showAlert: state.skillMatrixOps.showAlert || {}
    };
};

const mapDispatchToProps = (dispatch, ownProps) => {
    return {
        fetchClientList: async () => {
            const clients = await getClientsList(1);
            dispatch(setClients(clients));
        },
        fetchCategoryList: async (teamId = null) => {
            let categories;
            if (ownProps.identifier === "employeeScorePage") {
                let id = teamId;
                if (id === null) {
                    const clients = await getClientsList(1);
                    const clientTeams = await getClientsTeamsList(
                        clients[0].id
                    );
                    id = clientTeams[0].id;
                }
                categories = await GetCategoryListWithTeamScore(id, 1);
            } else {
                categories = await getCategoryList();
            }
            dispatch(setCategories(categories));
        },
        fetchTeamList: async id => {
            const clients = await getClientsList(1);
            const clientId = id ? id : clients[0].id;
            const clientTeams = await getClientsTeamsList(clientId);
            dispatch(setClientTeams(clientTeams));
        },
        fetchEmployeeList: async id => {
            const clients = await getClientsList(1);
            const clientTeams = await getClientsTeamsList(clients[0].id);
            const teamId = id ? id : clientTeams[0].id;
            const employees = await getEmployeeList(teamId);
            dispatch(getEmpList(employees));
        },
        fetchSkillMatrixData: async (teamId, categoryId) => {
            const clients = await getClientsList();
            const clientTeams = await getClientsTeamsList(clients[0]?.id);
            const selectedCategoryId = categoryId ? categoryId : 0;
            const selectedTeamId = teamId ? teamId : clientTeams[0]?.id;
            const data = {
                teamId: selectedTeamId,
                categoryId: selectedCategoryId
            };
            const skillsMatrixTable = await getSkillMatrixTableData(data);
            dispatch(setSkillMatrixDataNew(skillsMatrixTable));
        },
        fetchExpectedScore: async teamId => {
            const expectedScore = await teamExpectedScoresListApi(teamId);
            dispatch(setExpectedScoreMappings(expectedScore));
        },
        fetchClientScoreMapping: async id => {
            const clientList = await getClientsList(1);
            const clientId = clientList[0].id;
            const clientTeams = await getClientsTeamsList(clientId);
            const teamId = id ? id : clientTeams[0].id;
            const expectedScore = await teamExpectedScoresListApi(teamId);
            dispatch(setExpectedScoreMappings(expectedScore));
        },
        clientScoreMappingFunction: async (category, teamExpectedScore) => {
            const subCategories = await getSubCategoryList(category.id);
            const teamMappingScore = await clientTeamScoreMapping(
                subCategories,
                teamExpectedScore
            );
            dispatch(newSubCategoryMapping(teamMappingScore));
        },
        postEmployeeScores: async Scores => {
            return await PostEmployeeScoreMappings(Scores);
        },
        postClientScores: async Scores => {
            return await PostClientScoreMappings(Scores);
        },
        showErrorMessage: result => {
            let errorArray = [];
            result.error.response.data.map(item => {
                errorArray.push({ error: item.errorMessage, field: "name" });
            });
            const errorMessage = errorArray
                .map(error => error.error)
                .join(", ");
            const data = {
                setAlert: true,
                severity: "error",
                message: errorMessage
            };
            dispatch(showAlert(data));
        },
        setShowAlert: (setAlert = false, severity, message) => {
            const data = {
                setAlert,
                severity,
                message
            };
            dispatch(showAlert(data));
        }
    };
};

const ScoreMappingContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(ScoreMapping);

export default ScoreMappingContainer;
