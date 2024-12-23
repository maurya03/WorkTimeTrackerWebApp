import { connect } from "react-redux";
import {
    postEmp,
    postTeams,
    setTeamsBasedOnClient,
    getEmployeeType,
    getRolesList,
    getDesignationList,
    showAlert
} from "rootpath/redux/common/actions";
import { getEmployeeTypeList } from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import {
    EmpPostApi,
    updateEmployee,
    GetEmployeeRoles,
    GetEmployeeDesignation
} from "rootpath/services/SkillMatrix/EmployeeService/EmployeeService";
import AddEmployee from "./AddEmployee";
import { ClientTeamsApi } from "rootpath/services/SkillMatrix/MasterService/MasterService";

const mapStateToProps = state => ({
    empItem: state.skillMatrixOps.empItem,
    empListType: state.skillMatrixOps.employeeType || [],
    teams: state.skillMatrixOps.clientTeams || [],
    clients: state.skillMatrixOps.clients || [],
    employeeRoleList: state.skillMatrixOps.employeeRoles || [],
    employeeDesignationList: state.skillMatrixOps.employeeDesignation || [],
    showAlert: state.skillMatrixOps.showAlert || {}
});

const mapDispatchToProps = (dispatch, ownProps) => ({
    postEmp: async team => {
        const teams = await EmpPostApi(team);
        dispatch(postEmp(teams));
    },
    fetchClientTeams: async clientId => {
        let teams = await ClientTeamsApi(clientId);
        if (teams.length > 0) {
            teams.splice(0, 0, { teamName: "Select Team", id: 0 });
        }
        dispatch(setTeamsBasedOnClient(teams));
    },
    updateEmployee: async employee => {
        await updateEmployee(employee);
    },
    fetchEmpTypeList: async () => {
        const employeeListType = await getEmployeeTypeList();

        dispatch(getEmployeeType(employeeListType));
    },
    fetchRoleList: async () => {
        const roleList = await GetEmployeeRoles();

        dispatch(getRolesList(roleList));
    },
    fetchDesignationList: async () => {
        const designationList = await GetEmployeeDesignation();

        dispatch(getDesignationList(designationList));
    },
    setShowAlert: (setAlert = false, severity, message) => {
        const data = {
            setAlert,
            severity,
            message
        };
        dispatch(showAlert(data));
    }
});

const AddEmployeeContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(AddEmployee);

export default AddEmployeeContainer;
