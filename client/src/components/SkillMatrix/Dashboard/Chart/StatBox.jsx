import React from "react";
import { Box, Typography, useTheme } from "@mui/material";
import ProgressCircle from "rootpath/components/SkillMatrix/Dashboard/Chart/ProgressCircle";
import { tokens } from "rootpath/components/SkillMatrix/Dashboard/theme";

const StatBox = ({
    title,
    titleHighlight,
    subtitle,
    progress,
    increase,
    icon
}) => {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);

    return (
        <Box
            width="100%"
            m="0 30px"
            p="12px 0"
            display="flex"
            justifyContent="space-between"
        >
            <Box display="flex" flexDirection="column">
                <Typography
                    variant="h4"
                    fontSize="18px"
                    fontWeight="600"
                    mb="5px"
                    sx={{ color: colors.grey[100] }}
                >
                    {title}
                </Typography>
                <Typography
                    variant="h5"
                    fontSize="15px"
                    fontWeight="400"
                    sx={{ color: colors.grey[100] }}
                >
                    {subtitle}
                </Typography>
            </Box>
            <Box
                display="flex"
                justifyContent="space-between"
                alignItems="center"
            >
                <ProgressCircle
                    title={title}
                    titleHighlight={titleHighlight}
                    progress={progress}
                />

                <Typography
                    variant="h6"
                    fontStyle="italic"
                    sx={{ color: colors.greenAccent[600] }}
                >
                    {increase}
                </Typography>
            </Box>
        </Box>
    );
};

export default StatBox;
