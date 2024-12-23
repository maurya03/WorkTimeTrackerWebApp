import { connect } from "react-redux";
import { viewTimesheet } from "rootpath/services/Timesheet2.0/ViewTimesheetService";
// import { setViewTimesheetData } from "rootpath/redux/timesheet/actions";
import { initDate } from "rootpath/services/Timesheet2.0/ViewTimesheetService";
import {
    GetTimesheetSubCategoryApi,
    GetEmployeeProjectApi
} from "rootpath/services/TimeSheet/TimeSheetPostAndGetServices";
import { GetTimesheetCategory } from "rootpath/services/Timesheet2.0/TimeSheetPostAndGetServices";
import {
    setTimeSheetCategories,
    setTimeSheetSubCategories,
    setTimeSheetEmpProject,
    setViewTimesheetData
} from "rootpath/redux/timesheet/actions";
import TimesheetCreator from "./TimesheetCreator";
const mapStateToProps = state => {
    let toolbarOptions = false;
    const draftOrRejected =
        state.timeSheetOps.viewTimesheetData.timesheetData &&
        state.timeSheetOps.viewTimesheetData.timesheetData.filter(
            item => item.statusId === 1 || item.statusId === 3
        );
    if (draftOrRejected && draftOrRejected.length > 0) {
        toolbarOptions = true;
        state.timeSheetOps.viewTimesheetData.timesheetData = draftOrRejected;
    }
    return {
        timesheetDetails: state.timeSheetOps.viewTimesheetData.timesheetData,
        toolbarOptions: toolbarOptions,
        selectedDates: state.timeSheetOps.viewTimesheetData.dates || {},
        timesheetCategories: state.timeSheetOps.timeSheetCategories || [],
        timesheetSubCategories: state.timeSheetOps.timeSheetSubCategories || [],
        employeeProject: state.timeSheetOps.employeeProject || []
    };
};
const mapDispatchToProps = dispatch => ({
    getTimesheet: async dates => {
        if (!dates) {
            dates = initDate();
        }
        let timesheetDetails = await viewTimesheet(dates);
        timesheetDetails.dates = dates;
        dispatch(setViewTimesheetData(timesheetDetails));
    },
    fetchEmployeeProject: async () => {
        const results = await GetEmployeeProjectApi();
        dispatch(setTimeSheetEmpProject(results));
    },
    fetchTimesheetCategory: async () => {
        const category = await GetTimesheetCategory();
        dispatch(setTimeSheetCategories(category));
    },
    fetchTimesheetSubCategory: async () => {
        const subCategory = await GetTimesheetSubCategoryApi();
        dispatch(setTimeSheetSubCategories(subCategory));
    }
});
const TimesheetCreatorContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(TimesheetCreator);

export default TimesheetCreatorContainer;
