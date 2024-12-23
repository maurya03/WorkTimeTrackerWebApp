import React, { useEffect, useLayoutEffect, useState, useRef } from "react";
import styles from "rootpath/components/SkillMatrix/SkillMatrixDashboard/Dashboard.css";
import "react-horizontal-scrolling-menu/dist/styles.css";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import MaterialTable from "@material-table/core";
import { ArrowLeft, ArrowRight, Delete, Edit } from "@material-ui/icons";
import DrawerComponent from "rootpath/components/SkillMatrix/DrawerComponent/DrawerComponent";
import cx from "classnames";
import CustomAlert from "rootpath/components/CustomAlert";

const CategoryDashboard = ({
    title,
    categories,
    subCategoryList,
    fetchCategoryList,
    fetchSubCategoryList,
    deleteSubCategory,
    deleteCategory,
    setShowAlert,
    showAlert
}) => {
    const containerRef = useRef();
    const dashboardRef = useRef();
    const [selectedCategory, setSelectedCategory] = useState("");
    const [showDrawer, setShowDrawer] = useState(false);
    const [subCategories, setSubCategory] = useState([]);
    const [categoryFormVisible, setcategoryFormVisible] = useState(false);
    const [addSubCategoryFormVisible, setaddSubCategoryFormVisible] =
        useState(false);
    const [selectedSubCategory, setSelectedSubCategory] = useState({});
    const [isEdit, setIsEdit] = useState(false);
    const [isCategoryEdit, setIsCategoryEdit] = useState(false);
    const [categoryForAction, setCategoryForAction] = useState({});
    useEffect(() => {
        fetchCategoryList();
        fetchSubCategoryList();
        setShowAlert(false);
    }, [fetchCategoryList, fetchSubCategoryList]);

    useEffect(() => {
        let newSelectedCategory =
            categories.find(category => category.id === selectedCategory.id) ||
            categories[0] ||
            "";
        setSelectedCategory(newSelectedCategory);
    }, [categories]);

    useEffect(() => {
        setSubCategory(subCategoryList || []);
    }, [subCategoryList]);

    useLayoutEffect(() => {
        dashboardRef.current.style.height = `${window.innerHeight - 120}px`;
    }, []);

    const columns = [
        {
            title: "SubCategory",
            field: "subCategoryName",
            sortable: true
        },
        {
            title: "Description",
            field: "subCategoryDescription",
            sortable: true
        }
    ];
    const tableActions = [
        {
            icon: () => <Edit />,
            tooltip: "Edit",
            onClick: (e, rowData) => handleEditClick(e, rowData)
        },
        {
            icon: () => <Delete />,
            tooltip: "Delete",
            onClick: (e, rowData) => handleButtonClick(e, rowData)
        }
    ];
    const handleScroll = scrollAmount => {
        const newScrollPosition =
            containerRef.current.scrollLeft + scrollAmount;
        containerRef.current.scrollLeft = newScrollPosition;
    };
    const handleEditClick = (e, row) => {
        addSubCategory(e, row);
        setSelectedSubCategory(row);
    };

    const handleSelectedCategory = category => {
        setSelectedCategory(category);
        fetchSubCategoryList(category.id);
    };

    const addSubCategory = (e, row) => {
        if (row) {
            setIsEdit(true);
        } else {
            setIsEdit(false);
        }
        setShowDrawer(true);
        setaddSubCategoryFormVisible(true);
    };
    const addTechnology = category => {
        if (category) {
            setCategoryForAction(category);
            setIsCategoryEdit(true);
        } else {
            setIsCategoryEdit(false);
        }
        setShowDrawer(true);
        setcategoryFormVisible(!categoryFormVisible);
    };
    const handleDeleteCategory = async id => {
        if (confirm("Are you sure you want to delete this category?")) {
            const response = await deleteCategory(id);
            await fetchCategoryList();
            await fetchSubCategoryList();
            containerRef.current.scrollLeft = 0;
            if (response.success)
                setShowAlert(true, "success", "Category deleted successfully!");
            else
                setShowAlert(
                    true,
                    "error",
                    "Error deleting category. please delete dependent Sub Category!"
                );
        }
    };
    const handleButtonClick = async (event, row) => {
        if (confirm("Are you sure you want to delete this sub category?")) {
            const response = await deleteSubCategory(row.id);
            await fetchSubCategoryList(row.categoryId);
            if (response.success)
                setShowAlert(
                    true,
                    "success",
                    "Sub Category deleted successfully!"
                );
            else setShowAlert(true, "error", "Error deleting Sub Category.");
        }
    };

    return (
        <div className="container">
            {showAlert.setAlert &&
                Object.keys(showAlert).length > 0 &&
                showAlert.severity === "success" && (
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
                    />
                )}
            <div className={styles.contentHeader}>
                <div className={styles.title}>
                    {title} - {selectedCategory.categoryName}
                </div>
                <div>
                    <Button
                        className={styles.contentHeaderButtons}
                        handleClick={() => addTechnology()}
                        value="Add Category"
                    />
                    <Button
                        className={styles.contentHeaderButtons}
                        handleClick={addSubCategory}
                        value="Add Sub Category"
                    />
                </div>
            </div>

            <div className={styles.dashboardView} ref={dashboardRef}>
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
                            {categories.map((category, index) => (
                                <div className={styles.scrollItems} key={index}>
                                    <Button
                                        className={
                                            (category.categoryName ===
                                            selectedCategory.categoryName
                                                ? "btn btn-primary "
                                                : "btn btn-light ") +
                                            styles.clientButton
                                        }
                                        value={category.categoryName}
                                        handleClick={() =>
                                            handleSelectedCategory(category)
                                        }
                                    />
                                    <div className={styles.scrollItemActions}>
                                        <span title="Edit Category">
                                            <Edit
                                                onClick={() => {
                                                    addTechnology(category);
                                                    handleSelectedCategory(
                                                        category
                                                    );
                                                }}
                                            />
                                        </span>
                                        <span title="Delete Category">
                                            <Delete
                                                onClick={() =>
                                                    handleDeleteCategory(
                                                        category.id
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
                {/* <div className={styles.clientTeamContainer}>
                    <p>{selectedCategory.categoryName}</p>
                    <Button
                        handleClick={() => addSubCategory()}
                        value="Add Sub Category"
                    />
                </div> */}
                <div className={styles.table}>
                    {subCategories.length > 0 ? (
                        <MaterialTable
                            columns={columns}
                            data={subCategories}
                            options={{
                                search: true,
                                toolbar: true,
                                actionsColumnIndex: -1,
                                pageSize: 10,
                                headerStyle: {
                                    backgroundColor: "#17072b",
                                    color: "#fff"
                                },
                                showTitle: false,
                                draggable: false
                            }}
                            actions={tableActions}
                            style={{
                                height: "100%"
                            }}
                        />
                    ) : (
                        <div className={styles.noRecords}>
                            There are no records to display
                        </div>
                    )}
                </div>
            </div>
            {categories && categoryFormVisible && showDrawer && (
                <DrawerComponent
                    setShowAlert={setShowAlert}
                    showDrawer={showDrawer}
                    setShowDrawer={setShowDrawer}
                    setcategoryFormVisible={setcategoryFormVisible}
                    categoryFormVisible={categoryFormVisible}
                    formHeaderTitle={
                        isCategoryEdit ? "Edit Category" : "Add Category"
                    }
                    setIsCategoryEdit={setIsCategoryEdit}
                    selectedCategory={isCategoryEdit ? categoryForAction : {}}
                />
            )}
            {selectedCategory && addSubCategoryFormVisible && showDrawer && (
                <DrawerComponent
                    setShowAlert={setShowAlert}
                    showDrawer={showDrawer}
                    setShowDrawer={setShowDrawer}
                    addSubCategoryFormVisible={addSubCategoryFormVisible}
                    setaddSubCategoryFormVisible={setaddSubCategoryFormVisible}
                    parentid={selectedCategory.id}
                    selectedCategory={selectedCategory}
                    setSubCategory={setSubCategory}
                    selectedSubCategory={isEdit ? selectedSubCategory : {}}
                    formHeaderTitle={
                        isEdit
                            ? `Edit SubCategory - ${selectedCategory.categoryName}`
                            : `Add SubCategory - ${selectedCategory.categoryName}`
                    }
                    setIsSubCategoryEdit={setIsEdit}
                />
            )}
        </div>
    );
};

export default CategoryDashboard;
