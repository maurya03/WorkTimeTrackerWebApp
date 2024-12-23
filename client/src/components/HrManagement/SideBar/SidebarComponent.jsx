import {
    faPeopleGroup,
    faUsers,
    faUserTimes,
    faSitemap,
    faFileUpload
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React, { useState, useEffect } from "react";
import css from "rootpath/components/Timesheet/SideBar/SidebarComponent.css";
import { NavLink } from "react-router-dom";
import { handleNavItemClick } from "rootpath/components/HrManagement/SideBar/SidebarFunctions";

const SidebarComponent = ({
    userRole,
    fetchRole,
    setSelectedTimesheetStatus
}) => {
    const path = window.location.pathname;
    const setCurrentLocation = {
        HrMapping: path === "/hr-management/HrMapping",
        HrEmployee: path === "/hr-management/HrEmployeePage",
        HrDeleteEmployeePage: path === "/hr-management/HrDeleteEmployeePage",
        HrManageClient: path === "/hr-management/HrManageClient",
        HrImportExcel: path ==="/hr-management/import-excel"
    };
    const [activeLocation, setActiveLocation] = useState(setCurrentLocation);
    useEffect(() => {
        fetchRole();
        setSelectedTimesheetStatus(setCurrentLocation);
    }, [fetchRole]);

    return (
        <div className={css.sidebarContainerDiv}>
            {userRole?.roleName === "HR" && (
                <>
                    <NavLink
                        title="Employee Master"
                        to="/hr-management/HrEmployeePage"
                        className={css.sidebarNavItem}
                        activeClassName={
                            activeLocation.HrEmployee
                                ? css.sidebarActiveNavItem
                                : ""
                        }
                        onClick={() =>
                            handleNavItemClick(
                                activeLocation,
                                setActiveLocation,
                                "HrEmployee",
                                setSelectedTimesheetStatus
                            )
                        }
                    >
                        <FontAwesomeIcon icon={faUsers} />
                    </NavLink>

                    <NavLink
                        title="Assign Manager/Approver"
                        to="/hr-management/HrMapping"
                        exact
                        className={css.sidebarNavItem}
                        activeClassName={
                            activeLocation.HrMapping
                                ? css.sidebarActiveNavItem
                                : ""
                        }
                        onClick={() => {
                            handleNavItemClick(
                                activeLocation,
                                setActiveLocation,
                                "HrMapping",
                                setSelectedTimesheetStatus
                            );
                        }}
                    >
                        <FontAwesomeIcon icon={faPeopleGroup} />
                    </NavLink>

                    <NavLink
                        title="Client Master"
                        to="/hr-management/HrManageClient"
                        exact
                        className={css.sidebarNavItem}
                        activeClassName={
                            activeLocation.HrManageClient
                                ? css.sidebarActiveNavItem
                                : ""
                        }
                        onClick={() =>
                            handleNavItemClick(
                                activeLocation,
                                setActiveLocation,
                                "HrManageClient"
                            )
                        }
                    >
                        <FontAwesomeIcon icon={faSitemap} />
                    </NavLink>

                    <NavLink
                        title="Review Deleted Employee"
                        to="/hr-management/HrDeleteEmployeePage"
                        className={css.sidebarNavItem}
                        activeClassName={
                            activeLocation.HrDeleteEmployeePage
                                ? css.sidebarActiveNavItem
                                : ""
                        }
                        onClick={() =>
                            handleNavItemClick(
                                activeLocation,
                                setActiveLocation,
                                "HrDeleteEmployeePage",
                                setSelectedTimesheetStatus
                            )
                        }
                    >
                        <FontAwesomeIcon icon={faUserTimes} />
                    </NavLink>
                    <NavLink
                        title="Import Excel"
                        to="/hr-management/import-excel"
                        className={css.sidebarNavItem}
                        activeClassName={
                            activeLocation.HrImportExcel
                                ? css.sidebarActiveNavItem
                                : ""
                        }
                        onClick={() =>
                            handleNavItemClick(
                                activeLocation,
                                setActiveLocation,
                                "HrImportExcel",
                                setSelectedTimesheetStatus
                            )
                        }
                    >
                        <FontAwesomeIcon icon={faFileUpload} />
                    </NavLink>
                </>
            )}
        </div>
    );
};

export default SidebarComponent;
