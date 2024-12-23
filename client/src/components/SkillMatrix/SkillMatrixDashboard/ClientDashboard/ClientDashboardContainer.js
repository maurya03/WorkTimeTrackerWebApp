import { connect } from "react-redux";
import {
    getClientsList,
    getClientsTeamsList
} from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import {
    postUserRole,
    setClients,
    setClientTeams,
    showAlert
} from "rootpath/redux/common/actions";
import {
    DeleteTeamApi,
    DeleteClientApi
} from "rootpath/services/SkillMatrix/ClientService/ClientService";
import ClientDashboard from "./ClientDashboard";
import { getLoggedinUserRole } from "rootpath/services/SkillMatrix/RoleService/RoleService";

const mapStateToProps = state => ({
    clients: state.skillMatrixOps.clients || [],
    clientTeams: state.skillMatrixOps.teams || [],
    userRole: state.skillMatrixOps.userRole || {},
    showAlert: state.skillMatrixOps.showAlert || {}
});

const mapDispatchToProps = dispatch => ({
    fetchClientList: async () => {
        const clients = await getClientsList();
        dispatch(setClients(clients));
    },
    fetchTeamList: async id => {
        const clients = await getClientsList();
        const clientId = id ? id : clients[0]?.id;
        const team = await getClientsTeamsList(clientId);
        dispatch(setClientTeams(team));
    },
    deleteClient: async clientId => {
        return await DeleteClientApi(clientId);
    },
    deleteTeam: async teamId => {
        return await DeleteTeamApi(teamId);
    },
    fetchRole: async () => {
        const role = await getLoggedinUserRole();
        dispatch(postUserRole(role));
    },
    setShowAlert: (setAlert = false, severity, message) => {
        const data = {
            setAlert,
            severity,
            message
        };
        dispatch(showAlert(data));
    }
});

const ClientDashboardContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(ClientDashboard);

export default ClientDashboardContainer;
