import React from "react";
import SidebarContainer from "rootpath/components/SkillMatrix/Sidebar/SidebarContainer";
import RoleListContainer from "../../components/RoleComponent/RoleListContainer";

const RoleManagementPage = () => {
    return (
        <>
            <SidebarContainer />
            <RoleListContainer title={"Manage Role"} />
        </>
    );
};

export default RoleManagementPage;
