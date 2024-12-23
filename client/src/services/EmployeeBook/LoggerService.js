import { postApi } from "rootpath/services/baseApiService";

export const addLog = async Log => {
    const baseURL = "AddLog";
    await postApi(baseURL, Log)
        .then(() => {})
        .catch(error => {
            window.alert(`Error ocurred, while adding logs, Error : ${error}`);
        });
};
