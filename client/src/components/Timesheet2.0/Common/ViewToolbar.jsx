import React from "react";
import Box from "@mui/material/Box";
import Toolbar from "@mui/material/Toolbar";
import Tooltip from "@mui/material/Tooltip";
import TimesheetCalender from "rootpath/components/Timesheet2.0/Calender/TimesheetCalender";
import EditIcon from "@material-ui/icons/Edit";
import Button from "@mui/material/Button";
const ViewToolbar = ({
    selectedWeek,
    handleEdit,
    disableDates,
    handleDayClick,
    enabledStartDate,
    enabledEndDate,
    handleSubmit,
    toolbarOptions,
    toggleCalenderDisplay,
    setToggleCalenderDisplay,
    modifiers
}) => {
    const startDate = selectedWeek.from;
    const endDate = selectedWeek.to;
    return (
        <Toolbar
            style={{
                display: "flex",
                alignItems: "center",
                justifyContent: "space-between",
                padding: 0
            }}
        >
            <Box display="flex" alignItems="center">
                <TimesheetCalender
                    dayStart={startDate}
                    dayEnd={endDate}
                    enabledStartDate={enabledStartDate}
                    enabledEndDate={enabledEndDate}
                    disableDates={disableDates}
                    handleDayClick={handleDayClick}
                    toggleCalenderDisplay={toggleCalenderDisplay}
                    setToggleCalenderDisplay={setToggleCalenderDisplay}
                    modifiers={modifiers}
                />
                <label
                    style={{
                        fontWeight: "bold",
                        marginLeft: "10px",
                        marginRight: "5px"
                    }}
                >
                    Start Date :
                </label>

                <label
                    style={{
                        marginRight: "20px"
                    }}
                >
                    {startDate &&
                        new Date(startDate).toLocaleDateString("en-gb", {
                            day: "2-digit",
                            month: "short",
                            year: "numeric"
                        })}
                </label>
                <label
                    style={{
                        fontWeight: "bold",
                        marginLeft: "10px",
                        marginRight: "5px"
                    }}
                >
                    End Date :
                </label>
                <label>
                    {endDate &&
                        new Date(endDate).toLocaleDateString("en-gb", {
                            day: "2-digit",
                            month: "short",
                            year: "numeric"
                        })}
                </label>
            </Box>

            {toolbarOptions && (
                <Box
                    display="flex"
                    alignItems="center"
                    justifyContent="space-between"
                >
                    <Tooltip title="Edit">
                        <Box mr={2}>
                            <EditIcon onClick={handleEdit} />
                        </Box>
                    </Tooltip>
                    <Tooltip>
                        <Button
                            style={{
                                color: "white",
                                backgroundColor: "#17072B"
                            }}
                            onClick={handleSubmit}
                        >
                            Submit
                        </Button>
                    </Tooltip>
                </Box>
            )}
        </Toolbar>
    );
};
export default ViewToolbar;
