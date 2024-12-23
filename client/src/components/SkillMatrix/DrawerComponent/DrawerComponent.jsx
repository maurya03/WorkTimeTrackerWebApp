import React, { useState, useEffect } from "react";
import css from "./DrawerComponent.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTimes } from "@fortawesome/free-solid-svg-icons";
import AddClientContainer from "../AddClient/AddClientContainer";
import AddTeamContainer from "../AddTeam/AddTeamContainer";
import AddCategoryContainer from "../AddCategory/AddCategoryContainer";
import AddSubCategoryContainer from "../AddSubCategory/AddSubCategoryContainer";
import AddEmployeeContainer from "../AddEmployee/AddEmployeeContainer";

const DrawerComponent = props => {
    const [rightPosition, setRightPosition] = useState("-70%");
    useEffect(() => {
        setRightPosition("0");
    });
    return (
        <>
            <div className={css.drawerOverlay}></div>
            <div
                className={css.drawer_container}
                style={{ right: rightPosition }}
            >
                <div className={css.drawerHeader}>
                    <h5 className={css.title}>{props.formHeaderTitle}</h5>
                    <span className={css.closeIcon}>
                        {" "}
                        <FontAwesomeIcon
                            icon={faTimes}
                            size="lg"
                            onClick={() => {
                                if (props.setIsEdit) {
                                    props.setIsEdit(false);
                                }

                                props.setShowDrawer(!props.showDrawer);
                                props.setShowAlert(false);
                                props.setaddTeamFormVisible &&
                                    props.setaddTeamFormVisible(
                                        !props.addTeamFormVisible
                                    ) &&
                                    props.setIsEdit(false);
                                props.setclientFormVisible &&
                                    props.setclientFormVisible(
                                        !props.clientFormVisible
                                    ) &&
                                    props.setIsClientEdit(false);
                                props.setcategoryFormVisible &&
                                    props.setcategoryFormVisible(
                                        !props.categoryFormVisible
                                    );
                                props.setaddSubCategoryFormVisible &&
                                    props.setaddSubCategoryFormVisible(
                                        !props.addSubCategoryFormVisible
                                    ) &&
                                    props.setIsSubCategoryEdit(false);
                                props.setaddEmployeeFormVisible &&
                                    props.setaddEmployeeFormVisible(
                                        !props.addEmployeeFormVisible
                                    );
                            }}
                        />
                    </span>
                </div>
                {props.clientFormVisible && (
                    <AddClientContainer
                        clientFormVisible={props.clientFormVisible}
                        setclientFormVisible={props.setclientFormVisible}
                        showDrawer={props.showDrawer}
                        setShowDrawer={props.setShowDrawer}
                        setIsEdit={props.setIsClientEdit}
                        selectedClient={props.selectedClient}
                        setShowAlert={props.setShowAlert}
                    />
                )}
                {props.addTeamFormVisible && props.parentid && (
                    <AddTeamContainer
                        addTeamFormVisible={props.addTeamFormVisible}
                        setaddTeamFormVisible={props.setaddTeamFormVisible}
                        showDrawer={props.showDrawer}
                        setShowDrawer={props.setShowDrawer}
                        selectedClient={props.selectedClient}
                        setTeams={props.setTeams}
                        selectedTeam={props.selectedTeam}
                        setIsEdit={props.setIsEdit}
                        setShowAlert={props.setShowAlert}
                    />
                )}
                {props.categoryFormVisible && (
                    <AddCategoryContainer
                        categoryFormVisible={props.categoryFormVisible}
                        setcategoryFormVisible={props.setcategoryFormVisible}
                        showDrawer={props.showDrawer}
                        setShowDrawer={props.setShowDrawer}
                        selectedCategory={props.selectedCategory}
                        setIsEdit={props.setIsCategoryEdit}
                        setShowAlert={props.setShowAlert}
                    />
                )}
                {props.addSubCategoryFormVisible && props.parentid && (
                    <AddSubCategoryContainer
                        addSubCategoryFormVisible={
                            props.addSubCategoryFormVisible
                        }
                        setaddSubCategoryFormVisible={
                            props.setaddSubCategoryFormVisible
                        }
                        showDrawer={props.showDrawer}
                        setShowDrawer={props.setShowDrawer}
                        setSubCategory={props.setSubCategory}
                        selectedCategory={props.selectedCategory}
                        selectedSubCategory={props.selectedSubCategory}
                        setIsEdit={props.setIsSubCategoryEdit}
                        setShowAlert={props.setShowAlert}
                    />
                )}
                {props.addEmployeeFormVisible && props.parentid && (
                    <AddEmployeeContainer
                        addEmployeeFormVisible={props.addEmployeeFormVisible}
                        setaddEmployeeFormVisible={
                            props.setaddEmployeeFormVisible
                        }
                        showDrawer={props.showDrawer}
                        setShowDrawer={props.setShowDrawer}
                        setEmployees={props.setEmployees}
                        selectedTeam={props.selectedTeam}
                        setIsEdit={props.setIsEdit}
                        fetchEmplist={props.fetchEmplist}
                        selectedEmployee={props.selectedEmployee}
                        setShowAlert={props.setShowAlert}
                        setActiveClient={props.setActiveClient}
                        setActiveTeam={props.setActiveTeam}
                        fetchTeamList={props.fetchTeamList}
                    />
                )}
            </div>
        </>
    );
};

export default DrawerComponent;
