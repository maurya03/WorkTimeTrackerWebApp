import React from "react";
import SidebarContainer from "rootpath/components/Timesheet/SideBar/SidebarContainer";
import TimesheetListContainer from "rootpath/components/Timesheet/TimesheetList/TimesheetListContainer";

const TimesheetRejectedPage = () => {
    return (
        <>
            <SidebarContainer />
            <TimesheetListContainer status="Rejected" approverPending={false} />
        </>
    );
};

export default TimesheetRejectedPage;
