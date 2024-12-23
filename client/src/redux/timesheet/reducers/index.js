import * as types from "rootpath/redux/timesheet/constants/ActionTypes";
import Cookies from "universal-cookie";
import jwt_decode from "jwt-decode";

const cookies = new Cookies();
let tokenData = cookies.get("my_cookie");
const userName = tokenData ? jwt_decode(tokenData).Emp_name : "";

const timsheetState = {
    timeSheetCategories: [],
    timeSheetSubCategories: [],
    timesheetClients: [],
    timeSheetDetail: [],
    employeeProject: [],
    timesheet: [],
    timeSheetEmployees: [],
    isBehalfOpen: false,
    timesheetId: 0,
    selectedProject: {},
    timesheetTitle: "",
    selectedTimesheetStatus: {},
    startDate: "",
    endDate: "",
    selectedTimesheetClients: "",
    selectedTimesheetClientArray: [],
    searchedText: "",
    skipRows: 0,
    rejectRemarks: "",
    isRemarksModalOpen: false,
    timesheetForAction: {},
    errorMessage: [],
    selectedTimesheetlist: [],
    checkboxState: [],
    checkboxStatus: false,
    summationData: [],
    showAlert: {},
    listOfduplicateTask: {},
    //timesheet v2
    viewTimesheetData: {},
    showDialogBox: {},
    managerList: [],
    approverId1List: [],
    approverId2List: [],
    timesheetReportData: [],
    timesheetStatus: [],
    managerAndApprover: [],
    timesheetEmailData: []
};
export const timeSheetOps = (state = timsheetState, action) => {
    switch (action.type) {
        case types.SET_TIMESHEET_CATEGORIES:
            return { ...state, timeSheetCategories: action.payload };
        case types.SET_TIMESHEET_SUB_CATEGORIES:
            return { ...state, timeSheetSubCategories: action.payload };
        case types.SET_TIMESHEET_ENTERIES:
            return { ...state, timeSheetEnteries: action.payload };
        case types.SET_TIMESHEET_CLIENTS:
            return { ...state, timesheetClients: action.payload };
        case types.SET_TIMESHEET:
            return { ...state, timesheet: action.payload };
        case types.SET_TIMESHEET_DETAIL:
            return { ...state, timeSheetDetail: action.payload };
        case types.SET_TIMESHEET_EMP_PROJECT:
            return { ...state, employeeProject: action.payload };
        case types.SET_TIMESHEET_EMPLOYEES:
            return { ...state, timeSheetEmployees: action.payload };
        case types.SET_IS_BEHALF_OPEN:
            return { ...state, isBehalfOpen: action.payload };
        case types.SET_TIMESHEET_ID:
            return { ...state, timesheetId: action.payload };
        case types.SET_SELECTED_PROJECT:
            return { ...state, selectedProject: action.payload };
        case types.SET_TIMESHEET_TITLE:
            return { ...state, timesheetTitle: action.payload };
        case types.SET_SELECTED_TIMESHEET_STATUS:
            return { ...state, selectedTimesheetStatus: action.payload };
        case types.SET_DISPLAY_HEADER:
            return { ...state, displayHeader: action.payload };
        case types.SET_START_DATE:
            return { ...state, startDate: action.payload };
        case types.SET_END_DATE:
            return { ...state, endDate: action.payload };
        case types.SET_SELECTED_CLIENTS:
            return { ...state, selectedTimesheetClients: action.payload };
        case types.SET_TIMESHEET_CLIENT_ARRAY:
            return { ...state, selectedTimesheetClientArray: action.payload };
        case types.SET_SEARCHED_TEXT:
            return { ...state, searchedText: action.payload };
        case types.SET_SKIP_ROWS:
            return { ...state, skipRows: action.payload };
        case types.SET_REJECT_REMARKS:
            return { ...state, rejectRemarks: action.payload };
        case types.SET_REMARKS_MODAL:
            return { ...state, isRemarksModalOpen: action.payload };
        case types.SET_TIMESHEET_FOR_DELETE:
            return { ...state, timesheetForAction: action.payload };
        case types.SET_ERROR_MESSAGE:
            return { ...state, errorMessage: action.payload };
        case types.SET_SELECTED_TIMESHEET_LIST:
            return { ...state, selectedTimesheetlist: action.payload };
        case types.SET_CHECKBOX_STATE:
            return { ...state, checkboxState: action.payload };
        case types.SET_CHECKBOX_STATUS:
            return { ...state, checkboxStatus: action.payload };
        case types.TIMESHEET_SUM:
            return { ...state, summationData: action.payload };
        case types.TIMESHEET_ALERT:
            return { ...state, showAlert: action.payload };
        case types.DUPLICATE_TASK:
            return { ...state, listOfduplicateTask: action.payload };
        case types.SET_VIEW_TIMESHEET_DATA:
            return { ...state, viewTimesheetData: action.payload };
        case types.SHOW_DIALOG_BOX:
            return { ...state, showDialogBox: action.payload };
        case types.MANAGER_LIST:
            return { ...state, managerList: action.payload };
        case types.APPROVER_ID1_LIST:
            return { ...state, approverId1List: action.payload };
        case types.APPROVER_ID2_LIST:
            return { ...state, approverId2List: action.payload };
        case types.TIMESHEET_REPORT_DATA:
            return { ...state, timesheetReportData: action.payload };
        case types.SET_TIMESHEET_STATUS:
            return { ...state, timesheetStatus: action.payload };
        case types.SET_MANAGERANDAPPROVER_NAME:
            return { ...state, managerAndApprover: action.payload };
        case types.TIMESHEET_EMAIL_DATA:
            return { ...state, timesheetEmailData: action.payload };
        default:
            return state;
    }
};
