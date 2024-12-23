import { getApi, postApi, putApi } from "../../baseApiService";
const baseURL = "api/v1";
export const EmpListApi = async teamId => {
    const url = `${baseURL}/employeeDetailsByTeamId?TeamId=${teamId}`;
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

export const EmpPostApi = async data => {
    const url = `${baseURL}/employeeDetails`;

    const response = await postApi(url, data)
        .then(res => {
            alert("Employee added successfully!!");
            return {success:res}
        })

        .catch(error => {
          return {error:error};

        });

    return response;
};

export const updateEmployee = async data => {
    const url = `${baseURL}/teamEmployees`;

    const response = await putApi(url, data)
        .then(res => {
            alert("Employee updated successfully!!");
            return {success:res}
        })

        .catch(error => {
            return {error:error};
        });

    return response;
};

export const GetEmployeeType = async () => {
    const url = `${baseURL}/employeeType`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) {
                return res.data;
            } else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const GetEmployeeRoles = async () => {
    const url = `${baseURL}/employeeRoles`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) {
                return res.data;
            } else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const GetEmployeeDesignation = async () => {
    const url = `${baseURL}/employeeDesignation`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) {
                return res.data;
            } else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const GetEmployeeRole = async () => {
    const url = `${baseURL}/employeerole`;
    const response = await getApi(url)
        .then(res => {
            if (res && res.data) {
                return res.data;
            } else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
