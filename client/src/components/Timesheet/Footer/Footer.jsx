import React, { useState } from "react";
import { NavLink } from "react-router-dom";
// import { Button } from "react-bootstrap";
import css from "./Footer.css";

const Footer = props => {
    const afterSubmitRedirectTo =
        props.userRole.roleName === "Employee"
            ? "/timesheet/list"
            : props.isBehalf
            ? "/timesheet"
            : "/timesheet/pending";
    return (
        <div>
            {/* {(!props.isDetailPanel &&
                props.initialTimesheetId > 0 &&
                !props.isSubmitted &&
                props.canEdit) ||
            (props.data.length > 0 && !props.isSubmitted) ||
            !props.isEditMode ||
            (props.selectedTimesheetStatus.rejected && !props.isEditMode) ? (
                <NavLink to={afterSubmitRedirectTo}>
                    <Button
                        variant="contained"
                        color="secondary"
                        className={"btn btn-success " + css.submitButton}
                        size="large"
                        onClick={props.handleSubmitClick}
                    >
                        Submit
                    </Button>
                </NavLink>
            ) : null} */}
        </div>
    );
};

export default Footer;
