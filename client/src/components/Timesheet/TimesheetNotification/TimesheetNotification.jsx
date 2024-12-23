import React, { useState, useEffect, useLayoutEffect, useRef } from "react";
import InputLabel from "@mui/material/InputLabel";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Stack from "@mui/material/Stack";
import FormControl from "@mui/material/FormControl";
import Radio from "@mui/material/Radio";
import RadioGroup from "@mui/material/RadioGroup";
import Button from "rootpath/components/SkillMatrix/Button/Button";
import FormControlLabel from "@mui/material/FormControlLabel";
import Select from "@mui/material/Select";
import MenuItem from "@mui/material/MenuItem";
import MaterialTable from "@material-table/core";
import { DayPicker } from "react-day-picker";
import { CalendarTodayOutlined } from "@material-ui/icons";
import styles from "./TimesheetNotification.css";
import CustomAlert from "rootpath/components/CustomAlert";
import Checkbox from "@mui/material/Checkbox";

const TimesheetNotification = ({
    userRole,
    fetchRole,
    timesheetEmailData,
    getTimesheetEmailData,
    fetchClientList,
    fetchClientTeamsList,
    fetchClientManagerTeamsList,
    clients,
    teams,
    sendTimesheetEmail,
    setShowAlert,
    alert
}) => {
    const [toggleCalenderDisplay, setToggleCalenderDisplay] = useState(false);
    const [selectDay, setSelectDay] = useState(null);
    const [selectedClient, setSelectedClient] = useState(0);
    const [selectedTeam, setSelectedTeam] = useState(0);
    const [isTimesheetCreated, setIsTimesheetCreated] = useState("No");
    const [isTimesheetSubmitted, setIsTimesheetSubmitted] = useState("No");
    const [selectedData, setSelectedData] = useState([]);
    const dashboardRef = useRef();

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

    const data = {
        ClientId: selectedClient,
        TeamId: selectedTeam ? selectedTeam.id : 0,
        StartDate: startDate,
        EndDate: endDate,
        IsTimesheetCreated: isTimesheetCreated,
        IsTimesheetSubmitted: isTimesheetSubmitted
    };

    useEffect(() => {
        fetchRole();
    }, [fetchRole]);

    useLayoutEffect(() => {
        dashboardRef.current.style.height = `${window.innerHeight - 140}px`;
    }, []);

    useEffect(() => {
        fetchClientList();
        console.log(selectedData);
    }, [fetchClientList]);

    useEffect(() => {
        getTimesheetEmailData(data);
    }, [
        getTimesheetEmailData,
        selectedClient,
        startDate,
        endDate,
        isTimesheetCreated,
        isTimesheetSubmitted
    ]);

    useEffect(() => {
        if (userRole.roleName === "Reporting_Manager") {
            setSelectedTeam(0);
            fetchClientManagerTeamsList(userRole.clientId, userRole.employeeId);
        } else if (selectedClient !== "") {
            setSelectedTeam(0);
            fetchClientTeamsList(selectedClient);
        }
    }, [userRole, selectedClient, fetchClientTeamsList]);

    useEffect(() => {
        if (selectedTeam && selectedTeam.id > 0) {
            getTimesheetEmailData(data);
        } else {
            setSelectedTeam(0);
            getTimesheetEmailData(data);
        }
    }, [selectedTeam, getTimesheetEmailData]);

    const handleClietChange = event => {
        setSelectedClient(event.target.value);
    };

    const handleTeamChange = event => {
        const selectedTeam1 = teams.find(x => x.id == event.target.value);
        setSelectedTeam(selectedTeam1);
    };
    const handleTimesheetCreatedChange = event => {
        setIsTimesheetCreated(event.target.value);
    };
    const handleTimesheetSubmittedChange = event => {
        setIsTimesheetSubmitted(event.target.value);
    };
    const handleCheckboxChange = (event, rowData) => {
        if (event.target.checked) {
            setSelectedData(prevSelected => [...prevSelected, rowData]);
        } else {
            setSelectedData(prevSelected =>
                prevSelected.filter(data => data.emailId !== rowData.emailId)
            );
        }
    };
    const isRowSelected = rowData => {
        return selectedData.some(data => data.emailId === rowData.emailId);
    };

    const onSendEmail = async () => {
        const emailList = selectedData.map(item => item.emailId);
        setSelectedData([]);
        const data = {
            EmailIds: emailList,
            StartDate: startDate,
            EndDate: endDate
        };
        const response = await sendTimesheetEmail(data);
        if (response.success)
            setShowAlert(true, "success", "Email send successfully!");
        else setShowAlert(true, "error", "Error sending Email");
    };

    const tableColumns = [
        ...(isTimesheetSubmitted !== "Yes"
            ? [
                  {
                      title: "",
                      field: "checkbox",
                      render: rowData => (
                          <Checkbox
                              checked={isRowSelected(rowData)}
                              onChange={event =>
                                  handleCheckboxChange(event, rowData)
                              }
                          />
                      ),
                      width: "10%"
                  }
              ]
            : []),
        {
            title: "Employee Name",
            field: "employeeName",
            width: "calc(100%-20px)"
        },
        {
            title: "Email Id",
            field: "emailId",
            width: "calc(100%-20px)"
        },
        {
            title: "Project",
            field: "project",
            width: "calc(100%-20px)"
        },
        {
            title: "Created Date",
            field: "createdDate",
            width: "calc(100%-20px)",
            render: rowData => {
                const value =
                    rowData.createdDate === ""
                        ? "-"
                        : rowData.createdDate.split("T")[0];
                return <Typography>{value}</Typography>;
            }
        },
        {
            title: "Submitted Date",
            field: "submittedDate",
            width: "calc(100%-20px)",
            render: rowData => {
                const value =
                    rowData.submittedDate === ""
                        ? "-"
                        : rowData.submittedDate.split("T")[0];
                return <Typography>{value}</Typography>;
            }
        },
        {
            title: "Week Start Date",
            field: "weekStartDate",
            width: "calc(100%-20px)",
            render: rowData => {
                const value =
                    rowData.weekStartDate === ""
                        ? "-"
                        : rowData.weekStartDate.split("T")[0];
                return <Typography>{value}</Typography>;
            }
        },
        {
            title: "Week End Date",
            field: "weekEndDate",
            width: "calc(100%-20px)",
            render: rowData => {
                const value =
                    rowData.weekEndDate === ""
                        ? "-"
                        : rowData.weekEndDate.split("T")[0];
                return <Typography>{value}</Typography>;
            }
        },
        {
            title: "Approved/Rejected Date",
            field: "approvedRejectedDate",
            width: "calc(100%-20px)",
            render: rowData => {
                const value =
                    rowData.approvedRejectedDate === null
                        ? "-"
                        : rowData.approvedRejectedDate.split("T")[0];
                return <Typography>{value}</Typography>;
            }
        },
        {
            title: "TotalHours",
            field: "totalHours",
            width: "calc(100%-20px)",
            render: rowData => {
                const value =
                    rowData.totalHours.trim() === "" ? "-" : rowData.totalHours;
                return <Typography>{value}</Typography>;
            }
        }
    ];

    return (
        <>
            <Box className="container">
                {alert.setAlertOpen && Object.keys(alert).length > 0 && (
                    <CustomAlert
                        open={alert.setAlertOpen}
                        severity={alert.severity}
                        message={alert.message}
                        className={styles.alertStyle}
                        onClose={() => setShowAlert(false, "", "")}
                    ></CustomAlert>
                )}
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
                        width="20%"
                        sx={{
                            textOverflow: "ellipses",
                            overflow: "hidden",
                            whiteSpace: "nowrap",
                            cursor: "pointer"
                        }}
                    >
                        Send Notification
                    </Typography>

                    <Stack
                        direction="row"
                        alignItems="center"
                        marginRight="50px"
                        display="flex"
                    >
                        {(userRole.roleName === "Admin" ||
                            userRole.roleName === "Reporting_Manager") && (
                            <div className={styles.calendar}>
                                <div className={styles.tooltip}>
                                    <CalendarTodayOutlined
                                        onClick={() => {
                                            setSelectDay(0);
                                            setToggleCalenderDisplay(
                                                !toggleCalenderDisplay
                                            );
                                        }}
                                    ></CalendarTodayOutlined>
                                    <span className={styles.tooltiptext}>
                                        Select Week
                                    </span>
                                </div>

                                <label
                                    className={styles.dayPickerLabel}
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
                                <div className={styles.tooltip}>
                                    <CalendarTodayOutlined
                                        onClick={() => {
                                            setSelectDay(1);
                                            setToggleCalenderDisplay(
                                                !toggleCalenderDisplay
                                            );
                                        }}
                                    ></CalendarTodayOutlined>
                                    <span className={styles.tooltiptext}>
                                        Select Week End
                                    </span>
                                </div>
                                <label
                                    className={styles.dayPickerLabel}
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
                                    <div className={styles.dayPicker}>
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
                </Stack>

                <Stack alignItems="center" direction="row">
                    {userRole.roleName !== "Reporting_Manager" && (
                        <InputLabel id="clint-label" style={{ color: "black" }}>
                            Client:
                        </InputLabel>
                    )}
                    {userRole.roleName !== "Reporting_Manager" && (
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
                                        <MenuItem key={item.id} value={item.id}>
                                            {item.clientName}
                                        </MenuItem>
                                    ))}
                            </Select>
                        </FormControl>
                    )}
                    <InputLabel style={{ color: "black" }} id="team-label">
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
                    <InputLabel
                        style={{
                            color: "black"
                        }}
                    >
                        Timesheet Created:
                    </InputLabel>
                    <FormControl
                        sx={{
                            m: 1,
                            minWidth: 100
                        }}
                        size="small"
                    >
                        <RadioGroup
                            row
                            value={isTimesheetCreated}
                            onChange={handleTimesheetCreatedChange}
                        >
                            <FormControlLabel
                                value="Yes"
                                control={<Radio />}
                                label="Yes"
                            />
                            <FormControlLabel
                                value="No"
                                control={<Radio />}
                                label="No"
                            />
                        </RadioGroup>
                    </FormControl>
                    <InputLabel
                        style={{
                            color: "black"
                        }}
                    >
                        Timesheet Submitted:
                    </InputLabel>
                    <FormControl
                        sx={{
                            m: 1,
                            minWidth: userRole.roleName === "Admin" ? 260 : 480
                        }}
                        size="small"
                    >
                        <RadioGroup
                            row
                            value={isTimesheetSubmitted}
                            onChange={handleTimesheetSubmittedChange}
                            InputLabelProps={{ shrink: false }}
                            variant="outlined"
                        >
                            <FormControlLabel
                                value="Yes"
                                control={<Radio />}
                                label="Yes"
                            />
                            <FormControlLabel
                                value="No"
                                control={<Radio />}
                                label="No"
                            />
                        </RadioGroup>
                    </FormControl>

                    {selectedData.length > 0 && (
                        <Button
                            className={styles.contentHeaderButtons}
                            variant="contained"
                            sx={{
                                marginLeft: "50px"
                            }}
                            handleClick={() => onSendEmail()}
                            value="Send Email"
                        />
                    )}
                </Stack>

                <div className={styles.table} ref={dashboardRef}>
                    {timesheetEmailData.length > 0 ? (
                        <MaterialTable
                            columns={tableColumns}
                            data={timesheetEmailData}
                            options={{
                                toolbar: true,
                                maxBodyHeight: "100%",
                                thirdSortClick: false,

                                showTextRowsSelected: false,
                                search: true,
                                pageSize: 20,
                                headerStyle: {
                                    backgroundColor: "#17072b",
                                    color: "#ffff"
                                },
                                showTitle: false,
                                exportButton: true,
                                exportAllData: true,
                                draggable: false
                            }}
                            style={{
                                height: "100%"
                            }}
                        />
                    ) : (
                        <div className={styles.noRecords}>
                            There are no records to display
                        </div>
                    )}
                </div>
            </Box>
        </>
    );
};

export default TimesheetNotification;
