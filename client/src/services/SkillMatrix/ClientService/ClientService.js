import {
    delApi,
    getApi,
    postApi,
    putApi
} from "rootpath/services/baseApiService";

const baseURL = "api/v1";
export const ClientListApi = async (isWithTeam = 0) => {
    let url = `${baseURL}/clients?isWithTeam=${isWithTeam}`;
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

export const ClientTeamsApi = async (clientId, functionType = "All") => {
    let url = `${baseURL}/clientTeams?ClientId=${clientId}&functionType=${functionType}`;
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

export const ClientManagerTeamsApi = async (clientId, employeeId) => {
    let url = `${baseURL}/clientManagerTeams?clientId=${clientId}&employeeId=${employeeId}`;
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

export const ClientPostApi = async data => {
    let url = `${baseURL}/client`;
    const response = await postApi(url, data)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const UpdateClientAPI = async data => {
    const url = `${baseURL}/client`;
    const response = await putApi(url, data)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};
export const UpdateTeamAPI = async data => {
    const url = `${baseURL}/team`;
    const response = await putApi(url, data)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const updateSubCategory = async data => {
    const url = `${baseURL}/subCategory/` + data.id + "";
    const response = await putApi(url, data)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const updateCategory = async data => {
    const url = `${baseURL}/category/` + data.id + "";
    const response = await putApi(url, data)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const TeamPostApi = async data => {
    const url = `${baseURL}/team`;
    const response = await postApi(url, data)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const DeleteEmployeeApi = async employeeId => {
    const url = `${baseURL}/employeeDetails?employeeId=${employeeId}`;
    const response = await delApi(url)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const DeleteTeamApi = async teamId => {
    const url = `${baseURL}/team?teamId=${teamId}`;
    const response = await delApi(url)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const DeleteCategoryApi = async categoryId => {
    const url = `${baseURL}/category?Id=${categoryId}`;
    const response = await delApi(url)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const DeleteClientApi = async clientId => {
    const url = `${baseURL}/client?Id=${clientId}`;
    const response = await delApi(url)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const DeleteSubCategoryApi = async subCategoryId => {
    const url = `${baseURL}/subCategory?subCategoryId=${subCategoryId}`;
    const response = await delApi(url)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const EditClientTeamApi = async editObj => {
    const url = `${baseURL}/ClientMaster`;
    await putApi(url, editObj)
        .then(() => {
            alert("Client and teams updated successfully");
        })
        .catch(error => {
            alert("Error ocurred. Check console.");
            console.log(error);
        });
};

export const EditCategorySubcategoriesApi = async editObj => {
    const url = `${baseURL}/CategoryAndSubCategory`;
    await putApi(url, editObj)
        .then(() => {
            alert("Category and sub-categories updated successfully");
        })
        .catch(error => {
            alert("Error ocurred. Check console.");
            console.log(error);
        });
};

export const EditTeamEmployeesApi = async editObj => {
    const url = `${baseURL}/teamEmployeesDetails`;
    await putApi(url, editObj)
        .then(() => {
            alert("Team and employees updated successfully");
        })
        .catch(error => {
            alert("Error ocurred. Check console.");
        });
};
