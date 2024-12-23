import React from "react";
import Stack from "@mui/material/Stack";
import FormControl from "@mui/material/FormControl";
import Select from "@mui/material/Select";
import MenuItem from "@mui/material/MenuItem";
import { Years, Months } from "../Reports/Constants";

const YearMonthFilter = ({ selectedYearAndMonth, onYearOrMonthChange }) => {
    const handleYearOrMonthChange = event => {
        const { name, value } = event.target;
        onYearOrMonthChange({ ...selectedYearAndMonth, [name]: value });
    };

    return (
        <Stack direction="row" justifyContent="flex-end" alignItems="center">
            <FormControl sx={{ m: 1, minWidth: 160 }} size="small">
                <Select
                    name="year"
                    value={selectedYearAndMonth.year}
                    displayEmpty
                    onChange={handleYearOrMonthChange}
                >
                    {Years.map(item => (
                        <MenuItem key={item} value={item}>
                            {item}
                        </MenuItem>
                    ))}
                </Select>
            </FormControl>
            <FormControl sx={{ m: 1, minWidth: 160 }} size="small">
                <Select
                    name="month"
                    value={selectedYearAndMonth.month}
                    displayEmpty
                    onChange={handleYearOrMonthChange}
                >
                    {Object.keys(Months).map(key => (
                        <MenuItem key={Months[key]} value={Months[key]}>
                            {key}
                        </MenuItem>
                    ))}
                </Select>
            </FormControl>
        </Stack>
    );
};

export default YearMonthFilter;
