import { connect } from "react-redux";
import {
    TeamPostApi,
    UpdateTeamAPI
} from "rootpath/services/SkillMatrix/ClientService/ClientService";
import { postTeams, showAlert } from "rootpath/redux/common/actions";
import AddTeam from "./AddTeam";

const mapStateToProps = state => ({
    clients: state.skillMatrixOps.clients || [],
    client: state.skillMatrixOps.client,
    showAlert: state.skillMatrixOps.showAlert || {}
});

const mapDispatchToProps = dispatch => ({
    postTeam: async team => {
        const teams = await TeamPostApi(team);
        dispatch(postTeams(teams));
        return teams;
    },
    updateTeam: async team => {
        return await UpdateTeamAPI(team);
    },
    showErrorMessage: result => {
        let errorArray = [];
        result.error.response.data.map(item => {
            errorArray.push({ error: item.errorMessage, field: "name" });
        });
        const errorMessage = errorArray.map(error => error.error).join(", ");
        const data = {
            setAlert: true,
            severity: "error",
            message: errorMessage
        };
        dispatch(showAlert(data));
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

const AddTeamContainer = connect(mapStateToProps, mapDispatchToProps)(AddTeam);

export default AddTeamContainer;
