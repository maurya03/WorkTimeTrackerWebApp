import React from "react";
import SidebarContainer from "rootpath/components/SkillMatrix/Sidebar/SidebarContainer";
import ScoreMappingContainer from "rootpath/components/SkillMatrix/ScoreMappingComponent/ScoreMappingContainer";

const ScoreMappingPage = props => {
    return (
        <>
            <SidebarContainer />
            <ScoreMappingContainer {...props} />
        </>
    );
};

export default ScoreMappingPage;
