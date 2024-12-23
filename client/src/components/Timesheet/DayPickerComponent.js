import React from "react";
import { DayPicker } from "react-day-picker";
export const DayPickerComponent = (
    isDisabled,
    setDates,
    weekNumberClick,
    isWeekNumberEnabled
) => {
    return (
        <DayPicker
            showWeekNumber
            disabled={isDisabled}
            onDayClick={setDates}
            onWeekNumberClick={weekNumberClick}
        />
    );
};
