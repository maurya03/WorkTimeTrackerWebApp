import { getApi, delApi } from "rootpath/services/baseApiService";
import { formatDate } from "rootpath/services/TimeSheet/TimesheetDataService";
import { endOfWeek, isSameWeek, startOfWeek } from "date-fns";

const baseURL = "api/v2";
export const viewTimesheet = async dates => {
    const url = `${baseURL}/viewtimesheet/startDate/${dates.startDate}/endDate/${dates.endDate}`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const deleteTimesheetDetail = async id => {
    const url = `${baseURL}/removeTimesheetEntryById/${id}`;
    const response = await delApi(url)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};
export const getTimesheetById = async timesheetId => {
    const url = `${baseURL}/viewtimesheetid/timesheetId/${timesheetId}`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const initDate = () => {
    const weekDate = new Date();
    return GetStartAndEndDates(weekDate);
};
const GetStartAndEndDates = weekDate => {
    const startDate = formatDate(startOfWeek(new Date()));
    const endDate = formatDate(endOfWeek(new Date()));
    return { startDate, endDate };
};
