import { connect } from "react-redux";
import {
    setAlert,
    setViewTimesheetData
} from "rootpath/redux/timesheet/actions";
import EditTimesheetV2 from "rootpath/components/Timesheet2.0/EditTimesheetV2Component/EditTimesheetV2";
import {
    mapTimesheetData,
    postTimesheet
} from "rootpath/services/Timesheet2.0/CreateTimesheetService";
import {
    deleteTimesheetDetail,
    viewTimesheet
} from "rootpath/services/Timesheet2.0/ViewTimesheetService";
import { formatDate } from "rootpath/services/TimeSheet/TimesheetDataService";

const mapStateToProps = state => ({
    showAlert: state.timeSheetOps.showAlert || {},
    statusId: state.timeSheetOps.viewTimesheetData.statusId
});

const mapDispatchToProps = dispatch => ({
    setShowAlert: (setAlertOpen = false, severity, message) => {
        const data = {
            setAlertOpen,
            severity,
            message
        };
        dispatch(setAlert(data));
    },

    saveTimesheet: async (
        data,
        selectedWeek,
        daySums,
        statusId,
        isEditMode,
        handleCancel
    ) => {
        let alertOptions = null;
        const dates = {
            startDate: formatDate(selectedWeek.from),
            endDate: formatDate(selectedWeek.to)
        };
        const timesheetData = mapTimesheetData(data, dates, statusId);
        let allDaysBelowTwentyFour = true;
        let HoursError = "";
        for (const day in daySums) {
            const hoursWorked = parseFloat(daySums[day]);
            if (hoursWorked > 24) {
                HoursError += day + " ";
                allDaysBelowTwentyFour = false;
            }
        }
        if (!allDaysBelowTwentyFour) {
            alertOptions = {
                setAlertOpen: true,
                severity: "error",
                message: `Summation of hours in ${HoursError}exceeded 24!!!`
            };
        } else {
            const result = await postTimesheet(timesheetData);
            if (result.success) {
                alertOptions = {
                    setAlertOpen: true,
                    severity: "success",
                    message: "Timesheet updated successfully!"
                };
                let timesheetDetails = await viewTimesheet(dates);
                timesheetDetails.dates = dates;
                dispatch(setViewTimesheetData(timesheetDetails));
                if (isEditMode) handleCancel();
            } else {
                alertOptions = {
                    setAlertOpen: true,
                    severity: "error",
                    message: "Timesheet updation failed!"
                };
            }
        }
        dispatch(setAlert(alertOptions));
    },
    deleteTimesheet: async (e, ids, dates) => {
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
    }
});
const EditTimesheetContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(EditTimesheetV2);
export default EditTimesheetContainer;
