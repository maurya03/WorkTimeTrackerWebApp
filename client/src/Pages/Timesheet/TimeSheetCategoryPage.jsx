import React from 'react'
import TimesheetCategoryContainer from 'rootpath/components/Timesheet/CategoryDashBoard/TimesheetCategoryContainer';
import SidebarContainer from "rootpath/components/Timesheet/SideBar/SidebarContainer";
const TimeSheetCategoryPage = () => {
  return (
    <>
    <SidebarContainer />
    <TimesheetCategoryContainer title="CategoryDashboard"/>
    </>
  )
}

export default TimeSheetCategoryPage;