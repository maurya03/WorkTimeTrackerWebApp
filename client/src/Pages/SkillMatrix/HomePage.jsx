import React from "react";
import SidebarContainer from "rootpath/components/SkillMatrix/Sidebar/SidebarContainer";
import ClientDashboardContainer from "rootpath/components/SkillMatrix/SkillMatrixDashboard/ClientDashboard/ClientDashboardContainer";

const HomePage = () => {
    return (
        <>
            <SidebarContainer />
            <ClientDashboardContainer title="Manage Client" />
        </>
    );
};

export default HomePage;
