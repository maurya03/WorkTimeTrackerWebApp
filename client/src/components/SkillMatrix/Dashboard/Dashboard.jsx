import React, { useEffect, useRef, useState } from "react";
import {
    Box,
    Button,
    IconButton,
    Typography,
    useTheme,
    useMediaQuery,
    Modal,
    Radio,
    RadioGroup,
    FormControlLabel,
    Select,
    MenuItem,
    FormControl,
    Tooltip,
    Stack
} from "@mui/material";
import Grid from "@mui/material/Unstable_Grid2";
import css from "rootpath/components/SkillMatrix/Reports/Report.css";
import { tokens } from "./theme";
import DownloadOutlinedIcon from "@mui/icons-material/DownloadOutlined";
import ArrowBack from "@mui/icons-material/ArrowBack";
import Header from "rootpath/components/SkillMatrix/Dashboard/Chart/Header";
import LineChart from "rootpath/components/SkillMatrix/Dashboard/Chart/LineChart";
import BarChart from "rootpath/components/SkillMatrix/Dashboard/Chart/BarChart";
import StatBox from "rootpath/components/SkillMatrix/Dashboard/Chart/StatBox";
import html2canvas from "html2canvas";
import constants from "rootpath/components/SkillMatrix/constants";
import CircularProgress, {
    circularProgressClasses
} from "@mui/material/CircularProgress";

