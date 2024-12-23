import { connect } from "react-redux";
import { postOrgRecord } from "rootpath/redux/common/actions";
import {
    PostExcelRecords,
    postItHoursRecords
} from "rootpath/services/ImportData/ImportDataService";
import ImportData from "rootpath/components/ImportData/ImportData";
const mapStateToProps = state => {
    let orgData = state.skillMatrixOps.orgRecords.records || [];
    return {
        orgRecords: orgData
    };
};

const mapDispatchToProps = dispatch => ({
    postExcelRecord: async file => {
        const formData = new FormData();
        formData.append("file", file);
        const response = await PostExcelRecords(formData);
        dispatch(
            postOrgRecord({
                records: response.data.records,
                selectedColumn: ""
            })
        );
    },
    postItHoursRecord: async file => {
        const formData = new FormData();
        formData.append("file", file);
        const response = await postItHoursRecords(formData);
        dispatch(
            postOrgRecord({
                records: response.data.records,
                selectedColumn: ""
            })
        );
    },
    emptyRecords: ()=>{
        dispatch(
            postOrgRecord({
                records: [],
                selectedColumn: ""
            })
        );
    }

});

const ImportDataContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(ImportData);

export default ImportDataContainer;
