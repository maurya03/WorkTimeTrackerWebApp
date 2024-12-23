import React from "react";
import Box from "@mui/material/Box";
import Inputlabel from "@mui/material/InputLabel";
import { MTableToolbar } from "@material-table/core";
import TimesheetCalender from "rootpath/components/Timesheet2.0/Calender/TimesheetCalender";
const ViewToolbar = ({
    selectedWeek,
    toolbarProps,
    disableDates,
    handleDayClick,
    enabledStartDate,
    enabledEndDate
}) => {
    const startDate = selectedWeek.split(" ")[0];
    const endDate = selectedWeek.split(" ")[1];
    return (
        <Box display="flex" alignItems="center" justifyContent="space-between">
            {selectedWeek.length > 0 && (
                <Box display="flex" alignItems="center">
                    <TimesheetCalender
                        dayStart={startDate}
                        dayEnd={endDate}
                        enabledStartDate={enabledStartDate}
                        enabledEndDate={enabledEndDate}
                        disableDates={disableDates}
                        handleDayClick={handleDayClick}
                    />
                    <Inputlabel
                        style={{
                            marginRight: "20px",
                            color: "black"
                        }}
                    >
                        Start Date:
                        {startDate &&
                            new Date(startDate).toLocaleDateString("en-gb", {
                                day: "2-digit",
                                month: "short",
                                year: "numeric"
                            })}
                    </Inputlabel>
                    <Inputlabel
                        style={{
                            color: "black"
                        }}
                    >
                        End Date:
                        {endDate &&
                            new Date(endDate).toLocaleDateString("en-gb", {
                                day: "2-digit",
                                month: "short",
                                year: "numeric"
                            })}
                    </Inputlabel>
                </Box>
            )}

            <MTableToolbar {...toolbarProps} />
        </Box>
    );
};
export default ViewToolbar;
