import React from "react";
import SidebarContainer from "rootpath/components/Timesheet/SideBar/SidebarContainer";
import TaskSheetListContainer from "rootpth/components/Timesheet/TimeSheetList/TimeSheetListContainer";

const TimesheetList = () => {
    return (
        <>
            <SidebarContainer />
            <TaskSheetListContainer />
        </>
    );
};

export default TimesheetList;
