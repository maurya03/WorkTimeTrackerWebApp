import React from "react";
import { MTableToolbar } from "@material-table/core";
import css from "./TimesheetDetails.css";
import cx from "classnames";
import { CalendarTodayOutlined } from "@material-ui/icons";
import { DayPicker } from "react-day-picker";
import {
    formatDate,
    convertToYYYYMMDD,
    columnSummation
} from "rootpath/services/TimeSheet/TimesheetDataService";
const TableToolbar = ({
    timesheetEmployees,
    isBehalf,
    selectedEmployee,
    selectedClient,
    handleChange,
    isDetailPanel,
    setToggleCalenderDisplay,
    weekSelected,
    toggleCalenderDisplay,
    setWeekSelected,
    selectedTimesheetStatus,
    fetchtimesheetDetailByDate,
    dayStart,
    dayEnd,
    setData,
    setHourValue,
    setSummationData,
    setCanEdit,
    showAlert,
    fetchTimesheetDetailCreatedOnBehalf,
    setIsTimesheetWithPartialSubmission,
    setIsProjectSelectionDisabled,
    setShowActionColumn,
    setIsSubmitted,
    dataCopy,
    props,
    setMessageForApprovedOrSubmitted
}) => {
    const modifiers = {
        currentWeek: date => {
            const selectedStartDate = weekSelected
                ? new Date(weekSelected.split(" ")[0])
                : null;
            if (!selectedStartDate) return false;
            const startOfWeek = new Date(selectedStartDate);

            startOfWeek.setDate(startOfWeek.getDate() - startOfWeek.getDay());
            const endOfWeek = new Date(startOfWeek);
            endOfWeek.setDate(endOfWeek.getDate() + 6);
            startOfWeek.setHours(0, 0, 0, 0);
            return date >= startOfWeek && date <= endOfWeek;
        }
    };
    const modifiersStyles = {
        currentWeek: {
            color: "white",
            backgroundColor: "red"
        },
        disabled: {
            color: "grey"
        }
    };
    const styles = {
        caption: { color: "red", fontWeight: "bold" },
        head_cell: { color: "red" },
        day: {
            color: "black",
            border: "none",
            background: "none"
        }
    };
    const disableDates = date => {
        if (date <= dayStart || date > dayEnd) {
            return true;
        }
    };
    const handleDayClick = day => {
        setIsSubmitted(false);
        setData([]);
        setHourValue({});
        dataCopy.current = [];
        setShowActionColumn(true);

        const gridTotal = columnSummation([]);
        setSummationData([gridTotal.columnSum]);
        var curr = new Date(day);
        var currCopy = new Date(day);
        var first = curr.getDate() - curr.getDay();
        var last = first + 6;
        var firstday = formatDate(new Date(curr.setDate(first)));
        if (
            day
                ? day.toString().substring(3, 7) !==
                  curr.toString().substring(3, 7)
                : ""
        ) {
            curr = currCopy;
        }
        var lastday = formatDate(new Date(curr.setDate(last)));
        const selectedDates = {
            startDate: convertToYYYYMMDD(firstday),
            endDate: convertToYYYYMMDD(lastday)
        };
        const params = {
            startDate: selectedDates.startDate,
            endDate: selectedDates.endDate,
            isBehalf: true,
            empId: selectedEmployee,
            clientId: selectedClient
        };
        selectedEmployee && isBehalf
            ? fetchTimesheetDetailCreatedOnBehalf(
                  params,
                  showAlert,
                  setCanEdit,
                  setData,
                  setIsTimesheetWithPartialSubmission,
                  setIsProjectSelectionDisabled,
                  dataCopy,
                  setMessageForApprovedOrSubmitted,
                  setIsSubmitted
              )
            : fetchtimesheetDetailByDate(
                  selectedDates,
                  setIsTimesheetWithPartialSubmission,
                  setIsProjectSelectionDisabled
              );

        setWeekSelected(
            convertToYYYYMMDD(firstday) + " " + convertToYYYYMMDD(lastday)
        );
        setToggleCalenderDisplay(false);
    };
    return (
        <div className={css.toolbar}>
            <div
                className={cx({
                    [css.toolbarRight]: isDetailPanel
                })}
            >
                <div style={{ marginLeft: 50 }}>
                    <div className={css.tooltip}>
                        <CalendarTodayOutlined
                            onClick={() => {
                                setToggleCalenderDisplay(
                                    !toggleCalenderDisplay
                                );
                            }}
                        ></CalendarTodayOutlined>
                        <span className={css.tooltiptext}>Select Week</span>
                    </div>

                    <label
                        className={css.dayPickerLabel}
                        style={{
                            fontWeight: "bold"
                        }}
                    >
                        Start Date :{" "}
                    </label>
                    <label>
                        {weekSelected &&
                            new Date(
                                weekSelected.split(" ")[0]
                            ).toLocaleDateString("en-gb", {
                                day: "2-digit",
                                month: "short",
                                year: "numeric"
                            })}
                    </label>
                    <label
                        className={css.dayPickerLabel}
                        style={{
                            fontWeight: "bold"
                        }}
                    >
                        End Date :{" "}
                    </label>
                    <label>
                        {weekSelected &&
                            new Date(
                                weekSelected.split(" ")[1]
                            ).toLocaleDateString("en-gb", {
                                day: "2-digit",
                                month: "short",
                                year: "numeric"
                            })}
                    </label>
                </div>

                {toggleCalenderDisplay && (
                    <div className={css.dayPicker}>
                        <DayPicker
                            disabled={disableDates}
                            fromMonth={dayStart}
                            toDate={dayEnd}
                            modifiers={modifiers}
                            modifiersStyles={modifiersStyles}
                            styles={styles}
                            onDayClick={handleDayClick}
                        />
                    </div>
                )}
            </div>
            <MTableToolbar {...props} />
        </div>
    );
};
export default TableToolbar;
