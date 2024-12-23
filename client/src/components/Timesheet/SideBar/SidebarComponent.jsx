import {
    faClipboardList,
    faCheckCircle,
    faTimesCircle,
    faEdit,
    faPaperPlane,
    faHourglassHalf,
    faFile,
    faPlusCircle,
    faCompass,
    faPeopleGroup,
    faUsers,
    faUserTimes,
    faEnvelope
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React, { useState, useEffect } from "react";
import css from "rootpath/components/Timesheet/SideBar/SidebarComponent.css";
import { NavLink } from "react-router-dom";
import { handleNavItemClick } from "rootpath/components/Timesheet/SideBar/SidebarFunctions";

const SidebarComponent = ({
    userRole,
    fetchRole,
    setSelectedTimesheetStatus
}) => {
    const path = window.location.pathname;
    const setCurrentLocation = {
        submitted: path === "/timesheet/list",
        approved: path === "/timesheet/approved",
        create: path === "/timesheet/detail",
        rejected: path === "/timesheet/rejected",
        approverPending: path === "/timesheet/pending",
        category: path === "/timesheet/category",
        mapping: path === "/timesheet/mapping",
        reports: path === "/timesheet/reports",
        employee: path === "/timesheet/employee",
        deleteEmployee: path === "/timesheet/delete-employee",
        emailNotification: path === "/timesheet/sendNotification"
    };
    const [activeLocation, setActiveLocation] = useState(setCurrentLocation);
    useEffect(() => {
        fetchRole();
        setSelectedTimesheetStatus(setCurrentLocation);
    }, [fetchRole]);

    return (
        <div className={css.sidebarContainerDiv}>
            <NavLink
                title={
                    userRole.roleName === "Employee"
                        ? "Create Timesheet"
                        : "Submitted"
                }
                to={
                    userRole.roleName === "Employee"
                        ? "/timesheet/detail"
                        : "/timesheet/list"
                }
                exact
                className={css.sidebarNavItem}
                activeClassName={
                    (
                        userRole.roleName === "Employee"
                            ? activeLocation.create
                            : activeLocation.submitted
                    )
                        ? css.sidebarActiveNavItem
                        : ""
                }
                onClick={() => {
                    //setTimesheetId(0);
                    handleNavItemClick(
                        activeLocation,
                        setActiveLocation,
                        userRole.roleName === "Employee"
                            ? "create"
                            : "submitted",
                        setSelectedTimesheetStatus
                    );
                }}
            >
                <FontAwesomeIcon
                    icon={
                        userRole.roleName === "Employee"
                            ? faPlusCircle
                            : faPaperPlane
                    }
                />
            </NavLink>
            {userRole.roleName !== "Employee" && (
                <NavLink
                    title="Pending Approval"
                    to="/timesheet/pending"
                    exact
                    className={css.sidebarNavItem}
                    activeClassName={
                        activeLocation.approverPending
                            ? css.sidebarActiveNavItem
                            : ""
                    }
                    onClick={() => {
                        // setTimesheetId(0);
                        handleNavItemClick(
                            activeLocation,
                            setActiveLocation,
                            "approverPending",
                            setSelectedTimesheetStatus
                        );
                    }}
                >
                    <FontAwesomeIcon icon={faHourglassHalf} />
                    {/* <span class={"badge-light " + css.badge}>5</span> */}
                </NavLink>
            )}
            <NavLink
                title={
                    userRole.roleName === "Employee"
                        ? "Pending Approval"
                        : "Create Timesheet"
                }
                to={
                    userRole.roleName === "Employee"
                        ? "/timesheet/pending"
                        : "/timesheet/detail"
                }
                exact
                className={css.sidebarNavItem}
                activeClassName={
                    (
                        userRole.roleName === "Employee"
                            ? activeLocation.approverPending
                            : activeLocation.create
                    )
                        ? css.sidebarActiveNavItem
                        : ""
                }
                onClick={() => {
                    // setTimesheetId(0);
                    handleNavItemClick(
                        activeLocation,
                        setActiveLocation,
                        userRole.roleName === "Employee"
                            ? "submitted"
                            : "create",
                        setSelectedTimesheetStatus
                    );
                }}
            >
                <FontAwesomeIcon
                    icon={
                        userRole.roleName === "Employee"
                            ? faHourglassHalf
                            : faPlusCircle
                    }
                />
                {/* <span class={"badge-light " + css.badge}>5</span> */}
            </NavLink>

            <NavLink
                title="Approved"
                to="/timesheet/approved"
                exact
                className={css.sidebarNavItem}
                activeClassName={
                    activeLocation.approved ? css.sidebarActiveNavItem : ""
                }
                onClick={() => {
                    // setTimesheetId(0);
                    handleNavItemClick(
                        activeLocation,
                        setActiveLocation,
                        "approved",
                        setSelectedTimesheetStatus
                    );
                }}
            >
                <FontAwesomeIcon icon={faCheckCircle} />
                {/* <span class={"badge-light " + css.badge}>5</span> */}
            </NavLink>

            <NavLink
                title="Rejected"
                to="/timesheet/rejected"
                exact
                className={css.sidebarNavItem}
                activeClassName={
                    activeLocation.rejected ? css.sidebarActiveNavItem : ""
                }
                onClick={() => {
                    // setTimesheetId(0);
                    handleNavItemClick(
                        activeLocation,
                        setActiveLocation,
                        "rejected",
                        setSelectedTimesheetStatus
                    );
                }}
            >
                <FontAwesomeIcon icon={faTimesCircle} />
                {/* <span class={"badge-light " + css.badge}>5</span> */}
            </NavLink>

            {userRole.roleName !== "Employee" &&
                userRole.roleName !== "Approver" && (
                    <NavLink
                        title="Reports"
                        to="/timesheet/reports"
                        exact
                        className={css.sidebarNavItem}
                        activeClassName={
                            activeLocation.reports
                                ? css.sidebarActiveNavItem
                                : ""
                        }
                        onClick={() => {
                            // setTimesheetId(0);
                            handleNavItemClick(
                                activeLocation,
                                setActiveLocation,
                                "reports",
                                setSelectedTimesheetStatus
                            );
                        }}
                    >
                        <FontAwesomeIcon icon={faFile} />
                        {/* <span class={"badge-light " + css.badge}>5</span> */}
                    </NavLink>
                )}

            {userRole?.roleName !== "Employee" &&
                userRole?.roleName !== "Approver" && (
                    <NavLink
                        title="Send Notification"
                        to="/timesheet/sendNotification"
                        exact
                        className={css.sidebarNavItem}
                        activeClassName={
                            activeLocation.emailNotification
                                ? css.sidebarActiveNavItem
                                : ""
                        }
                        onClick={() => {
                            handleNavItemClick(
                                activeLocation,
                                setActiveLocation,
                                "emailNotification",
                                setSelectedTimesheetStatus
                            );
                        }}
                    >
                        <FontAwesomeIcon icon={faEnvelope} />
                    </NavLink>
                )}
            {userRole.roleName === "Admin" && (
                <NavLink
                    title="Assign Manager/Approver"
                    to="/timesheet/mapping"
                    exact
                    className={css.sidebarNavItem}
                    activeClassName={
                        activeLocation.mapping ? css.sidebarActiveNavItem : ""
                    }
                    onClick={() => {
                        handleNavItemClick(
                            activeLocation,
                            setActiveLocation,
                            "mapping",
                            setSelectedTimesheetStatus
                        );
                    }}
                >
                    <FontAwesomeIcon icon={faPeopleGroup} />
                </NavLink>
            )}
            {/* <NavLink
                title="Org Chart"
                to="/timesheet/orgchart"
                className={css.sidebarNavItem}
                activeClassName={
                    activeLocation.category ? css.sidebarActiveNavItem : ""
                }
                onClick={() =>
                    handleNavItemClick(
                        activeLocation,
                        setActiveLocation,
                        "Org Chart",
                        setSelectedTimesheetStatus
                    )
                }
            >
                <FontAwesomeIcon icon={faSitemap} />
            </NavLink> */}
            {userRole.roleName === "Admin" && (
                <NavLink
                    title="CategoryDashboard"
                    to="/timesheet/category"
                    className={css.sidebarNavItem}
                    activeClassName={
                        activeLocation.category ? css.sidebarActiveNavItem : ""
                    }
                    onClick={() =>
                        handleNavItemClick(
                            activeLocation,
                            setActiveLocation,
                            "category",
                            setSelectedTimesheetStatus
                        )
                    }
                >
                    <FontAwesomeIcon icon={faClipboardList} />
                </NavLink>
            )}

            {userRole.roleName === "Admin" && (
                <NavLink
                    title="Employee Master"
                    to="/timesheet/employee"
                    className={css.sidebarNavItem}
                    activeClassName={
                        activeLocation.employee ? css.sidebarActiveNavItem : ""
                    }
                    onClick={() =>
                        handleNavItemClick(
                            activeLocation,
                            setActiveLocation,
                            "employee"
                        )
                    }
                >
                    <FontAwesomeIcon icon={faUsers} />
                </NavLink>
            )}

            {/* {userRole.roleName !== "Employee" && (
                <NavLink
                    title="Create Timesheet On Behalf"
                    to="/timesheet/createOnBehalf"
                    className={css.sidebarNavItem}
                    activeClassName={
                        activeLocation.onBehalf ? css.sidebarActiveNavItem : ""
                    }
                    onClick={() =>
                        handleNavItemClick(
                            activeLocation,
                            setActiveLocation,
                            "onBehalf",
                            setSelectedTimesheetStatus
                        )
                    }
                >
                    <FontAwesomeIcon icon={faCompass} />
                </NavLink>
            )} */}

            {userRole.roleName === "Admin" && (
                <NavLink
                    title="Review Deleted Employee"
                    to="/timesheet/delete-employee"
                    className={css.sidebarNavItem}
                    activeClassName={
                        activeLocation.deleteEmployee
                            ? css.sidebarActiveNavItem
                            : ""
                    }
                    onClick={() =>
                        handleNavItemClick(
                            activeLocation,
                            setActiveLocation,
                            "deleteEmployee"
                        )
                    }
                >
                    <FontAwesomeIcon icon={faUserTimes} />
                </NavLink>
            )}
        </div>
    );
};

export default SidebarComponent;
