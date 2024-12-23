import * as types from "rootpath/redux/common/constants/ActionTypes";
import Cookies from "universal-cookie";
import jwt_decode from "jwt-decode";
import { approverId1List, approverId2List, managerList } from "../actions";

const cookies = new Cookies();
let tokenData = cookies.get("my_cookie");
const userName = tokenData ? jwt_decode(tokenData).Emp_name : "";

const skillMatrixState = {
    clients: [],
    teams: [],
    category: [],
    categories: [],
    subCategories: [],
    expectedScoreMappings: [],
    newSubCategoryMapping: [],
    newClientExpectedScore: [],
    teamEmployees: [],
    skillMatrixData: [],
    employeeScores: [],
    category: [],
    subcategory: [],
    client: {},
    categoryItem: {},
    employee: [],
    employeeRole: [],
    empItem: {},
    dasboardData: [],
    showAlert: {},
    applicationList: [],
    reportsData: [],
    employeeType: [],
    employeeRoles: [],
    employeeDesignation: [],
    clientTeams: [],
    employeeScoreReportData: [],
    skillSegmentReportsData: [],
    employees: [],
    employeeDetail: {},
    projectList: [],
    employeeSearchParam: {
        page: 1,
        pageSize: 6,
        projectId: 0,
        interests: "All",
        searchText: "",
        sortBy: "NameAsc"
    },
    pageParam: 1,
    totalPageCount: {
        totalRecords: 0,
        totalPages: 0
    },
    roles: [],
    empNavigationId: 0,
    isLoading: false,
    allEmployees: [],
    updatedEmployeesList: [],
    updatedEmployeeById: [],
    isReportLoading: false,
    employeeDetails: [],
    deleteEmployeeList: [],
    orgRecords: []
};

