import React from "react";
import SidebarContainer from "rootpath/components/SkillMatrix/Sidebar/SidebarContainer";
import EmployeeDashboardContainer from "rootpath/components/SkillMatrix/SkillMatrixDashboard/EmployeeDashboard/EmployeeDashboardContainer";

const EmployeePage = () => {
    return (
        <>
            <SidebarContainer />
            <EmployeeDashboardContainer title={"Manage Employees"} />
        </>
    );
};

export default EmployeePage;
