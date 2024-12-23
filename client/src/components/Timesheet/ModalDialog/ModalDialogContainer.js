import { connect } from "react-redux";
import ModalDialog from "./ModalDialog";
const mapStateToProps = state => ({
    isRemarksModalOpen: state.timeSheetOps.isRemarksModalOpen || false,
    errorMessage: state.timeSheetOps.errorMessage || []
});

// const mapDispatchToProps = (dispatch, ownProps) => ({

// });

const ModalDialogContainer = connect(mapStateToProps, null)(ModalDialog);

export default ModalDialogContainer;
