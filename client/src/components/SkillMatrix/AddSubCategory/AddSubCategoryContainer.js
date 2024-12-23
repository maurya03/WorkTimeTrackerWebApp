import { connect } from "react-redux";
import {
    postSubCategory,
    postTeams,
    showAlert
} from "rootpath/redux/common/actions";
import { SubCatPostApi } from "rootpath/services/SkillMatrix/CategoryService/CategoryService";
import AddSubCategory from "./AddSubCategory";
import { updateSubCategory } from "rootpath/services/SkillMatrix/ClientService/ClientService";

const mapStateToProps = state => ({
    client: state.skillMatrixOps.client,
    categoryItem: state.skillMatrixOps.categoryItem,
    showAlert: state.skillMatrixOps.showAlert || {}
});

const mapDispatchToProps = dispatch => ({
    postSubCategory: async cat => {
        const teams = await SubCatPostApi(cat);
        dispatch(postSubCategory(teams));
        return teams;
    },
    updateSubCategoryRecord: async subCategory => {
        return await updateSubCategory(subCategory);
    },
    showErrorMessage: result => {
        let errorArray = [];
        result.error.response.data.map(item => {
            errorArray.push({ error: item.errorMessage, field: "name" });
        });
        const errorMessage = errorArray.map(error => error.error).join(", ");
        const data = {
            setAlert: true,
            severity: "error",
            message: errorMessage
        };
        dispatch(showAlert(data));
    },
    setShowAlert: (setAlert = false, severity, message) => {
        const data = {
            setAlert,
            severity,
            message
        };
        dispatch(showAlert(data));
    }
});

const AddSubCategoryContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(AddSubCategory);

export default AddSubCategoryContainer;
