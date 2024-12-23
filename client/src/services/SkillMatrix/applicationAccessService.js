import { getApi } from "../baseApiService";
const baseURL = "api/v1";

export const getApplicationAccessList = async () => {
    const url = `${baseURL}/applicationAccess`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) {
                return { success: res.data };
            } else return [];
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};
