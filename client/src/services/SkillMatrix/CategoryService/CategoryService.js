import { getApi, postApi } from "../../baseApiService";
const baseURL = "api/v1";
export const CategoryListApi = async () => {
    let url = `${baseURL}/categories`;
    let response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const SubCategoryListApi = async categoryId => {
    let url = `${baseURL}/subCategoriesByCategoryId?CategoryId=${categoryId}`;
    let response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};

export const CategoryPostApi = async data => {
    const url = `${baseURL}/category`;
    const response = await postApi(url, data)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const SubCatPostApi = async data => {
    let url = `${baseURL}/subCategory`;
    let response = await postApi(url, data)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};

export const GetCategoryListWithTeamScore = async (teamId, isWithScore = 0) => {
    let url = `${baseURL}/categoriesWithTeamScore?teamId=${teamId}&isWithScore=${isWithScore}`;
    let response = await getApi(url)
        .then(res => {
            if (res && res.data) return res.data;
            else return [];
        })
        .catch(error => {
            return error;
        });
    return response;
};
