import { connect } from "react-redux";
import { postUserRole } from "rootpath/redux/common/actions";
import { getLoggedInUserRole } from "rootpath/services/EmployeeBook/RoleService";
import ImportEmployees from "rootpath/components/EmployeeBook/ImportEmployees/ImportEmployees.jsx";

const mapStateToProps = state => ({
    userRole: state.skillMatrixOps.userRole || {}
});
const mapDispatchToProps = dispatch => {
    return {
        fetchRole: async () => {
            const role = await getLoggedInUserRole();
            dispatch(postUserRole(role));
        }
    };
};

const ImportEmployeeContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(ImportEmployees);

export default ImportEmployeeContainer;
