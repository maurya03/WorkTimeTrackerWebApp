import { PostRoleMappings,EmpRoleListApi } from "../../services/SkillMatrix/RoleService/RoleService";

export const getEmployeeRoleList = async teamId => {
    const result = await EmpRoleListApi(teamId);
    return result;
};
export const postEmployeeRoleList = async roles => {
    const data = await PostRoleMappings(roles);
    return data;
};
