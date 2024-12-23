import { connect } from "react-redux";
import { getClientsList } from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import { getTimesheet } from "rootpath/services/TimeSheet/TimeSheetPostAndGetServices";
import {
    setTimesheet,
    setTimeSheetClients,
    setSearchedText,
    setSkipRows,
    setTimesheetId
} from "rootpath/redux/timesheet/actions";
import TimesheetListTable from "./TimesheetListTable";

const mapStateToProps = state => ({
    clients: state.timeSheetOps.timesheetClients || [],
    userRole: state.skillMatrixOps.userRole || {},
    searchedText: state.timeSheetOps.searchedText || "",
    skipRows: state.timeSheetOps.skipRows || 0,
    selectedTimesheetlist: state.timeSheetOps.selectedTimesheetlist || [],
    checkboxStatus: state.timeSheetOps.checkboxStatus || false,
    checkboxState: state.timeSheetOps.checkboxState || []
});

const timesheetFetch = (ownProps, rows, value) => {
    return async (dispatch, getState) => {
        const state = getState();

        const data = {
            clientId: state.timeSheetOps.selectedTimesheetClients,
            status: ownProps.status,
            startDate: state.timeSheetOps.startDate,
            endDate: state.timeSheetOps.endDate,
            isApproverPending: ownProps.approverPending,
            searchedText: value ? value : state.timeSheetOps.searchedText,
            skipRows: rows,
            showSelfRecordsToggle: ownProps.showSelfRecordsOnly
        };
        const timesheet = await getTimesheet(data);
        if (rows !== 0) {
            timesheet.forEach(element => {
                ownProps.data.push(element);
            });
            dispatch(setTimesheet(ownProps.data));
        } else {
            dispatch(setTimesheet(timesheet));
        }
    };
};
const mapDispatchToProps = (dispatch, ownProps) => ({
    fetchClientList: async () => {
        const clients = await getClientsList();
        dispatch(setTimeSheetClients(clients));
    },
    fetchTimesheet: async (rows, value) => {
        // dispatch(setSearchedText(value));
        // const rows = ownProps.skipRows + 10;
        // ownProps.setSkipRows(rows);
        await dispatch(timesheetFetch(ownProps, rows, value));
    },
    setSearchedText: text => {
        dispatch(setSearchedText(text));
    },
    setSkipRows: rows => {
        dispatch(setSkipRows(rows));
    },
    setTimesheetId: timesheetId => {
        dispatch(setTimesheetId(timesheetId));
    }
});

const TimesheetListTableContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(TimesheetListTable);

export default TimesheetListTableContainer;
