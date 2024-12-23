import RoleList from "./RoleList";
import { connect } from "react-redux";
import { getClientsList, getClientsTeamsList } from "../SkillMatrix/CardsComponent/CardsComponentFunction";
import { getEmpRoleList, setClientTeams, setClients } from "rootpath/redux/common/actions.js";
import { postEmployeeRoleList,getEmployeeRoleList } from "./RoleListFunctions";

const mapStateToProps = state => ({
    clients: state.skillMatrixOps.clients || [],
    teams: state.skillMatrixOps.teams || [],
    employees: state.skillMatrixOps.employeeRole || [],
});
const mapDispatchToProps = dispatch => ({
    fetchClientList: async () => {
        const clients = await getClientsList();
        dispatch(setClients(clients));
    },
  
    fetchClientTeamsList: async clientId => {
        const teams = await getClientsTeamsList(clientId);
        dispatch(setClientTeams(teams));
    },

    fetchEmplist: async teamid => {
        const emps = await getEmployeeRoleList(teamid);
        dispatch(getEmpRoleList(emps))
    },
    postEmployeeRolesFunction: async (roles, teamId) => {
        await postEmployeeRoleList(roles);
    }
  
});

const RoleListContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(RoleList);

export default RoleListContainer;