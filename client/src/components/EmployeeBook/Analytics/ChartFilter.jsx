import React, { useState } from "react";
import Box from "@mui/material/Box";
import { CalendarTodayOutlined } from "@material-ui/icons";
import { DayPicker } from "react-day-picker";
import Button from "@mui/material/Button";
import Select from "@mui/material/Select";
import MenuItem from "@mui/material/MenuItem";
import moment from "moment";
import {
    modifiersStyles,
    styles,
    filterOptions
} from "rootpath/services/EmployeeBook/AnalyticService/AnalyticData";

export const ChartFilter = ({ onHandleChartFilterChange }) => {
    const [filter, setFilter] = useState(filterOptions[2].value);
    const getCurrentDate = () => moment().format("YYYY-MM-DD");
    const getOneMonthBackDate = () =>
        moment().subtract(1, "months").format("YYYY-MM-DD");
    const [toggleEndCalenderDisplay, setToggleEndCalenderDisplay] =
        useState(false);

    const [toggleStartCalenderDisplay, setToggleStartCalenderDisplay] =
        useState(false);

    const [chartStartDate, setChartStartDate] = useState(getOneMonthBackDate());
    const [chartEndDate, setChartEndDate] = useState(getCurrentDate());

    const onHandleFilterChange = e => {
        setFilter(e.target.value);
    };

    const onHandleDayClick = (day, isStartDate) => {
        const currentDate = new Date(day);

        const date = `${currentDate.getFullYear()}-${
            currentDate.getMonth() + 1
        }-${currentDate.getDate()}`;

        if (isStartDate) {
            setChartStartDate(date);
        } else {
            setChartEndDate(date);
        }
        setToggleEndCalenderDisplay(false);
        setToggleStartCalenderDisplay(false);
    };

    return (
        <Box width="90%">
            <Box
                component="div"
                display="inline-flex"
                p="1"
                m="1"
                marginLeft="20px"
            >
                <CalendarTodayOutlined
                    onClick={() => {
                        setToggleStartCalenderDisplay(
                            !toggleStartCalenderDisplay
                        );
                    }}
                ></CalendarTodayOutlined>
                Start Date : {chartStartDate}
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
                End Date : {chartEndDate}
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
                <Select
                    labelId="Select-Filter-Option"
                    id="filterId"
                    name="filter"
                    value={filter}
                    width="50%"
                    onChange={e => onHandleFilterChange(e)}
                >
                    {filterOptions &&
                        filterOptions.length > 0 &&
                        filterOptions.map(data => (
                            <MenuItem key={data.label} value={data.value}>
                                {data.value}
                            </MenuItem>
                        ))}
                </Select>
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
                    onClick={() =>
                        onHandleChartFilterChange(
                            filter,
                            chartStartDate,
                            chartEndDate
                        )
                    }
                    marginBottom="10px"
                >
                    Filter
                </Button>
            </Box>
        </Box>
    );
};
