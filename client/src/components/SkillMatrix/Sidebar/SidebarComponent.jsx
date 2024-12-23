import {
    faLaptopCode,
    faPenToSquare,
    faSitemap,
    faTableList,
    faCheck,
    faUserPlus,
    faUsers,
    faHome,
    faFile
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import React, { useState, useEffect } from "react";
import css from "./SidebarComponent.css";
import { NavLink } from "react-router-dom";
import { handleNavItemClick } from "./SidebarFunctions";

const SidebarComponent = ({ userRole, fetchRole }) => {
    const path = window.location.pathname;
    const [isAdminNavVisible, setIsAdminNavVisible] = useState(false);

    useEffect(() => {
        fetchRole();
    }, [fetchRole]);

    useEffect(() => {
        const value =
            Object.keys(userRole).length > 0 &&
            userRole.roleName !== "Reporting_Manager";
        setIsAdminNavVisible(value);
    });
    const [activeLocation, setActiveLocation] = useState({
        dashboard: path === "/skill-matrix/dashboard",
        clients: path === "/skill-matrix/client",
        category: path === "/skill-matrix/category",
        employee: path === "/skill-matrix/employee",
        clientScore: path === "/skill-matrix/client-score",
        employeeScore: path === "/skill-matrix/employee-score",
        scoreMapping: path === "/skill-matrix/score-mapping",
        reports: path === "/skill-matrix/reports",
        roleManagement: path === "/skill-matrix/role-management"
    });
    return (
        <div className={css.sidebarContainerDiv}>
            <NavLink
                title="Dashbaord"
                to="/skill-matrix/dashboard"
                exact
                className={css.sidebarNavItem}
                activeClassName={
                    activeLocation.dashboard ? css.sidebarActiveNavItem : ""
                }
                onClick={() =>
                    handleNavItemClick(
                        activeLocation,
                        setActiveLocation,
                        "dashboard"
                    )
                }
            >
                <FontAwesomeIcon icon={faHome} />
            </NavLink>
            <NavLink
                title="Client Master"
                to="/skill-matrix/client"
                exact
                className={css.sidebarNavItem}
                activeClassName={
                    activeLocation.clients ? css.sidebarActiveNavItem : ""
                }
                onClick={() =>
                    handleNavItemClick(
                        activeLocation,
                        setActiveLocation,
                        "clients"
                    )
                }
            >
                <FontAwesomeIcon icon={faSitemap} />
            </NavLink>
            <NavLink
                title="Category Master"
                to="/skill-matrix/category"
                className={css.sidebarNavItem}
                activeClassName={
                    activeLocation.category ? css.sidebarActiveNavItem : ""
                }
                onClick={() =>
                    handleNavItemClick(
                        activeLocation,
                        setActiveLocation,
                        "category"
                    )
                }
            >
                <FontAwesomeIcon icon={faLaptopCode} />
            </NavLink>
            {isAdminNavVisible && (
                <NavLink
                    title="Employee Master"
                    to="/skill-matrix/employee"
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
            <NavLink
                title="Client Expected Score Mapping"
                to="/skill-matrix/client-score"
                className={css.sidebarNavItem}
                activeClassName={
                    activeLocation.clientScore ? css.sidebarActiveNavItem : ""
                }
                onClick={() =>
                    handleNavItemClick(
                        activeLocation,
                        setActiveLocation,
                        "clientScore"
                    )
                }
            >
                <FontAwesomeIcon icon={faPenToSquare} />
            </NavLink>
            <NavLink
                title="Score Mappings"
                to="/skill-matrix/score-mapping"
                className={css.sidebarNavItem}
                activeClassName={
                    activeLocation.scoreMapping ? css.sidebarActiveNavItem : ""
                }
                onClick={() =>
                    handleNavItemClick(
                        activeLocation,
                        setActiveLocation,
                        "scoreMapping"
                    )
                }
            >
                <FontAwesomeIcon icon={faTableList} />
            </NavLink>
            <NavLink
                title="Reports"
                to="/skill-matrix/reports"
                className={css.sidebarNavItem}
                activeClassName={
                    activeLocation.reports ? css.sidebarActiveNavItem : ""
                }
                onClick={() =>
                    handleNavItemClick(
                        activeLocation,
                        setActiveLocation,
                        "reports"
                    )
                }
            >
                <FontAwesomeIcon icon={faFile} />
            </NavLink>
            {isAdminNavVisible && (
                <NavLink
                    title="Role Management"
                    to="/skill-matrix/role-management"
                    className={css.sidebarNavItem}
                    activeClassName={
                        activeLocation.roleManagement
                            ? css.sidebarActiveNavItem
                            : ""
                    }
                    onClick={() =>
                        handleNavItemClick(
                            activeLocation,
                            setActiveLocation,
                            "roleManagement"
                        )
                    }
                >
                    <FontAwesomeIcon icon={faUserPlus} />
                </NavLink>
            )}
        </div>
    );
};

export default SidebarComponent;
