import React from "react";
import Box from "@mui/material/Box";

const NoAccess = () => {
    return (
        <Box
            display="flex"
            justifyContent="center"
            alignItems="center"
            minHeight="10vh"
        >
            <h2>You are not access to authorized to access the application</h2>
        </Box>
    );
};
export default NoAccess;
