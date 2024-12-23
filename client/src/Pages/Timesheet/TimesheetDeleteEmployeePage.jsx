import React from "react";
import SidebarContainer from "rootpath/components/Timesheet/SideBar/SidebarContainer";
import DeleteEmployeeContainer from "rootpath/components/Timesheet/DeleteEmployee/DeleteEmployeeContainer";

const TimesheetEmployeePage = () => {
    return (
        <>
            <SidebarContainer />
            <DeleteEmployeeContainer title={"Manage Delete Employees"} />
        </>
    );
};

export default TimesheetEmployeePage;
