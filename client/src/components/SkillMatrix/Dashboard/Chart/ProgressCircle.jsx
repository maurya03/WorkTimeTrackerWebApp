import React, { useState, useEffect } from "react";
import { Box, Typography } from "@mui/material";
import { useTheme } from "@mui/material";
import { tokens } from "rootpath/components/SkillMatrix/Dashboard/theme";
const ProgressCircle = ({
    title,
    titleHighlight,
    progress = "0.70",
    size = "50"
}) => {
    const theme = useTheme();
    const colors = tokens(theme.palette.mode);
    const angle = progress * 360;

    const [highlightColor, setHighlightColor] = useState(
        colors.greenAccent[500]
    );

    useEffect(() => {
        let color = colors.greenAccent[500];
        switch (title) {
            case "Good":
                color = colors.blueAccent[500];
                break;
            case "Average":
                color = "#e67c0d";
                break;
            case "Need Training":
                color = colors.redAccent[500];
                break;
            case "Not Available":
                color = colors.grey[500];
                break;
            default:
                color = colors.greenAccent[500];
                break;
        }
        setHighlightColor(color);
    }, []);
    return (
        <Box
            display="flex"
            alignItems="center"
            justifyContent="center"
            sx={{
                background: `radial-gradient(${colors.primary[400]} 55%, transparent 56%),
                conic-gradient(transparent 0deg ${angle}deg, #f1f1f1 ${angle}deg 360deg),
                ${highlightColor}`,
                borderRadius: "50%",
                width: `${size}px`,
                height: `${size}px`
            }}
        >
            <Typography
                variant="h3"
                fontSize="24px"
                fontWeight="bold"
                sx={{ color: highlightColor }}
            >
                {titleHighlight}
            </Typography>
        </Box>
    );
};

export default ProgressCircle;
