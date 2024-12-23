import React, { useEffect, useState } from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import EmployeeImageSlider from "rootpath/components/EmployeeBook/EmployeeList/EmployeeImageSlider";
import EmployeesContainer from "rootpath/components/EmployeeBook/Employees/EmployeesContainer";
import ReactGA from "react-ga4";
import useMediaQuery from "@mui/material/useMediaQuery";
import { withRouter } from "react-router-dom";

const EmployeeList = ({
    isAdmin,
    isHR,
    fetchRole,
    setLoader,
    clearEmployeeSearchParam,
    history
}) => {
    const [isAdminNavVisible, setIsAdminNavVisible] = useState(false);
    const [isHRNavVisible, setIsHRNavVisible] = useState(false);
    const isMobile = useMediaQuery("(max-width:767px)");
    const [isListView, setListView] = useState(true);

    useEffect(() => {
        ReactGA.send({
            hitType: "pageview",
            page: window.location.pathname,
            title: "EmployeeBook Home Page"
        });
    }, []);

    const changeView = toggleValue => {
        setListView(toggleValue);
    };

    useEffect(() => {
        fetchRole();
        setLoader(true);
    }, [fetchRole]);

    useEffect(() => {
        setIsAdminNavVisible(isAdmin);
        setIsHRNavVisible(isHR);
    }, [isAdmin, isHR]);

    const goToPage = pageId => {
        clearEmployeeSearchParam();
        history.push(pageId);
    };
    return (
        <Box mt="40px" mb="80px" className="container">
            <EmployeeImageSlider isListView={isListView} />
            {isAdminNavVisible && isListView && (
                <Box
                    display="flex"
                    alignItems="center"
                    mb="25px"
                    flexDirection={isMobile ? "column" : "row"}
                >
                    <Button
                        variant="contained"
                        sx={{
                            marginRight: !isMobile && "20px",
                            marginBottom: isMobile && "20px",
                            width: isMobile ? "100%" : "auto"
                        }}
                        onClick={() =>
                            goToPage("/employeebook/import-employees")
                        }
                    >
                        Add Employee
                    </Button>
                    <Button
                        variant="contained"
                        sx={{
                            marginRight: !isMobile && "20px",
                            marginBottom: isMobile && "20px",
                            width: isMobile ? "100%" : "auto"
                        }}
                        onClick={() => goToPage("/employeebook/manage-access")}
                    >
                        Manage User Access
                    </Button>
                    <Button
                        variant="contained"
                        sx={{
                            marginRight: !isMobile && "20px",
                            marginBottom: isMobile && "10px",
                            width: isMobile ? "100%" : "auto"
                        }}
                        onClick={() => goToPage("/employeebook/analytics")}
                    >
                        Show Analytics
                    </Button>
                    <Button
                        variant="contained"
                        sx={{
                            marginRight: !isMobile && "20px",
                            marginBottom: isMobile && "20px",
                            width: isMobile ? "100%" : "auto"
                        }}
                        onClick={() =>
                            goToPage("/employeebook/share-idea-details")
                        }
                    >
                        Share Idea Details
                    </Button>
                    <Button
                        variant="contained"
                        sx={{
                            width: isMobile ? "100%" : "auto"
                        }}
                        onClick={() =>
                            goToPage("/employeebook/manage-employee-profile")
                        }
                    >
                        Manage Employee Profile
                    </Button>
                </Box>
            )}
            {isHRNavVisible && isListView && (
                <Button
                    variant="contained"
                    sx={{
                        width: isMobile ? "100%" : "auto",
                        marginBottom: "20px"
                    }}
                    onClick={() =>
                        goToPage("/employeebook/manage-employee-profile")
                    }
                >
                    Manage Employee Profile
                </Button>
            )}
            <EmployeesContainer
                changeView={changeView}
                isListView={isListView}
            />
        </Box>
    );
};

export default withRouter(EmployeeList);
