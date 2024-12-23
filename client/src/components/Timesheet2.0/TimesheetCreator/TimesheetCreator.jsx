import React, { useEffect, useState } from "react";
import ViewTimesheetContainer from "rootpath/components/Timesheet2.0/ViewTimesheetComponent/ViewTimesheetContainer";
import CreateTimesheetV2 from "rootpath/components/Timesheet2.0/CreateTimesheetV2Component/CreateTimesheetV2Container";
import { enabledDates } from "rootpath/services/Timesheet2.0/TimesheetService";
import EditTimesheetContainer from "rootpath/components/Timesheet2.0/EditTimesheetV2Component/EditTimesheetContainer";

import { endOfWeek, startOfWeek } from "date-fns";
import { formatDate } from "rootpath/services/TimeSheet/TimesheetDataService";

const TimesheetCreator = ({
    timesheetDetails,
    getTimesheet,
    toolbarOptions,
    selectedDates,
    fetchEmployeeProject,
    fetchTimesheetCategory,
    fetchTimesheetSubCategory,
    employeeProject,
    timesheetCategories,
    timesheetSubCategories
}) => {
    const currDate = new Date();
    const [toggleCalenderDisplay, setToggleCalenderDisplay] = useState(false);
    const [selectedWeek, setSelectedWeek] = useState({
        from: startOfWeek(currDate),
        to: endOfWeek(currDate)
    });
    const [enabledStartDate, setEnabledStartDate] = useState("");
    const [enabledEndDate, setEnabledEndDate] = useState("");
    const [isEditMode, setIsEditMode] = useState(false);

    const modifiers = {
        currentWeek: selectedWeek
    };

    useEffect(() => {
        fetchEmployeeProject();
        fetchTimesheetCategory();
        fetchTimesheetSubCategory();
        getTimesheet();
        const { dayStart, dayEnd } = enabledDates();
        setEnabledStartDate(dayStart);
        setEnabledEndDate(dayEnd);
    }, [
        fetchEmployeeProject,
        fetchTimesheetCategory,
        fetchTimesheetSubCategory,
        getTimesheet
    ]);

    useEffect(() => {
        if (selectedDates.startDate && selectedDates.endDate) {
            const startDate = selectedDates.startDate;
            new Date(startDate + "T00:00:00").toLocaleDateString() !==
                selectedWeek.from.toLocaleDateString() &&
                setSelectedWeek({
                    from: startOfWeek(new Date(startDate)),
                    to: endOfWeek(new Date(startDate))
                });
        }
    }, [selectedDates]);

    const disableDates = date => {
        const isSubmitted = false; //condition if the current dates have submitted timesheet.
        const weekStart = new Date(selectedDates.startDate);
        const weekEnd = new Date(selectedDates.endDate);
        const { dayStart, dayEnd } = enabledDates();
        if (date <= dayStart || date > dayEnd) {
            return true;
        }
    };

    const handleDayClick = (day, modifiers) => {
        setToggleCalenderDisplay(false);
        if (modifiers.selected) {
            return;
        }
        const startDate = startOfWeek(new Date(day));
        const endDate = endOfWeek(new Date(day));
        setSelectedWeek({
            from: startDate,
            to: endDate
        });

        const dates = {
            startDate: formatDate(startDate),
            endDate: formatDate(endDate)
        };
        getTimesheet(dates);
        setIsEditMode(false);
    };

    const handleEdit = () => {
        setIsEditMode(true);
    };

    const handleCancelClick = () => {
        setIsEditMode(false);
    };

    return (
        <>
            {timesheetDetails && timesheetDetails.length > 0 && !isEditMode && (
                <ViewTimesheetContainer
                    timesheetDetails={timesheetDetails}
                    toolbarOptions={toolbarOptions}
                    selectedWeek={selectedWeek}
                    enabledStartDate={enabledStartDate}
                    enabledEndDate={enabledEndDate}
                    disableDates={disableDates}
                    handleDayClick={handleDayClick}
                    setToggleCalenderDisplay={setToggleCalenderDisplay}
                    toggleCalenderDisplay={toggleCalenderDisplay}
                    handleEdit={handleEdit}
                    modifiers={modifiers}
                />
            )}
            {timesheetDetails && timesheetDetails.length > 0 && isEditMode && (
                <EditTimesheetContainer
                    timesheetDetails={timesheetDetails}
                    selectedWeek={selectedWeek}
                    handleCancelClick={handleCancelClick}
                    setToggleCalenderDisplay={setToggleCalenderDisplay}
                    toggleCalenderDisplay={toggleCalenderDisplay}
                    employeeProject={employeeProject}
                    timesheetCategories={timesheetCategories}
                    timesheetSubCategories={timesheetSubCategories}
                    isEditMode={isEditMode}
                />
            )}
            {timesheetDetails && timesheetDetails.length === 0 && (
                <CreateTimesheetV2
                    selectedWeek={selectedWeek}
                    enabledStartDate={enabledStartDate}
                    enabledEndDate={enabledEndDate}
                    disableDates={disableDates}
                    handleDayClick={handleDayClick}
                    employeeProject={employeeProject}
                    timesheetCategories={timesheetCategories}
                    timesheetSubCategories={timesheetSubCategories}
                    setToggleCalenderDisplay={setToggleCalenderDisplay}
                    toggleCalenderDisplay={toggleCalenderDisplay}
                    isEditMode={isEditMode}
                    handleCancelClick={handleCancelClick}
                    modifiers={modifiers}
                />
            )}
        </>
    );
};
export default TimesheetCreator;
