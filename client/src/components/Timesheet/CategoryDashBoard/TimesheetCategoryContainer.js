import { connect } from "react-redux";
import TimesheetCategory from "./TimesheetCategory";
import {
    setTimeSheetCategories,
    setTimeSheetSubCategories
} from "rootpath/redux/timesheet/actions.js";
import {showAlert} from "rootpath/redux/common/actions";

import {
    getCategoryList,
    getSubCategoryList,
    addCategory,
    addSubCategory,
    editCategory,
    editSubCategory,
    deleteCategoryRecord,
    deleteSubCategoryRecord
} from "rootpath/services/TimeSheet/TimesheetCategoryService";

const mapStateToProps = state => ({
    categories: state.timeSheetOps.timeSheetCategories || [],
    subCategoryList: state.timeSheetOps.timeSheetSubCategories || [],
    showAlert: state.skillMatrixOps.showAlert || {}

});

const mapDispatchToProps = dispatch => ({
  setShowAlert: (setAlert = false, severity, message) => {
    const data = {
        setAlert,
        severity,
        message
    };
    dispatch(showAlert(data));
    },
    fetchCategoryList: async () => {
        const categories = await getCategoryList();
        dispatch(setTimeSheetCategories(categories));
    },
    fetchSubCategoryList: async id => {
        const categoryList = await getCategoryList();
        const categoryId = id ? id : categoryList[0].timeSheetCategoryId;
        const subCategories = await getSubCategoryList(categoryId);
        dispatch(setTimeSheetSubCategories(subCategories));
    },
    postCategoryData: async (category) => {
        const result=await addCategory(category);
        if(result?.success){
          const data={
            setAlert: true,
            severity:"success",
            message:"Category added successfully"
          }
          dispatch(showAlert(data));
          const categories = await getCategoryList();
          dispatch(setTimeSheetCategories(categories));
        }
        else{
            const errorMessage=result.error.response.data;
            const data = {
              setAlert: true,
              severity: "error",
              message: errorMessage
            };
          dispatch(showAlert(data));
        }
    },
    postSubcategoryData: async (subcategory) => {
        const result=await addSubCategory(subcategory);
        if(result?.success){
          const data={
            setAlert:true,
            severity:"success",
            message:"Subcategory added successfully"
          }
          dispatch(showAlert(data));
          const subCategories = await getSubCategoryList(
            subcategory.timeSheetCategoryId
        );
        dispatch(setTimeSheetSubCategories(subCategories));
        }
        else{
          const errorMessage=result.error.response.data;
          const data={
          setAlert:true,
          severity:"error",
          message:errorMessage
          }
          dispatch(showAlert(data));
        }


    },
    updateCategory: async (category) => {
        const result=await editCategory(category);

        if(result?.success){
          const data={
            setAlert:true,
            severity:"success",
            message:"Category updated successfully"
            }
          dispatch(showAlert(data));
          const categories = await getCategoryList();
          const categoryId = categories[0].timeSheetCategoryId;
          const subCategories = await getSubCategoryList(categoryId);
          dispatch(setTimeSheetSubCategories(subCategories));
          dispatch(setTimeSheetCategories(categories));
          }
          else{

          const errorMessage=result.error.response.data;
          const data={
            setAlert:true,
            severity:"error",
            message:errorMessage
            }
          dispatch(showAlert(data));
          }
    },
    updateSubCategory: async (subcategory) => {
          const result=await editSubCategory(subcategory);
          if(result?.success){
            const data={
              setAlert:true,
              severity:"success",
              message:"Subcategory updated successfully"
            }
            const subCategories = await getSubCategoryList(
              subcategory.timeSheetCategoryId
          );
          dispatch(showAlert(data));
          dispatch(setTimeSheetSubCategories(subCategories));

          }
          else{
            const errorMessage=result.error.response.data;
            const data={
              setAlert:true,
              severity:"error",
              message:errorMessage
            }
            dispatch(showAlert(data));
          }

    },
    deleteCategory: async (categoryId) => {
          const result= await deleteCategoryRecord(categoryId);
          if(result?.success){
          const data={
            setAlert: true,
            severity:"success",
            message:"Category deleted successfully"
          }
          dispatch(showAlert(data));
          }
          else{
            const errorMessage=result.error.response.data[0].errorMessage;
            const data = {
              setAlert: true,
              severity: "error",
              message: errorMessage
          };
          dispatch(showAlert(data));
          }
    },
    deleteSubCategory: async (subCategoryId) => {
          const result=await deleteSubCategoryRecord(subCategoryId);
          if(result?.success){
          const data={
            setAlert:true,
            severity:"success",
            message:"Subcategory deleted successfully"
          };
          dispatch(showAlert(data));
          }
          else{
            const errorMessage=result.error.response.data[0].errorMessage;
            const data={
              setAlert:true,
              severity:"error",
              message:errorMessage
            };
            dispatch(showAlert(data));
          }
    }
});

const TimesheetCategoryContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(TimesheetCategory);

export default TimesheetCategoryContainer;
