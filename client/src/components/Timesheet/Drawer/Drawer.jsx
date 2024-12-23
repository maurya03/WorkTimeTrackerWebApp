import React, { useState, useEffect } from "react";
import css from "./Drawer.css";
import styles from "rootpath/styles/formStyles.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTimes } from "@fortawesome/free-solid-svg-icons";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import { validationInput } from "rootpath/components/commonValidations";

const DrawerComponent = props => {
    const [rightPosition, setRightPosition] = useState("-70%");
    const [errorMessage, setErrorMesaage] = useState([]);
    useEffect(() => {
        setRightPosition("0");
    });
    const [category, setCategory] = useState({
        timeSheetCategoryName: "",
        function: ""
    });
    const [subCategory, setSubCategory] = useState({
        timeSheetSubCategoryName: "",
        timeSheetCategoryId: ""
    });
    const onHandleChange = e => {
        props.isCategory
            ? setCategory(prev => {
                  return { ...prev, [e.target.id]: e.target.value };
              })
            : setSubCategory(prev => {
                  return { ...prev, [e.target.id]: e.target.value };
              });
    };
    useEffect(() => {
        if (props.isEdit) {
            if (props.selectedCategory) {
                category.timeSheetCategoryName =
                    props.selectedCategory.timeSheetCategoryName;
                category.function = props.selectedCategory.function;
            }
            setCategory(category);
        }
    }, [props.selectedCategory]);
    useEffect(() => {
        if (props.selectedCategory) {
            subCategory.timeSheetCategoryId =
                props.selectedCategory.timeSheetCategoryId;
        }
        setSubCategory(subCategory);
    }, [props.selectedCategory]);
    const postCategory = async data => {
        await props.postCategoryData(data);
    };
    const postSubCategory = async data => {
        await props.postSubcategoryData(data);
    };
    const updateCategory = async category => {
        if (Object.keys(props.selectedCategory).length > 0) {
            category.id = props.selectedCategory.timeSheetCategoryId;
        }
        await props.updateCategory(category);
    };
    const updateSubCategory = async subCategory => {
        if (Object.keys(props.selectedSubCategory).length > 0) {
            subCategory.id = props.selectedSubCategory.timeSheetSubCategoryId;
        }
        await props.updateSubCategory(subCategory);
    };
    const closeDrawer = () => {
        props.setShowDrawer(!props.showDrawer);
        props.setIsEdit(false);
    };
    const onSubmitClick = event => {
        event.preventDefault();
        if (!props.isEdit) {
            if (category.function === "") {
                category.function = "";
            }
            if (category.timeSheetCategoryName === "") {
                category.timeSheetCategoryName = "";
            }
            if (subCategory.timeSheetSubCategoryName === "") {
                subCategory.timeSheetSubCategoryName = "";
            }
        }
        var validation = validationInput(
            props.isCategory ? category : subCategory,
            props.isCategory ? "timeSheetCategory" : "timeSheetSubCategory"
        );
        setErrorMesaage(validation);
        if (validation.length === 0) {
            if (props.isEdit) {
                props.isCategory
                    ? updateCategory(category)
                    : updateSubCategory(subCategory);
            } else {
                props.isCategory
                    ? postCategory(category)
                    : postSubCategory(subCategory);
            }
            closeDrawer();
        }
    };
    return (
        <>
            <div className={css.drawerOverlay}></div>
            <div
                className={css.drawer_container}
                style={{ right: rightPosition }}
            >
                <div className={css.drawerHeader}>
                    <h5 className={css.title}>
                        {" "}
                        {!props.isCategory
                            ? `${props.formHeaderTitle} - ${props.selectedCategory.timeSheetCategoryName}`
                            : props.formHeaderTitle}
                    </h5>
                    <span className={css.closeIcon}>
                        {" "}
                        <FontAwesomeIcon
                            icon={faTimes}
                            size="lg"
                            onClick={() => {
                                props.setShowDrawer(!props.showDrawer);
                                props.setIsEdit(false);
                            }}
                        />
                    </span>
                </div>
                <div className={styles.formContainer}>
                    <label className={styles.label}>
                        {props.formHeaderTitle.split(" ")[1]} Name
                    </label>
                    <input
                        className={styles.formInput}
                        defaultValue={
                            props.isEdit
                                ? props.isCategory
                                    ? props.selectedCategory
                                          .timeSheetCategoryName
                                    : props.selectedSubCategory
                                          .timeSheetSubCategoryName
                                : ""
                        }
                        id={
                            props.formHeaderTitle.split(" ")[1] ===
                            "SubCategory"
                                ? "timeSheetSubCategoryName"
                                : "timeSheetCategoryName"
                        }
                        type="text"
                        onChange={e => onHandleChange(e)}
                        placeholder="Name"
                    ></input>
                    {errorMessage.map(
                        item =>
                            item.field === "Name" && (
                                <div className={styles.errorMessages}>
                                    <span>{item.error}</span>
                                </div>
                            )
                    )}
                    {props.isCategory && (
                        <>
                            <label className={styles.label}>
                                Category Function
                            </label>
                            <input
                                className={styles.formInput}
                                defaultValue={
                                    props.isEdit
                                        ? props.selectedCategory.function
                                        : ""
                                }
                                id={"function"}
                                type="text"
                                onChange={e => onHandleChange(e)}
                                placeholder="Function"
                            ></input>
                        </>
                    )}
                    {errorMessage.map(
                        item =>
                            item.field === "function" && (
                                <div className={styles.errorMessages}>
                                    <span>{item.error}</span>
                                </div>
                            )
                    )}

                    <div className={styles.footer}>
                        <Button
                            handleClick={() => closeDrawer()}
                            className={"btn btn-light " + styles.cancelButton}
                            value="Cancel"
                        />
                        <Button
                            handleClick={e => onSubmitClick(e)}
                            className={"btn btn-light " + styles.submitButton}
                            value="Save"
                        />
                    </div>
                </div>
            </div>
        </>
    );
};

export default DrawerComponent;
