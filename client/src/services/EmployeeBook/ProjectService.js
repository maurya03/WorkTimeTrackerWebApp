import { getApi } from "rootpath/services/baseApiService";

export const getProjectList = async () => {
    const baseURL = `getRoleBasedProjects`;
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

export const getProject = async id => {
    const baseURL = `GetProjectById?Id=${id}`;
    let response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) return res.data;
            else return {};
        })
        .catch(error => {
            baseURL;
            return error;
        });
    return response;
};
