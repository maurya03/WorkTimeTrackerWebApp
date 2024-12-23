import { connect } from "react-redux";
import ViewTimesheet from "rootpath/components/Timesheet2.0/ViewTimesheetComponent/ViewTimesheet";
import {
    setAlert,
    setShowDialogBox,
    setViewTimesheetData
} from "rootpath/redux/timesheet/actions";
import { postUserRole } from "rootpath/redux/common/actions";
import { getLoggedinUserRole } from "rootpath/services/SkillMatrix/RoleService/RoleService";
import { UpdateTimeSheetStatusApi } from "rootpath/services/TimeSheet/TimeSheetPostAndGetServices";
import {
    deleteTimesheetDetail,
    viewTimesheet
} from "rootpath/services/Timesheet2.0/ViewTimesheetService";
import {
    emailPayload,
    submitPayload
} from "rootpath/components/Timesheet2.0/ViewTimesheetComponent/Constant";
import { formatDate } from "rootpath/services/TimeSheet/TimesheetDataService";

const mapStateToProps = state => {
    return {
        userRole: state.skillMatrixOps.userRole || {},
        showAlert: state.timeSheetOps.showAlert || {},
        showDialogBox: state.timeSheetOps.showDialogBox || {}
    };
};
const mapDispatchToProps = dispatch => ({
    fetchRole: async () => {
        const role = await getLoggedinUserRole();
        dispatch(postUserRole(role));
    },
    setShowAlert: (setAlertOpen = false, severity, message) => {
        const data = {
            setAlertOpen,
            severity,
            message
        };
        dispatch(setAlert(data));
    },
    setShowDialogBox: (open = false, title, content, onConfirm) => {
        const data = {
            open,
            title,
            content,
            onConfirm
        };
        dispatch(setShowDialogBox(data));
    },
    onDelete: async (e, ids, dates) => {
        const response = await deleteTimesheetDetail(ids.join(","));
        let alertOptions = null;
        if (response.success) {
            alertOptions = {
                setAlertOpen: true,
                severity: "success",
                message: "Task deleted successfully!"
            };
            let timesheetDetails = await viewTimesheet(dates);
            timesheetDetails.dates = dates;
            dispatch(setViewTimesheetData(timesheetDetails));
        } else {
            alertOptions = {
                setAlertOpen: true,
                severity: "error",
                message: "Error in deleting task!"
            };
        }
        dispatch(setAlert(alertOptions));
    },
    validateTimesheetDetail: daySums => {
        const weekSum = Object.values(daySums).reduce(
            (sum, hours) => sum + parseFloat(hours),
            0
        );
        const error =
            weekSum < 40 && false
                ? "Minimum 40 hours required to submit the timesheet"
                : "";
        error.length > 0 &&
            dispatch(
                setAlert({
                    setAlertOpen: true,
                    severity: "error",
                    message: error
                })
            );
        return error;
    },
    onSubmit: async selectedWeek => {
        const payload = submitPayload(
            formatDate(selectedWeek.from),
            formatDate(selectedWeek.to),
            0
        );
        const emailQuery = emailPayload(
            localStorage.getItem("userEmailId"),
            formatDate(selectedWeek.from),
            formatDate(selectedWeek.to),
            ""
        );
        const result = await UpdateTimeSheetStatusApi(payload, emailQuery);
        let alertOptions = null;
        if (result.status == 202) {
            const dates = {
                startDate: formatDate(selectedWeek.from),
                endDate: formatDate(selectedWeek.to)
            };
            alertOptions = {
                setAlertOpen: true,
                severity: "success",
                message: "Timesheet submitted successfully!"
            };
            let timesheetDetails = await viewTimesheet(dates);
            timesheetDetails.dates = dates;
            dispatch(setViewTimesheetData(timesheetDetails));
            dispatch(setShowDialogBox(false));
        } else {
            alertOptions = {
                setAlertOpen: true,
                severity: "error",
                message: "Timesheet submit failed!"
            };
        }
        dispatch(setAlert(alertOptions));
    }
});
const ViewTimesheetContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(ViewTimesheet);

export default ViewTimesheetContainer;