const Dashboard = ({
    barData,
    lineData,
    expert,
    needTraining,
    fetchDashBoardList,
    goodDataEmployee,
    averageEmployee,
    clients,
    fetchClientScore,
    fetchBarDataTeamWise,
    barDataCategoryWise,
    barDataTeamWiseScore,
    clientTeamList,
    employeeList,
    fetchLineChartEmployeeWise,
    fetchLineChartTrendDataTeamWise,
    scoreNotAvailable,
    selectedClient,
    selectedTeam,
    selectedEmployee,
    SelectedTrendClient,
    fetchLineChartTrendDataClientWise,
    selectedFunctionType,
    empListType,
    isLoading
}) => {
    const barChartRef = useRef(null);
    const trendChartRef = useRef(null);
    const [isBarTeamWise, setBarTeamWise] = useState(false);
    const [barDataLabel, setBarDataLabel] = useState(constants.ScoreWiseLabel);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [modalContent, setModalContent] = useState([]);
    const [modalTitle, setModalTitle] = useState(0);
    const [chartType, setChartType] = useState("ScoreWise");
    const [activeClient, setActiveClient] = useState("");
    const [activeTeam, setActiveTeam] = useState("");
    const [activeEmployee, setActiveEmployee] = useState("");
    const [showClientTeam, setShowClientTeam] = useState("");
    const totaEmployee =
        expert.length +
        needTraining.length +
        averageEmployee.length +
        goodDataEmployee.length +
        scoreNotAvailable.length;
    const [activeTrendClient, setActiveTrendClient] = useState("0");
    const [functionType, setFunctionType] = useState("All");
    useEffect(() => {
        fetchDashBoardList();
    }, [fetchDashBoardList]);

    useEffect(() => {
        (selectedClient || selectedClient == "0") &&
            setActiveClient(selectedClient);
        (selectedTeam || selectedTeam == "0") && setActiveTeam(selectedTeam);
        (selectedEmployee || selectedEmployee == "0") &&
            setActiveEmployee(selectedEmployee);
        selectedFunctionType && setFunctionType(selectedFunctionType);
    }, [selectedClient, selectedTeam, selectedEmployee, selectedFunctionType]);

    useEffect(() => {
        SelectedTrendClient && setActiveTrendClient(SelectedTrendClient);
    }, [SelectedTrendClient]);

    useEffect(() => {
        const chartTypeLabel =
            chartType == "TeamWise"
                ? constants.TeamWiseLabel
                : chartType == "ScoreWise"
                ? null
                : constants.CategoryWiseLabel;
        setBarDataLabel(chartTypeLabel);
    }, [chartType]);

    const handleChange = event => {
        setChartType(event.target.value);
    };

    const handleOpenModal = (content, title) => {
        setModalTitle(title);
        setModalContent(content);
        setIsModalOpen(true);
    };

    const handleCloseModal = () => {
        setIsModalOpen(false);
        setModalContent([]);
    };

    const handleClientBarChange = id => {
        const findClient = clients.find(x => x.clientName == id.indexValue);
        if (!findClient) {
            setActiveClient(0);
            fetchClientScore(0, clients);
        } else {
            setActiveClient(findClient.id);
            fetchClientScore(findClient.id, clients);
        }
    };

    const handleBarDataTeamWise = async event => {
        if (selectedClient == 0) {
            handleClientBarChange(event);
        } else {
            if (
                isBarTeamWise == false &&
                (chartType == "TeamWise" || chartType == "ScoreWise")
            ) {
                setBarTeamWise(true);
                setShowClientTeam(event.indexValue);
                await fetchBarDataTeamWise(
                    event.indexValue,
                    clients,
                    lineData,
                    expert,
                    needTraining,
                    goodDataEmployee,
                    averageEmployee,
                    barDataCategoryWise,
                    barDataTeamWiseScore,
                    chartType,
                    barData,
                    clientTeamList,
                    employeeList,
                    scoreNotAvailable,
                    activeClient,
                    activeTeam,
                    activeEmployee,
                    functionType
                );
            }
        }
    };

    const handleClientChange = event => {
        setActiveClient(event.target.value);
        setActiveTrendClient(event.target.value);

        fetchClientScore(event.target.value, clients);
    };

    const functionTypeChange = event => {
        setFunctionType(event.target.value);
        fetchClientScore(activeClient, clients, event.target.value);
    };

    const handleTeamChange = async event => {
        setActiveTeam(event.target.value);

        await fetchLineChartTrendDataTeamWise(
            event.target.value,
            clients,
            expert,
            needTraining,
            goodDataEmployee,
            averageEmployee,
            barDataCategoryWise,
            barDataTeamWiseScore,
            barData,
            clientTeamList,
            scoreNotAvailable,
            activeClient,
            activeTrendClient,
            functionType
        );
    };

    const handleTrendClientChange = async event => {
        setActiveTrendClient(event.target.value);
        await fetchLineChartTrendDataClientWise(
            "0",
            clients,
            expert,
            needTraining,
            goodDataEmployee,
            averageEmployee,
            barDataCategoryWise,
            barDataTeamWiseScore,
            barData,
            clientTeamList,
            scoreNotAvailable,
            activeClient,
            event.target.value,
            functionType
        );
    };

    const handleEmployeeChange = async event => {
        setActiveEmployee(event.target.value);
        await fetchLineChartEmployeeWise(
            event.target.value,
            clients,
            expert,
            needTraining,
            goodDataEmployee,
            averageEmployee,
            barDataCategoryWise,
            barDataTeamWiseScore,
            barData,
            clientTeamList,
            employeeList,
            scoreNotAvailable,
            activeClient,
            activeTeam,
            functionType
        );
    };

    const handleBarDataTeamChange = async () => {
        setBarTeamWise(false);
        setShowClientTeam("");
        await fetchDashBoardList(
            activeClient,
            activeTeam,
            activeEmployee,
            functionType
        );
    };

    const downloadChartAsImage = useRef => {
        html2canvas(useRef.current).then(canvas => {
            const link = document.createElement("a");
            link.href = canvas.toDataURL("image/png");
            link.download = "report_chart.png";
            link.click();
        });
    };

    const theme = useTheme();
    const smScreen = useMediaQuery(theme.breakpoints.up("sm"));
    const colors = tokens(theme.palette.mode);
    return (
        <Box m="20px">
            <Box
                display={smScreen ? "flex" : "block"}
                flexDirection={smScreen ? "row" : "column"}
                justifyContent={smScreen ? "space-between" : "start"}
                alignItems={smScreen ? "center" : "start"}
                mb="20px"
            >
                <Header title="Skill Matrix Dashboard" />
                <Box sx={{ display: "grid" }}>
                    {clients.length > 0 && (
                        <FormControl
                            sx={{
                                m: 1,
                                minWidth: 140
                            }}
                            size="small"
                        >
                            <Select
                                value={activeClient}
                                displayEmpty
                                disabled={isLoading}
                                onChange={handleClientChange}
                            >
                                {clients.map(client => (
                                    <MenuItem key={client.id} value={client.id}>
                                        {client.clientName}
                                    </MenuItem>
                                ))}
                            </Select>
                        </FormControl>
                    )}
                    <FormControl
                        sx={{
                            m: 1,
                            minWidth: 140
                        }}
                        size="small"
                    >
                        <Select
                            value={functionType}
                            displayEmpty
                            onChange={functionTypeChange}
                            disabled={isLoading}
                        >
                            {empListType.map(currentObject => (
                                <MenuItem
                                    key={currentObject.id}
                                    value={currentObject.function_Type}
                                >
                                    {currentObject.function_Type === "All"
                                        ? "All FunctionType"
                                        : currentObject.function_Type}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                </Box>
            </Box>

            <Grid
                container
                rowSpacing={1}
                justifyContent="space-between"
                columnSpacing={{ xs: 1, sm: 2, md: 3, lg: 4, xl: 4 }}
            >
                <Grid xs={12} sm={12} md={6} lg={2} xl={2}>
                    <Box
                        width="100%"
                        backgroundColor={colors.primary[400]}
                        display="flex"
                        alignItems="center"
                        justifyContent="center"
                        sx={{ cursor: "pointer" }}
                        onClick={() => handleOpenModal(expert, "Expert")}
                    >
                        <StatBox
                            title="Expert"
                            titleHighlight={expert.length}
                            subtitle="> 80%"
                            progress={expert.length / totaEmployee}
                            increase=""
                            // icon={
                            //     <EmailIcon
                            //         sx={{
                            //             color: colors.greenAccent[600],
                            //             fontSize: "26px"
                            //         }}
                            //     />
                            // }
                        />
                    </Box>
                </Grid>
                <Grid xs={12} sm={12} md={6} lg={2} xl={2}>
                    <Box
                        width="100%"
                        backgroundColor={colors.primary[400]}
                        display="flex"
                        alignItems="center"
                        justifyContent="center"
                        sx={{ cursor: "pointer" }}
                        onClick={() =>
                            handleOpenModal(goodDataEmployee, "Good")
                        }
                    >
                        <StatBox
                            title={"Good"}
                            titleHighlight={goodDataEmployee.length}
                            subtitle="60% > 80%"
                            progress={goodDataEmployee.length / totaEmployee}
                            increase=""
                            // icon={
                            //     <PointOfSaleIcon
                            //         sx={{
                            //             color: colors.greenAccent[600],
                            //             fontSize: "26px"
                            //         }}
                            //     />
                            // }
                        />
                    </Box>
                </Grid>
                <Grid xs={12} sm={12} md={6} lg={2} xl={2}>
                    <Box
                        width="100%"
                        backgroundColor={colors.primary[400]}
                        display="flex"
                        alignItems="center"
                        justifyContent="center"
                        sx={{ cursor: "pointer" }}
                        onClick={() =>
                            handleOpenModal(averageEmployee, "Average Employee")
                        }
                    >
                        <StatBox
                            title={"Average"}
                            titleHighlight={averageEmployee.length}
                            subtitle="40% < 60%"
                            progress={averageEmployee.length / totaEmployee}
                            increase=""
                            // icon={
                            //     <PersonAddIcon
                            //         sx={{
                            //             color: colors.greenAccent[600],
                            //             fontSize: "26px"
                            //         }}
                            //     />
                            // }
                        />
                    </Box>
                </Grid>
                <Grid xs={12} sm={12} md={6} lg={2} xl={2}>
                    <Box
                        width="100%"
                        backgroundColor={colors.primary[400]}
                        display="flex"
                        alignItems="center"
                        justifyContent="center"
                        sx={{ cursor: "pointer" }}
                        onClick={() =>
                            handleOpenModal(needTraining, "Need Training")
                        }
                    >
                        <StatBox
                            title={"Need Training"}
                            titleHighlight={needTraining.length}
                            subtitle="< 40%"
                            progress={needTraining.length / totaEmployee}
                            increase=""
                            // icon={
                            //     <TrafficIcon
                            //         sx={{
                            //             color: colors.greenAccent[600],
                            //             fontSize: "26px"
                            //         }}
                            //     />
                            // }
                        />
                    </Box>
                </Grid>

                <Grid xs={12} sm={12} md={6} lg={2} xl={2}>
                    <Box
                        width="100%"
                        backgroundColor={colors.primary[400]}
                        display="flex"
                        alignItems="center"
                        justifyContent="center"
                        sx={{ cursor: "pointer" }}
                        onClick={() =>
                            handleOpenModal(scoreNotAvailable, "Not Available")
                        }
                    >
                        <StatBox
                            title="Not Available"
                            titleHighlight={scoreNotAvailable.length}
                            subtitle=""
                            progress={scoreNotAvailable.length / totaEmployee}
                            increase=""
                            // icon={
                            //     <EmailIcon
                            //         sx={{
                            //             color: colors.greenAccent[600],
                            //             fontSize: "26px"
                            //         }}
                            //     />
                            // }
                        />
                    </Box>
                </Grid>
                <Modal
                    open={isModalOpen}
                    onClose={handleCloseModal}
                    aria-labelledby="modal-title"
                    aria-describedby="modal-description"
                >
                    <Box
                        sx={{
                            position: "absolute",
                            top: "50%",
                            left: "50%",
                            transform: "translate(-50%, -50%)",
                            width: 400,
                            bgcolor: "background.paper",
                            boxShadow: 24,
                            p: "15px 30px",
                            display: "flex",
                            flexDirection: "column"
                        }}
                    >
                        <div>
                            <span
                                style={{
                                    display: "inline-block",
                                    padding: "10px 0",
                                    width: "100%",
                                    textAlign: "center",
                                    cursor: "pointer",
                                    borderRadius: "5px 5px 0 0",
                                    backgroundColor: "#f0f0f0",
                                    borderBottom: "2px solid #007bff",
                                    boxSizing: "border-box"
                                }}
                            >
                                Employee
                            </span>
                        </div>
                        <Box height="250px" overflow="auto">
                            <ul>
                                {modalContent &&
                                    modalContent.length > 0 &&
                                    modalContent.map((item, index) => (
                                        <li key={index}>
                                            <Typography
                                                fontSize="14px"
                                                id="modal-description"
                                            >
                                                {item.employeeName} -{" "}
                                                {item.teamName}
                                            </Typography>
                                        </li>
                                    ))}
                            </ul>
                        </Box>
                        <Button
                            onClick={handleCloseModal}
                            variant="contained"
                            sx={{ alignSelf: "flex-end", mt: "15px" }}
                        >
                            Close
                        </Button>
                    </Box>
                </Modal>
                <Grid
                    xs={12}
                    sm={12}
                    md={12}
                    lg={12}
                    container
                    rowSpacing={1}
                    columnSpacing={{ xs: 1, sm: 2, md: 3 }}
                >
                    <Grid xs={12}>
                        <Box backgroundColor={colors.primary[400]}>
                            <Box
                                mt="15px"
                                p="10px 30px"
                                display="flex"
                                justifyContent="space-between"
                                alignItems="center"
                                height="85px"
                            >
                                {showClientTeam.length > 0 ? (
                                    <Typography
                                        variant="h5"
                                        fontWeight="600"
                                        color={colors.grey[100]}
                                    >
                                        Client Expected vs Employee Score for{" "}
                                        {showClientTeam} (in Percentage)
                                    </Typography>
                                ) : (
                                    <Typography
                                        variant="h5"
                                        fontWeight="600"
                                        color={colors.grey[100]}
                                    >
                                        {barDataLabel} Client Expected vs
                                        Employee Score (in Percentage)
                                    </Typography>
                                )}
                                <Box display="flex" minWidth="501px">
                                    <RadioGroup
                                        row
                                        aria-labelledby="demo-radio-buttons-group-label"
                                        value={chartType}
                                        onChange={handleChange}
                                        name="radio-buttons-group"
                                    >
                                        <FormControlLabel
                                            value="ScoreWise"
                                            control={
                                                <Radio
                                                    disabled={isBarTeamWise}
                                                />
                                            }
                                            label="Total Score Wise"
                                        />
                                        <FormControlLabel
                                            value="TeamWise"
                                            control={
                                                <Radio
                                                    disabled={isBarTeamWise}
                                                />
                                            }
                                            label="Team Wise"
                                        />
                                        <FormControlLabel
                                            value="CategoryWise"
                                            control={
                                                <Radio
                                                    disabled={isBarTeamWise}
                                                />
                                            }
                                            label="Category Wise"
                                        />
                                    </RadioGroup>
                                    {(chartType == "TeamWise"
                                        ? barData
                                        : chartType == "ScoreWise"
                                        ? barDataTeamWiseScore
                                        : barDataCategoryWise
                                    ).length > 0 && (
                                        <Box>
                                            <Tooltip title="Download Chart">
                                                <IconButton
                                                    onClick={() =>
                                                        downloadChartAsImage(
                                                            barChartRef
                                                        )
                                                    }
                                                >
                                                    <DownloadOutlinedIcon
                                                        sx={{
                                                            fontSize: "26px",
                                                            color: colors
                                                                .greenAccent[500]
                                                        }}
                                                    />
                                                </IconButton>
                                            </Tooltip>
                                        </Box>
                                    )}
                                    <Box ml="10px">
                                        {isBarTeamWise && (
                                            <IconButton
                                                onClick={
                                                    handleBarDataTeamChange
                                                }
                                            >
                                                <ArrowBack
                                                    sx={{
                                                        fontSize: "26px",
                                                        color: colors
                                                            .greenAccent[500]
                                                    }}
                                                />
                                            </IconButton>
                                        )}
                                    </Box>
                                </Box>
                            </Box>
                            <div ref={barChartRef}>
                                <Box
                                    width="100%"
                                    height="600px"
                                    m="-20px 0 0 0"
                                >
                                    {!isLoading ? (
                                        <BarChart
                                            barData={
                                                chartType == "TeamWise"
                                                    ? barData
                                                    : chartType == "ScoreWise"
                                                    ? barDataTeamWiseScore
                                                    : barDataCategoryWise
                                            }
                                            isDashboard={true}
                                            fetchBarDataTeamWise={
                                                handleBarDataTeamWise
                                            }
                                            chartType={chartType}
                                        />
                                    ) : (
                                        <Stack className={css.displayLoading}>
                                            <CircularProgress
                                                variant="indeterminate"
                                                disableShrink
                                                sx={{
                                                    animationDuration: "550ms",
                                                    position: "absolute",
                                                    [`& .${circularProgressClasses.circle}`]:
                                                        {
                                                            strokeLinecap:
                                                                "round"
                                                        }
                                                }}
                                                size={40}
                                                thickness={4}
                                            />
                                        </Stack>
                                    )}
                                </Box>
                            </div>
                        </Box>
                    </Grid>

                    <Grid xs={12} sm={12} md={12} lg={12}>
                        <Box backgroundColor={colors.primary[400]}>
                            <Box
                                display="flex"
                                justifyContent="space-between"
                                alignItems="center"
                                p="10px 30px"
                                mt="15px"
                            >
                                <Typography variant="h5" fontWeight="600">
                                    History Trend
                                </Typography>
                                <Box display="flex" alignItems="center">
                                    {clients.length > 0 &&
                                        selectedClient == 0 && (
                                            <FormControl
                                                sx={{
                                                    m: 1,
                                                    minWidth: 140
                                                }}
                                                size="small"
                                            >
                                                <Select
                                                    value={activeTrendClient}
                                                    displayEmpty
                                                    onChange={
                                                        handleTrendClientChange
                                                    }
                                                >
                                                    {clients.map(team => (
                                                        <MenuItem
                                                            key={team.id}
                                                            value={team.id}
                                                        >
                                                            {team.clientName}
                                                        </MenuItem>
                                                    ))}
                                                </Select>
                                            </FormControl>
                                        )}
                                    {clientTeamList.length > 0 && (
                                        <FormControl
                                            sx={{
                                                m: 1,
                                                minWidth: 140
                                            }}
                                            size="small"
                                        >
                                            <Select
                                                value={activeTeam}
                                                displayEmpty
                                                onChange={handleTeamChange}
                                            >
                                                {clientTeamList.map(team => (
                                                    <MenuItem
                                                        key={team.id}
                                                        value={team.id}
                                                    >
                                                        {team.teamName}
                                                    </MenuItem>
                                                ))}
                                            </Select>
                                        </FormControl>
                                    )}
                                    {employeeList.length > 0 && (
                                        <FormControl
                                            sx={{
                                                m: 1,
                                                minWidth: 140
                                            }}
                                            size="small"
                                        >
                                            <Select
                                                value={activeEmployee}
                                                displayEmpty
                                                onChange={handleEmployeeChange}
                                            >
                                                {employeeList.map(emp => (
                                                    <MenuItem
                                                        key={
                                                            emp.bhavnaEmployeeId
                                                        }
                                                        value={
                                                            emp.bhavnaEmployeeId
                                                        }
                                                    >
                                                        {emp.employeeName}
                                                    </MenuItem>
                                                ))}
                                            </Select>
                                        </FormControl>
                                    )}
                                    <Tooltip title="Download Graph">
                                        <IconButton
                                            onClick={() =>
                                                downloadChartAsImage(
                                                    trendChartRef
                                                )
                                            }
                                        >
                                            <DownloadOutlinedIcon
                                                sx={{
                                                    fontSize: "27px",
                                                    color: colors
                                                        .greenAccent[500]
                                                }}
                                            />
                                        </IconButton>
                                    </Tooltip>
                                </Box>
                            </Box>
                            <div ref={trendChartRef}>
                                <Box width="100%" height="450px" mt="-20px">
                                    {!isLoading ? (
                                        <LineChart
                                            lineData={lineData}
                                            isDashboard={true}
                                        />
                                    ) : (
                                        <Stack className={css.displayLoading}>
                                            <CircularProgress
                                                variant="indeterminate"
                                                disableShrink
                                                sx={{
                                                    animationDuration: "550ms",
                                                    position: "absolute",
                                                    [`& .${circularProgressClasses.circle}`]:
                                                        {
                                                            strokeLinecap:
                                                                "round"
                                                        }
                                                }}
                                                size={40}
                                                thickness={4}
                                            />
                                        </Stack>
                                    )}
                                </Box>
                            </div>
                        </Box>
                    </Grid>
                </Grid>
            </Grid>
        </Box>
    );
};

export default Dashboard;
