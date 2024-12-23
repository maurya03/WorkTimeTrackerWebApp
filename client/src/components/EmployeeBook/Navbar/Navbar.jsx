import React, { useState, useEffect } from "react";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Avatar from "@mui/material/Avatar";
import useMediaQuery from "@mui/material/useMediaQuery";
import IconButton from "@mui/material/IconButton";
import ArrowBack from "@mui/icons-material/ArrowBack";
import { withRouter } from "react-router-dom";
import bhavnaLogo from "rootpath/assets/bhavna-logo.png";
import SocialMedia from "rootpath/components/EmployeeBook/Navbar/SocialMedia";
import { Tooltip } from "@mui/material";

const Navbar = ({ history, onRouteChange }) => {
    const [rightBoxWidth, setRightBoxWidth] = useState("65%");
    const isMobile = useMediaQuery("(max-width: 767px)");
    const isIPad = useMediaQuery("(min-width: 768px) and (max-width: 1024px)");

    const handleHomeClick = () => {
        history.push("/employeebook/");
        onRouteChange("/employeebook/");
    };

    const handleBackClick = () => {
        history.push("/timesheet");
        onRouteChange("/timesheet");
    };

    useEffect(() => {
        const width = isMobile ? "100%" : isIPad ? "85%" : "65%";
        setRightBoxWidth(width);
    }, [isMobile, isIPad]);

    return (
        <Box
            backgroundColor="rgba(21, 156, 73, 255)"
            height={isMobile ? "115px" : "75px"}
            position="sticky"
            zIndex="2"
            top="0"
        >
            <Box
                className="container"
                height={isMobile ? "115px" : "75px"}
                display="flex"
                alignItems="center"
                justifyContent={isMobile ? "center" : "space-between"}
            >
                <Tooltip title="Go To Timesheet">
                    <IconButton
                        onClick={handleBackClick}
                        sx={{ color: "#fff" }}
                    >
                        <ArrowBack />
                    </IconButton>
                </Tooltip>
                <Box
                    display="flex"
                    flexDirection="column"
                    alignItems="center"
                    justifyContent="center"
                    width={70}
                    height={70}
                    borderRadius="50%"
                    backgroundColor="#fff"
                    sx={{ cursor: "pointer" }}
                    onClick={handleHomeClick}
                >
                    <Avatar
                        sx={{ width: 60, height: 53, marginTop: "-2px" }}
                        src={bhavnaLogo}
                    />
                </Box>
                <Box
                    display="flex"
                    flexDirection={isMobile ? "column" : "row"}
                    justifyContent="space-between"
                    alignItems="center"
                    width={rightBoxWidth}
                >
                    <Box
                        display="flex"
                        flexDirection="column"
                        alignItems="center"
                        justifyContent="center"
                    >
                        <Typography
                            variant="h5"
                            fontSize={isMobile ? "16px" : "20px"}
                            color="#fff"
                            textTransform="uppercase"
                        >
                            Welcome to the Employee Book
                        </Typography>
                        <Typography
                            variant="h6"
                            fontSize={isMobile ? "14px" : "15px"}
                            color="#fff"
                            textTransform="uppercase"
                        >
                            YOUR COLLEAGUE CHRONICLES
                        </Typography>
                    </Box>
                    <SocialMedia isMobile={isMobile} history={history} />
                </Box>
            </Box>
        </Box>
    );
};

export default withRouter(Navbar);
