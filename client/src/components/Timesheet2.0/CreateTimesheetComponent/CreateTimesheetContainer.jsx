import { connect } from "react-redux";
import CreateTimesheet from "rootpath/components/Timesheet2.0/CreateTimesheetComponent/CreateTimesheet";
import {
    GetTimesheetSubCategoryApi,
    GetEmployeeProjectApi
} from "rootpath/services/Timesheet/TimeSheetPostAndGetServices";
import { GetTimesheetCategory } from "rootpath/services/Timesheet2.0/TimeSheetPostAndGetServices";
import {
    setTimeSheetCategories,
    setTimeSheetSubCategories,
    setTimeSheetEmpProject,
    setStartDate,
    setEndDate
} from "rootpath/redux/timesheet/actions";
import { InitDate } from "rootpath/services/Timesheet2.0/TimesheetService";

const mapStateToProps = state => ({
    // timesheetDetail: state.timeSheetOps.timeSheetDetail || [],
    timesheetCategories: state.timeSheetOps.timeSheetCategories,
    timesheetSubCategories: state.timeSheetOps.timeSheetSubCategories,
    employeeProject: state.timeSheetOps.employeeProject,
    startDate: state.timeSheetOps.startDate || {},
    endDate: state.timeSheetOps.endDate || {}
});

const mapDispatchToProps = dispatch => ({
    fetchTimesheetWeekDate: async dates => {
        if (!dates) {
            const { startDate, endDate } = InitDate();
            dispatch(setStartDate(startDate));
            dispatch(setEndDate(endDate));
        }
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
    },
    postTimeSheet: async (
        enteries,
        selectedWeek,
        selectedEmployee,
        timesheetId,
        actionName
    ) => {
        const toPost = mapTimesheetPostData(
            enteries,
            selectedWeek,
            selectedEmployee,
            timesheetId
        );
        return await postTimeSheetApi(toPost, actionName);
    }
});
const CreateTimesheetContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(CreateTimesheet);
export default CreateTimesheetContainer;
