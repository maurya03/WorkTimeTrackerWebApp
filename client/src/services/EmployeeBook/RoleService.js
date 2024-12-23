import { getApi, postApi } from "rootpath/services/baseApiService";
import { addLog } from "rootpath/services/EmployeeBook/LoggerService";

let loggedInRole = "";
export const getLoggedInUserRole = async () => {
    const baseURL = "api/v1/userRoleDetail";
    const response = await getApi(baseURL)
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

export const getUserRole = () => {
    return loggedInRole;
};

export const addRoleMapping = async roleMappings => {
    const baseURL = "AddEmployeeRole";
    const loggedInEmployee = await getLoggedInUserRole();
    await postApi(baseURL, roleMappings)
        .then(() => {
            addLog({
                description: `Employee Id : ${roleMappings.employeeId} role was updated by logged in employee Id : ${loggedInEmployee.employeeId}`
            });
            window.alert("Employee role updated successfully!");
        })
        .catch(error => {
            window.alert("Error ocurred, check console!");
        });
};

export const getRoles = async () => {
    const baseURL = "api/v1/roles";
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
