import { connect } from "react-redux";
import { getUpdateEmployeeDetails } from "rootpath/services/EmployeeBook/employee/EmployeeService";
import {
    setEmployeesDetail,
    setEmployeeNavigationId,
    setUpdatedEmployeesList
} from "rootpath/redux/common/actions";
import ManageEmployeeProfile from "rootpath/components/EmployeeBook/ManageEmployeeProfile/ManageEmployeeProfile";

const mapStateToProps = state => ({
    userRole: state.skillMatrixOps.userRole || {},
    updatedEmployeesList: state.skillMatrixOps.updatedEmployeesList || []
});

const mapDispatchToProps = dispatch => {
    return {
        fetchUpdatedEmployeesList: async () => {
            const updatedEmployees = await getUpdateEmployeeDetails();
            dispatch(setUpdatedEmployeesList(updatedEmployees));
        },

        setEmpNavigationId: (employeeId, updatedEmployeesList) => {
            const employee = updatedEmployeesList.filter(
                employee => employee.employeeId == employeeId
            );
            dispatch(setEmployeeNavigationId(employeeId));
            dispatch(setEmployeesDetail(employee[0]));
        }
    };
};

const ManageEmployeeProfileContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(ManageEmployeeProfile);

export default ManageEmployeeProfileContainer;
