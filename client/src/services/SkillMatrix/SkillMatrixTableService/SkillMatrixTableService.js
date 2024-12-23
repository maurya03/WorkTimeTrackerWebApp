import { getApi, postApi } from "../../baseApiService";
const baseURL = "api/v1";
export const GetSkillMatrixAPI = async () => {
    const url = `${baseURL}/skillsMatrices`;
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
export const getSkillMatrixTableData = async data => {
    const url = `${baseURL}/skillsMatrixTablesCheck`;
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
