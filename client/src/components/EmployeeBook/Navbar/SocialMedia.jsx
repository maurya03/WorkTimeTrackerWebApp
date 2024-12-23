import React from "react";
import { useMsal } from "@azure/msal-react";
import FacebookIcon from "@mui/icons-material/Facebook";
import TwitterIcon from "@mui/icons-material/Twitter";
import LinkedInIcon from "@mui/icons-material/LinkedIn";
import YouTubeIcon from "@mui/icons-material/YouTube";
import LogoutIcon from "@mui/icons-material/Logout";
import TungstenIcon from "@mui/icons-material/Tungsten";
import { Box, IconButton } from "@mui/material";

const SocialMedia = ({ isMobile, history }) => {
    const { instance } = useMsal();
    const signOutClickHandler = instance => {
        localStorage.removeItem("accessToken");
        instance.logoutRedirect({
            postLogoutRedirectUri: "/"
        });
    };
    return (
        <Box>
            <IconButton
                onClick={() => history.push("/employeebook/share-idea/")}
                sx={{
                    backgroundColor: "#007bb5",
                    marginRight: "10px",
                    padding: "7px"
                }}
            >
                <TungstenIcon
                    fontSize={isMobile ? "small" : ""}
                    sx={{ color: "#fff" }}
                />
            </IconButton>
            <IconButton
                target="_blank"
                href="https://www.linkedin.com/company/bhavna-corp"
                sx={{
                    backgroundColor: "#007bb5",
                    marginRight: "10px",
                    padding: "7px"
                }}
            >
                <LinkedInIcon
                    fontSize={isMobile ? "small" : ""}
                    sx={{ color: "#fff" }}
                />
            </IconButton>
            <IconButton
                target="_blank"
                href="https://www.facebook.com/BhavnaCorp"
                sx={{
                    backgroundColor: "#5f86d8",
                    marginRight: "10px",
                    padding: "6px"
                }}
            >
                <FacebookIcon
                    fontSize={isMobile ? "small" : ""}
                    sx={{ color: "#fff" }}
                />
            </IconButton>
            <IconButton
                target="_blank"
                href="https://twitter.com/bhavnacorp"
                sx={{
                    backgroundColor: "#55acee",
                    marginRight: "10px",
                    padding: "5px"
                }}
            >
                <TwitterIcon
                    fontSize={isMobile ? "small" : ""}
                    sx={{ color: "#fff" }}
                />
            </IconButton>
            <IconButton
                target="_blank"
                href="https://www.youtube.com/channel/UCfMyo7XDnTuCtk0ZQl63FTQ/featured"
                sx={{
                    backgroundColor: "#bb0000",
                    marginRight: "10px",
                    padding: "5px"
                }}
            >
                <YouTubeIcon
                    fontSize={isMobile ? "small" : ""}
                    sx={{ color: "#fff" }}
                />
            </IconButton>
            <LogoutIcon
                sx={{ color: "#fff", cursor: "pointer" }}
                onClick={() => signOutClickHandler(instance)}
            />
        </Box>
    );
};

export default SocialMedia;
