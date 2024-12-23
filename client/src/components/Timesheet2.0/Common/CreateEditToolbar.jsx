import React from "react";
import Box from "@mui/material/Box";
import Toolbar from "@mui/material/Toolbar";
import Tooltip from "@mui/material/Tooltip";
import TimesheetCalender from "rootpath/components/Timesheet2.0/Calender/TimesheetCalender";
import AddCircleIcon from "@material-ui/icons/AddCircle";
import SaveIcon from "@material-ui/icons/Save";
import CloseSharpIcon from "@material-ui/icons/CloseSharp";
const CreateEditToolbar = ({
    selectedWeek,
    handleAddRow,
    handleSave,
    handleCancel,
    showSaveCancel,
    disableDates,
    handleDayClick,
    enabledStartDate,
    enabledEndDate,
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
                {enabledStartDate && (
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
                )}
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
            <Box
                display="flex"
                alignItems="center"
                justifyContent="space-between"
            >
                <Tooltip title="Add row">
                    <AddCircleIcon
                        style={{
                            marginRight: "10px"
                        }}
                        onClick={handleAddRow}
                    />
                </Tooltip>

                {showSaveCancel && (
                    <>
                        <Tooltip title="Save all">
                            <SaveIcon
                                style={{
                                    marginRight: "10px",
                                    color: "#4caf50"
                                }}
                                onClick={handleSave}
                            />
                        </Tooltip>
                        <Tooltip title="Cancel">
                            <CloseSharpIcon
                                style={{ color: "#f44336" }}
                                onClick={handleCancel}
                            />
                        </Tooltip>
                    </>
                )}
            </Box>
        </Toolbar>
    );
};
export default CreateEditToolbar;
