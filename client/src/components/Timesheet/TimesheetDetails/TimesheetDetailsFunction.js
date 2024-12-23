import {
    getTimesheetDetail,
    PostTimeSheetApi,
    GetTimesheetCategoryApi,
    GetTimesheetSubCategoryApi,
    GetEmployeeProjectApi,
    UpdateTimeSheetStatusApi,
    GetProjectsForOnBehalfEmployeeApi,
    GetTimesheetEmployeeApi,
    SubmitTimesheetonbehalf
} from "rootpath/services/TimeSheet/TimeSheetPostAndGetServices";

export const timeSheetEntryByIdApi = async timesheetId => {
    const result = await getTimesheetDetail(timesheetId);
    return result;
};
export const postTimeSheetApi = async (timeSheetEntries, actionName) => {
    const result = await PostTimeSheetApi(timeSheetEntries, actionName);
    return result;
};
export const getEmployeeProject = async () => {
    const result = await GetEmployeeProjectApi();
    return result;
};
export const getProjectsForOnBehalfEmployeeApi = async employeeId => {
    const result = await GetProjectsForOnBehalfEmployeeApi(employeeId);
    return result;
};
export const getTimesheetCategoryApi = async () => {
    const result = await GetTimesheetCategoryApi();
    return result;
};
export const getTimesheetSubCategoryApi = async () => {
    const result = await GetTimesheetSubCategoryApi();
    return result;
};
export const updateTimeSheetStatusApi = async (
    data,
    selectedEmailListAndWeek
) => {
    const result = await UpdateTimeSheetStatusApi(
        data,
        selectedEmailListAndWeek
    );
    return result;
};
export const submitTimesheetonbehalf = async (
    empId,
    data,
    selectedEmailListAndWeek
) => {
    const result = await SubmitTimesheetonbehalf(
        empId,
        data,
        selectedEmailListAndWeek
    );
    return result;
};
export const getTimesheetEmployeeApi = async projectId => {
    return (await projectId)
        ? GetTimesheetEmployeeApi(projectId)
        : GetTimesheetEmployeeApi();
};
