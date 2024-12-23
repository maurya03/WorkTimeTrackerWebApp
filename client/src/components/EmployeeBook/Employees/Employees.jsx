import React, { useEffect, useState } from "react";
import Button from "@mui/material/Button";
import Box from "@mui/material/Box";
import Avatar from "@mui/material/Avatar";
import Typography from "@mui/material/Typography";
import CircularProgress from "@mui/material/CircularProgress";
// import { useHistory } from "react-router-dom";
import EmployeeSearchAndFilter from "rootpath/components/EmployeeBook/Employees/EmployeeSearchAndFilter";
import { getImageSource } from "rootpath/services/EmployeeBook/employee/EmployeeDetail.js";
import useMediaQuery from "@mui/material/useMediaQuery";
import ArrowRight from "@mui/icons-material/ArrowRight";
import ArrowLeft from "@mui/icons-material/ArrowLeft";
import ReactGA from "react-ga4";
import EmployeeDetailsContainer from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeeDetailsContainer";

const Employees = ({
    employees,
    employeeSearchParam,
    totalPageCount,
    projectList,
    fetchProjectList,
    postFilterParams,
    setEmpNavigationId,
    setLoader,
    isLoading,
    clearEmployeeSearchParam,
    postFilterEmployees,
    employeesList,
    changeView,
    isListView
}) => {
    // const history = useHistory();
    const [pageNumber, setPageNumber] = useState(1);
    const [searchParam, setSearchParam] = useState(employeeSearchParam);
    const [boxWidth, setBoxWidth] = useState("32%");

    const isMobile = useMediaQuery("(max-width: 767px)");
    const isTab = useMediaQuery("(min-width: 768px) and (max-width:1024px)");

    useEffect(() => {
        fetchProjectList();
    }, [fetchProjectList]);

    useEffect(() => {
        postFilterParams(searchParam);
    }, []);

    useEffect(() => {
        setLoader(false);
    }, [employees]);

    useEffect(() => {
        isMobile && setBoxWidth("70%");
        isTab && setBoxWidth("45%");
    }, [isMobile, isTab]);
    const onPrevClick = async () => {
        const prePageNumber = pageNumber - 1;
        await postFilterEmployees(
            { ...searchParam, page: prePageNumber },
            employeesList
        );
        setSearchParam({ ...searchParam, page: prePageNumber });
        setPageNumber(prePageNumber);
    };

    const onNextClick = async () => {
        const nextPageNumber = pageNumber + 1;
        await postFilterEmployees(
            { ...searchParam, page: nextPageNumber },
            employeesList
        );
        setSearchParam({ ...searchParam, page: nextPageNumber });
        setPageNumber(nextPageNumber);
    };

    const onSearchParamChange = async e => {
        ReactGA.event({
            category: "Search",
            action: "SearchOptionsTrigger",
            label: "Search Options Update",
            value: 1
        });
        const pageNumber = 1;
        setSearchParam({
            ...searchParam,
            [e.target.name]: e.target.value,
            page: pageNumber
        });
        setPageNumber(pageNumber);
        await postFilterEmployees(
            {
                ...searchParam,
                [e.target.name]: e.target.value,
                page: pageNumber
            },
            employeesList
        );
    };

    const onHandleSearch = async () => {
        await postFilterEmployees(searchParam, employeesList);
    };

    const getEmployeeDetail = async employeeId => {
        //clearEmployeeSearchParam();
        if (employeeId) {
            setEmpNavigationId(employeeId, employeesList);
            //history.push("/employee-details");
            changeView(false);
        }
    };

    return (
        <>
            {isListView ? (
                <>
                    <EmployeeSearchAndFilter
                        projectList={projectList}
                        searchParam={searchParam}
                        onSearchParamChange={onSearchParamChange}
                        onHandleSearch={onHandleSearch}
                        setSearchParam={setSearchParam}
                        clearEmployeeSearchParam={clearEmployeeSearchParam}
                        employeeList={employeesList}
                    />
                    {isLoading && (
                        <Box
                            display="flex"
                            justifyContent="center"
                            marginTop="50px"
                            height={400}
                        >
                            <CircularProgress color="secondary" />
                        </Box>
                    )}
                    {!isLoading && (
                        <>
                            <Box
                                display="flex"
                                alignItems="center"
                                justifyContent="center"
                                marginTop="30px"
                                flexWrap="wrap"
                            >
                                {employees &&
                                    employees.length > 0 &&
                                    employees?.map((employee, i) => {
                                        const borderColor =
                                            i % 2 ? "#159c49" : "#292e80";
                                        return (
                                            <Box
                                                key={employee.employeeId}
                                                display="flex"
                                                bgcolor="#e9ebee"
                                                borderRadius="60px"
                                                flexBasis={boxWidth}
                                                padding="10px"
                                                marginBottom="15px"
                                                marginRight="1%"
                                                alignItems="center"
                                                sx={{ cursor: "pointer" }}
                                                onClick={() =>
                                                    getEmployeeDetail(
                                                        employee.employeeId
                                                    )
                                                }
                                            >
                                                <Avatar
                                                    src={
                                                        employee.profilePictureUrl
                                                    }
                                                    sx={{
                                                        width: 100,
                                                        height: 100,
                                                        border: `3px solid ${borderColor}`
                                                    }}
                                                />

                                                <Box ml="10px" mt="-10px">
                                                    <Typography
                                                        variant="h5"
                                                        fontSize={
                                                            isMobile
                                                                ? "15px"
                                                                : "24px"
                                                        }
                                                        textTransform="capitalize"
                                                    >
                                                        {employee.employeeName}
                                                    </Typography>
                                                    <Typography
                                                        textTransform="capitalize"
                                                        fontSize={
                                                            isMobile
                                                                ? "12px"
                                                                : "14px"
                                                        }
                                                    >
                                                        {employee.designation}
                                                    </Typography>
                                                </Box>
                                            </Box>
                                        );
                                    })}
                                {employees && employees.length === 0 && (
                                    <Box
                                        display="flex"
                                        flexDirection="column"
                                        justifyContent="center"
                                        fontWeight="500"
                                        fontSize="20px"
                                        flexBasis="100%"
                                        padding="10px"
                                        marginBottom="15px"
                                        marginRight="1%"
                                        alignItems="center"
                                    >
                                        No Employee found
                                    </Box>
                                )}
                            </Box>
                            {employees && employees.length > 0 && (
                                <Box
                                    display="flex"
                                    justifyContent="center"
                                    mt="20px"
                                >
                                    <Button
                                        variant="contained"
                                        sx={
                                            isMobile
                                                ? {
                                                      marginRight: "20px",
                                                      width: "50px",
                                                      borderRadius: "10px"
                                                  }
                                                : {
                                                      marginRight: "20px",
                                                      borderRadius: "10px",
                                                      width: "200px"
                                                  }
                                        }
                                        onClick={onPrevClick}
                                        disabled={pageNumber <= 1}
                                    >
                                        {isMobile ? <ArrowLeft /> : "Previous"}
                                    </Button>
                                    <Button
                                        variant="contained"
                                        sx={
                                            isMobile
                                                ? {
                                                      marginRight: "20px",
                                                      width: "50px",
                                                      borderRadius: "10px"
                                                  }
                                                : {
                                                      marginRight: "20px",
                                                      borderRadius: "10px",
                                                      width: "200px"
                                                  }
                                        }
                                        onClick={onNextClick}
                                        disabled={
                                            pageNumber ==
                                            totalPageCount?.totalPages
                                        }
                                    >
                                        {isMobile ? <ArrowRight /> : "Next"}
                                    </Button>
                                </Box>
                            )}
                        </>
                    )}
                </>
            ) : (
                // Render <otherComponent> here if isDetailView is false
                <EmployeeDetailsContainer
                    changeView={changeView}
                    isListView={isListView}
                    employeesList={employeesList}
                    employees={employees}
                />
            )}
        </>
    );
};
export default Employees;
