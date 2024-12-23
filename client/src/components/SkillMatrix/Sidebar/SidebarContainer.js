import { connect } from "react-redux";
import SidebarComponent from "./SidebarComponent";
import { getLoggedinUserRole } from "rootpath/services/SkillMatrix/RoleService/RoleService";
import { postUserRole } from "rootpath/redux/common/actions";

const mapStateToProps = state => ({
    userRole: state.skillMatrixOps.userRole || {}
});

const mapDispatchToProps = dispatch => {
    return {
        fetchRole: async () => {
            const role = await getLoggedinUserRole();
            dispatch(postUserRole(role));
        }
    };
};

const SidebarContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(SidebarComponent);
export default SidebarContainer;
