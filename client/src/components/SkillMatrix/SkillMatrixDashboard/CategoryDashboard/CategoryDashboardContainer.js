import { connect } from "react-redux";
import {
    getCategoryList,
    getSubCategoryList
} from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import CategoryDashboard from "./CategoryDashboard";
import { setCategories, setSubCategories, showAlert } from "rootpath/redux/common/actions";
import {
    DeleteCategoryApi,
    DeleteSubCategoryApi
} from "rootpath/services/SkillMatrix/ClientService/ClientService";

const mapStateToProps = state => ({
    categories: state.skillMatrixOps.categories || [],
    subCategoryList: state.skillMatrixOps.subCategories || [],
    showAlert: state.skillMatrixOps.showAlert || {}
});

const mapDispatchToProps = dispatch => ({
    fetchCategoryList: async () => {
        const categories = await getCategoryList();
        dispatch(setCategories(categories));
    },
    fetchSubCategoryList: async id => {
        const categoryList = await getCategoryList();
        const categoryId = id ? id : categoryList[0].id;
        const subCategories = await getSubCategoryList(categoryId);
        dispatch(setSubCategories(subCategories));
    },
    deleteSubCategory: async subCategoryId => {
        return await DeleteSubCategoryApi(subCategoryId);
    },
    deleteCategory: async categoryId => {
        return await DeleteCategoryApi(categoryId);
    },
    setShowAlert: (setAlert=false,severity,message) => {
        const data= {
            setAlert,
            severity,
            message
        }
        dispatch(showAlert(data));
    }
});

const CategoryDashboardContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(CategoryDashboard);

export default CategoryDashboardContainer;
