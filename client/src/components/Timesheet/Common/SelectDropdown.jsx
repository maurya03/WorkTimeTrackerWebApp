import React from "react";
import Select from "@mui/material/Select";
import MenuItem from "@mui/material/MenuItem";
const SelectDropdown = ({
    onChangeFunction,
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
            onChange={onChangeFunction}
        >
            {bindingData.length > 0 &&
                bindingData.map(item => (
                    <MenuItem value={item[keyName]}>{item[value]}</MenuItem>
                ))}
        </Select>
    );
};
export default SelectDropdown;
