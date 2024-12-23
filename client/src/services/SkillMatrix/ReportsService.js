import { getApi, postApi } from "rootpath/services/baseApiService";
const baseURL = "api/v1";

export const fetchReportByCategoryAndClient = async (categoryId, clientId) => {
    const url = `${baseURL}/reportByCategoryAndClient?CategoryId=${categoryId}&ClientId=${clientId}`;
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

export const fetchEmployeeScoreReport = async data => {
    const url = `${baseURL}/employeeScoreReportByClientCategory`;
    const response = await postApi(url, data)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const fetchSkillSegmentByCategoryReport = async (
    categoryId = null,
    clientId = null,
    teamId = null,
    year,
    month
) => {
    let queryParams = "";
    if (year > 0) {
        queryParams += `?year=${year}`;
    }
    if (month > 0) {
        queryParams +=
            queryParams.length > 0 ? `&month=${month}` : `?month=${month}`;
    }
    if (categoryId > 0) {
        queryParams +=
            queryParams.length > 0
                ? `&categoryId=${categoryId}`
                : `?categoryId=${categoryId}`;
    }
    if (clientId > 0) {
        queryParams +=
            queryParams.length > 0
                ? `&clientId=${clientId}`
                : `?clientId=${clientId}`;
    }
    if (teamId > 0) {
        queryParams +=
            queryParams.length > 0 ? `&teamId=${teamId}` : `?teamId=${teamId}`;
    }
    const url = `${baseURL}/skillsegmentbycategoryreports${queryParams}`;
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
