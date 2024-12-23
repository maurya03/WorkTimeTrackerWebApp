import { connect } from "react-redux";
import TimesheetNotification from "./TimesheetNotification";
import {
    getClientsList,
    getClientsTeamsList
} from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import { ClientManagerTeamsApi } from "rootpath/services/SkillMatrix/ClientService/ClientService";
import { getLoggedinUserRole } from "rootpath/services/SkillMatrix/RoleService/RoleService";
import {
    setClients,
    setClientTeams,
    postUserRole
} from "rootpath/redux/common/actions";
import {
    setTimesheetEmailData,
    setAlert
} from "rootpath/redux/timesheet/actions";
import { fetchTimesheetReport } from "rootpath/services/TimeSheet/TimesheetReportService";
import {
    fetchTimesheetEmailData,
    sendEmailNotification
} from "rootpath/services/TimeSheet/TimeSheetPostAndGetServices";

const mapStateToProps = state => ({
    timesheetReportData: state.timeSheetOps.timesheetReportData || [],
    timesheetEmailData: state.timeSheetOps.timesheetEmailData || [],
    userRole: state.skillMatrixOps.userRole || {},
    clients: state.skillMatrixOps.clients || [],
    teams: state.skillMatrixOps.teams || [],
    startDate: state.timeSheetOps.startDate || "",
    endDate: state.timeSheetOps.endDate || "",
    alert: state.timeSheetOps.showAlert || {}
});

const mapDispatchToProps = dispatch => {
    return {
        fetchRole: async () => {
            const role = await getLoggedinUserRole();
            dispatch(postUserRole(role));
        },
        getTimesheetEmailData: async data => {
            const timesheetEmailData = await fetchTimesheetEmailData(data);
            dispatch(setTimesheetEmailData(timesheetEmailData));
        },

        fetchClientList: async () => {
            const clients = await getClientsList();
            dispatch(setClients(clients));
        },
        fetchClientTeamsList: async clientId => {
            const teams = await getClientsTeamsList(clientId);
            dispatch(setClientTeams(teams));
        },
        fetchClientManagerTeamsList: async (clientId, employeeId) => {
            const teams = await ClientManagerTeamsApi(clientId, employeeId);
            dispatch(setClientTeams(teams));
        },
        sendTimesheetEmail: async emailData => {
            return await sendEmailNotification(emailData);
        },
        setShowAlert: (setAlertOpen = false, severity, message) => {
            const data = {
                setAlertOpen,
                severity,
                message
            };
            dispatch(setAlert(data));
        }
    };
};

const TimesheetNotificationContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(TimesheetNotification);

export default TimesheetNotificationContainer;
