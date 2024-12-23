import React, { useEffect } from "react";
import SidebarContainer from "rootpath/components/Timesheet/SideBar/SidebarContainer";
import TimesheetListContainer from "rootpath/components/Timesheet/TimesheetList/TimesheetListContainer";

const TimesheetApprovedPage = () => {
    useEffect(() => {
        console.log("Approved");
    }, []);
    return (
        <>
            <SidebarContainer />
            <TimesheetListContainer status="Approved" approverPending={false} />
        </>
    );
};

export default TimesheetApprovedPage;
