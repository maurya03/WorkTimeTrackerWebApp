import { getApi } from "rootpath/services/baseApiService";
import moment from "moment";

const getCurrentDate = () => moment().format("YYYY-MM-DD");
const getOneMonthBackDate = () =>
    moment().subtract(1, "months").format("YYYY-MM-DD");

export const getChartData = async (filter, sDate, eDate) => {
    const startDate = sDate ? sDate : getOneMonthBackDate();
    const endDate = eDate ? eDate : getCurrentDate();
    const baseURL = `GetAnalyticsReport?Filter=${filter}&StartDate=${startDate}&EndDate=${endDate}`;
    let response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            baseURL;
            return error;
        });
    return response;
};

export const getLogs = async filter => {
    const baseURL = `GetEmployeebookLogs?Filter=${filter}`;
    let response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            baseURL;
            return error;
        });
    return response;
};

export const getGoogleAnalyticsReport = async (sDate, eDate) => {
    const startDate = sDate ? sDate : getOneMonthBackDate();
    const endDate = eDate ? eDate : getCurrentDate();

    const baseURL = `GetGoogleAnalyticalReports?startDate=${startDate}&endDate=${endDate}`;
    let response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) {
                const records = [];
                res.data.map(row => {
                    records.push(
                        Object.assign(
                            ...row.dimensionValues,
                            ...row.metricValues
                        )
                    );
                });
                return records;
            } else return [];
        })
        .catch(error => {
            alert(
                `Error ocurred while fetching Google Analytics Report !! Error Message : ${error.message}`
            );
            return error;
        });
    return response;
};
