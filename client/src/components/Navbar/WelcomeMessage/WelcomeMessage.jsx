import React from "react";
import Typography from "@mui/material/Typography";
import Avatar from "@mui/material/Avatar";
import Stack from "@mui/material/Stack";
import defaultPic from "rootpath/assets/default_pic.png";

const WelcomeMessage = ({ userRole }) => {
    return (
        <Stack spacing={1} direction="row" alignItems="center">
            <Typography variant="h5" fontSize="14px" noWrap>
                Welcome, {userRole.employeeName}
                {userRole.roleName !== "Employee" && ` (${userRole.roleName})`}
            </Typography>
            <Avatar src={defaultPic} />
        </Stack>
    );
};
export default WelcomeMessage;
