import { connect } from "react-redux";
import TimesheetListToolbar from "rootpath/components/Timesheet/TimesheetListToolbar/TimesheetListToolbar";
import { formatDate } from "rootpath/services/TimeSheet/TimesheetDataService";
import { setEndDate, setStartDate } from "rootpath/redux/timesheet/actions";
import { endOfWeek, startOfWeek } from "date-fns";

const mapStateToProps = state => ({
    userRole: state.skillMatrixOps.userRole || {},
    startDate: state.timeSheetOps.startDate || "",
    endDate: state.timeSheetOps.endDate || "",
    searchedText: state.timeSheetOps.searchedText || ""
});

const mapDispatchToProps = (dispatch, ownProps) => ({
    setDate: (selectDay, day) => {
        const startDate = startOfWeek(new Date(day));
        const endDate = endOfWeek(new Date(day));
        !selectDay && dispatch(setStartDate(startDate));
        dispatch(setEndDate(endDate));
    }
});

const TimesheetListToolbarContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(TimesheetListToolbar);

export default TimesheetListToolbarContainer;
