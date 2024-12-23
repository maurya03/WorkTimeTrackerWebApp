import { connect } from "react-redux";
import {
    setIdeaCategory,
    setShareIdeaQuestions
} from "rootpath/redux/common/actions";
import ShareIdea from "rootpath/components/EmployeeBook/ShareIdea/ShareIdea";
import {
    getIdeaCategories,
    getShareIdeaQuestions,
    saveIdea
} from "rootpath/services/EmployeeBook/ShareIdeaService";

const mapStateToProps = state => ({
    ideaCategory: state.skillMatrixOps.ideaCategory || {},
    shareIdeaQuestions: state.skillMatrixOps.shareIdeaQuestions || [],
    userRole: state.skillMatrixOps.userRole || {}
});

const mapDispatchToProps = dispatch => {
    return {
        fetchIdeaCategory: async () => {
            const categories = await getIdeaCategories();
            dispatch(setIdeaCategory(categories));
        },
        fetchIdeaQuestions: async () => {
            const shareIdeaQuestions = await getShareIdeaQuestions();
            dispatch(setShareIdeaQuestions(shareIdeaQuestions));
        },
        saveIdea: async (categoryId, questionAnswer) => {
            return await saveIdea(categoryId, questionAnswer);
        }
    };
};

const ShareIdeaContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(ShareIdea);

export default ShareIdeaContainer;
