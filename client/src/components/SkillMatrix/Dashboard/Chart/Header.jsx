import React from "react";
import { Typography, useTheme } from "@mui/material";
import { tokens } from "rootpath/components/SkillMatrix/Dashboard/theme";

const Header = ({ title, subtitle }) => {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);

    return (
        <>
            <Typography
                variant="h5"
                color="#000"
                fontWeight="bold"
                fontSize="25px"
            >
                {title}
            </Typography>
            {subtitle && (
                <Typography variant="h5" color={colors.greenAccent[400]}>
                    {subtitle}
                </Typography>
            )}
        </>
    );
};

export default Header;
