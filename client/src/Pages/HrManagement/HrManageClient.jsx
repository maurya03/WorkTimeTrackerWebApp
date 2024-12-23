import React from "react";
import SidebarContainer from "rootpath/components/HrManagement/SideBar/SidebarContainer";
import ClientDashboardContainer from "rootpath/components/SkillMatrix/SkillMatrixDashboard/ClientDashboard/ClientDashboardContainer";

const HrManageClient = () => {
    return (
        <>
            <SidebarContainer />
            <ClientDashboardContainer title="Manage Client" />
        </>
    );
};

export default HrManageClient;
