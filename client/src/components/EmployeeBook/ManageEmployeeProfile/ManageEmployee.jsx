import React, { useEffect, useState } from "react";
import { useParams, useHistory, withRouter } from "react-router-dom";
import Box from "@mui/material/Box";
import Stack from "@mui/material/Stack";
import Button from "@mui/material/Button";
import EmployeePersonalDetailFields from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeePersonalDetailFields.jsx";
import {
    getImageSource,
    HttpCodes,
    HttpVerbsMessage
} from "rootpath/services/EmployeeBook/employee/EmployeeDetail.js";
import {
    updateEmployeeDetailById,
    rejectUpdatedEmployeeDetailById
} from "rootpath/services/EmployeeBook/employee/EmployeeService";
import { EmployeeDetailsFieldData } from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeeDetailsFieldData.js";
import EmployeeQuickFire from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeeQuickFire";
import EmployeeBasicDetail from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeeBasicDetail";
import ReactGA from "react-ga4";
import useMediaQuery from "@mui/material/useMediaQuery";
import Alert from "@mui/material/Alert";
const ManageEmployee = ({
    fetchUpdatedEmployeeDetailById,
    updatedEmployeeById,
    userRole,
    designations,
    projectList,
    history,
    match,
    fetchUpdatedEmployeesList
}) => {
    const [showAlert, setShowAlert] = useState(false);
    const [severity, setSeverity] = useState("");
    const [responseMessage, setResponseMessage] = useState("");
    const [isAdminNavVisible, setIsAdminNavVisible] = useState(false);
    const [isHRNavVisible, setIsHRNavVisible] = useState(false);
    const [employeeProfile, setEmployeeProfile] = useState({});
    const [employeeFieldData, setEmployeeFieldData] = useState(
        EmployeeDetailsFieldData
    );
    const [showApproveReject, setShowApproveReject] = useState(true);
    const isMobile = useMediaQuery("(max-width: 767px)");
    const { employeeId } = match.params;
    useEffect(() => {
        ReactGA.send({
            hitType: "pageview",
            page: window.location.pathname,
            title: "EmployeeBook user detail page"
        });
    }, []);

    useEffect(() => {
        if (showAlert) {
            const timeOutSet = setTimeout(() => {
                handleAlertBarClose();
            }, 4000);

            return () => clearTimeout(timeOutSet);
        }
    }, [showAlert]);

    useEffect(() => {
        window.scrollTo(0, 0);
        setEmployeeProfile(updatedEmployeeById);
        EmployeeDetailsFieldData.forEach(data => {
            data.answere = updatedEmployeeById[data.id];
        });
        setEmployeeFieldData(EmployeeDetailsFieldData);
    }, [updatedEmployeeById]);

    useEffect(() => {
        fetchUpdatedEmployeeDetailById(employeeId);
        window.scrollTo(0, 0);
    }, [fetchUpdatedEmployeeDetailById, employeeId]);

    useEffect(() => {
        const isAdmin =
            Object.keys(userRole).length > 0 && userRole.roleName == "Admin";
        const isHR =
            Object.keys(userRole).length > 0 && userRole.roleName == "HR";
        setIsHRNavVisible(isHR);
        setIsAdminNavVisible(isAdmin);
    }, []);

    const handleAlertBarClose = () => setShowAlert(false);

    const onApproveReject = async type => {
        setShowApproveReject(false);
        let result;
        if (type === "approve") {
            result = await updateEmployeeDetailById(
                employeeId,
                updatedEmployeeById
            );
        } else {
            result = await rejectUpdatedEmployeeDetailById(employeeId);
        }
        if (result?.success?.status == HttpCodes.success) {
            setSeverity("success");
            setResponseMessage(
                HttpVerbsMessage.find(
                    x =>
                        x.page === "manageEmployee" &&
                        x.verb === type &&
                        x.severity === "success"
                ).message
            );
            setShowAlert(true);
            fetchUpdatedEmployeesList();
        }
    };
    return (
        <Box mt="40px" width="100%" className="container">
            {showAlert && (
                <Alert onClose={handleAlertBarClose} severity={severity}>
                    {responseMessage}
                </Alert>
            )}

            <Stack direction="row" justifyContent={"space-between"} mb="20px">
                <Button
                    variant="contained"
                    size="medium"
                    sx={{
                        marginRight: "20px",
                        backgroundColor: "#FA8072"
                    }}
                    onClick={() => {
                        history.push("/employeebook/manage-employee-profile");
                    }}
                >
                    Back to List
                </Button>

                <Box display="flex" justifyContent="end">
                    {(isAdminNavVisible || isHRNavVisible) &&
                        showApproveReject && (
                            <Stack direction="row" right="0" height="40px">
                                <Button
                                    variant="contained"
                                    size="medium"
                                    sx={{
                                        marginLeft: "20px",
                                        backgroundColor: "#bb0000"
                                    }}
                                    onClick={() => {
                                        onApproveReject("reject");
                                    }}
                                >
                                    Reject
                                </Button>
                                <Button
                                    variant="contained"
                                    size="medium"
                                    sx={{ marginLeft: "20px" }}
                                    onClick={() => {
                                        onApproveReject("approve");
                                    }}
                                >
                                    Approve
                                </Button>
                            </Stack>
                        )}
                </Box>
            </Stack>
            <EmployeeBasicDetail
                employeeDetail={updatedEmployeeById}
                employeeProfile={employeeProfile}
                designations={designations}
                projectList={projectList}
                getImageSource={getImageSource}
                id={employeeId}
                isAdminNavVisible={false}
                isUpdatedEmployeeView={true}
                isEdit={false}
            />
            <Box
                display="flex"
                flexDirection="column"
                alignItems={isMobile && "flex-start"}
            >
                <Box
                    display={isMobile && "flex"}
                    justifyContent={isMobile && "center"}
                    width="100%"
                >
                    <EmployeeQuickFire employeeFieldData={employeeFieldData} />
                </Box>
                <Box mb="80px">
                    {employeeFieldData
                        ?.filter(record => record.isQuickFire === false)
                        .map(field => {
                            return (
                                <EmployeePersonalDetailFields
                                    key={field.id}
                                    details={field}
                                />
                            );
                        })}
                </Box>
            </Box>
        </Box>
    );
};
export default ManageEmployee;
