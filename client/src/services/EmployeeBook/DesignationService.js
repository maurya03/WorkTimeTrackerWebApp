import { getApi } from "rootpath/services/baseApiService";

export const getDesignations = async () => {
    const baseURL = "GetDesignations";
    const response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
