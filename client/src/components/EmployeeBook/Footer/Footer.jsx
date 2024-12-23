import React from "react";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Link from "@mui/material/Link";

const Footer = () => {
    return (
        <Box
            position="fixed"
            bottom="0"
            width="100%"
            textAlign="right"
            p="10px"
            sx={{ backgroundColor: "lightgray" }}
        >
            <Typography fontSize="12px">
                © 2013-2024 Bhavna Corp. All rights reserved.
            </Typography>
        </Box>
    );
};
export default Footer;
