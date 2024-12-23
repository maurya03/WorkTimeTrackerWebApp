import React, { useEffect, useState } from "react";
import {
    Switch,
    BrowserRouter as Router,
    Route,
    Redirect,
    withRouter
} from "react-router-dom";
import PageNotFound from "rootpath/components/PageNotFound/PageNotFound";
import { Provider } from "react-redux";
import Navbar from "rootpath/components/Navbar/NavbarContainer";
import configureStore from "rootpath/store/main";
import css from "rootpath/routes.css";
import CategoryPage from "rootpath/Pages/SkillMatrix/CategoryPage";
import ClientPage from "rootpath/Pages/SkillMatrix/HomePage";
import EmployeePage from "rootpath/Pages/SkillMatrix/EmployeePage";
import ScoreMappingPage from "rootpath/Pages/SkillMatrix/ScoreMappingPage";
import ReportsPage from "rootpath/Pages/SkillMatrix/ReportsPage";
import LoginPage from "rootpath/components/LoginPage/LoginPage";
import ManageEmployeeProfileContainer from "rootpath/components/EmployeeBook/ManageEmployeeProfile/ManageEmployeeProfileContainer";
import ManageEmployeeContainer from "rootpath/components/EmployeeBook/ManageEmployeeProfile/ManageEmployeeContainer";
import TimesheetTasks from "rootpath/Pages/Timesheet/TimesheetTasks";
import {
    AuthenticatedTemplate,
    UnauthenticatedTemplate,
    useMsal
} from "@azure/msal-react";
import { acquireToken, handleLogin } from "rootpath/commonFunctions";
import RoleManagementPage from "rootpath/Pages/SkillMatrix/RoleManagementPage";
import Dashboard from "rootpath/Pages/SkillMatrix/DashBoardPage";
import TimesheetListPage from "rootpath/Pages/Timesheet/TimesheetListPage";
import TimesheetApprovedPage from "rootpath/Pages/Timesheet/TimesheetApprovedPage";
import TimesheetRejectedPage from "rootpath/Pages/Timesheet/TimesheetRejectedPage";
import TimesheetMapping from "rootpath/Pages/Timesheet/TimesheetMapping";
import TimesheetReport from "rootpath/Pages/Timesheet/TimesheetReportPage";
import TimesheetNotificationPage from "rootpath/Pages/Timesheet/TimesheetNotificationPage";
import TimeSheetCategoryPage from "rootpath/Pages/Timesheet/TimeSheetCategoryPage";
import TimesheetEmployeePage from "rootpath/Pages/Timesheet/TimesheetEmployeePage";
import TimesheetDeleteEmployeePage from "rootpath/Pages/Timesheet/TimesheetDeleteEmployeePage";
import TimesheetPendingPage from "rootpath/Pages/Timesheet/TimesheetPendingPage";
import { getLoggedinUserRole } from "rootpath/services/SkillMatrix/RoleService/RoleService";
// import Timesheetv2Page from "rootpath/Pages/Timesheet2.0/Timesheetv2Page";
// import CreateTimesheetOnBehalfPage from "rootpath/Pages/Timesheet/CreateTimesheetOnBehalfPage";
// import { getApplicationAccessList } from "rootpath/services/SkillMatrix/applicationAccessService";
// import CustomAlert from "rootpath/components/CustomAlert";
import EmployeeListContainer from "rootpath/components/EmployeeBook/EmployeeList/EmployeeListContainer.js";
import EmployeeDetailsContainer from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeeDetailsContainer";
import NavbarEmployeeBook from "rootpath/components/EmployeeBook/Navbar/Navbar";
import AnalyticsContainer from "rootpath/components/EmployeeBook/Analytics/AnalyticsContainer";
import ShareIdeaListContainer from "rootpath/components/EmployeeBook/ShareIdea/Admin/ShareIdeaListContainer";
import Footer from "rootpath/components/EmployeeBook/Footer/Footer";
// import LoginPage from "rootpath/components/LoginPage/LoginPage";
// import { acquireToken, handleLogin } from "rootpath/commonFunctions";
import ManageUserAccessContainer from "rootpath/components/EmployeeBook/ManageUserAccess/ManageUserAccessContainer";
import ImportEmployeeContainer from "rootpath/components/EmployeeBook/ImportEmployees/ImportEmployeeContainer";
import ShareIdeaContainer from "rootpath/components/EmployeeBook/ShareIdea/ShareIdeaContainer";
import NoAccess from "rootpath/components/EmployeeBook/NoAccess/NoAccess";
import EmployeeBookHomePage from "rootpath/Pages/EmployeeBook/EmployeeBookHomePage";
import Timesheetv2Page from "rootpath/Pages/Timesheet2.0/Timesheetv2Page";
import CreateTimesheetOnBehalfPage from "rootpath/Pages/Timesheet/CreateTimesheetOnBehalfPage";
import { getApplicationAccessList } from "rootpath/services/SkillMatrix/applicationAccessService";
import CustomAlert from "rootpath/components/CustomAlert";
import ImportFile from "rootpath/Pages/HrManagement/ImportFile";
import HrDeleteEmployeePage from "rootpath/Pages/HrManagement/HrDeleteEmployeePage";
import HrEmployeePage from "rootpath/Pages/HrManagement/HrEmployeePage";
import HrMapping from "rootpath/Pages/HrManagement/HrMapping";
import HrManageClient from "rootpath/Pages/HrManagement/HrManageClient";

