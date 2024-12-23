import React from "react";
import SidebarContainer from "rootpath/components/Timesheet/SideBar/SidebarContainer";
import EmployeeDashboardContainer from "rootpath/components/SkillMatrix/SkillMatrixDashboard/EmployeeDashboard/EmployeeDashboardContainer";

const TimesheetEmployeePage = () => {
    return (
        <>
            <SidebarContainer />
            <EmployeeDashboardContainer title={"Manage Employees"} />
        </>
    );
};

export default TimesheetEmployeePage;
