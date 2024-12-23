import React, { useEffect, useState } from "react";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Grid from "@mui/material/Grid";
import { BarChart } from "rootpath/components/EmployeeBook/Analytics/BarChart";
import Stack from "@mui/material/Stack";
import FormControlLabel from "@mui/material/FormControlLabel";
import Switch from "@mui/material/Switch";
import MaterialTable from "@material-table/core";
import { DateFilter } from "rootpath/components/EmployeeBook/Analytics/DateFilter";
import {
    filterOptions,
    logColumns,
    googleAnalyticsColumns
} from "rootpath/services/EmployeeBook/AnalyticService/AnalyticData";
import { ChartFilter } from "rootpath/components/EmployeeBook/Analytics/ChartFilter";

const Analytics = ({
    logs,
    fetchLogs,
    chartData,
    fetchChartData,
    googleAnalyticsReport,
    fetchGoogleAnalyticsReport,
    chartObject,
    activeEmployeeCount,
    todayLoginEmployeeCount,
    userRole,
    fetchRole
}) => {
    const [filter, setFilter] = useState(filterOptions[2].value);
    const [showGoogleAnalytics, setShowGoogleAnalytics] = useState(true);
    const [showLogs, setShowLogs] = useState(false);

    const handleShowLogsChange = event => {
        setShowLogs(event.target.checked);
    };

    const handleShowAnalyticsChange = event => {
        setShowGoogleAnalytics(event.target.checked);
    };

    useEffect(() => {
        fetchGoogleAnalyticsReport();
    }, [fetchGoogleAnalyticsReport]);

    useEffect(() => {
        fetchChartData(filter);
    }, [filter, fetchChartData]);

    useEffect(() => {
        fetchLogs();
    }, [fetchLogs]);

    useEffect(() => {
        fetchRole();
    }, [fetchRole]);

    const handleHomeClick = () => {
        history.push("/employeebook/");
    };

    return userRole?.roleName === "Admin" ? (
        <Box flexGrow={1} className="container">
            <Typography
                m="10px 0"
                textAlign="center"
                variant="h4"
                marginTop="20px"
                marginBottom="30px"
                backgroundColor="#f3eeed"
                borderRadius="30px"
            >
                ANALYTICS
            </Typography>
            <Box
                display="flex"
                p={1}
                m={1}
                backgroundColor="background.paper"
                borderRadius={1}
                marginLeft="20px"
                flexDirection="row"
            >
                <Box
                    component="section"
                    p={2}
                    border="1px thin grey"
                    width="15%"
                    backgroundColor="#229954"
                    color="#FFFFFF"
                    fontSize="15px"
                    textAlign="center"
                    fontWeight={600}
                >
                    TOTAL EMPLOYEES : {activeEmployeeCount}
                </Box>

                <Box
                    component="section"
                    p={2}
                    border="1px thin grey"
                    width="15%"
                    backgroundColor="#213f93"
                    color="#FFFFFF"
                    fontSize="15px"
                    textAlign="center"
                    marginLeft="15px"
                    fontWeight={600}
                >
                    EMPLOYEE LOGIN TODAY : {todayLoginEmployeeCount}
                </Box>

                <Stack direction="row" spacing={2} marginBottom="10px">
                    <FormControlLabel
                        control={
                            <Switch
                                checked={showLogs}
                                onChange={handleShowLogsChange}
                                inputProps={{
                                    "aria-label": "controlled"
                                }}
                            />
                        }
                        label="Show Logs"
                    />

                    <FormControlLabel
                        control={
                            <Switch
                                checked={showGoogleAnalytics}
                                onChange={handleShowAnalyticsChange}
                                inputProps={{
                                    "aria-label": "controlled"
                                }}
                            />
                        }
                        label="Show Google Analytics Report"
                    />
                </Stack>
            </Box>

            <Grid>
                {showGoogleAnalytics && (
                    <Box marginBottom="30px" width="100%">
                        <Typography
                            variant="h4"
                            textAlign="center"
                            marginBottom="30px"
                            backgroundColor="#f3eeed"
                            borderRadius="30px"
                        >
                            Google Analytic Report
                        </Typography>

                        <DateFilter onSubmit={fetchGoogleAnalyticsReport} />

                        <MaterialTable
                            columns={googleAnalyticsColumns}
                            data={googleAnalyticsReport}
                            options={{
                                search: true,
                                toolbar: false,
                                maxBodyHeight: "100%",
                                actionsColumnIndex: -1,
                                headerStyle: {
                                    backgroundColor: "#17072b",
                                    color: "#fff"
                                }
                            }}
                            style={{
                                height: "80%"
                            }}
                            localization={{
                                body: {
                                    emptyDataSourceMessage:
                                        "No report exist, please use filter to get reports !!"
                                }
                            }}
                        />
                    </Box>
                )}

                <Box margin="auto">
                    <Typography
                        variant="h4"
                        textAlign="center"
                        marginBottom="30px"
                        marginTop="30px"
                        backgroundColor="#f3eeed"
                        borderRadius="30px"
                    >
                        Daily Employee Login Chart
                    </Typography>

                    <Stack direction="row" spacing={2} marginBottom="10px">
                        <ChartFilter
                            onHandleChartFilterChange={(
                                filter,
                                startDate,
                                endDate
                            ) => fetchChartData(filter, startDate, endDate)}
                        ></ChartFilter>
                    </Stack>
                    {Object.keys(chartObject).length !== 0 && (
                        <BarChart chartData={chartObject} />
                    )}
                </Box>

                {showLogs && (
                    <Box marginBottom="30px" width="100%">
                        <Typography
                            variant="h4"
                            textAlign="center"
                            marginBottom="30px"
                            marginTop="30px"
                            backgroundColor="#f3eeed"
                            borderRadius="30px"
                        >
                            Logs
                        </Typography>

                        <MaterialTable
                            columns={logColumns}
                            data={logs}
                            options={{
                                search: true,
                                toolbar: false,
                                maxBodyHeight: "100%",
                                actionsColumnIndex: -1,
                                headerStyle: {
                                    backgroundColor: "#17072b",
                                    color: "#fff"
                                }
                            }}
                            style={{
                                height: "100%"
                            }}
                            localization={{
                                body: {
                                    emptyDataSourceMessage: "No logs exist !!"
                                }
                            }}
                        />
                    </Box>
                )}
            </Grid>
        </Box>
    ) : (
        <Box className="container">
            <Typography m="20px 0" textAlign="center" variant="h6">
                You do not have permission for this page.
            </Typography>
            <Typography
                m="20px 0"
                textAlign="center"
                variant="h6"
                backgroundColor="#fff"
                onClick={handleHomeClick}
                sx={{ cursor: "pointer", "&:hover": { color: "Blue" } }}
            >
                Go To Home Page
            </Typography>
        </Box>
    );
};
export default Analytics;
