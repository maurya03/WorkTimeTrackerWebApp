import { connect } from "react-redux";
import TimesheetReport from "rootpath/components/Timesheet/TimesheetReports/TimesheetReport";
import {
    getClientsList,
    getClientsTeamsList
} from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import { getLoggedinUserRole } from "rootpath/services/SkillMatrix/RoleService/RoleService";
import {
    setClients,
    setClientTeams,
    postUserRole
} from "rootpath/redux/common/actions";
import {
    setTimesheetReportsData,
    setTimesheetStatus,
    setEndDate,
    setStartDate
} from "rootpath/redux/timesheet/actions";
import {
    fetchTimesheetReport,
    generateTimesheetWeeklyReport,
    generateTimesheetWeeklyExcelReport
} from "rootpath/services/TimeSheet/TimesheetReportService";
import { getTimesheetStatusList } from "rootpath/services/TimeSheet/TimeSheetPostAndGetServices";

const mapStateToProps = state => ({
    timesheetReportData: state.timeSheetOps.timesheetReportData || [],
    userRole: state.skillMatrixOps.userRole || {},
    clients: state.skillMatrixOps.clients || [],
    teams: state.skillMatrixOps.teams || [],
    timesheetStatus: state.timeSheetOps.timesheetStatus || [],
    startDate: state.timeSheetOps.startDate || "",
    endDate: state.timeSheetOps.endDate || ""
});

const mapDispatchToProps = dispatch => {
    return {
        fetchRole: async () => {
            const role = await getLoggedinUserRole();
            dispatch(postUserRole(role));
        },
        getTimesheetReportData: async data => {
            const report = await fetchTimesheetReport(data);
            dispatch(setTimesheetReportsData(report));
        },
        fetchClientList: async () => {
            const clients = await getClientsList();
            dispatch(setClients(clients));
        },
        fetchClientTeamsList: async clientId => {
            const teams = await getClientsTeamsList(clientId);
            dispatch(setClientTeams(teams));
        },
        fetchTimesheetStatusList: async () => {
            const timesheetStatus = await getTimesheetStatusList();
            dispatch(setTimesheetStatus(timesheetStatus));
        },
        generateTimesheeWeeklyReport: async (startDate, endDate) => {
            await generateTimesheetWeeklyReport(startDate, endDate);
        },
        generateTimesheeWeeklyExcelReport: async (startDate, endDate) => {
            await generateTimesheetWeeklyExcelReport(startDate, endDate);
        }
    };
};

const TimesheetReportContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(TimesheetReport);

export default TimesheetReportContainer;
