import React from "react";
import SidebarContainer from "rootpath/components/HrManagement/SideBar/SidebarContainer";
import DeleteEmployeeContainer from "rootpath/components/Timesheet/DeleteEmployee/DeleteEmployeeContainer";

const HrDeleteEmployeePage = () => {
    return (
        <>
            <SidebarContainer />
            <DeleteEmployeeContainer title={"Manage Delete Employees"} />
        </>
    );
};

export default HrDeleteEmployeePage;
