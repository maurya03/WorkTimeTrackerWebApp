import React, { useEffect, useState } from "react";
import Box from "@mui/material/Box";
import { CalendarTodayOutlined } from "@material-ui/icons";
import { DayPicker } from "react-day-picker";
import Button from "@mui/material/Button";
import {
    modifiersStyles,
    styles
} from "rootpath/services/EmployeeBook/AnalyticService/AnalyticData";
import moment from "moment";

export const DateFilter = ({ onSubmit }) => {
    const getCurrentDate = () => moment().format("YYYY-MM-DD");
    const getOneMonthBackDate = () =>
        moment().subtract(1, "months").format("YYYY-MM-DD");
    const [toggleEndCalenderDisplay, setToggleEndCalenderDisplay] =
        useState(false);

    const [toggleStartCalenderDisplay, setToggleStartCalenderDisplay] =
        useState(false);

    const [startDate, setStartDate] = useState(getOneMonthBackDate());
    const [endDate, setEndDate] = useState(getCurrentDate());

    const onHandleDayClick = (day, isStartDate) => {
        const currentDate = new Date(day);

        const date = `${currentDate.getFullYear()}-${
            currentDate.getMonth() + 1
        }-${currentDate.getDate()}`;

        if (isStartDate) {
            setStartDate(date);
        } else {
            setEndDate(date);
        }
        setToggleEndCalenderDisplay(false);
        setToggleStartCalenderDisplay(false);
    };

    return (
        <Box marginLeft="20px" width="90%">
            <Box
                component="div"
                display="inline-flex"
                paddingBottom="20px"
                p="1"
                m="1"
            >
                <CalendarTodayOutlined
                    onClick={() => {
                        setToggleStartCalenderDisplay(
                            !toggleStartCalenderDisplay
                        );
                    }}
                ></CalendarTodayOutlined>
                Start Date : {startDate}
                {toggleStartCalenderDisplay && (
                    <Box
                        style={{
                            color: "#040a1e",
                            width: "300px",
                            height: "300px",
                            backgroundColor: "#FFFFFF",
                            border: "1px solid #110f0f",
                            borderRadius: "5px",
                            padding: "5px",
                            zIndex: 3,
                            position: "absolute",
                            alignItems: "center",
                            marginTop: "24px"
                        }}
                    >
                        <DayPicker
                            modifiersStyles={modifiersStyles}
                            styles={styles}
                            onDayClick={day => onHandleDayClick(day, true)}
                        />
                    </Box>
                )}
            </Box>
            <Box
                component="div"
                display="inline-flex"
                p="1"
                m="1"
                marginLeft="30px"
            >
                <CalendarTodayOutlined
                    onClick={() => {
                        setToggleEndCalenderDisplay(!toggleEndCalenderDisplay);
                    }}
                ></CalendarTodayOutlined>
                End Date : {endDate}
                {toggleEndCalenderDisplay && (
                    <Box
                        style={{
                            color: "#040a1e",
                            width: "300px",
                            height: "300px",
                            backgroundColor: "#FFFFFF",
                            border: "1px solid #110f0f",
                            borderRadius: "5px",
                            padding: "5px",
                            zIndex: 3,
                            position: "absolute",
                            alignItems: "center",
                            marginTop: "24px"
                        }}
                    >
                        <DayPicker
                            modifiersStyles={modifiersStyles}
                            styles={styles}
                            onDayClick={day => onHandleDayClick(day, false)}
                        />
                    </Box>
                )}
            </Box>

            <Box
                component="div"
                display="inline-flex"
                p="1"
                m="1"
                marginLeft="30px"
            >
                <Button
                    variant="contained"
                    onClick={() => onSubmit(startDate, endDate)}
                    marginBottom="10px"
                >
                    Filter
                </Button>
            </Box>
        </Box>
    );
};
