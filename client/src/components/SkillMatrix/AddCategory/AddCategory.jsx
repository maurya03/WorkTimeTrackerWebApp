import React, { useState, useEffect } from "react";
import css from "rootpath/styles/formStyles.css";
import { validationInput } from "rootpath/components/SkillMatrix/commonValidationFunction";
import { CategoryPostApi } from "rootpath/services/SkillMatrix/CategoryService/CategoryService";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import CustomAlert from "rootpath/components/CustomAlert";

const AddCategory = ({
    selectedCategory,
    categoryFormVisible,
    updateCategory,
    fetchCategoriesList,
    setcategoryFormVisible,
    setShowDrawer,
    showDrawer,
    setIsEdit,
    showErrorMessage,
    setShowAlert,
    showAlert
}) => {
    const [category, setCategory] = useState({
        categoryFunction: selectedCategory?.categoryFunction || "",
        categoryName: selectedCategory?.categoryName || "",
        categoryDescription: selectedCategory?.categoryDescription || "",
        createdOn: new Date().toJSON(),
        modifiedOn: new Date().toJSON()
    });
    const [errorMessage, setErrorMesaage] = useState([]);
    const handlechange = e => {
        setCategory(prev => {
            return { ...prev, [e.target.id]: e.target.value };
        });
    };
    useEffect(async () => {
        if (selectedCategory) {
            let category = {};
            category.categoryFunction = selectedCategory.categoryFunction;
            category.categoryDescription = selectedCategory.categoryDescription;
            category.categoryName = selectedCategory.categoryName;
        }
        setCategory(category);
    }, [selectedCategory]);

    const postCategoryRecord = async state => {
        const result = await CategoryPostApi(state);
        if (result?.success) {
            fetchCategoriesList();
            closeDrawer();
            setShowAlert(true, "success", "Category added successfully!");
        } else {
            showErrorMessage(result);
        }
    };
    const updateCategoryRecord = async state => {
        const result = await updateCategory(state);
        if (result?.success) {
            fetchCategoriesList();
            closeDrawer();

            setShowAlert(true, "success", "Category updated successfully!");
        } else {
            showErrorMessage(result);
        }
    };
    const closeDrawer = () => {
        setShowAlert(false);
        setcategoryFormVisible(!categoryFormVisible);
        setShowDrawer(!showDrawer);
        setIsEdit(false);
    };
    const onSubmitClick = () => {
        var validation = validationInput(category, "category");
        if (validation.length === 0) {
            if (Object.keys(selectedCategory).length > 0) {
                category.id = selectedCategory.id;
                category.modifiedOn = new Date().toJSON();
                updateCategoryRecord(category);
            } else {
                postCategoryRecord(category);
            }
        }
        setErrorMesaage(validation);
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
                <label className={css.label}>Category Function</label>
                <input
                    className={css.formInput}
                    defaultValue={selectedCategory.categoryFunction}
                    id={"categoryFunction"}
                    type="text"
                    onChange={e => handlechange(e)}
                    placeholder="Category Function"
                ></input>
                {errorMessage.map(
                    item =>
                        item.field === "Function" && (
                            <div className={css.errorMessages}>
                                <span>{item.error}</span>
                            </div>
                        )
                )}
                <label className={css.label}>Category Name</label>
                <input
                    className={css.formInput}
                    defaultValue={selectedCategory.categoryName}
                    id={"categoryName"}
                    type="text"
                    onChange={e => handlechange(e)}
                    placeholder="Category Name"
                ></input>
                {errorMessage.map(
                    item =>
                        item.field === "Name" && (
                            <div className={css.errorMessages}>
                                <span>{item.error}</span>
                            </div>
                        )
                )}
                <label className={css.label}>Category Description</label>
                <textarea
                    rows={5}
                    className={css.description}
                    defaultValue={selectedCategory.categoryDescription}
                    id={"categoryDescription"}
                    type="text"
                    onChange={e => handlechange(e)}
                    size="50"
                    placeholder="Category Description"
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

export default AddCategory;
