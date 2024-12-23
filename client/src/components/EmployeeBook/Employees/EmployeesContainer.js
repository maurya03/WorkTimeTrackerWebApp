import { connect } from "react-redux";
import { getEmployees } from "rootpath/services/EmployeeBook/employee/EmployeeService";
import { getProjectList } from "rootpath/services/EmployeeBook/ProjectService";
import {
    setEmployeeList,
    setProjectList,
    setTotalPageCount,
    setEmployeeSearchParam,
    setEmployeeNavigationId,
    setLoader,
    setAllEmployees,
    setEmployeesDetail
} from "rootpath/redux/common/actions";
import Employees from "rootpath/components/EmployeeBook/Employees/Employees";
import { filterEmployees } from "./EmployeeFilter";

const mapStateToProps = state => ({
    employeesList: state.skillMatrixOps.allEmployees || [],
    employees: state.skillMatrixOps.employees || [],
    pageParam: state.skillMatrixOps.pageParam || 1,
    employeeSearchParam: state.skillMatrixOps.employeeSearchParam || {},
    totalPageCount: state.skillMatrixOps.totalPageCount,
    projectList: state.skillMatrixOps.projectList || [],
    isLoading: state.skillMatrixOps.isLoading || false
});

const mapDispatchToProps = dispatch => {
    return {
        postFilterParams: async param => {
            const employees = await getEmployees(param);
            const filteredEmployees = filterEmployees(
                employees?.employeeList,
                param
            );
            dispatch(setAllEmployees(employees?.employeeList));
            dispatch(setEmployeeList(filteredEmployees?.employees));
            dispatch(setTotalPageCount(employees?.employeeCount));
            dispatch(setEmployeeSearchParam(param));
        },
        postFilterEmployees: async (param, employeeList) => {
            const filteredEmployees = filterEmployees(employeeList, param);
            dispatch(setEmployeeList(filteredEmployees?.employees));
            dispatch(setEmployeeSearchParam(param));
            dispatch(setTotalPageCount(filteredEmployees?.totalpage));
        },
        fetchProjectList: async () => {
            const projectList = await getProjectList();
            dispatch(setProjectList(projectList));
        },
        setEmpNavigationId: (e, employeeList) => {
            const employee = employeeList?.filter(employee => {
                return employee?.employeeId == e;
            });

            dispatch(setEmployeeNavigationId(e));
            dispatch(setEmployeesDetail(employee[0]));
        },
        setLoader: isLoading => {
            dispatch(setLoader(isLoading));
        },
        clearEmployeeSearchParam: async employeeList => {
            const param = {
                page: 1,
                pageSize: 6,
                projectId: 0,
                interests: "All",
                searchText: "",
                sortBy: "NameAsc"
            };
            dispatch(setEmployeeSearchParam(param));
            const filteredEmployees = filterEmployees(employeeList, param);
            if (filteredEmployees && filteredEmployees?.employees.length > 0) {
                dispatch(setEmployeeList(filteredEmployees?.employees));
                dispatch(setTotalPageCount(filteredEmployees?.totalpage));
            }
        }
    };
};

const EmployeesContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(Employees);

export default EmployeesContainer;
