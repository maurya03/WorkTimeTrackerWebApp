import {
    getApi,
    postApi,
    putApi,
    delApi
} from "rootpath/services/baseApiService";
import { addLog } from "rootpath/services/EmployeeBook/LoggerService";

export const getEmployees = async employeeSearchParam => {
    const baseURL = `GetEmployeesWithSearch?ProjectId=${employeeSearchParam.projectId}&Interests=${employeeSearchParam.interests}&SortBy=${employeeSearchParam.sortBy}&SearchText=${employeeSearchParam.searchText}&Page=${employeeSearchParam.page}&PageSize=${employeeSearchParam.pageSize}`;
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

export const getEmployeeList = async () => {
    const baseURL = `GetEmployees`;
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

export const getEmployeeDetails = async employeeId => {
    const baseURL = `GetEmployeeDetailById?EmployeeId=${employeeId}`;
    let response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const getUpdatedEmployeeDetailById = async employeeId => {
    const baseURL = `GetUpdatedEmployeeDetailById?EmployeeId=${employeeId}`;
    let response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const getUpdateEmployeeDetails = async () => {
    const baseURL = `GetUpdateEmployeeDetails`;
    let response = await getApi(baseURL)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const updateEmployeeDetails = async (
    employeeId,
    editObj,
    loggedInEmployeeId
) => {
    const baseURL = `UpdateEmployeeDetail?EmployeeId=${employeeId}`;
    const response = await putApi(baseURL, editObj)
        .then(res => {
            if (res.status == "200") {
                addLog({
                    description: `Employee Id : ${employeeId} profile updated by logged in employee Id : ${loggedInEmployeeId}`
                });
                return { success: res };
            }
        })
        .catch(error => {
            console.log(error);
            return { error: error };
        });
    return response;
};

export const updateEmployeeDetailById = async (employeeId, updatedData) => {
    const baseURL = `UpdateEmployeeDetailById?EmployeeId=${employeeId}`;
    const response = await putApi(baseURL, updatedData)
        .then(res => {
            if (res.status == "200") {
                return { success: res };
            }
        })
        .catch(error => {
            console.log(error);
            return { error: error };
        });
    return response;
};

export const updateEmployeeDetailsByEmployee = async editObj => {
    const baseURL = `UpdateEmployeeDetailByEmployee`;
    const response = await postApi(baseURL, editObj)
        .then(res => {
            if (res.status == "200") {
                return { success: res };
            }
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const rejectUpdatedEmployeeDetailById = async EmployeeId => {
    const baseURL = `UpdatedEmployeeDetailById?EmployeeId=${EmployeeId}`;
    const response = await delApi(baseURL)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const deleteEmployee = async (EmployeeId, loggedInEmployeeId) => {
    const baseURL = `EmployeeDetail?EmployeeId=${EmployeeId}`;
    const response = await delApi(baseURL)
        .then(res => {
            addLog({
                description: `Employee Id : ${EmployeeId} was deleted by logged in employee Id : ${loggedInEmployeeId}`
            });
            return { success: res };
        })
        .catch(error => {
            console.log(error);
            return { error: error };
        });
    return response;
};

export const uploadEmployeeExcelData = async excelData => {
    if (excelData) {
        const baseURL = `AddExcelEmployeeData`;
        let response = await postApi(baseURL, JSON.parse(excelData))
            .then(response => {
                if (response.data == 1) {
                    alert("Excel data uploaded successfully!!");
                } else {
                    alert(
                        "data already exist or some issue occured while uploading excel!!"
                    );
                }
            })
            .catch(error => {
                alert("Error Occured !! - " + error);
            });
        return response;
    }
};

export const uploadEmployeeImage = async imageData => {
    if (imageData) {
        const baseURL = `UpdateEmployeeImage`;
        let response = await postApi(baseURL, imageData)
            .then(() => {
                alert("Employee image uploaded successfully!!");
            })
            .catch(error => {
                alert("Error Occured !! - " + error);
            });
        return response;
    }
};
