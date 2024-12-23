import { connect } from "react-redux";
import {
    postTimeSheetApi,
    getEmployeeProject,
    getTimesheetCategoryApi,
    getTimesheetSubCategoryApi,
    getProjectsForOnBehalfEmployeeApi,
    getTimesheetEmployeeApi
} from "./TimesheetDetailsFunction";
import {
    setTimeSheetDetail,
    setTimeSheetCategories,
    setTimeSheetSubCategories,
    setTimeSheetEmpProject,
    setTimsheetEmployees,
    setTimeSheetClients,
    setSummationData,
    setListOfDuplicateTasks,
    setAlert
} from "rootpath/redux/timesheet/actions";
import TimesheetDetails from "./TimesheetDetails";
import {
    mapTimesheetData,
    mapTimesheetPostData,
    setPartialSubmission
} from "rootpath/services/TimeSheet/TimesheetDataService";
import { getClientsList } from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
const mapStateToProps = state => ({
    timesheetDetail: state.timeSheetOps.timeSheetDetail || [],
    timesheetCategories: state.timeSheetOps.timeSheetCategories,
    timesheetSubCategories: state.timeSheetOps.timeSheetSubCategories,
    employeeProject: state.timeSheetOps.employeeProject,
    timesheetEmployees: state.timeSheetOps.timeSheetEmployees,
    isBehalfOpen: state.timeSheetOps.isBehalfOpen,
    selectedProject: state.timeSheetOps.selectedProject,
    timesheetTitle: state.timeSheetOps.timesheetTitle,
    selectedTimesheetStatus: state.timeSheetOps.selectedTimesheetStatus,
    displayHeader: state.timeSheetOps.displayHeader,
    timesheetId: state.timeSheetOps.timesheetId,
    userRole: state.skillMatrixOps.userRole || {},
    clients: state.timeSheetOps.timesheetClients || [],
    summationData: state.timeSheetOps.summationData || [],
    listOfduplicateTask: state.timeSheetOps.listOfduplicateTask || {}
});

const mapDispatchToProps = dispatch => {
    const weekData = [
        { 1: "Sun" },
        { 2: "Mon" },
        { 3: "Tue" },
        { 4: "Wed" },
        { 5: "Thu" },
        { 6: "Fri" },
        { 7: "Sat" }
    ];
    return {
        fetchEmployeeProject: async (selectedProject, isBehalfOpen) => {
            const results =
                selectedProject &&
                Object.keys(selectedProject).length > 0 &&
                isBehalfOpen
                    ? [
                          {
                              projectId: selectedProject.id,
                              clientName: selectedProject.clientName
                          }
                      ]
                    : await getEmployeeProject();
            dispatch(setTimeSheetEmpProject(results));
        },
        fetchTimesheetDetailCreatedOnBehalf: async (
            params,
            showAlert,
            setCanEdit,
            setData,
            setIsTimesheetWithPartialSubmission,
            setIsProjectSelectionDisabled,
            dataCopy,
            setMessageForApprovedOrSubmitted,
            setIsSubmitted
        ) => {
            // dispatch(setTimeSheetDetail([]));
            const tableData = await mapTimesheetData(
                null,
                params,
                params.isBehalf
            );
            if (Object.keys(tableData).length > 0 && tableData.msg) {
                setMessageForApprovedOrSubmitted(tableData.msg);
                setIsSubmitted(true);
                // showAlert("error", tableData.msg);
                setCanEdit(false);
                setData([]);
                dataCopy.current = [];
                return false;
            } else {
                setCanEdit(true);
                tableData.filter(x => x.statusId === 4 || x.statusId === 2)
                    .length > 0 &&
                tableData.filter(x => x.statusId === 3 || x.statusId === 1)
                    .length > 0
                    ? setPartialSubmission(
                          setIsTimesheetWithPartialSubmission,
                          setIsProjectSelectionDisabled,
                          true
                      )
                    : setPartialSubmission(
                          setIsTimesheetWithPartialSubmission,
                          setIsProjectSelectionDisabled,
                          false
                      );
                dispatch(setTimeSheetDetail(tableData));
                return true;
            }
        },
        fetchTimesheetCategory: async () => {
            const category = await getTimesheetCategoryApi();
            dispatch(setTimeSheetCategories(category));
        },
        fetchTimesheetSubCategory: async () => {
            const subCategory = await getTimesheetSubCategoryApi();
            dispatch(setTimeSheetSubCategories(subCategory));
        },
        fetchtimesheetDetail: async timesheetId => {
            const tableData = await mapTimesheetData(timesheetId, null);
            dispatch(setTimeSheetDetail(tableData));
        },
        fetchtimesheetDetailByDate: async (
            dates,
            setIsTimesheetWithPartialSubmission,
            setIsProjectSelectionDisabled
        ) => {
            const tableData = await mapTimesheetData(null, dates);

            tableData.filter(x => x.statusId === 4 || x.statusId === 2).length >
                0 &&
            tableData.filter(x => x.statusId === 3 || x.statusId === 1).length >
                0
                ? setPartialSubmission(
                      setIsTimesheetWithPartialSubmission,
                      setIsProjectSelectionDisabled,
                      true
                  )
                : setPartialSubmission(
                      setIsTimesheetWithPartialSubmission,
                      setIsProjectSelectionDisabled,
                      false
                  );
            dispatch(setTimeSheetDetail(tableData));
        },
        fetchTimesheetEmployee: async projectId => {
            const timsheetEmployees = projectId
                ? await getTimesheetEmployeeApi(projectId)
                : await getTimesheetEmployeeApi();

            dispatch(setTimsheetEmployees(timsheetEmployees));
        },
        resetTimesheetDetail: () => {
            dispatch(setTimeSheetDetail([]));
        },
        fetchClientList: async () => {
            const clients = await getClientsList();
            dispatch(setTimeSheetClients(clients));
        },
        postTimeSheetApi: async (
            enteries,
            selectedWeek,
            selectedEmployee,
            timesheetId,
            actionName
        ) => {
            const toPost = mapTimesheetPostData(
                enteries,
                selectedWeek,
                selectedEmployee,
                timesheetId
            );
            return await postTimeSheetApi(toPost, actionName);
        },
        setSummationData: data => {
            dispatch(setSummationData(data));
        },
        setListOfDuplicateTasks: data => {
            dispatch(setListOfDuplicateTasks(data));
        },
        setShowAlert: (setAlertOpen = false, severity, message) => {
            const data = {
                setAlertOpen,
                severity,
                message
            };
            dispatch(setAlert(data));
        }
    };
};

const TimesheetDetailsContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(TimesheetDetails);
export default TimesheetDetailsContainer;
