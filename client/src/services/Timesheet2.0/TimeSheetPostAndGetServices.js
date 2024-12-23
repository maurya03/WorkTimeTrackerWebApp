import { getApi, postApi } from "rootpath/services/baseApiService";

const baseURLv2 = "api/v2";
const baseURL = "api/v1";
export const GetTimesheetCategory = async empId => {
    const url = `${baseURLv2}/timesheetCategories/Employees?employeeId=${
        empId ?? 0
    }`;
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
