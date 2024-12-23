import { postApi, getApi } from "rootpath/services/baseApiService";
const baseURL = "api/v1";

export const fetchTimesheetReport = async data => {
    const url = `${baseURL}/getTimesheetReport`;
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

export const generateTimesheetWeeklyReport = async (startDate, endDate) => {
    const url = `${baseURL}/generateTimesheetWeeklyReport/startDate/${startDate}/endDate/${endDate}`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) {
                var mediaType = "data:application/pdf;base64,";
                var a = document.createElement("a");
                a.href = mediaType + res.data;
                const formattedEndDate = new Date(endDate)
                    .toISOString()
                    .slice(5, 10)
                    .replace("-", "");
                a.download = `TS_WSR_WKEnding${formattedEndDate}.pdf`;
                a.textContent = "Download file!";
                document.body.appendChild(a);
                a.click();
            } else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const generateTimesheetWeeklyExcelReport = async (
    startDate,
    endDate
) => {
    const url = `${baseURL}/generateTimesheetWeeklyExcelReport/startDate/${startDate}/endDate/${endDate}`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) {
                var mediaType =
                    "data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,";
                var a = document.createElement("a");
                a.href = mediaType + res.data;
                const formattedEndDate = new Date(endDate)
                    .toISOString()
                    .slice(5, 10)
                    .replace("-", "");
                a.download = `TS_WSR_WKEnding${formattedEndDate}.xlsx`;
                a.textContent = "Download file!";
                document.body.appendChild(a);
                a.click();
            } else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
