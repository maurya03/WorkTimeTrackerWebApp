import React from "react";
import SidebarContainer from "../../components/Timesheet/SideBar/SidebarContainer";
import TimesheetListContainer from "../../components/Timesheet/TimesheetList/TimesheetListContainer";

const TimesheetListPage = () => {
    return (
        <>
            <SidebarContainer />
            <TimesheetListContainer status="Pending" approverPending={false} />
        </>
    );
};

export default TimesheetListPage;
