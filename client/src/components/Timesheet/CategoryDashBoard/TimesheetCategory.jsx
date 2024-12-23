import React, { useEffect, useLayoutEffect, useState, useRef } from "react";
import styles from "rootpath/components/Timesheet/CategoryDashBoard/TimesheetCategory.css";
import "react-horizontal-scrolling-menu/dist/styles.css";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import MaterialTable from "@material-table/core";
import { ArrowLeft, ArrowRight, Delete, Edit } from "@material-ui/icons";
import cx from "classnames";
import Drawer from "rootpath/components/Timesheet/Drawer/Drawer";
import CustomAlert from "rootpath/components/CustomAlert";

const CategoryDashboard = ({
    title,
    categories,
    subCategoryList,
    fetchCategoryList,
    fetchSubCategoryList,
    postCategoryData,
    postSubcategoryData,
    updateCategory,
    updateSubCategory,
    deleteCategory,
    deleteSubCategory,
    setShowAlert,
    showAlert
}) => {
    const containerRef = useRef();
    const dashboardRef = useRef();
    const [selectedCategory, setSelectedCategory] = useState("");
    const [showDrawer, setShowDrawer] = useState(false);
    const [subCategories, setSubCategories] = useState([]);
    const [selectedSubCategory, setSelectedSubCategory] = useState({});
    const [isEdit, setIsEdit] = useState(false);
    const [isCategory, setIsCategory] = useState();

    useEffect(async () => {
        fetchCategoryList();
        fetchSubCategoryList();
    }, [fetchCategoryList, fetchSubCategoryList]);

    useEffect(() => {
        setSelectedCategory(categories[0] || "");
    }, [categories]);

    useEffect(() => {
        setSubCategories(subCategoryList || []);
    }, [subCategoryList]);

    useLayoutEffect(() => {
        dashboardRef.current.style.height = `${window.innerHeight - 120}px`;
    }, []);

    const columns = [
        {
            title: "ID",
            field: "timeSheetSubCategoryId",
            sortable: true
        },
        {
            title: "SubCategory",
            field: "timeSheetSubCategoryName",
            sortable: true
        }
    ];
    const tableActions = [
        {
            icon: () => <Edit />,
            tooltip: "Edit",
            onClick: (e, rowData) => onEditSubCategoryClick(e, rowData)
        },
        {
            icon: () => <Delete />,
            tooltip: "Delete",
            onClick: (e, rowData) => onDeleteSubcategoryClick(e, rowData)
        }
    ];
    const handleScroll = scrollAmount => {
        const newScrollPosition =
            containerRef.current.scrollLeft + scrollAmount;
        containerRef.current.scrollLeft = newScrollPosition;
    };
    const onEditSubCategoryClick = (e, row) => {
        addSubCategory(e, row);
        setSelectedSubCategory(row);
    };

    const onCategorySelectionChange = category => {
        setSelectedCategory(category);
        fetchSubCategoryList(category.timeSheetCategoryId);
    };

    const addSubCategory = (e, row) => {
        if (row) {
            setIsEdit(true);
        } else {
            setIsEdit(false);
        }
        setIsCategory(false);
        setShowDrawer(true);
    };
    const addCategory = category => {
        if (category) {
            setIsEdit(true);
        } else {
            setIsEdit(false);
        }
        setIsCategory(true);
        setShowDrawer(true);
    };
    const onDeleteCategoryClick = async id => {
        if (confirm("Are you sure you want to delete this category?")) {
            await deleteCategory(id);
            await fetchCategoryList();
            await fetchSubCategoryList();
            containerRef.current.scrollLeft = 0;
        }
    };
    const onDeleteSubcategoryClick = async (event, row) => {
        if (confirm("Are you sure you want to delete this item?")) {
            await deleteSubCategory(row.timeSheetSubCategoryId);
            await fetchSubCategoryList(row.timeSheetCategoryId);
        }
    };

    return (
        <div className="container">
            {showAlert.setAlert && Object.keys(showAlert).length > 0 && (
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
            <div className={styles.contentHeader}>
                <div className={styles.title}>
                    {title} - {selectedCategory.timeSheetCategoryName}
                </div>
                <div>
                    <Button
                        className={styles.contentHeaderButtons}
                        handleClick={() => addCategory()}
                        value="Add Category"
                    />
                    <Button
                        className={styles.contentHeaderButtons}
                        handleClick={addSubCategory}
                        value="Add SubCategory"
                    />
                </div>
            </div>

            <div className={styles.dashboardView} ref={dashboardRef}>
                {categories.length > 0 && (
                    <div
                        className={cx(
                            styles.clientContainer,
                            styles.topBottomMargin
                        )}
                    >
                        <button
                            className={"btn btn-light" + styles.actionButton}
                            onClick={() => handleScroll(-200)}
                        >
                            <ArrowLeft />
                        </button>
                        <div ref={containerRef} className={styles.scrollClient}>
                            <div className={styles.contentBox}>
                                {categories.map(category => (
                                    <div className={styles.scrollItems}>
                                        <Button
                                            className={
                                                (category.timeSheetCategoryName ===
                                                selectedCategory.timeSheetCategoryName
                                                    ? "btn btn-primary "
                                                    : "btn btn-light ") +
                                                styles.clientButton
                                            }
                                            value={
                                                category.timeSheetCategoryName
                                            }
                                            handleClick={() =>
                                                onCategorySelectionChange(
                                                    category
                                                )
                                            }
                                        />
                                        <div
                                            className={styles.scrollItemActions}
                                        >
                                            <span>
                                                <Edit
                                                    onClick={() => {
                                                        addCategory(category);
                                                        onCategorySelectionChange(
                                                            category
                                                        );
                                                    }}
                                                />
                                            </span>
                                            <span>
                                                <Delete
                                                    onClick={() =>
                                                        onDeleteCategoryClick(
                                                            category.timeSheetCategoryId
                                                        )
                                                    }
                                                />
                                            </span>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        </div>
                        <button
                            className={"btn btn-light" + styles.actionButton}
                            onClick={() => handleScroll(200)}
                        >
                            <ArrowRight />
                        </button>
                    </div>
                )}
                <div className={styles.table}>
                    <MaterialTable
                        columns={columns}
                        data={subCategories}
                        options={{
                            search: false,
                            toolbar: false,
                            maxBodyHeight: "100%",
                            actionsColumnIndex: -1,
                            pageSize: 10,
                            headerStyle: {
                                backgroundColor: "#17072b",
                                color: "#fff"
                            },
                            draggable: false
                        }}
                        actions={tableActions}
                        style={{
                            height: "100%"
                        }}
                    />
                </div>
            </div>
            {showDrawer && (
                <Drawer
                    showDrawer={showDrawer}
                    isCategory={isCategory}
                    setShowDrawer={setShowDrawer}
                    postCategoryData={postCategoryData}
                    postSubcategoryData={postSubcategoryData}
                    updateCategory={updateCategory}
                    updateSubCategory={updateSubCategory}
                    formHeaderTitle={
                        isEdit
                            ? isCategory
                                ? "Edit Category"
                                : "Edit SubCategory"
                            : isCategory
                            ? "Add Category"
                            : "Add SubCategory"
                    }
                    isEdit={isEdit}
                    setIsEdit={setIsEdit}
                    selectedCategory={selectedCategory}
                    selectedSubCategory={selectedSubCategory}
                />
            )}
        </div>
    );
};

export default CategoryDashboard;
