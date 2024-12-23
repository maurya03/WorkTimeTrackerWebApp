import { connect } from "react-redux";
import Report from "rootpath/components/SkillMatrix/Reports/Report";
import { CategoryListApi } from "rootpath/services/SkillMatrix/CategoryService/CategoryService";
import { ClientListApi } from "rootpath/services/SkillMatrix/MasterService/MasterService";
import { ClientTeamsApi } from "rootpath/services/SkillMatrix/ClientService/ClientService";
import {
    fetchReportByCategoryAndClient,
    fetchEmployeeScoreReport,
    fetchSkillSegmentByCategoryReport
} from "rootpath/services/SkillMatrix/ReportsService";
import {
    setCategories,
    setClients,
    setEmployeeScoreReportsData,
    setReportsData,
    setSkillSegmentReportsData,
    setClientTeams,
    setIsReportLoading,
    getEmployeeType
} from "rootpath/redux/common/actions";
import { GetEmployeeType } from "rootpath/services/SkillMatrix/EmployeeService/EmployeeService";

const mapStateToProps = state => ({
    reportsData: state.skillMatrixOps.reportsData,
    categories: state.skillMatrixOps.categories || [],
    clients: state.skillMatrixOps.clients || [],
    teams: state.skillMatrixOps.teams || [],
    isLoading: state.skillMatrixOps.isReportLoading || false,
    empTypeList: state.skillMatrixOps.employeeType
});

const mapDispatchToProps = dispatch => {
    return {
        fetchCategoryList: async () => {
            const categories = await CategoryListApi();
            dispatch(setCategories(categories));
        },
        fetchClientList: async () => {
            const clients = await ClientListApi();
            dispatch(setClients(clients));
        },
        fetchClientTeamsList: async clientId => {
            const teams = clientId ? await ClientTeamsApi(clientId) : [];
            dispatch(setClientTeams(teams));
        },
        fetchEmpTypeList: async () => {
            const employeeListType = await GetEmployeeType();

            dispatch(getEmployeeType(employeeListType));
        },
        fetchDataByActiveReportType: async (
            activeReport,
            categoryId,
            clientId,
            teamId,
            reportType,
            functionType,
            year,
            month
        ) => {
            switch (activeReport) {
                case "Report By Employee Score":
                    dispatch(setIsReportLoading(true));
                    try {
                        const employeeScore = {
                            categoryId: categoryId,
                            clientId: clientId,
                            teamId: teamId,
                            reportType: reportType ? 1 : 0,
                            functionType: functionType,
                            year: year,
                            month: month
                        };
                        const skillsMatrixTable =
                            await fetchEmployeeScoreReport(employeeScore);
                        dispatch(setReportsData(skillsMatrixTable));
                    } finally {
                        dispatch(setIsReportLoading(false));
                    }
                    break;
                case "Skill Segment By Categories":
                    dispatch(setIsReportLoading(true));
                    try {
                        const skillSegmentScore =
                            await fetchSkillSegmentByCategoryReport(
                                categoryId,
                                clientId,
                                teamId,
                                year,
                                month
                            );
                        dispatch(setReportsData(skillSegmentScore));
                    } finally {
                        dispatch(setIsReportLoading(false));
                    }
                    break;

                default:
                    dispatch(setIsReportLoading(true));
                    try {
                        const categoryScore =
                            await fetchReportByCategoryAndClient(
                                categoryId,
                                clientId
                            );
                        dispatch(setReportsData(categoryScore));
                    } finally {
                        dispatch(setIsReportLoading(false));
                    }
            }
        }
    };
};

const ReportContainer = connect(mapStateToProps, mapDispatchToProps)(Report);

export default ReportContainer;
