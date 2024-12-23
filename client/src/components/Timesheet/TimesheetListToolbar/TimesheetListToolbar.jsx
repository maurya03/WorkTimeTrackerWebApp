import React, { useEffect, useState } from "react";
import { DayPicker } from "react-day-picker";
import styles from "rootpath/components/Timesheet/TimesheetListToolbar/TimesheetListToolbar.css";
import SearchIcon from "@material-ui/icons/Search";
import Switch from "@mui/material/Switch";
import Stack from "@mui/material/Stack";
import {
    employee,
    rejected,
    pending,
    approved
} from "rootpath/components/Timesheet/Constants";
import { TextField } from "@mui/material";
import { CalendarTodayOutlined } from "@material-ui/icons";
import { endOfWeek, startOfWeek } from "date-fns";

const TimesheetListToolbar = ({
    userRole,
    status,
    approverPending,
    startDate,
    endDate,
    setDate,
    handleSearchChange,
    showSelfRecordsOnly,
    toggleSelfAndAdminRecords
}) => {
    const modifiers = {
        currentWeek: {
            from: startDate,
            to: endDate
        }
    };
    const modifiersStyles = {
        currentWeek: {
            color: "#FFFFFF",
            backgroundColor: "#008000"
        },
        disabled: {
            color: "#808080"
        }
    };
    const customStyles = {
        caption: { color: "#008000", fontWeight: "bold" },
        head_cell: { color: "#008000" },
        navigator: { color: "#008000" },
        day: {
            color: "#000000",
            border: "none",
            background: "none"
        }
    };

    const [toggleCalenderDisplay, setToggleCalenderDisplay] = useState(false);
    const [isDisabled, setIsDisabled] = useState(true);
    const [selectDay, setSelectDay] = useState(null);
    const handleDayClick = day => {
        setDate(selectDay, day);
        setToggleCalenderDisplay(false);
    };

    const disablePastDates = date => {
        const specificDate = new Date(startDate);
        const nextWeekDate = new Date();
        nextWeekDate.setDate(nextWeekDate.getDate() + 7);
        const endDate = endOfWeek(nextWeekDate);
        return date < specificDate || date > endDate;
    };
    const disableFutureDates = date => {
        const nextWeekDate = new Date();
        nextWeekDate.setDate(nextWeekDate.getDate() + 7);
        const endDate = endOfWeek(nextWeekDate);
        return date > endDate;
    };

    return (
        <div>
            {userRole && userRole.roleName !== employee && !approverPending && (
                <div className={styles.toolbarComponents}>
                    {userRole && userRole.roleName !== employee && (
                        <Stack alignItems="center" direction="row" spacing={2}>
                            {(userRole.roleName === "Admin" ||
                                ((userRole.roleName === "Reporting_Manager" ||
                                    userRole.roleName === "Approver" ||
                                    userRole.roleName === "HR") &&
                                    status !== pending)) && (
                                <Stack alignItems="center" direction="row">
                                    <Switch
                                        checked={showSelfRecordsOnly}
                                        onChange={toggleSelfAndAdminRecords}
                                    />
                                    <label>Show Self Timesheet</label>
                                </Stack>
                            )}
                            {!showSelfRecordsOnly && (
                                <Stack
                                    direction="row"
                                    sx={{ position: "relative", zIndex: "999" }}
                                >
                                    <div className={styles.tooltip}>
                                        <CalendarTodayOutlined
                                            onClick={() => {
                                                setSelectDay(0);
                                                setIsDisabled(false);
                                                setToggleCalenderDisplay(
                                                    !toggleCalenderDisplay
                                                );
                                            }}
                                        ></CalendarTodayOutlined>
                                        <span className={styles.tooltiptext}>
                                            Select Week
                                        </span>
                                    </div>

                                    <label
                                        className={styles.dayPickerLabel}
                                        style={{ fontWeight: "bold" }}
                                    >
                                        Start Date :
                                    </label>
                                    <label>
                                        {startDate &&
                                            new Date(
                                                startDate
                                            ).toLocaleDateString("en-gb", {
                                                day: "2-digit",
                                                month: "short",
                                                year: "numeric"
                                            })}
                                    </label>
                                    <div className={styles.tooltip}>
                                        <CalendarTodayOutlined
                                            onClick={() => {
                                                setSelectDay(1);
                                                setIsDisabled(true);
                                                setToggleCalenderDisplay(
                                                    !toggleCalenderDisplay
                                                );
                                            }}
                                        ></CalendarTodayOutlined>
                                        <span className={styles.tooltiptext}>
                                            Select Week End
                                        </span>
                                    </div>
                                    <label
                                        className={styles.dayPickerLabel}
                                        style={{ fontWeight: "bold" }}
                                    >
                                        End Date :
                                    </label>
                                    <label>
                                        {endDate &&
                                            new Date(
                                                endDate
                                            ).toLocaleDateString("en-gb", {
                                                day: "2-digit",
                                                month: "short",
                                                year: "numeric"
                                            })}
                                    </label>
                                    {toggleCalenderDisplay && (
                                        <div className={styles.dayPicker}>
                                            <DayPicker
                                                disabled={
                                                    isDisabled
                                                        ? disablePastDates
                                                        : disableFutureDates
                                                }
                                                modifiers={modifiers}
                                                modifiersStyles={
                                                    modifiersStyles
                                                }
                                                styles={customStyles}
                                                onDayClick={handleDayClick}
                                            />
                                        </div>
                                    )}
                                </Stack>
                            )}
                        </Stack>
                    )}
                    {userRole.roleName !== employee &&
                        (status === rejected ||
                            status === approved ||
                            (status === pending && !approverPending)) && (
                            <TextField
                                placeholder="Search by name..."
                                size="small"
                                sx={{ width: "500px" }}
                                onChange={handleSearchChange}
                                InputProps={{
                                    startAdornment: (
                                        <SearchIcon
                                            style={{ marginRight: 8 }}
                                        />
                                    ),
                                    style: { paddingRight: 0 }
                                }}
                                fullWidth
                            />
                        )}
                </div>
            )}
        </div>
    );
};
export default React.memo(TimesheetListToolbar);
