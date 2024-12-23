import Select from "@mui/material/Select";
import MenuItem from "@mui/material/MenuItem";
import React from "react";
//created because previous was created using @mui/material Select which was creating conflict in the design on using @mui/material and @material-ui/core components.
const Dropdown2 = ({
    onDropdownChange,
    bindingData,
    keyName,
    value,
    defaultValue,
    cssClass
}) => {
    return (
        <Select
            className={cssClass}
            value={defaultValue}
            onChange={onDropdownChange}
        >
            {bindingData.length > 0 &&
                bindingData.map(item => (
                    <MenuItem key={item[keyName]} value={item[keyName]}>
                        {item[value]}
                    </MenuItem>
                ))}
        </Select>
    );
};
export default Dropdown2;
