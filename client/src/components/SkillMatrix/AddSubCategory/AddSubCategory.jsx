import React, { useState, useEffect } from "react";
import css from "rootpath/styles/formStyles.css";
import { validationInput } from "rootpath/components/SkillMatrix/commonValidationFunction";
import { getSubCategoryList } from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import CustomAlert from "rootpath/components/CustomAlert";

const AddSubCategory = ({
    selectedCategory,
    setaddSubCategoryFormVisible,
    addSubCategoryFormVisible,
    showDrawer,
    setShowDrawer,
    postSubCategory,
    setSubCategory,
    selectedSubCategory,
    updateSubCategoryRecord,
    setIsEdit,
    showErrorMessage,
    setShowAlert,
    showAlert
}) => {
    const [subCategory, setSubCategoryInfo] = useState({
        categoryId: selectedCategory.id,
        subCategoryName: selectedSubCategory?.subCategoryName || "",
        subCategoryDescription:
            selectedSubCategory?.subCategoryDescription || "",
        createdOn: new Date().toJSON(),
        modifiedOn: new Date().toJSON()
    });
    const [errorMessage, setErrorMessage] = useState([]);
    const handlechange = e => {
        setSubCategoryInfo(prev => {
            return { ...prev, [e.target.id]: e.target.value };
        });
    };
    useEffect(async () => {
        if (selectedSubCategory) {
            let subCategory = {};
            subCategory.subCategoryName = selectedSubCategory.subCategoryName;
            subCategory.subCategoryDescription =
                selectedSubCategory.subCategoryDescription;
            subCategory.id = selectedSubCategory.id;
        }
        setSubCategoryInfo(subCategory);
    }, [selectedSubCategory]);

    const closeDrawer = () => {
        setShowAlert(false);
        setaddSubCategoryFormVisible(!addSubCategoryFormVisible);
        setShowDrawer(!showDrawer);
        setIsEdit(false);
    };
    const addSubCategory = async state => {
        const result = await postSubCategory(state);
        const subCategories = await getSubCategoryList(subCategory.categoryId);
        setSubCategory(subCategories);
        if (result?.success) {
            closeDrawer();
            setShowAlert(true, "success", "Sub Category added successfully!");
        } else {
            showErrorMessage(result);
        }
    };
    const updatesubCategory = async state => {
        const result = await updateSubCategoryRecord(state);
        const subCategories = await getSubCategoryList(subCategory.categoryId);
        setSubCategory(subCategories);
        if (result?.success) {
            closeDrawer();
            setShowAlert(true, "success", "Sub Category updated successfully!");
        } else {
            showErrorMessage(result);
        }
    };
    const onSubmitClick = () => {
        var validate = validationInput(subCategory, "subCategory");
        if (validate.length === 0) {
            if (Object.keys(selectedSubCategory).length > 0) {
                subCategory.id = selectedSubCategory.id;
                subCategory.modifiedOn = new Date().toJSON();
                updatesubCategory(subCategory);
            } else {
                addSubCategory(subCategory);
            }
        }
        setErrorMessage(validate);
    };
    return (
        <div className={css.formDrawer}>
            <div className={css.formContainer}>
                {showAlert.severity === "error" &&
                    Object.keys(showAlert).length > 0 && (
                        <CustomAlert
                            open={showAlert.setAlert}
                            severity={showAlert.severity}
                            message={showAlert.message}
                            onClose={() =>
                                setShowAlert(
                                    false,
                                    showAlert.severity,
                                    showAlert.message
                                )
                            }
                        ></CustomAlert>
                    )}
                <label className={css.label}>SubCategory Name</label>
                <input
                    className={css.formInput}
                    defaultValue={selectedSubCategory.subCategoryName}
                    id={"subCategoryName"}
                    type="text"
                    onChange={e => handlechange(e)}
                    placeholder="SubCategory Name"
                ></input>
                {errorMessage.map(
                    item =>
                        item.field === "Name" && (
                            <div className={css.errorMessages}>
                                <span>{item.error}</span>
                            </div>
                        )
                )}
                <label className={css.label}>SubCategory Description</label>
                <textarea
                    rows={5}
                    className={css.description}
                    defaultValue={selectedSubCategory.subCategoryDescription}
                    id={"subCategoryDescription"}
                    type="text"
                    onChange={e => handlechange(e)}
                    placeholder="SubCategory Description"
                    size="50"
                ></textarea>
                {errorMessage.map(
                    item =>
                        item.field === "Description" && (
                            <div className={css.errorMessages}>
                                <span>{item.error}</span>
                            </div>
                        )
                )}
            </div>

            <div className={css.footer}>
                <Button
                    handleClick={() => closeDrawer()}
                    className={"btn btn-light " + css.cancelButton}
                    value="Cancel"
                />
                <Button
                    handleClick={e => onSubmitClick(e)}
                    className={"btn btn-light " + css.submitButton}
                    value="Save"
                />
            </div>
        </div>
    );
};

export default AddSubCategory;
