import { connect } from "react-redux";
import { getClientsList } from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import {
    setTimeSheetClients,
    setTimsheetEmployees,
    setTimeSheetEmpProject
} from "rootpath/redux/timesheet/actions";
import {
    GetTimesheetEmployeeApi,
    GetEmployeeProjectApi
} from "rootpath/services/TimeSheet/TimeSheetPostAndGetServices";
import CreateTimesheetOnBehalf from "rootpath/components/Timesheet2.0/CreateTimesheetOnBehalf/CreateTimesheetOnBehalf";

const mapStateToProps = state => ({
    clients: state.timeSheetOps.timesheetClients || [],
    timesheetEmployees: state.timeSheetOps.timeSheetEmployees || [],
    selectedProject: state.timeSheetOps.selectedProject
});

const mapDispatchToProps = dispatch => {
    return {
        fetchEmployeeProject: async selectedProject => {
            const result =
                selectedProject && Object.keys(selectedProject).length > 0
                    ? [
                          {
                              projectId: selectedProject.id,
                              clientName: selectedProject.clientName
                          }
                      ]
                    : await GetEmployeeProjectApi();
            dispatch(setTimeSheetEmpProject(result));
        },
        fetchClientList: async () => {
            const clients = await getClientsList();
            dispatch(setTimeSheetClients(clients));
        },
        fetchTimesheetEmployee: async projectId => {
            const timsheetEmployees = projectId
                ? await GetTimesheetEmployeeApi(projectId)
                : await GetTimesheetEmployeeApi();
            dispatch(setTimsheetEmployees(timsheetEmployees));
        }
    };
};

const CreateTimesheetOnBehalfContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(CreateTimesheetOnBehalf);

export default CreateTimesheetOnBehalfContainer;
