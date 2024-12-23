import {
    TimeSheetEntryByIdApi,
    PostTimeSheetApi
} from "rootpath/services/Timesheet/TimeSheetPostAndGetServices";

export const timeSheetEntryByIdApi = async entryId => {
    const result = await TimeSheetEntryByIdApi(entryId);
    return result;
};
export const postTimeSheetApi = async timeSheetEntries => {
    const result = await PostTimeSheetApi(timeSheetEntries);
    return result;
};
