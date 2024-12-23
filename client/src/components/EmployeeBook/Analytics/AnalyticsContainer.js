import { connect } from "react-redux";
import moment from "moment";
import {
    setChartData,
    setLogs,
    setGoogleAnalyticsReport,
    setChartObject,
    setActiveEmployeeCount,
    setTodayLoginEmployeeCount,
    postUserRole
} from "rootpath/redux/common/actions";
import { getLoggedInUserRole } from "rootpath/services/EmployeeBook/RoleService";
import Analytics from "rootpath/components/EmployeeBook/Analytics/Analytics";
import {
    getChartData,
    getLogs,
    getGoogleAnalyticsReport
} from "rootpath/services/EmployeeBook/AnalyticService/AnalyticService";
import { getChartObject } from "rootpath/services/EmployeeBook/AnalyticService/AnalyticData";

const mapStateToProps = state => ({
    logs: state.skillMatrixOps.logs || [],
    chartData: state.skillMatrixOps.chartData || {},
    chartObject: state.skillMatrixOps.chartObject || {},
    activeEmployeeCount: state.skillMatrixOps.activeEmployeeCount || 0,
    todayLoginEmployeeCount: state.skillMatrixOps.todayLoginEmployeeCount || 0,
    googleAnalyticsReport: state.skillMatrixOps.googleAnalyticsReport || [],
    userRole: state.skillMatrixOps.userRole || {}
});

const mapDispatchToProps = dispatch => {
    return {
        fetchLogs: async () => {
            const logs = await getLogs("Employeebook");
            const result = logs.map(row => {
                return {
                    ...row,
                    createdDate: moment(row.createdDate).format(
                        "YYYY-MM-DD HH:mm:ss"
                    )
                };
            });
            dispatch(setLogs(result));
        },
        fetchChartData: async (filter, startDate, endDate) => {
            const result = await getChartData(filter, startDate, endDate);
            dispatch(setChartData(result));
            dispatch(setChartObject(getChartObject(result)));
            dispatch(setActiveEmployeeCount(result.activeEmployeeCount));
            dispatch(
                setTodayLoginEmployeeCount(result.dailyEmployeeLoginCount)
            );
        },
        fetchGoogleAnalyticsReport: async (startDate, endDate) => {
            const result = await getGoogleAnalyticsReport(startDate, endDate);
            dispatch(setGoogleAnalyticsReport(result));
        },
        fetchRole: async () => {
            const role = await getLoggedInUserRole();
            dispatch(postUserRole(role));
        }
    };
};

const AnalyticsContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(Analytics);

export default AnalyticsContainer;
