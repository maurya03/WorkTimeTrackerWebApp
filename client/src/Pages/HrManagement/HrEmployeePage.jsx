import React from "react";
import SidebarContainer from "rootpath/components/HrManagement/SideBar/SidebarContainer";
import EmployeeDashboardContainer from "rootpath/components/SkillMatrix/SkillMatrixDashboard/EmployeeDashboard/EmployeeDashboardContainer";

const HrEmployeePage = () => {
    return (
        <>
            <SidebarContainer />
            <EmployeeDashboardContainer title={"Manage Employees"} />
        </>
    );
};

export default HrEmployeePage;
