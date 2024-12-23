import React, { useState, useEffect, useLayoutEffect, useRef } from "react";
import {
    Box,
    Typography,
    Stack,
    FormControl,
    Select,
    MenuItem,
    InputLabel,
    Grid
} from "@mui/material";
import { DayPicker } from "react-day-picker";
import { CalendarTodayOutlined } from "@material-ui/icons";
import css from "rootpath/components/Timesheet/TimesheetReports/Report.css";
import ReportTable from "rootpath/components/Timesheet/TimesheetReports/ReportTable";
import { ReportTypes } from "rootpath/components/Timesheet/TimesheetReports/Constants";

const TimesheetReport = ({
    userRole,
    fetchRole,
    timesheetReportData,
    getTimesheetReportData,
    fetchClientList,
    fetchClientTeamsList,
    fetchTimesheetStatusList,
    clients,
    teams,
    timesheetStatus,
    generateTimesheeWeeklyReport,
    generateTimesheeWeeklyExcelReport
}) => {
    const [toggleCalenderDisplay, setToggleCalenderDisplay] = useState(false);
    const [selectDay, setSelectDay] = useState(null);

    const today = new Date();
    const lastWeekStartDate = new Date(today);
    lastWeekStartDate.setDate(today.getDate() - today.getDay() - 7);

    const lastWeekEndDate = new Date(today);
    lastWeekEndDate.setDate(today.getDate() - today.getDay() - 1);

    const [startDate, setStartDate] = useState(lastWeekStartDate.toISOString());
    const [endDate, setEndDate] = useState(lastWeekEndDate.toISOString());

    const modifiers = {
        currentWeek: {
            from: new Date(startDate.split(" ")[0]),
            to: new Date(endDate.split(" ")[0])
        }
    };
    const modifiersStyles = {
        currentWeek: {
            color: "#FFFFFF",
            backgroundColor: "#008000"
        }
    };
    const customStyles = {
        caption: { color: "#008000", fontWeight: "bold" },
        head_cell: { color: "#008000" },
        navigator: { color: "#008000" },
        day: {
            color: "#000000",
            border: "none",
            background: "none"
        }
    };

    const handleDayClick = day => {
        if (selectDay === 0) {
            const formattedStartDate = new Date(day).toISOString();
            setStartDate(formattedStartDate);
        } else if (selectDay === 1) {
            const formattedEndDate = new Date(day).toISOString();
            setEndDate(formattedEndDate);
        }

        setToggleCalenderDisplay(false);
    };

    const [activeReport, setActiveReport] = useState(
        "Timesheet Submission Report"
    );
    const [reportData, setReportData] = useState("");
    const [activeReportData, setActiveReportData] = useState("");
    const [selectedClient, setSelectedClient] = useState(0);
    const [selectedTeam, setSelectedTeam] = useState(0);
    const [selectedStatus, setSelectedStatus] = useState(0);
    const dashboardRef = useRef();

    const data = {
        ReportType: activeReport,
        ClientId: selectedClient,
        TeamId: selectedTeam ? selectedTeam.id : 0,
        StatusId: selectedStatus,
        StartDate: startDate,
        EndDate: endDate
    };

    useEffect(() => {
        fetchRole();
    }, [fetchRole]);

    useLayoutEffect(() => {
        dashboardRef.current.style.height = `${window.innerHeight - 140}px`;
    }, []);

    useEffect(() => {
        reportDataFunc();
    });

    useEffect(() => {
        fetchClientList();
        fetchTimesheetStatusList();
    }, [fetchClientList, fetchClientTeamsList]);

    useEffect(() => {
        getTimesheetReportData(data);
    }, [
        getTimesheetReportData,
        activeReport,
        selectedClient,
        selectedStatus,
        startDate,
        endDate
    ]);

    useEffect(() => {
        if (
            userRole.roleName === "Reporting_Manager" ||
            userRole.roleName === "HR"
        ) {
            setSelectedTeam(0);
            fetchClientTeamsList(userRole.clientId);
        } else if (selectedClient !== "") {
            setSelectedTeam(0);
            fetchClientTeamsList(selectedClient);
        }
    }, [userRole, selectedClient, fetchClientTeamsList]);

    useEffect(() => {
        if (selectedTeam && selectedTeam.id > 0) {
            getTimesheetReportData(data);
        } else {
            setSelectedTeam(0);
            getTimesheetReportData(data);
        }
    }, [selectedTeam, getTimesheetReportData]);

    useEffect(() => {
        setReportData(timesheetReportData);
    }, [timesheetReportData]);

    const handleReportTypeChange = event => {
        setActiveReport(event.target.value);
    };

    const handleClietChange = event => {
        setSelectedClient(event.target.value);
    };

    const handleStatusChange = event => {
        setSelectedStatus(event.target.value);
    };

    const handleTeamChange = event => {
        const selectedTeam1 = teams.find(x => x.id == event.target.value);
        setSelectedTeam(selectedTeam1);
    };

    const handleGeneratePdfReport = (startDate, endDate) => {
        generateTimesheeWeeklyReport(
            formatDateToCustom(startDate),
            formatDateToCustom(endDate)
        );
    };
    const handleGenerateExcelReport = (startDate, endDate) => {
        generateTimesheeWeeklyExcelReport(
            formatDateToCustom(startDate),
            formatDateToCustom(endDate)
        );
    };

    const formatDateToCustom = date => {
        // Get the day, month, and year parts
        const day = new Date(date.split(" ")[0]).toLocaleDateString("en-GB", {
            day: "2-digit"
        });
        const month = new Date(date.split(" ")[0]).toLocaleDateString("en-GB", {
            month: "2-digit"
        });
        const year = new Date(date.split(" ")[0]).toLocaleDateString("en-GB", {
            year: "numeric"
        });

        // Combine them with hyphens
        return `${year}-${month}-${day}`;
    };

    const reportDataFunc = () => {
        switch (activeReport) {
            case "Timesheet Submission Report":
                setActiveReportData(reportData);
                break;
            case "Timesheet Detail Report":
                setActiveReportData(reportData);
                break;
            // case "Timesheet Employee Submission Report":
            //     setActiveReportData(reportData);
            //     break;
            default:
                setActiveReportData("");
        }
    };
    return (
        <>
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
                        width="8%"
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
                        alignItems="center"
                        marginRight="250px"
                        display="flex"
                    >
                        {userRole.roleName === "Admin" && (
                            <div className={css.calendar}>
                                <div className={css.tooltip}>
                                    <CalendarTodayOutlined
                                        onClick={() => {
                                            setSelectDay(0);
                                            setToggleCalenderDisplay(
                                                !toggleCalenderDisplay
                                            );
                                        }}
                                    ></CalendarTodayOutlined>
                                    <span className={css.tooltiptext}>
                                        Select Week
                                    </span>
                                </div>

                                <label
                                    className={css.dayPickerLabel}
                                    style={{ fontWeight: "bold" }}
                                >
                                    Start Date :{" "}
                                </label>
                                <label>
                                    {startDate &&
                                        new Date(
                                            startDate.split(" ")[0]
                                        ).toLocaleDateString("en-gb", {
                                            day: "2-digit",
                                            month: "short",
                                            year: "numeric"
                                        })}
                                </label>
                                <div className={css.tooltip}>
                                    <CalendarTodayOutlined
                                        onClick={() => {
                                            setSelectDay(1);
                                            setToggleCalenderDisplay(
                                                !toggleCalenderDisplay
                                            );
                                        }}
                                    ></CalendarTodayOutlined>
                                    <span className={css.tooltiptext}>
                                        Select Week End
                                    </span>
                                </div>
                                <label
                                    className={css.dayPickerLabel}
                                    style={{ fontWeight: "bold" }}
                                >
                                    End Date :{" "}
                                </label>
                                <label>
                                    {endDate &&
                                        new Date(
                                            endDate.split(" ")[0]
                                        ).toLocaleDateString("en-gb", {
                                            day: "2-digit",
                                            month: "short",
                                            year: "numeric"
                                        })}
                                </label>

                                {toggleCalenderDisplay && (
                                    <div className={css.dayPicker}>
                                        <DayPicker
                                            modifiers={modifiers}
                                            modifiersStyles={modifiersStyles}
                                            styles={customStyles}
                                            onDayClick={handleDayClick}
                                        />
                                    </div>
                                )}
                            </div>
                        )}{" "}
                    </Stack>
                    <Stack
                        direction="row"
                        justifyContent="flex-end"
                        alignItems="center"
                    >
                        <FormControl
                            sx={{
                                m: 1,
                                minWidth: 160
                            }}
                            size="small"
                        >
                            <Select
                                value={activeReport}
                                displayEmpty
                                onChange={handleReportTypeChange}
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
                    </Stack>
                </Stack>

                <Stack alignItems="center" direction="row">
                    {userRole.roleName !== "Reporting_Manager" &&
                        userRole.roleName !== "HR" && (
                            <InputLabel
                                id="clint-label"
                                style={{ color: "black" }}
                            >
                                Client:
                            </InputLabel>
                        )}
                    {userRole.roleName !== "Reporting_Manager" &&
                        userRole.roleName !== "HR" && (
                            <FormControl
                                sx={{
                                    m: 1,
                                    minWidth: 160
                                }}
                                size="small"
                            >
                                <Select
                                    value={selectedClient}
                                    onChange={handleClietChange}
                                >
                                    <MenuItem value={0}>All</MenuItem>
                                    {clients &&
                                        clients.map(item => (
                                            <MenuItem
                                                key={item.id}
                                                value={item.id}
                                            >
                                                {item.clientName}
                                            </MenuItem>
                                        ))}
                                </Select>
                            </FormControl>
                        )}
                    <InputLabel id="team-label" style={{ color: "black" }}>
                        Team:
                    </InputLabel>
                    <FormControl
                        sx={{
                            m: 1,
                            minWidth: 160
                        }}
                        size="small"
                    >
                        <Select
                            value={selectedTeam ? selectedTeam.id : 0}
                            onChange={handleTeamChange}
                        >
                            <MenuItem value={0}>All</MenuItem>
                            {teams &&
                                teams.map(item => (
                                    <MenuItem key={item.id} value={item.id}>
                                        {item.teamName}
                                    </MenuItem>
                                ))}
                        </Select>
                    </FormControl>
                    <InputLabel id="team-label" style={{ color: "black" }}>
                        Status:
                    </InputLabel>
                    <FormControl
                        sx={{
                            m: 1,
                            minWidth: 160
                        }}
                        size="small"
                    >
                        <Select
                            value={selectedStatus}
                            onChange={handleStatusChange}
                        >
                            <MenuItem value={0}>All</MenuItem>
                            {timesheetStatus &&
                                timesheetStatus.map(item => (
                                    <MenuItem
                                        key={item.statusID}
                                        value={item.statusID}
                                    >
                                        {item.statusName}
                                    </MenuItem>
                                ))}
                        </Select>
                    </FormControl>
                    {(userRole.roleName === "Reporting_Manager" ||
                        userRole.roleName === "HR") && (
                        <div className={css.calendar}>
                            <div className={css.tooltip}>
                                <CalendarTodayOutlined
                                    onClick={() => {
                                        setSelectDay(0);
                                        setToggleCalenderDisplay(
                                            !toggleCalenderDisplay
                                        );
                                    }}
                                ></CalendarTodayOutlined>
                                <span className={css.tooltiptext}>
                                    Select Week
                                </span>
                            </div>

                            <label
                                className={css.dayPickerLabel}
                                style={{ fontWeight: "bold" }}
                            >
                                Start Date :{" "}
                            </label>
                            <label>
                                {startDate &&
                                    new Date(
                                        startDate.split(" ")[0]
                                    ).toLocaleDateString("en-gb", {
                                        day: "2-digit",
                                        month: "short",
                                        year: "numeric"
                                    })}
                            </label>
                            <div className={css.tooltip}>
                                <CalendarTodayOutlined
                                    onClick={() => {
                                        setSelectDay(1);
                                        setToggleCalenderDisplay(
                                            !toggleCalenderDisplay
                                        );
                                    }}
                                ></CalendarTodayOutlined>
                                <span className={css.tooltiptext}>
                                    Select Week End
                                </span>
                            </div>
                            <label
                                className={css.dayPickerLabel}
                                style={{ fontWeight: "bold" }}
                            >
                                End Date :{" "}
                            </label>
                            <label>
                                {endDate &&
                                    new Date(
                                        endDate.split(" ")[0]
                                    ).toLocaleDateString("en-gb", {
                                        day: "2-digit",
                                        month: "short",
                                        year: "numeric"
                                    })}
                            </label>

                            {toggleCalenderDisplay && (
                                <div className={css.dayPicker}>
                                    <DayPicker
                                        modifiers={modifiers}
                                        modifiersStyles={modifiersStyles}
                                        styles={customStyles}
                                        onDayClick={handleDayClick}
                                    />
                                </div>
                            )}
                        </div>
                    )}
                    {userRole.roleName === "Admin" && (
                        <div className={css.button}>
                            <button
                                onClick={() =>
                                    handleGeneratePdfReport(startDate, endDate)
                                }
                                className={
                                    "btn btn-primary " + css.generateButton
                                }
                            >
                                Generate Report Pdf
                            </button>
                        </div>
                    )}{" "}
                    {userRole.roleName === "Admin" && (
                        <div className={css.buttonExcel}>
                            <button
                                onClick={() =>
                                    handleGenerateExcelReport(
                                        startDate,
                                        endDate
                                    )
                                }
                                className={
                                    "btn btn-primary " + css.generateButtonExcel
                                }
                            >
                                Generate Report Excel
                            </button>
                        </div>
                    )}
                </Stack>

                <div className={css.table} ref={dashboardRef}>
                    <ReportTable
                        data={activeReportData}
                        reportType={activeReport}
                    />
                </div>
            </Box>
        </>
    );
};

export default TimesheetReport;
