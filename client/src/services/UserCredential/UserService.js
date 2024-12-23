import {
    getApi,
    postApi,
    putApi,
    delApi
} from "rootpath/services/baseApiService";

const baseURL = "api/v1";

export const AddUser = async registerUserDetails => {
    const url = `${baseURL}/registerUser`;
    const response = await postApi(url, registerUserDetails)
    .then(res =>{
        return {success: res};
    })
    .catch(error => {
        return {error:error};
    });
    return response;
};

export const ValidateUser = async loginUserDetails => {
    const url = `${baseURL}/validateUser`;
    const response = await postApi(url, loginUserDetails)
    .then(res => {
        return {success: res};
    })
    .catch(error => {
        return {error:error}
    });
    return response;
};