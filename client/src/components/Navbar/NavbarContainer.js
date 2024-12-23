import { connect } from "react-redux";
import Navbar from "./Navbar";
import { getApplicationAccessList } from "rootpath/services/SkillMatrix/applicationAccessService";
import { sendApplicationAccessList } from "rootpath/redux/common/actions";

const mapStateToProps = state => ({
    applicationList: state.skillMatrixOps.applicationList || {},
    userRole: state.skillMatrixOps.userRole || {}
});

const mapDispatchToProps = dispatch => {
    return {
        fetchApplicationAccess: async () => {
            const applicationList = await getApplicationAccessList();
            dispatch(sendApplicationAccessList(applicationList));
        }
    };
};

const NavbarContainer = connect(mapStateToProps, mapDispatchToProps)(Navbar);
export default NavbarContainer;
