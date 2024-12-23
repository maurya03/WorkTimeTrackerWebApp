import { getApi, delApi, putApi } from "rootpath/services/baseApiService";
const baseURL = "api/v1";
export const GetDeleteEmployeeList = async () => {
    const url = `${baseURL}/getDeleteEmployeeList`;
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

export const hardDeleteEmployeeList = async EmpIds => {
    const url = `${baseURL}/hardDeleteEmployeeList/${EmpIds}`;
    const response = await delApi(url)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const recoverDeleteEmployeeList = async EmpIds => {
    const url = `${baseURL}/recoverDeleteEmployeeList/${EmpIds}`;
    const response = await putApi(url)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};
