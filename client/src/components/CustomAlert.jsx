import React, { useEffect } from "react";
import { Collapse, Alert } from "@mui/material";
const CustomAlert = ({ open, severity, message, onClose, className ,onScrollToTop }) => {
    useEffect(() => {
        if (open || onScrollToTop) {
            const timeOutSet = setTimeout(() => {
                handleClose();
            }, 4000);
        onScrollToTop;

            return () => clearTimeout(timeOutSet);
        }
    }, [open]);

    const handleClose = () => {
        onClose && onClose();
    };

    return (
        <Collapse in={open} sx={{ minHeight: "auto !important" }}>
            <Alert
                variant="filled"
                severity={severity}
                onClose={handleClose}
                className={className}
            >
                {message}
            </Alert>
        </Collapse>
    );
};

export default CustomAlert;
