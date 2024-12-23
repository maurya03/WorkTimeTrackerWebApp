import { getApi } from "rootpath/services/baseApiService";

export const GetBarData = async (id, functionType) => {
    let url = `api/v1/dashboard/bar/${id}?functionType=${functionType}`;
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

export const GetBarDataCategoryWise = async (id, functionType) => {
    let url = `api/v1/dashboard/bar/teamwise/${id}?functionType=${functionType}`;
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

export const GetBarDataCategoryTeamWiseScore = async (id, functionType) => {
    let url = `api/v1/dashboard/bar/teamwisescore/clients/${id}?functionType=${functionType}`;
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

export const GetBarDataCategoryTeamWiseScoreByTeamName = async (
    id,
    teamName,
    functionType
) => {
    let url = `api/v1/dashboard/bar/categorywiseempscore/clients/${id}?TeamName=${teamName}&functionType=${functionType}`;
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

export const GetBarDataTeamWise = async (
    id,
    teamName,
    chartType,
    functionType
) => {
    let url = `api/v1/dashboard/bar/clients/${id}/teams/${teamName}?chartType=${chartType}&functionType=${functionType}`;
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

export const GetLineDataEmployeeWiseTrend = async (
    id,
    teamid,
    bhavnaEmployeeId,
    functionType
) => {
    let url = `api/v1/dashboard/line/clients/${id}/teams/${teamid}/employees/${bhavnaEmployeeId}?functionType=${functionType}`;
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

export const GetBoxData = async (
    clientId,
    startRange,
    endRange,
    functionType
) => {
    let url = `api/v1/dashboard/shortcutbox/${clientId}?startRange=${startRange}&endRange=${endRange}&functionType=${functionType}`;
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

export const GetScoreNotMaintainedBoxData = async (clientId, functionType) => {
    let url = `api/v1/dashboard/shortcutbox/scorenotmaintained/${clientId}?functionType=${functionType}`;
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