const store = configureStore();
const App = ({ location }) => {
    const { instance, accounts, inProgress } = useMsal();
    const [token, setAccessToken] = useState("");
    const [roles, setRoles] = useState("");
    const [showAlert, setShowAlert] = useState(false);
    const [alertMessage, setAlertMessage] = useState("");
    const [isEmployeeBookPath, setIsEmployeeBookPath] = useState(
        location.pathname.startsWith("/employeebook")
    );

    const signOutHandler = instance => {
        localStorage.removeItem("accessToken");
        instance.logoutRedirect({ postLogoutRedirectUri: "/" });
    };

    const getApplicationAccess = async () => {
        const res = await getApplicationAccessList();
        if (!res?.success) {
            if (res?.error.response.status == 401) {
                const message = res.error.message;
                setAlertMessage(message);
                setShowAlert(true);
                signOutHandler(instance);
            }
        }
    };

    useEffect(() => {
        if (token && token.length > 0) {
            getApplicationAccess();
            getUserRole();
        }
        const employeeBookPath = location.pathname.startsWith("/employeebook");
        setIsEmployeeBookPath(employeeBookPath);
    }, [location.pathname, token]);

    const getUserRole = async () => {
        const role = await getLoggedinUserRole();
        setRoles(role);
    };
    useEffect(async () => {
        if (!localStorage.getItem("accessToken")) {
            const accessToken = await acquireToken(instance, accounts);
            setAccessToken(accessToken);
        } else {
            setAccessToken(localStorage.getItem("accessToken"));
        }
    }, [accounts]);

    const handleRouteChange = path => {
        setIsEmployeeBookPath(path.startsWith("/employeebook"));
    };

    return (
        <div>
            {showAlert && (
                <CustomAlert
                    open={true}
                    severity={"error"}
                    message={alertMessage}
                    onClose={() => setShowAlert(false)}
                ></CustomAlert>
            )}
            {roles && (
                <Provider store={store}>
                    <Router>
                        <div className={css.appContainerDiv}>
                            <AuthenticatedTemplate>
                                {isEmployeeBookPath &&
                                roles.roleName !== "HR" ? (
                                    <NavbarEmployeeBook
                                        onRouteChange={handleRouteChange}
                                    />
                                ) : (
                                    <Navbar />
                                )}
                                {token && (
                                    <div className={css.mainContainerDiv}>
                                        <Switch>
                                            /* Skill matrix routes starts from
                                            here */
                                            {roles.roleName === "HR" ? (
                                                <Redirect
                                                    exact
                                                    from="/"
                                                    to="/hr-management/"
                                                />
                                            ) : (
                                                <Redirect
                                                    exact
                                                    from="/"
                                                    to="/timesheet/"
                                                />
                                            )}
                                            {roles.roleName === "Employee" ? (
                                                <>
                                                    {isEmployeeBookPath ? (
                                                        <Redirect
                                                            exact
                                                            from="/"
                                                            to="/employeebook/"
                                                        />
                                                    ) : (
                                                        <Redirect
                                                            exact
                                                            from="/skill-matrix/"
                                                            to="/timesheet/detail"
                                                        />
                                                    )}
                                                    <Route
                                                        exact
                                                        path="/timesheet/list"
                                                        component={
                                                            TimesheetListPage
                                                        }
                                                    />
                                                    <Route
                                                        exact
                                                        path="/timesheet/pending"
                                                        component={
                                                            TimesheetPendingPage
                                                        }
                                                    />
                                                    {
                                                        <Route
                                                            exact
                                                            path="/timesheet/detail"
                                                            component={
                                                                Timesheetv2Page
                                                            }
                                                        />
                                                    }
                                                    <Route
                                                        exact
                                                        path="/timesheet/approved"
                                                        component={
                                                            TimesheetApprovedPage
                                                        }
                                                    />
                                                    <Route
                                                        exact
                                                        path="/timesheet/rejected"
                                                        component={
                                                            TimesheetRejectedPage
                                                        }
                                                    />
                                                    <Route
                                                        exact
                                                        path="/employeebook/"
                                                        component={
                                                            EmployeeBookHomePage
                                                        }
                                                    />
                                                </>
                                            ) : roles.roleName === "HR" ? (
                                                [
                                                    "/skill-matrix/",
                                                    "/employeebook/"
                                                ].map((path, index) => (
                                                    <Redirect
                                                        key={index}
                                                        from={path}
                                                        to="/hr-management"
                                                    />
                                                ))
                                            ) : roles.roleName ==
                                              "Reporting_Manager" ? (
                                                <>
                                                    <Redirect
                                                        exact
                                                        from="/skill-matrix/"
                                                        to="/skill-matrix/dashboard"
                                                    />
                                                    <Route
                                                        exact
                                                        path="/skill-matrix/"
                                                        component={Dashboard}
                                                    />
                                                    <Route
                                                        exact
                                                        path="/skill-matrix/dashboard"
                                                        component={Dashboard}
                                                    />
                                                    <Route
                                                        exact
                                                        path="/skill-matrix/client"
                                                        component={ClientPage}
                                                    />
                                                    <Route
                                                        path="/skill-matrix/category"
                                                        component={CategoryPage}
                                                    />
                                                    <Route
                                                        path="/skill-matrix/client-score"
                                                        component={() => (
                                                            <ScoreMappingPage identifier="clientScorePage" />
                                                        )}
                                                    />
                                                    <Route
                                                        path="/skill-matrix/score-mapping"
                                                        component={() => (
                                                            <ScoreMappingPage identifier="employeeScorePage" />
                                                        )}
                                                    />
                                                    <Route
                                                        path="/skill-matrix/reports"
                                                        component={ReportsPage}
                                                    />
                                                </>
                                            ) : (
                                                <Redirect
                                                    exact
                                                    from="/skill-matrix/"
                                                    to="/skill-matrix/dashboard"
                                                />
                                            )}
                                            <Route
                                                exact
                                                path="/skill-matrix/"
                                                component={Dashboard}
                                            />
                                            <Route
                                                exact
                                                path="/skill-matrix/dashboard"
                                                component={Dashboard}
                                            />
                                            <Route
                                                exact
                                                path="/skill-matrix/client"
                                                component={ClientPage}
                                            />
                                            <Route
                                                path="/skill-matrix/category"
                                                component={CategoryPage}
                                            />
                                            <Route
                                                path="/skill-matrix/employee"
                                                component={EmployeePage}
                                            />
                                            <Route
                                                path="/skill-matrix/client-score"
                                                component={() => (
                                                    <ScoreMappingPage identifier="clientScorePage" />
                                                )}
                                            />
                                            <Route
                                                path="/skill-matrix/score-mapping"
                                                component={() => (
                                                    <ScoreMappingPage identifier="employeeScorePage" />
                                                )}
                                            />
                                            <Route
                                                path="/skill-matrix/reports"
                                                component={ReportsPage}
                                            />
                                            <Route
                                                path="/skill-matrix/role-management"
                                                component={RoleManagementPage}
                                            />
                                            /* Skill matrix routes ends here */
                                            /* Timesheet routes starts from here
                                            */
                                            {roles.roleName === "Employee" ? (
                                                <Redirect
                                                    exact
                                                    from="/timesheet/"
                                                    to="/timesheet/detail"
                                                />
                                            ) : (
                                                <Redirect
                                                    exact
                                                    from="/timesheet/"
                                                    to="/timesheet/list"
                                                />
                                            )}
                                            <Route
                                                exact
                                                path="/timesheet/list"
                                                component={TimesheetListPage}
                                            />
                                            <Route
                                                exact
                                                path="/timesheet/pending"
                                                component={TimesheetPendingPage}
                                            />
                                            <Route
                                                exact
                                                path="/timesheet/detail"
                                                component={Timesheetv2Page}
                                            />
                                            <Route
                                                exact
                                                path="/timesheet/approved"
                                                component={
                                                    TimesheetApprovedPage
                                                }
                                            />
                                            <Route
                                                exact
                                                path="/timesheet/rejected"
                                                component={
                                                    TimesheetRejectedPage
                                                }
                                            />
                                            <Route
                                                exact
                                                path="/timesheet/category"
                                                component={
                                                    TimeSheetCategoryPage
                                                }
                                            />
                                            <Route
                                                exact
                                                path="/timesheet/mapping"
                                                component={TimesheetMapping}
                                            />
                                            <Route
                                                exact
                                                path="/timesheet/reports"
                                                component={TimesheetReport}
                                            />
                                            <Route
                                                exact
                                                path="/timesheet/sendNotification"
                                                component={
                                                    TimesheetNotificationPage
                                                }
                                            />
                                            <Route
                                                exact
                                                path="/timesheet/employee"
                                                component={
                                                    TimesheetEmployeePage
                                                }
                                            />
                                            <Route
                                                exact
                                                path="/timesheet/delete-employee"
                                                component={
                                                    TimesheetDeleteEmployeePage
                                                }
                                            />
                                            /* Timesheet routes ends here */
                                            {/* Employee book routes
                                        starts from here */}
                                            <Redirect
                                                exact
                                                from="/"
                                                to="/employeebook"
                                            />
                                            <Route
                                                exact
                                                path="/employeebook/manage-employee/:employeeId"
                                                render={props => (
                                                    <ManageEmployeeContainer
                                                        {...props}
                                                    />
                                                )}
                                            />
                                            <Route
                                                exact
                                                path="/employeebook/"
                                                component={EmployeeBookHomePage}
                                            />
                                            <Route
                                                exact
                                                path="/employeebook/import-employees"
                                                component={
                                                    ImportEmployeeContainer
                                                }
                                            />
                                            <Route
                                                exact
                                                path="/employeebook/manage-access"
                                                component={
                                                    ManageUserAccessContainer
                                                }
                                            />
                                            <Route
                                                exact
                                                path="/employeebook/analytics"
                                                component={AnalyticsContainer}
                                            />
                                            <Route
                                                exact
                                                path="/employeebook/employee-details"
                                                component={
                                                    EmployeeDetailsContainer
                                                }
                                            />
                                            <Route
                                                exact
                                                path="/employeebook/share-idea"
                                                component={ShareIdeaContainer}
                                            />
                                            <Route
                                                exact
                                                path="/employeebook/share-idea-details"
                                                component={
                                                    ShareIdeaListContainer
                                                }
                                            />
                                            <Route
                                                exact
                                                path="/employeebook/no-access"
                                                component={NoAccess}
                                            />
                                            <Route
                                                exact
                                                path="/employeebook/manage-employee-profile"
                                                component={
                                                    ManageEmployeeProfileContainer
                                                }
                                            />
                                            {/* Employee book routes end
                                        here */}
                                            /* HR-Management routes starts from
                                            here */
                                            {roles.roleName === "HR" && (
                                                <Redirect
                                                    exact
                                                    from="/hr-management/"
                                                    to="/hr-management/HrEmployeePage"
                                                />
                                            )}
                                            <Route
                                                exact
                                                path="/hr-management/HrMapping"
                                                component={HrMapping}
                                            />
                                             <Route
                                                path="/hr-management/import-excel"
                                                component={ImportFile}
                                            />
                                            <Route
                                                exact
                                                path="/hr-management/HrEmployeePage"
                                                component={HrEmployeePage}
                                            />
                                            <Route
                                                exact
                                                path="/hr-management/HrDeleteEmployeePage"
                                                component={HrDeleteEmployeePage}
                                            />
                                            <Route
                                                exact
                                                path="/hr-management/HrManageClient"
                                                component={HrManageClient}
                                            />
                                            /* HR-Management routes ends here */
                                            <Route component={PageNotFound} />
                                        </Switch>
                                    </div>
                                )}
                                {isEmployeeBookPath ? <Footer /> : ""}
                            </AuthenticatedTemplate>
                            <UnauthenticatedTemplate>
                                <LoginPage
                                    handleLogin={handleLogin}
                                    instance={instance}
                                />
                            </UnauthenticatedTemplate>
                        </div>
                    </Router>
                </Provider>
            )}
        </div>
    );
};
export default withRouter(App);
