import React from "react";
import SidebarContainer from "rootpath/components/HrManagement/SideBar/SidebarContainer";
import TimesheetMappingContainer from "rootpath/components/Timesheet/TimesheetManagerMapping/TimesheetMappingRoleContainer";

const HrMapping = () => {
    return (
        <>
            <SidebarContainer />
            <TimesheetMappingContainer title="Assign Manager/Approver" />
        </>
    );
};
export default HrMapping;
