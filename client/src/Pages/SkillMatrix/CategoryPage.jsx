import React from "react";
import SidebarContainer from "rootpath/components/SkillMatrix/Sidebar/SidebarContainer";
import CategoryDashboardContainer from "rootpath/components/SkillMatrix/SkillMatrixDashboard/CategoryDashboard/CategoryDashboardContainer";

const CategoryPage = () => {
    return (
        <>
            <SidebarContainer />
            <CategoryDashboardContainer
                title="Manage Technology"
                subTitle="categories"
            />
        </>
    );
};

export default CategoryPage;
