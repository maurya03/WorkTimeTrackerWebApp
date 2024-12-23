import { connect } from "react-redux";
import TimesheetList from "rootpath/components/Timesheet/TimesheetList/TimesheetList.jsx";
import { getClientsList } from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import {
    getTimesheet,
    getManagerAndApproverByEmployeeId
} from "rootpath/services/TimeSheet/TimeSheetPostAndGetServices";
import {
    setTimesheet,
    setTimesheetId,
    setIsBehalfOpen,
    setTimesheetTitle,
    setSelectedProject,
    setTimeSheetClients,
    setTimeSheetDetail,
    setSelectedTimesheetStatus,
    setDisplayHeader
} from "rootpath/redux/timesheet/actions";
import { createTimesheetDataForReview } from "rootpath/services/TimeSheet/TimesheetDataService";
import {
    convertToYYYYMMDD,
    getWeekStartDate
} from "rootpath/services/TimeSheet/TimesheetDataService";
import { endOfWeek, startOfWeek } from "date-fns";

import {
    setEndDate,
    setStartDate,
    setSelectedTimesheetClients,
    setSelectedTimesheetClientArray,
    setSkipRows,
    setRemarksModal,
    setRejectRemarks,
    setSelectedTimesheetList,
    setCheckboxState,
    setCheckboxStatus,
    setTimesheetForDelete,
    setErrorMessage,
    setAlert,
    setManagerAndApprover
} from "rootpath/redux/timesheet/actions";
import { admin } from "rootpath/components/Timesheet/Constants";
import { getLoggedinUserRole } from "rootpath/services/SkillMatrix/RoleService/RoleService";

const mapStateToProps = state => ({
    clients: state.timeSheetOps.timesheetClients || [],
    timesheet: state.timeSheetOps.timesheet || [],
    isRemarksModalOpen: state.timeSheetOps.isRemarksModalOpen || false,
    userRole: state.skillMatrixOps.userRole || {},
    startDate: state.timeSheetOps.startDate || "",
    endDate: state.timeSheetOps.endDate || "",
    selectedTimesheetClients: state.timeSheetOps.selectedTimesheetClients || "",
    searchedText: state.timeSheetOps.searchedText || "",
    skipRows: state.timeSheetOps.skipRows || 0,
    selectedTimesheetClientArray:
        state.timeSheetOps.selectedTimesheetClientArray || [],
    remarks: state.timeSheetOps.rejectRemarks || "",
    checkboxState: state.timeSheetOps.checkboxState || [],
    selectedTimesheetlist: state.timeSheetOps.selectedTimesheetlist || [],
    checkboxStatus: state.timeSheetOps.checkboxStatus || false,
    timesheetForAction: state.timeSheetOps.timesheetForAction || {},
    alert: state.timeSheetOps.showAlert || {},
    managerAndApprover: state.timeSheetOps.managerAndApprover || []
});

const mapDispatchToProps = (dispatch, ownProps) => ({
    fetchClientList: async () => {
        const clients = await getClientsList();
        dispatch(setTimeSheetClients(clients));
    },
    fetchTimesheetStatusWise: async data => {
        const timesheet = await getTimesheet(data);
        dispatch(setTimesheet(timesheet));
    },
    emptyTimesheet: () => {
        dispatch(setTimesheet([]));
    },
    handleModalClose: async () => {
        dispatch(setRemarksModal(false));
    },
    handleModalOpen: rowData => {
        if (rowData.timesheetId) {
            dispatch(setTimesheetForDelete(rowData));
        }
        dispatch(setRemarksModal(true));
    },

    setRemarks: async remarks => {
        dispatch(setRejectRemarks(remarks));
    },
    setTimesheetForDelete: timesheet => {
        dispatch(setTimesheetForDelete(timesheet));
    },
    updateTimesheetStatusByReviewer: async (
        status,
        rows,
        timesheetList,
        remarks
    ) => {
        return await createTimesheetDataForReview(
            status,
            rows,
            timesheetList,
            remarks
        );
    },

    fetchManagerAndApprover: async empId => {
        const managerAndApprover = await getManagerAndApproverByEmployeeId(
            empId
        );
        dispatch(setManagerAndApprover(managerAndApprover));
    },

    setDateOnLoad: async userRole => {
        if (Object.keys(userRole).length === 0) {
            userRole = await getLoggedinUserRole();
        }
        const currDate = new Date();

        const endDate = endOfWeek(currDate);
        dispatch(setEndDate(endDate));

        const startDate = startOfWeek(
            new Date(currDate.setDate(currDate.getDate() - 7))
        );
        dispatch(setStartDate(startDate));
    },
    setTimesheetId: timesheetId => {
        dispatch(setTimesheetId(timesheetId));
    },
    setIsBehalfOpen: value => {
        dispatch(setIsBehalfOpen(value));
    },
    setSkipRows: rows => {
        dispatch(setSkipRows(rows));
    },
    setSelectedClients: client => {
        client.map(x => x);
        const clients = client.map(x => x.id).join(",");
        dispatch(setSelectedTimesheetClientArray(client));
        dispatch(setSelectedTimesheetClients(clients));
    },
    handleClientChange: values => {
        const clients = values.map(x => x.id).join(",");
        dispatch(setSelectedTimesheetClients(clients));
        dispatch(setSelectedTimesheetClientArray(values));
        dispatch(setSkipRows(0));
    },
    setSelectedTimesheetList: list => {
        dispatch(setSelectedTimesheetList(list));
    },
    setCheckboxState: list => {
        dispatch(setCheckboxState(list));
    },
    setCheckboxStatus: list => {
        dispatch(setCheckboxStatus(list));
    },
    setErrorMessage: validation => {
        dispatch(setErrorMessage(validation));
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

const TimesheetListContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(TimesheetList);

export default TimesheetListContainer;
