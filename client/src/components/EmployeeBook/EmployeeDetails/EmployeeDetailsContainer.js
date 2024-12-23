import { connect } from "react-redux";
import {
    setEmployeesDetail,
    postUserRole,
    setDesignations,
    setProjectList,
    setAllEmployees,
    setEmployeeList
} from "rootpath/redux/common/actions";
import EmployeeDetails from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeeDetails.jsx";
import { getEmployeeDetails } from "rootpath/services/EmployeeBook/employee/EmployeeService";
import { getLoggedInUserRole } from "rootpath/services/EmployeeBook/RoleService";
import { getDesignations } from "rootpath/services/EmployeeBook/DesignationService";
import { getProjectList } from "rootpath/services/EmployeeBook/ProjectService";

const mapStateToProps = state => ({
    employeeDetail: state.skillMatrixOps.employeeDetail || {},
    userRole: state.skillMatrixOps.userRole || {},
    designations: state.skillMatrixOps.designations || [],
    projectList: state.skillMatrixOps.projectList || [],
    id: state.skillMatrixOps.empNavigationId
});

const mapDispatchToProps = dispatch => {
    return {
        fetchEmployeeDetail: async (Id, employeesList, employees) => {
            const employeeDetail = await getEmployeeDetails(Id);
            dispatch(setEmployeesDetail(employeeDetail));
            const index = employeesList.findIndex(
                employee => employee.employeeId === employeeDetail.employeeId
            );
            if (index !== -1) {
                let newList = [...employeesList];
                newList[index] = employeeDetail;
                dispatch(setAllEmployees(newList));
            }

            const empIndex = employees.findIndex(
                employee => employee.employeeId === employeeDetail.employeeId
            );
            if (empIndex !== -1) {
                let newList = [...employees];
                newList[empIndex] = employeeDetail;
                dispatch(setEmployeeList(newList));
            }
        },
        setEmployeesDetails: () => {
            dispatch(setEmployeesDetail([]));
        },
        setAllEmployeeList: (employeeList, updatedEmployee) => {
            const index = employeeList.findIndex(
                employee => employee.employeeId === updatedEmployee.employeeId
            );
            if (index !== -1) {
                let newList = [...employeeList];
                newList[index] = updatedEmployee;
                dispatch(setAllEmployees(newList));
            }
        },

        fetchRole: async () => {
            const role = await getLoggedInUserRole();
            dispatch(postUserRole(role));
        },

        fetchDesignations: async () => {
            const role = await getDesignations();
            dispatch(setDesignations(role));
        },

        fetchProjectList: async () => {
            const projectList = await getProjectList();
            dispatch(setProjectList(projectList));
        }
    };
};

const EmployeeDetailsContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(EmployeeDetails);

export default EmployeeDetailsContainer;
