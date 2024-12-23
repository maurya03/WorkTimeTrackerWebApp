import { getApi, postApi,putApi } from "rootpath/services/baseApiService";

export const PostExcelRecords = async data => {
    const url = "api/org/records";    //"api/import/records"
    const response = await postApi(url,data);         
    return response;
};
export const postItHoursRecords = async data => {
    const url = "api/ItHours";   
    const response = await postApi(url,data);         
    return response;
};


