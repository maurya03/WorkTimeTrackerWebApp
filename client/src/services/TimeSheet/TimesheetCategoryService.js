import {
    getApi,
    postApi,
    putApi,
    delApi
} from "rootpath/services/baseApiService";
const baseURL = "api/v1";

export const TimeSheetCategoryList = async () => {
    let url = "ClientMaster";
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
export const getCategoryList = async () => {
    let url = `${baseURL}/timesheetCategories`;
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
export const getSubCategoryList = async categoryId => {
    let url = `${baseURL}/timesheetSubCategoriesByCategoryId?CategoryId=${categoryId}`;
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
export const addCategory = async data => {
    const url = `${baseURL}/timesheetCategory`;
    const response = await postApi(url, data)
        .then(res => {
          return {success:res};
        })
        .catch(error => {
          return {error:error};
        });
    return response;
};

export const addSubCategory = async data => {
    let url = `${baseURL}/timesheetSubCategory`;
    let response = await postApi(url, data)
        .then(res => {
          return {success:res};
        })
        .catch(error => {
          return {error:error};
        });
    return response;
};
export const editCategory = async data => {
    const url = `${baseURL}/timesheetCategory/${data.id}`;
    const response = await putApi(url, data)
        .then(res => {
              return {success:res}
        })
        .catch(error => {
            return {error:error}
        });
    return response;
};
export const editSubCategory = async data => {
    const url = `${baseURL}/timesheetSubCategory/${data.id}`;
    const response = await putApi(url, data)
        .then(res => {
          return {success:res};
        })
        .catch(error => {
            return {error:error};
        });
    return response;
};
export const deleteCategoryRecord = async id => {
    const url = `${baseURL}/timesheetCategory/${id}`;
    const response=await delApi(url)
    .then(res=>{
      return {success:res}
    }).catch(error=>{
      return {error:error};
    })
    return response;
};

export const deleteSubCategoryRecord = async id => {
    const url = `${baseURL}/timesheetSubCategory/${id}`;
    const response=await delApi(url)
        .then((res) => {
            return {success:res}
        })
        .catch(error => {
            return {error:error}
        })
        return response;
};
