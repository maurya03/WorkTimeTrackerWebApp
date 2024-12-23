import { connect } from "react-redux";
import {
    getRoles,
    addRoleMapping
} from "rootpath/services/EmployeeBook/RoleService";
import { getEmployeeList } from "rootpath/services/EmployeeBook/employee/EmployeeService";
import { setEmployees, setRoleList } from "rootpath/redux/common/actions";
import ManageUserAccess from "rootpath/components/EmployeeBook/ManageUserAccess/ManageUserAccess.jsx";
import { getLoggedInUserRole } from "rootpath/services/EmployeeBook/RoleService";
import { postUserRole } from "rootpath/redux/common/actions";

const mapStateToProps = state => ({
    employees: state.skillMatrixOps.employees || [],
    roles: (state.skillMatrixOps.roles || []).map(obj => ({
        roleId: obj.roleId,
        roleName: obj.roleName,
        isChecked: false
    })),
    userRole: state.skillMatrixOps.userRole || {}
});

const mapDispatchToProps = dispatch => {
    return {
        fetchRoles: async () => {
            const roles = await getRoles();
            dispatch(setRoleList(roles));
        },

        fetchLoggedInUserRole: async () => {
            const role = await getLoggedInUserRole();
            dispatch(postUserRole(role));
        },

        fetchEmployees: async () => {
            const employees = await getEmployeeList();
            dispatch(setEmployees(employees));
        },

        updateEmployeeRole: async employeeRole => {
            if (employeeRole) {
                await addRoleMapping(employeeRole);
            }
        }
    };
};

const ManageUserAccessContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(ManageUserAccess);

export default ManageUserAccessContainer;
