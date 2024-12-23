import { connect } from "react-redux";
import {
    getClientsList,
    getClientsTeamsList,
    getEmployeeList,
    getEmployeeTypeList
} from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import {
    getEmpList,
    setClients,
    setClientTeams,
    showAlert,
    getEmployeeType
} from "rootpath/redux/common/actions";
import EmployeeDashboard from "./EmployeeDashboard";
import { DeleteEmployeeApi } from "rootpath/services/SkillMatrix/ClientService/ClientService";

const mapStateToProps = state => ({
    clients: state.skillMatrixOps.clients || [],
    clientTeams: state.skillMatrixOps.teams || [],
    employees: state.skillMatrixOps.employee || [],
    empListType: state.skillMatrixOps.employeeType || [],
    showAlert: state.skillMatrixOps.showAlert || {}
});

const mapDispatchToProps = (dispatch, ownProps) => ({
    fetchClientList: async () => {
        const clients = await getClientsList(1);
        dispatch(setClients(clients));
    },
    fetchTeamList: async id => {
        const clients = await getClientsList(1);
        const clientId = id ? id : clients[0]?.id;
        const teams = await getClientsTeamsList(clientId);
        dispatch(setClientTeams(teams));
        const teamId = teams[0]?.id;
        const employees = await getEmployeeList(teamId);
        dispatch(getEmpList(employees));
    },
    fetchEmplist: async (id, clientId) => {
        const clients = await getClientsList(1);
        const teamClientId = clientId ?? clients[0]?.id;
        const teams = await getClientsTeamsList(teamClientId);
        const teamId = id ? id : teams[0]?.id;
        const employees = await getEmployeeList(teamId);
        dispatch(getEmpList(employees));
    },
    fetchEmpTypeList: async () => {
        const employeeListType = await getEmployeeTypeList();
        dispatch(getEmployeeType(employeeListType));
    },
    deleteEmployee: async employeeID => {
        const result = await DeleteEmployeeApi(employeeID);
        if (result?.success) {
            const data = {
                setAlert: true,
                severity: "success",
                message: "Employee deleted successfully !"
            };
            dispatch(showAlert(data));
        } else {
            const data = {
                setAlert: true,
                severity: "error",
                message: result.error.response.data
            };
            dispatch(showAlert(data));
        }
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

const EmployeeDashboardContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(EmployeeDashboard);

export default EmployeeDashboardContainer;
