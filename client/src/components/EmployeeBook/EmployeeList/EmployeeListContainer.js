import { connect } from "react-redux";
import EmployeeList from "rootpath/components/EmployeeBook/EmployeeList/EmployeeList.jsx";
import { getLoggedInUserRole } from "rootpath/services/EmployeeBook/RoleService";
import {
    setUserRole,
    setLoader,
    setEmployeeSearchParam
} from "rootpath/redux/common/actions";

const mapStateToProps = state => {
    const userRole = state.skillMatrixOps.userRole || {};
    const isAdmin =
        Object.keys(userRole).length > 0 && userRole.roleName == "Admin";
    const isHR = Object.keys(userRole).length > 0 && userRole.roleName == "HR";
    return {
        isAdmin,
        isHR
    };
};

const mapDispatchToProps = dispatch => {
    return {
        fetchRole: async () => {
            const role = await getLoggedInUserRole();
            dispatch(setUserRole(role));
        },
        setLoader: isLoading => {
            dispatch(setLoader(isLoading));
        },
        clearEmployeeSearchParam: () => {
            const param = {
                page: 1,
                pageSize: 6,
                projectId: 0,
                interests: "All",
                searchText: "",
                sortBy: "NameAsc"
            };
            dispatch(setEmployeeSearchParam(param));
        }
    };
};

const EmployeeListContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(EmployeeList);

export default EmployeeListContainer;
