import { connect } from "react-redux";
import {
    setShareIdeaCountsWithCategory,
    postUserRole,
    setEmployeeShareIdea
} from "rootpath/redux/common/actions";
import ShareIdeaList from "rootpath/components/EmployeeBook/ShareIdea/Admin/ShareIdeaList";
import {
    getShareIdeaCountsWithCategory,
    getEmployeeShareIdea
} from "rootpath/services/EmployeeBook/ShareIdeaService";
import { getLoggedInUserRole } from "rootpath/services/EmployeeBook/RoleService";

const mapStateToProps = state => ({
    shareIdeaCountsWithCategory:
        state.skillMatrixOps.shareIdeaCountsWithCategory || [],
    userRole: state.skillMatrixOps.userRole || {},
    employeeShareIdea: state.skillMatrixOps.employeeShareIdea || []
});

const mapDispatchToProps = dispatch => {
    return {
        fetchShareIdeaCountsWithCategory: async () => {
            const ideaCounts = await getShareIdeaCountsWithCategory();
            dispatch(setShareIdeaCountsWithCategory(ideaCounts));
        },
        fetchRole: async () => {
            const role = await getLoggedInUserRole();
            dispatch(postUserRole(role));
        },
        fetchEmployeeShareIdea: async () => {
            const employeeShareIdea = await getEmployeeShareIdea();
            dispatch(setEmployeeShareIdea(employeeShareIdea));
        }
    };
};

const ShareIdeaListContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(ShareIdeaList);

export default ShareIdeaListContainer;
