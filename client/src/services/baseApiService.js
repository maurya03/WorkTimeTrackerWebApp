import axios from "axios";
import config from "Configurator";

const getHeaders = () => {
    const accessToken = localStorage.getItem("accessToken");
    let headers = {
        Authorization: `Bearer ${accessToken}`,
        "Access-Control-Allow-Origin": "*"
    };
    return headers;
};
export const getApi = async urlPath => {
    let apiURL = `${config.baseUrl}${urlPath}`;
    const response = await axios.get(apiURL, {
        headers: getHeaders()
    });
    return response;
};

export const putApi = async (urlPath, data) => {
    let apiURL = `${config.baseUrl}${urlPath}`;
    const response = await axios.put(apiURL, data, {
        headers: getHeaders()
    });
    return response;
};
export const patchApi = async (urlPath, data) => {
    let apiURL = `${config.baseUrl}${urlPath}`;
    const response = await axios.patch(apiURL, data, {
        headers: getHeaders()
    });
    return response;
};
export const delApi = async urlPath => {
    let apiURL = `${config.baseUrl}${urlPath}`;
    const response = await axios.delete(apiURL, {
        headers: getHeaders()
    });
    return response;
};

export const postApi = async (urlPath, data) => {
    let apiURL = `${config.baseUrl}${urlPath}`;
    const reponse = await axios.post(apiURL, data, {
        headers: getHeaders()
    });
    return reponse;
};

const getFormDataHeader = () => {
    const accessToken = localStorage.getItem("accessToken");
    let headers = {
        Authorization: `Bearer ${accessToken}`,
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "multipart/form-data"
    };
    return headers;
};

export const postFormDataApi = async (urlPath, data) => {
    let apiURL = `${config.baseUrl}${urlPath}`;
    const reponse = await axios.post(apiURL, data, {
        headers: getFormDataHeader()
    });
    return reponse;
};
