import { postApi } from "../../baseApiService";
const baseURL = "api/v1";
export const PostEmployeeScore = async employeeScoringObject => {
    const url = `${baseURL}/SkillsMatrix`;
    await postApi(url, employeeScoringObject)
        .then(() => {
            console.log("Data inserted successfully");
            alert("Data saved Successfully!!!");
        })
        .catch(error => {
            console.log(error);
        });
};
