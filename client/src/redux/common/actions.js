import * as types from "rootpath/redux/common/constants/ActionTypes";

export const initGetApiCall = () => ({
    type: types.INIT_GET_API_CALL
});

export const refreshData = payload => ({
    type: types.REFRESH_DATA,
    payload
});

export const openActions = payload => ({
    type: types.OPEN_ACTIONS,
    payload
});

export const selected = payload => ({
    type: types.SELECTED,
    payload
});

export const openToggle = payload => ({
    type: types.OPEN,
    payload
});

export const setTeam = payload => ({
    type: types.FETCH_TEAM,
    payload
});

export const setName = payload => ({
    type: types.FETCH_NAME,
    payload
});

export const fetchData = payload => ({
    type: types.FETCH_DATA,
    payload
});

export const toggleOpen = payload => ({
    type: types.OPEN,
    payload
});

export const setClients = payload => ({
    type: types.SET_CLIENTS,
    payload
});

export const setClientTeams = payload => ({
    type: types.SET_CLIENT_TEAMS,
    payload
});

export const setCategories = payload => ({
    type: types.SET_CATEGORIES,
    payload
});

export const setSubCategories = payload => ({
    type: types.SET_SUB_CATEGORIES,
    payload
});

export const setExpectedScoreMappings = payload => ({
    type: types.SET_SCORE_MAPPINGS,
    payload
});

export const newSubCategoryMapping = payload => ({
    type: types.NEW_SUB_CATEGORY_MAPPINGS,
    payload
});

export const newClientScore = payload => ({
    type: types.NEW_CLIENT_SCORE,
    payload
});

export const setTeamEmployees = payload => ({
    type: types.SET_TEAM_EMPLOYEES,
    payload
});

export const setSkillMatrixData = payload => ({
    type: types.SET_SKILL_MATRIX_DATA,
    payload
});
export const setSkillMatrixDataNew = payload => ({
    type: types.SET_SKILL_MATRIX_TABLE_DATA,
    payload
});
export const setEmployeeScores = payload => ({
    type: types.SET_EMPLOYEE_SCORES,
    payload
});

export const postTeams = payload => ({
    type: types.POST_TEAMS,
    payload
});

export const fetchCategory = payload => ({
    type: types.FETCH_CATEGORY,
    payload
});

export const fetchSubCategory = payload => ({
    type: types.FETCH_SUBCATEGORY,
    payload
});

export const getClient = payload => ({
    type: types.CLIENT,
    payload
});

export const getCategory = payload => ({
    type: types.CATEGORY,
    payload
});

export const postSubCategory = payload => ({
    type: types.POST_SUBCATEGORY,
    payload
});

export const getEmpList = payload => ({
    type: types.GET_EMPLOYEE,
    payload
});
export const getDeleteEmployeeList = payload => ({
    type: types.GET_DELETE_EMPLOYEE_LIST,
    payload
});

export const getEmpRoleList = payload => ({
    type: types.GET_EMPLOYEE_ROLE,
    payload
});

export const fetchEmp = payload => ({
    type: types.EMPLOYEE,
    payload
});

export const postEmp = payload => ({
    type: types.POST_EMPLOYEE,
    payload
});
export const postUserRole = payload => ({
    type: types.USER_ROLE,
    payload
});

export const getDashboardData = payload => ({
    type: types.DASHBOARD_DATA,
    payload
});
export const sendApplicationAccessList = payload => ({
    type: types.APP_LIST,
    payload
});

export const showAlert = payload => ({
    type: types.SHOW_ALERT,
    payload
});

export const setReportsData = payload => ({
    type: types.REPORT_DATA,
    payload
});

export const getEmployeeType = payload => ({
    type: types.EMPLOYEE_TYPE,
    payload
});

export const getRolesList = payload => ({
    type: types.ROLES_LIST,
    payload
});

export const getDesignationList = payload => ({
    type: types.DESIGNATION_LIST,
    payload
});

export const setTeamsBasedOnClient = payload => ({
    type: types.SET_CLIENT_BASED_ONTEAM,
    payload
});

export const setIsReportLoading = payload => ({
    type: types.SET_IS_REPORT_LOADING,
    payload
});
export const employeeDetails = payload => ({
    type: types.EMPLOYEE_DETAILS,
    payload
});

export const postOrgRecord = payload => ({
    type: types.ORG_RECORD,
    payload
});

export const setEmployeeList = payload => ({
    type: types.GET_EMPLOYEE_LIST,
    payload
});

export const setEmployeesDetail = payload => ({
    type: types.GET_EMPLOYEE_DETAIL,
    payload
});

export const setProjectList = payload => ({
    type: types.GET_PROJECT_LIST,
    payload
});

export const setEmployeeSearchParam = payload => ({
    type: types.GET_EMPLOYEE_SEARCH_PARAM,
    payload
});

export const setEmployees = payload => ({
    type: types.GET_EMPLOYEES,
    payload
});

export const setRoleList = payload => ({
    type: types.GET_ROLES,
    payload
});

export const setTotalPageCount = payload => ({
    type: types.GET_TOTAL_PAGE_COUNT,
    payload
});

export const setUserRole = payload => ({
    type: types.USER_ROLE,
    payload
});

export const setDesignations = payload => ({
    type: types.GET_DESIGNATIONS,
    payload
});

export const setEmployeeNavigationId = payload => ({
    type: types.SET_EMPLOYEE_NAVIGATION_ID,
    payload
});

export const setLogs = payload => ({
    type: types.GET_LOGS,
    payload
});

export const setChartData = payload => ({
    type: types.GET_CHART_DATA,
    payload
});

export const setChartObject = payload => ({
    type: types.CHART_OBJECT,
    payload
});

export const setActiveEmployeeCount = payload => ({
    type: types.ACTIVE_EMPLOYEE_COUNT,
    payload
});

export const setTodayLoginEmployeeCount = payload => ({
    type: types.TODAY_LOGIN_EMPLOYEE_COUNT,
    payload
});

export const setGoogleAnalyticsReport = payload => ({
    type: types.GOOGLE_ANALYTICS_REPORT,
    payload
});

export const setLoader = payload => ({
    type: types.SET_IS_LOADING,
    payload
});

export const setAllEmployees = payload => ({
    type: types.GET_ALL_EMPLOYEES,
    payload
});

export const setIdeaCategory = payload => ({
    type: types.IDEA_CATEGORY,
    payload
});

export const setShareIdeaQuestions = payload => ({
    type: types.SHARE_IDEA_QUESTIONS,
    payload
});

export const setShareIdeaCountsWithCategory = payload => ({
    type: types.SHARE_IDEA_COUNTS_WITH_CATEGORY,
    payload
});

export const setEmployeeShareIdea = payload => ({
    type: types.EMPLOYEE_SHARE_IDEA,
    payload
});

export const setUpdatedEmployeesList = payload => ({
    type: types.UPDATED_EMPLOYEES_LIST,
    payload
});

export const setUpdatedEmployeeDetailById = payload => ({
    type: types.UPDATED_EMPLOYEE_DETAIL_BY_ID,
    payload
});
