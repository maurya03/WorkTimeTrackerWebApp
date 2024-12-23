import { connect } from "react-redux";
import { getClientsList } from "rootpath/components/SkillMatrix/CardsComponent/CardsComponentFunction";
import { setClients, showAlert } from "rootpath/redux/common/actions";
import AddClient from "rootpath/components/SkillMatrix/AddClient/AddClient";
import { UpdateClientAPI } from "rootpath/services/SkillMatrix/ClientService/ClientService";

const mapStateToProps = state => ({
    showAlert: state.skillMatrixOps.showAlert || {}
});

const mapDispatchToProps = dispatch => {
    return {
        fetchClientList: async () => {
            const clients = await getClientsList();
            dispatch(setClients(clients));
        },
        updateClient: async client => {
          return await UpdateClientAPI(client);
        },
        setShowAlert: (setAlert=false,severity,message) => {
            const data= {
                setAlert,
                severity,
                message
            }
            dispatch(showAlert(data));
        }
    };
};

const AddClientContainer = connect(mapStateToProps, mapDispatchToProps)(AddClient);
export default AddClientContainer;
