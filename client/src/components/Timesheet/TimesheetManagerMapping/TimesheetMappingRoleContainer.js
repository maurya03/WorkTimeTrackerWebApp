import { connect } from "react-redux";
import ManagerMappingList from "./TimesheetMappingRole";
import {
    setClientTeams,
    setClients,
    employeeDetails
} from "rootpath/redux/common/actions";
import {
    setAlert,
    setManagerList,
    setApproverId1List,
    setApproverId2List
} from "rootpath/redux/timesheet/actions";
import {
    getClientsList,
    getClientsTeamsList
} from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import {
    GetEmployeeDetailsByTeamId,
    updateEmployeeDetail,
    bulkUpdateEmployeeDetail,
    GetApprovalList
} from "rootpath/services/TimeSheet/TimeSheetPostAndGetServices";

const mapStateToProps = state => ({
    clients: state.skillMatrixOps.clients || [],
    teams: state.skillMatrixOps.teams || [],
    employeeDetails: state.skillMatrixOps.employeeDetails || [],
    alert: state.timeSheetOps.showAlert || {},
    managerList: state.timeSheetOps.managerList || [],
    approverId1List: state.timeSheetOps.approverId1List || [],
    approverId2List: state.timeSheetOps.approverId2List || []
});
const mapDispatchToProps = dispatch => ({
    fetchClientList: async () => {
        const clients = await getClientsList(1);
        dispatch(setClients(clients));
    },

    fetchClientTeamsList: async (clientId = null) => {
        let id = clientId;
        if (!clientId) {
            const clients = await getClientsList(1);
            id = id ? id : clients[0].id;
        }
        const teams = await getClientsTeamsList(id);
        dispatch(setClientTeams(teams));
    },

    fetchEmployeeDetailsByTeamId: async (teamId = null, clientId = null) => {
        let updatedClientId = clientId;
        let updatedTeamId = teamId;
        if (!clientId) {
            const clients = await getClientsList(1);
            updatedClientId = clients[0].id;
        }
        if (!teamId) {
            const clients = await getClientsList(1);
            updatedClientId = updatedClientId ? updatedClientId : clients[0].id;
            const teams = await getClientsTeamsList(updatedClientId);
            updatedTeamId = teams[0].id;
        }
        let detail = await GetEmployeeDetailsByTeamId(updatedTeamId);
        detail = detail.map(emp => ({
            ...emp,
            checked: false
        }));
        const response = await GetApprovalList(updatedClientId, updatedTeamId);
        dispatch(setManagerList(response.reportingManagerList));
        dispatch(setApproverId1List(response.approverId1List));
        dispatch(setApproverId2List(response.approverId2List));
        dispatch(employeeDetails(detail));
    },

    updateTimesheetEmployee: async data => {
        return await updateEmployeeDetail(data);
    },

    bulkUpdateEmployeeDetails: async bulkEmployeeDetails => {
        return await bulkUpdateEmployeeDetail(bulkEmployeeDetails);
    },

    setShowAlert: (setAlertOpen = false, severity, message) => {
        const data = {
            setAlertOpen,
            severity,
            message
        };
        dispatch(setAlert(data));
    }
});

const TimesheetMappingRoleContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(ManagerMappingList);

export default TimesheetMappingRoleContainer;
