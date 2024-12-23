import { getApi } from "../../baseApiService";
const baseURL = "api/v1";
export const ClientListApi = async (isWithTeam = 0) => {
    const url = `${baseURL}/clients?isWithTeam=${isWithTeam}`;
    const response = await getApi(url)
        .then(res => {
            if (res.data.length > 0) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const ClientTeamsApi = async (clientId, functionType = "All") => {
    const url = `${baseURL}/clientTeams?ClientId=${clientId}&functionType=${functionType}`;
    const response = await getApi(url)
        .then(res => {
            if (res.data.length > 0) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const CategoryListApi = async () => {
    const url = `${baseURL}/categories`;
    const response = await getApi(url)
        .then(res => {
            if (res.data.length > 0) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const SubCategoryListApi = async () => {
    const url = `${baseURL}/subCategories`;
    const response = await getApi(url)
        .then(res => {
            if (res.data.length > 0) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const SubCategoryCategoryListApi = async categoryId => {
    const url = `${baseURL}/subCategoriesByCategoryId?CategoryId=${categoryId}`;
    const response = await getApi(url)
        .then(res => {
            if (res.data.length > 0) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const TeamEmployeesListApi = async teamId => {
    const url = `${baseURL}/employeeDetailsByTeamId?TeamId=${teamId}`;
    const response = await getApi(url)
        .then(res => {
            if (res.data.length > 0) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
