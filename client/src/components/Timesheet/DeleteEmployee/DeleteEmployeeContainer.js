import { connect } from "react-redux";
import { getDeleteEmployeeList } from "rootpath/redux/common/actions";
import DeleteEmployee from "./DeleteEmployee";
import {
    GetDeleteEmployeeList,
    hardDeleteEmployeeList,
    recoverDeleteEmployeeList
} from "rootpath/services/TimeSheet/DeleteEmployeeService";
import { setAlert } from "rootpath/redux/timesheet/actions";

const mapStateToProps = state => ({
    deleteEmployeeList: state.skillMatrixOps.deleteEmployeeList || [],
    alert: state.timeSheetOps.showAlert || {}
});

const mapDispatchToProps = dispatch => ({
    fetchDeleteEmployeeList: async () => {
        const empList = await GetDeleteEmployeeList();
        dispatch(getDeleteEmployeeList(empList));
    },
    hardDeleteEmployeeList: async listOfEmpId => {
        return await hardDeleteEmployeeList(listOfEmpId);
    },
    recoverDeleteEmployeeList: async listOfEmpId => {
        return await recoverDeleteEmployeeList(listOfEmpId);
    },
    setShowAlert: (setAlertOpen = false, severity, message) => {
        const data = {
            setAlertOpen,
            severity,
            message
        };
        dispatch(setAlert(data));
    }
});

const DeleteEmployeeContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(DeleteEmployee);

export default DeleteEmployeeContainer;