export const skillMatrixOps = (state = skillMatrixState, action) => {
    switch (action.type) {
        case types.SET_CLIENTS:
            return { ...state, clients: action.payload };
        case types.SET_CLIENT_TEAMS:
            return { ...state, teams: action.payload };
        case types.SET_CATEGORIES:
            return { ...state, categories: action.payload };
        case types.SET_SUB_CATEGORIES:
            return { ...state, subCategories: action.payload };
        case types.SET_SCORE_MAPPINGS:
            return { ...state, expectedScoreMappings: action.payload };
        case types.SET_TEAM_EMPLOYEES:
            return { ...state, teamEmployees: action.payload };
        case types.SET_SKILL_MATRIX_DATA:
            return { ...state, skillMatrixData: action.payload };
        case types.SET_SKILL_MATRIX_TABLE_DATA:
            return { ...state, skillMatrixDataUpdated: action.payload };
        case types.SET_EMPLOYEE_SCORES:
            return { ...state, employeeScores: action.payload };
        case types.POST_TEAMS:
            return { ...state, teams: action.payload };
        case types.FETCH_CATEGORY:
            return { ...state, category: action.payload };
        case types.FETCH_SUBCATEGORY:
            return { ...state, subcategory: action.payload };
        case types.CLIENT:
            return { ...state, client: action.payload };
        case types.POST_SUBCATEGORY:
            return { ...state, subcategory: action.payload };
        case types.CATEGORY:
            return { ...state, categoryItem: action.payload };
        case types.GET_EMPLOYEE:
            return { ...state, employee: action.payload };
        case types.GET_EMPLOYEE_ROLE:
            return { ...state, employeeRole: action.payload };
        case types.NEW_SUB_CATEGORY_MAPPINGS:
            return { ...state, newSubCategoryMapping: action.payload };
        case types.NEW_CLIENT_SCORE:
            return { ...state, newClientExpectedScore: action.payload };
        case types.EMPLOYEE:
            return { ...state, empItem: action.payload };
        case types.POST_EMPLOYEE:
            return { ...state, employee: action.payload };
        case types.USER_ROLE:
            return { ...state, userRole: action.payload };
        case types.DASHBOARD_DATA:
            return { ...state, dashBoard: action.payload };
        case types.SHOW_ALERT:
            return { ...state, showAlert: action.payload };
        case types.APP_LIST:
            return { ...state, applicationList: action.payload };
        case types.REPORT_DATA:
            return { ...state, reportsData: action.payload };
        case types.EMPLOYEE_TYPE:
            return { ...state, employeeType: action.payload };
        case types.ROLES_LIST:
            return { ...state, employeeRoles: action.payload };
        case types.DESIGNATION_LIST:
            return { ...state, employeeDesignation: action.payload };
        case types.SET_CLIENT_BASED_ONTEAM:
            return { ...state, clientTeams: action.payload };
        case types.EMPLOYEE_SCORE_REPORT_DATA:
            return { ...state, employeeScoreReportData: action.payload };
        case types.SKILL_SEGMENT_REPORT_DATA:
            return { ...state, skillSegmentReportsData: action.payload };
        case types.SET_IS_LOADING:
            return { ...state, isLoading: action.payload };

        case types.GET_EMPLOYEE_LIST:
            return { ...state, employees: action.payload };

        case types.GET_TOTAL_PAGE_COUNT:
            return { ...state, totalPageCount: action.payload };

        case types.GET_EMPLOYEE_DETAIL:
            return { ...state, employeeDetail: action.payload };

        case types.GET_PROJECT_LIST:
            return { ...state, projectList: action.payload };

        case types.GET_EMPLOYEE_SEARCH_PARAM:
            return { ...state, employeeSearchParam: action.payload };

        case types.GET_EMPLOYEES:
            return { ...state, employees: action.payload };

        case types.GET_ROLES:
            return { ...state, roles: action.payload };

        case types.GET_DESIGNATIONS:
            return { ...state, designations: action.payload };

        case types.SET_EMPLOYEE_NAVIGATION_ID:
            return { ...state, empNavigationId: action.payload };

        case types.SET_IS_LOADING:
            return { ...state, isLoading: action.payload };

        case types.GET_LOGS:
            return { ...state, logs: action.payload };

        case types.CHART_OBJECT:
            return { ...state, chartObject: action.payload };

        case types.ACTIVE_EMPLOYEE_COUNT:
            return { ...state, activeEmployeeCount: action.payload };

        case types.TODAY_LOGIN_EMPLOYEE_COUNT:
            return { ...state, todayLoginEmployeeCount: action.payload };

        case types.GET_CHART_DATA:
            return { ...state, chartData: action.payload };

        case types.GOOGLE_ANALYTICS_REPORT:
            return { ...state, googleAnalyticsReport: action.payload };
        case types.GET_ALL_EMPLOYEES:
            return { ...state, allEmployees: action.payload };

        case types.IDEA_CATEGORY:
            return { ...state, ideaCategory: action.payload };

        case types.SHARE_IDEA_QUESTIONS:
            return { ...state, shareIdeaQuestions: action.payload };

        case types.SHARE_IDEA_COUNTS_WITH_CATEGORY:
            return { ...state, shareIdeaCountsWithCategory: action.payload };

        case types.EMPLOYEE_SHARE_IDEA:
            return { ...state, employeeShareIdea: action.payload };

        case types.UPDATED_EMPLOYEES_LIST:
            return { ...state, updatedEmployeesList: action.payload };

        case types.UPDATED_EMPLOYEE_DETAIL_BY_ID:
            return { ...state, updatedEmployeeById: action.payload };

        case types.SET_IS_REPORT_LOADING:
            return { ...state, isReportLoading: action.payload };
        case types.EMPLOYEE_DETAILS:
            return { ...state, employeeDetails: action.payload };
        case types.GET_DELETE_EMPLOYEE_LIST:
            return { ...state, deleteEmployeeList: action.payload };
        case types.ORG_RECORD:
            return { ...state, orgRecords: action.payload };
        default:
            return state;
    }
};
