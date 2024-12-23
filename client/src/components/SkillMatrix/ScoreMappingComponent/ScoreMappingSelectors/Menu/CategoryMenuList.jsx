import React, { useEffect } from "react";
import cx from "classnames";
import css from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreMappingSelectors/Menu/Menu.css";
import styles from "rootpath/styles/formStyles.css";

const CategoryMenuList = props => {
    const {
        menuList,
        activeCategory,
        setActiveCategory,
        handleMenuChange,
        identifier,
        setIsButtonDisable
    } = props;
    const allCategoryItem = [
        {
            categoryDescription: "All Categories",
            categoryFunction: "All Categories",
            categoryName: "All Categories",
            id: 0
        }
    ];
    const updatedCategoryList =
        identifier === "employeeScorePage"
            ? [...allCategoryItem, ...menuList]
            : menuList;
    const handleCategoryChange = item => {
        handleMenuChange(item);
        setIsButtonDisable(true);
    };

    useEffect(() => {
        updatedCategoryList && setActiveCategory(updatedCategoryList[0]);
    }, [menuList]);

    return (
        <section className={css.categoryMenuItemsContainer}>
            <div className={cx(css.categoryMenuList, styles.scrollbar)}>
                {menuList.length > 0 &&
                    updatedCategoryList.map((menuItem, index) => {
                        return (
                            <span
                                key={index}
                                className={cx(
                                    css.menuItem,
                                    (activeCategory?.id
                                        ? menuItem.id === activeCategory.id
                                        : menuItem.id === 0) &&
                                        css.activeCategory
                                )}
                                onClick={() => handleCategoryChange(menuItem)}
                            >
                                {menuItem.categoryName}
                            </span>
                        );
                    })}
            </div>
        </section>
    );
};

export default CategoryMenuList;
