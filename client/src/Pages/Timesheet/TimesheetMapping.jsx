import React from "react";
import SidebarContainer from "rootpath/components/Timesheet/SideBar/SidebarContainer";
import TimesheetMappingContainer from "rootpath/components/Timesheet/TimesheetManagerMapping/TimesheetMappingRoleContainer";

const TimesheetMapping = () => {
    return (
        <>
            <SidebarContainer />
            <TimesheetMappingContainer title="Assign Manager/Approver" />
        </>
    );
};
export default TimesheetMapping