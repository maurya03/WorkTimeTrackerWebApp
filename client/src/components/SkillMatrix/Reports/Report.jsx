import React, { useState, useEffect, useLayoutEffect, useRef } from "react";
import { DayPicker } from "react-day-picker";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Stack from "@mui/material/Stack";
import FormControl from "@mui/material/FormControl";
import Select from "@mui/material/Select";
import MenuItem from "@mui/material/MenuItem";
import IconButton from "@mui/material/IconButton";
import Badge from "@mui/material/Badge";
import css from "rootpath/components/SkillMatrix/Reports/Report.css";
import ReportTable from "rootpath/components/SkillMatrix/Reports/ReportTable";
import { ReportTypes } from "rootpath/components/SkillMatrix/Reports/Constants";
import FilterIcon from "@mui/icons-material/FilterAlt";
import FilterPopover from "rootpath/components/SkillMatrix/Reports/FilterPopover";
import { Tooltip } from "@mui/material";
import YearMonthFilter from "../Reports/YearMonthFilter";

const Report = ({
    reportsData,
    categories,
    clients,
    teams,
    isLoading,
    fetchCategoryList,
    fetchClientList,
    fetchClientTeamsList,
    empTypeList,
    fetchEmpTypeList,
    fetchDataByActiveReportType
}) => {
    const currentYear = new Date().getFullYear();
    const currentMonth = new Date().getMonth() + 1;

    const [selectedYearAndMonth, setSelectedYearAndMonth] = useState({
        year: currentYear,
        month: currentMonth
    });
    const [activeReport, setActiveReport] = useState(
        "Report By All Categories"
    );
    const [activeClient, setActiveClient] = useState(0);
    const [activeTeam, setActiveTeam] = useState(0);
    const [activeType, setActiveType] = useState(0);
    const [activeReportData, setActiveReportData] = useState([]);
    const [activeCategoryFunction, setActiveCategoryFunction] = useState(0);
    const [isCategoryWiseChecked, setIsCategoryWiseChecked] = useState(true);
    const [activePopover, setActivePopover] = useState(null);
    const [isFilterApplied, setIsFilterApplied] = useState(false);
    const [isFilterDisable, setIsFilterDisable] = useState(true);
    const dashboardRef = useRef();

    useLayoutEffect(() => {
        dashboardRef.current.style.height = `${window.innerHeight - 140}px`;
    }, []);

    useEffect(() => {
        setSelectedYearAndMonth({
            year: new Date().getFullYear(),
            month: new Date().getMonth() + 1
        });
    }, [activeReport]);

    useEffect(() => {
        fetchCategoryList();
        fetchClientList();
        fetchEmpTypeList();
    }, [fetchCategoryList, fetchClientList, fetchEmpTypeList]);

    useEffect(() => {
        fetchClientTeamsList(activeClient);
    }, [activeClient, fetchClientTeamsList]);

    useEffect(() => {
        fetchDataByActiveReportType(
            activeReport,
            activeCategoryFunction,
            activeClient,
            activeTeam,
            isCategoryWiseChecked,
            activeType,
            selectedYearAndMonth.year,
            selectedYearAndMonth.month
        );
    }, [fetchDataByActiveReportType, selectedYearAndMonth]);

    useEffect(() => {
        setActiveReportData(reportsData);
    }, [reportsData]);

    const handleFilterReset = () => {
        setActivePopover(null);
        setIsFilterDisable(true);
        setIsFilterApplied(false);
        setActiveCategoryFunction(0);
        setActiveClient(0);
        setActiveTeam(0);
        setActiveType(0);
        setIsCategoryWiseChecked(true);
    };

    const handleYearAndMonthChange = result => {
        setSelectedYearAndMonth(result);
    };

    return (
        <Box className="container">
            <Stack
                marginTop="10px"
                direction="row"
                alignItems="center"
                justifyContent="space-between"
            >
                <Typography
                    variant="h5"
                    color="#000"
                    fontSize="25px"
                    width="50%"
                    sx={{
                        textOverflow: "ellipses",
                        overflow: "hidden",
                        whiteSpace: "nowrap",
                        cursor: "pointer"
                    }}
                >
                    Reports
                </Typography>
                <Stack
                    direction="row"
                    justifyContent="flex-end"
                    alignItems="center"
                >
                    {(activeReport === "Report By Employee Score" ||
                        activeReport === "Skill Segment By Categories") && (
                        <YearMonthFilter
                            selectedYearAndMonth={selectedYearAndMonth}
                            onYearOrMonthChange={handleYearAndMonthChange}
                        />
                    )}
                    <FormControl sx={{ m: 1, minWidth: 160 }} size="small">
                        <Select
                            value={activeReport}
                            displayEmpty
                            onChange={event => {
                                setActiveReport(event.target.value);
                                fetchDataByActiveReportType(
                                    event.target.value,
                                    0,
                                    0,
                                    0,
                                    true,
                                    0,
                                    selectedYearAndMonth.year,
                                    selectedYearAndMonth.month
                                );
                                handleFilterReset();
                            }}
                        >
                            {ReportTypes.map(item => {
                                return (
                                    <MenuItem key={item} value={item}>
                                        {item}
                                    </MenuItem>
                                );
                            })}
                        </Select>
                    </FormControl>
                    <IconButton
                        onClick={() => {
                            setActivePopover(event.currentTarget);
                        }}
                    >
                        <Badge
                            color="primary"
                            variant={isFilterApplied ? "dot" : "standard"}
                        >
                            <Tooltip title="Apply Filter">
                                <FilterIcon />
                            </Tooltip>
                        </Badge>
                    </IconButton>
                    <FilterPopover
                        activePopover={activePopover}
                        handleFilterReset={handleFilterReset}
                        categories={categories}
                        clients={clients}
                        teams={teams}
                        empTypeList={empTypeList}
                        activeCategoryFunction={activeCategoryFunction}
                        activeClient={activeClient}
                        activeTeam={activeTeam}
                        activeType={activeType}
                        isCategoryWiseChecked={isCategoryWiseChecked}
                        setIsCategoryWiseChecked={setIsCategoryWiseChecked}
                        setIsFilterDisable={setIsFilterDisable}
                        setActivePopover={setActivePopover}
                        setActiveCategoryFunction={setActiveCategoryFunction}
                        setActiveClient={setActiveClient}
                        setActiveTeam={setActiveTeam}
                        setActiveType={setActiveType}
                        activeReport={activeReport}
                        isFilterDisable={isFilterDisable}
                        setIsFilterApplied={setIsFilterApplied}
                        fetchDataByActiveReportType={
                            fetchDataByActiveReportType
                        }
                        selectedYearAndMonth={selectedYearAndMonth}
                    />
                </Stack>
            </Stack>
            <div className={css.table} ref={dashboardRef}>
                <ReportTable
                    data={activeReportData}
                    reportType={activeReport}
                    isLoading={isLoading}
                />
            </div>
        </Box>
    );
};

export default Report;
