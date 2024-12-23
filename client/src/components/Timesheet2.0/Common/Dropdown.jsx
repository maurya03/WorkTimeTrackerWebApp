import React from "react";
import { MenuItem, Select } from "@mui/material";

const Dropdown = ({
    onDropdownChange,
    bindingData,
    keyName,
    value,
    defaultValue,
    title,
    cssClass,
    isDisabled
}) => {
    return (
        <Select
            className={cssClass}
            title={title}
            disabled={isDisabled}
            value={defaultValue}
            onChange={onDropdownChange}
        >
            {bindingData.length > 0 &&
                bindingData.map(item => (
                    <MenuItem value={item[keyName]}>{item[value]}</MenuItem>
                ))}
        </Select>
    );
};
export default Dropdown;
