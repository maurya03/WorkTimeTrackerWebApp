import React, { useState } from "react";
import { DayPicker } from "react-day-picker";
import {
    modifiersStyles,
    styles,
    useStyles
} from "rootpath/components/Timesheet2.0/Calender/CalenderUtility";
import { CalendarTodayOutlined } from "@material-ui/icons";
import { Tooltip } from "@mui/material";

const TimesheetCalender = ({
    dayStart,
    dayEnd,
    enabledStartDate,
    enabledEndDate,
    handleDayClick,
    disableDates,
    toggleCalenderDisplay,
    setToggleCalenderDisplay,
    modifiers
}) => {
    const classes = useStyles();

    return (
        <>
            <Tooltip title="Select Week">
                <CalendarTodayOutlined
                    onClick={() => {
                        setToggleCalenderDisplay(!toggleCalenderDisplay);
                    }}
                ></CalendarTodayOutlined>
            </Tooltip>
            {toggleCalenderDisplay && (
                <div className={classes.root}>
                    <DayPicker
                        disabled={disableDates} // this function needs to be declared in parent class
                        fromMonth={enabledStartDate}
                        toDate={enabledEndDate}
                        modifiers={modifiers}
                        modifiersStyles={modifiersStyles}
                        styles={styles}
                        onDayClick={handleDayClick} // this function needs to be declared in parent class
                    />
                </div>
            )}
        </>
    );
};

export default TimesheetCalender;
