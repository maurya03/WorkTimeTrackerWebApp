import React, { useState, useEffect, useRef } from "react";
import styles from "rootpath/components/SkillMatrix/SkillMatrixDashboard/Dashboard.css";
import { ArrowLeft, ArrowRight } from "@material-ui/icons";
import Button from "rootpath/components/SkillMatrix/Button/Button";
const ScoreMappingCategories = ({
    categories,
    setActiveCategory,
    activeCategory
}) => {
    const containerRefCategory = useRef();
    useEffect(() => {
        setActiveCategory(categories[0] || null);
    }, [categories]);

    const handleCategoryScroll = scrollAmount => {
        const newScrollPosition =
            containerRefCategory.current.scrollLeft + scrollAmount;
        containerRefCategory.current.scrollLeft = newScrollPosition;
    };
    return (
        <div className={styles.clientContainer}>
            <button
                className={"btn btn-light" + styles.actionButton}
                onClick={() => handleCategoryScroll(-200)}
            >
                <ArrowLeft />
            </button>
            <div ref={containerRefCategory} className={styles.scrollClient}>
                <div className={styles.contentBox}>
                    {categories.map(category => (
                        <div className={styles.scrollItems}>
                            <Button
                                title={category.categoryName}
                                className={
                                    (category.categoryName ===
                                    activeCategory.categoryName
                                        ? "btn btn-primary "
                                        : "btn btn-light ") +
                                    styles.clientButton
                                }
                                value={category.categoryName}
                                handleClick={() => setActiveCategory(category)}
                            />
                        </div>
                    ))}
                </div>
            </div>
            <button
                className={"btn btn-light" + styles.actionButton}
                onClick={() => handleCategoryScroll(200)}
            >
                <ArrowRight />
            </button>
        </div>
    );
};
export default ScoreMappingCategories;
