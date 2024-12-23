import React from "react";
import SidebarContainer from "rootpath/components/Timesheet/SideBar/SidebarContainer";
import TimesheetListContainer from "rootpath/components/Timesheet/TimesheetList/TimesheetListContainer";

const TimesheetPendingPage = () => {
    return (
        <>
            <SidebarContainer />
            <TimesheetListContainer status="Pending" approverPending={true} />
        </>
    );
};

export default TimesheetPendingPage;
