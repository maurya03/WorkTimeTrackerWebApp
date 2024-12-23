import { getApi, postApi } from "../../baseApiService";
const baseURL = "api/v1";
let loggedInRole = "";

export const getLoggedinUserRole = async () => {
    const url = `${baseURL}/userRoleDetail`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) {
                loggedInRole = res.data;
                return res.data;
            } else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
export const PostRoleMappings = async roleMappings => {
    const url = `${baseURL}/emloyeeRoleTeamWise`;
    await postApi(url, roleMappings)
        .then(() => {
            window.alert("Employee role updated successfully!");
        })
        .catch(error => {
            window.alert("Error ocurred, check console!");
        });
};
export const EmpRoleListApi = async teamId => {
    const url = `${baseURL}/emloyeeRoleTeamWise?TeamId=${teamId}`;
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

export const getUserRole = () => {
    return loggedInRole;
};
