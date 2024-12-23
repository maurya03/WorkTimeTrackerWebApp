import { connect } from "react-redux";
import SidebarComponent from "./SidebarComponent";
import { getLoggedinUserRole } from "rootpath/services/SkillMatrix/RoleService/RoleService";
import { postUserRole } from "rootpath/redux/common/actions";
import { setSelectedTimesheetStatus } from "rootpath/redux/timesheet/actions.js";

const mapStateToProps = state => ({
    userRole: state.skillMatrixOps.userRole || {}
});

const mapDispatchToProps = dispatch => {
    return {
        fetchRole: async () => {
            const role = await getLoggedinUserRole();
            dispatch(postUserRole(role));
        },
        setSelectedTimesheetStatus: async status => {
            dispatch(setSelectedTimesheetStatus(status));
        }
    };
};

const SidebarContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(SidebarComponent);
export default SidebarContainer;
