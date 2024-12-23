import { connect } from "react-redux";
import {
    setAlert,
    setViewTimesheetData,
    setManagerAndApprover
} from "rootpath/redux/timesheet/actions";
import { postUserRole } from "rootpath/redux/common/actions";
import CreateTimesheetV2 from "rootpath/components/Timesheet2.0/CreateTimesheetV2Component/CreateTimesheetV2";
import {
    mapTimesheetData,
    postTimesheet
} from "rootpath/services/Timesheet2.0/CreateTimesheetService";
import { viewTimesheet } from "rootpath/services/Timesheet2.0/ViewTimesheetService";
import { formatDate } from "rootpath/services/TimeSheet/TimesheetDataService";
import { getManagerAndApproverByEmployeeId } from "rootpath/services/TimeSheet/TimeSheetPostAndGetServices";
import { getLoggedinUserRole } from "rootpath/services/SkillMatrix/RoleService/RoleService";

const mapStateToProps = state => ({
    showAlert: state.timeSheetOps.showAlert || {},
    managerAndApprover: state.timeSheetOps.managerAndApprover || [],
    userRole: state.skillMatrixOps.userRole || {}
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
    fetchRole: async () => {
        const role = await getLoggedinUserRole();
        dispatch(postUserRole(role));
    },
    fetchManagerAndApprover: async empId => {
        const managerAndApprover = await getManagerAndApproverByEmployeeId(
            empId
        );
        dispatch(setManagerAndApprover(managerAndApprover));
    },
    saveTimesheet: async (data, selectedWeek, daySums) => {
        let alertOptions = null;
        const status = { draft: 1 };
        const dates = {
            startDate: formatDate(selectedWeek.from),
            endDate: formatDate(selectedWeek.to)
        };
        const timesheetData = mapTimesheetData(data, dates, status.draft);
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
                    message: "Timesheet created successfully!"
                };
                let timesheetDetails = await viewTimesheet(dates);
                timesheetDetails.dates = dates;
                dispatch(setViewTimesheetData(timesheetDetails));
            } else {
                alertOptions = {
                    setAlertOpen: true,
                    severity: "error",
                    message: "Timesheet submission failed!"
                };
            }
        }
        dispatch(setAlert(alertOptions));
    }
});
const CreateTimesheetV2Container = connect(
    mapStateToProps,
    mapDispatchToProps
)(CreateTimesheetV2);
export default CreateTimesheetV2Container;
