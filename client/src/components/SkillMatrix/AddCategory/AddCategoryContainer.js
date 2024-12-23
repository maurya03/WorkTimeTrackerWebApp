import { connect } from "react-redux";
import { setCategories, showAlert } from "rootpath/redux/common/actions";
import { getCategoryList } from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import AddCategory from "rootpath/components/SkillMatrix/AddCategory/AddCategory";
import { updateCategory } from "rootpath/services/SkillMatrix/ClientService/ClientService";

const mapStateToProps = state => ({
    category: state.skillMatrixOps.category,
    showAlert: state.skillMatrixOps.showAlert || {}
});
const mapDispatchToProps = dispatch => {
    return {
        fetchCategoriesList: async () => {
            const categories = await getCategoryList();
            dispatch(setCategories(categories));
        },
        updateCategory: async category => {
            return await updateCategory(category);
        },
        showErrorMessage: result => {
            let errorArray = [];
            result.error.response.data.map(item => {
                errorArray.push({ error: item.errorMessage, field: "name" });
            });
            const errorMessage = errorArray
                .map(error => error.error)
                .join(", ");
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
    };
};
const AddCategoryContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(AddCategory);

export default AddCategoryContainer;
