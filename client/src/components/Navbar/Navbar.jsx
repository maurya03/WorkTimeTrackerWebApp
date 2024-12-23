import React, { useState, useEffect } from "react";
import css from "./Navbar.css";
import constants from "rootpath/components/SkillMatrix/constants";
import bhavnaLogo from "rootpath/assets/bhavna-logo.png";
import { useMsal } from "@azure/msal-react";
import { ExitToApp } from "@material-ui/icons";
import Stack from "@mui/material/Stack";
import Button from "@mui/material/Button";
import WelcomeMessage from "rootpath/components/Navbar/WelcomeMessage/WelcomeMessage";
const Navbar = ({ applicationList, userRole, fetchApplicationAccess }) => {
    const { instance } = useMsal();
    const signOutClickHandler = instance => {
        localStorage.removeItem("accessToken");
        instance.logoutRedirect({
            postLogoutRedirectUri: "/"
        });
    };
    useEffect(() => {
        fetchApplicationAccess();
    }, [fetchApplicationAccess]);
    return (
        <div className={css.Navbar}>
            <nav className={css.NavbarItems}>
                <div className={css.Left_Navbar_Headings}>
                    {/* <h3 className={css.navbarBrand}>{constants.CompanyName}</h3> */}
                    <Stack spacing={2} direction="row">
                        {applicationList?.success &&
                            applicationList?.success.length > 1 &&
                            applicationList?.success.map((app, key) => (
                                <Button
                                    style={{ border: "1px solid #0000FF" }}
                                    key={key}
                                    variant="outlined"
                                >
                                    <a
                                        className={css.linkButton}
                                        href={app.applicationPath}
                                    >
                                        {app.applicationName}
                                    </a>
                                </Button>
                            ))}
                    </Stack>
                </div>
                {userRole.employeeName && (
                    <WelcomeMessage userRole={userRole} />
                )}
                <div className={css.companyLogo}>
                    <img className={css.companyLogoImg} src={bhavnaLogo} />
                </div>
                <div>
                    <ExitToApp
                        className={css.logoutIcon}
                        titleAccess="Logout"
                        onClick={() => signOutClickHandler(instance)}
                    />
                </div>
            </nav>
        </div>
    );
};

export default Navbar;
