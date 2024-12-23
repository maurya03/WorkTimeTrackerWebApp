import { connect } from "react-redux";
import {
    setUpdatedEmployeeDetailById,
    setUpdatedEmployeesList
} from "rootpath/redux/common/actions";
import ManageEmployee from "rootpath/components/EmployeeBook/ManageEmployeeProfile/ManageEmployee.jsx";
import {
    getUpdatedEmployeeDetailById,
    getUpdateEmployeeDetails
} from "rootpath/services/EmployeeBook/employee/EmployeeService";

const mapStateToProps = state => ({
    employeeDetail: state.employeesBookOps.employeeDetail || {},
    userRole: state.employeesBookOps.userRole || {},
    designations: state.employeesBookOps.designations || [],
    projectList: state.employeesBookOps.projectList || [],
    updatedEmployeeById: state.employeesBookOps.updatedEmployeeById || [],
    updatedEmployeesList: state.employeesBookOps.updatedEmployeesList || []
});

const mapDispatchToProps = dispatch => {
    return {
        fetchUpdatedEmployeeDetailById: async id => {
            const updatedEmployees = await getUpdatedEmployeeDetailById(id);
            dispatch(setUpdatedEmployeeDetailById(updatedEmployees));
        },
        fetchUpdatedEmployeesList: async () => {
            const updatedEmployees = await getUpdateEmployeeDetails();
            dispatch(setUpdatedEmployeesList(updatedEmployees));
        }
    };
};

const ManageEmployeeContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(ManageEmployee);

export default ManageEmployeeContainer;
