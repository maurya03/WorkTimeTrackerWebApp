import {
    CategoryListApi,
    SubCategoryListApi
} from "rootpath/services/SkillMatrix/CategoryService/CategoryService";
import { ClientTeamsApi } from "rootpath/services/SkillMatrix/ClientService/ClientService";
import {
    EmpListApi,
    GetEmployeeType
} from "rootpath/services/SkillMatrix/EmployeeService/EmployeeService";
import { ClientListApi } from "rootpath/services/SkillMatrix/MasterService/MasterService";

export const getClientsList = async (isWithTeam = 0) => {
    const result = await ClientListApi(isWithTeam);
    return result;
};

export const getClientsTeamsList = async clientId => {
    const result = await ClientTeamsApi(clientId);
    return result;
};

export const getCategoryList = async () => {
    const result = await CategoryListApi();
    return result;
};

export const getSubCategoryList = async catId => {
    const result = await SubCategoryListApi(catId);
    return result;
};

export const getEmployeeList = async teamId => {
    const result = await EmpListApi(teamId);
    return result;
};

export const getEmployeeTypeList = async () => {
    const result = await GetEmployeeType();
    return result;
};
