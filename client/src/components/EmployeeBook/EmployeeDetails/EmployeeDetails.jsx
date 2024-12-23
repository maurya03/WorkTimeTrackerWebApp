import React, { useEffect, useState } from "react";
import Box from "@mui/material/Box";
import EmployeePersonalDetailFields from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeePersonalDetailFields.jsx";
import {
    validateImage,
    getImageSource,
    saveEmployeeImage,
    updateEmployeeFieldData,
    updateEmployeeDetail,
    handleDeleteEmployee,
    HttpCodes,
    HttpVerbsMessage
} from "rootpath/services/EmployeeBook/employee/EmployeeDetail.js";
import { EmployeeDetailsFieldData } from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeeDetailsFieldData.js";
import EmployeeBasicDetail from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeeBasicDetail";
import EmployeeQuickFire from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeeQuickFire";
import ReactGA from "react-ga4";
import useMediaQuery from "@mui/material/useMediaQuery";
import Alert from "@mui/material/Alert";

const EmployeeDetails = ({
    fetchEmployeeDetail,
    employeeDetail,
    userRole,
    fetchRole,
    designations,
    fetchDesignations,
    fetchProjectList,
    projectList,
    id,
    setEmployeesDetails,
    changeView,
    isListView,
    setAllEmployeeList,
    employeesList,
    employees,
    history
}) => {
    const [isFormDirty, setFormDirty] = useState(false);
    const [showAlert, setShowAlert] = useState(false);
    const [severity, setSeverity] = useState("");
    const [responseMessage, setResponseMessage] = useState("");
    const [isEdit, setIsEdit] = useState(false);
    const [isValidImage, setValidImage] = useState(false);
    const [isAdminNavVisible, setIsAdminNavVisible] = useState(false);
    const [isDeleteOptionVisible, setDeleteOptionVisible] = useState(true);
    const [isEditOptionVisible, setEditOptionVisible] = useState(false);
    const [employeeProfile, setEmployeeProfile] = useState({});
    const [employeeFieldData, setEmployeeFieldData] = useState(
        EmployeeDetailsFieldData
    );
    const [imgFile, setImageFile] = useState();
    const isMobile = useMediaQuery("(max-width: 767px)");
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
        setEmployeeProfile(employeeDetail);
        EmployeeDetailsFieldData.map(data => {
            if (data.id in employeeDetail) {
                data.answere = employeeDetail[data.id];
            }
            return data;
        });
        setEmployeeFieldData(EmployeeDetailsFieldData);
    }, [employeeDetail]);

    useEffect(() => {
        fetchEmployeeDetail(id);
        window.scrollTo(0, 0);
    }, [fetchEmployeeDetail, id]);

    useEffect(() => {
        fetchRole();
        fetchDesignations();
        fetchProjectList();
    }, [fetchRole, fetchDesignations, fetchProjectList]);

    useEffect(() => {
        if (userRole.employeeId == id) {
            setDeleteOptionVisible(false);
            setEditOptionVisible(true);
        }
        const value =
            Object.keys(userRole).length > 0 && userRole.roleName == "Admin";
        setIsAdminNavVisible(value);
        return () => {
            setEmployeesDetails();
            setEmployeeFieldData([]);
        };
    }, []);
    useEffect(() => {
        if (id == undefined || id == 0 || id === null) {
            history.push("/employeebook/");
        }
    }, []);

    const onHandleFormFieldchange = e => {
        const value = e.target.value;
        setEmployeeProfile(prev => {
            return { ...prev, [e.target.id]: value };
        });
        if (e.target.id == "designationId") {
            if (designations) {
                employeeDetail.designation = designations.find(
                    x => x.id === parseInt(value)
                ).designation;
            }
        } else if (e.target.id == "projectId") {
            if (projectList) {
                employeeDetail.project = projectList.find(
                    x => x.id === parseInt(value)
                ).projectName;
            }
        } else if (e.target.id == "experienceYear") {
            employeeDetail.experienceYear = parseInt(value);
        } else if (e.target.id == "nativePlace") {
            employeeDetail.nativePlace = value;
        }
        setFormDirty(true);
    };

    const onCancel = async () => {
        setIsEdit(false);
        await fetchEmployeeDetail(id, employeesList, employees);
    };

    const onFileChange = e => {
        setValidImage(validateImage(e));
        if (isValidImage);
        {
            setImageFile(e.target.files[0]);
        }
    };

    const onSaveEmployeeImage = async () => {
        await saveEmployeeImage(id, imgFile);
        ReactGA.event({
            category: "EmployeeProfile",
            action: "UpdateEmployeeImageTrigger",
            label: "Employee Profile Image Update",
            value: 1
        });
        await fetchEmployeeDetail(id, employeesList, employees);
    };

    const onFieldValueChange = e => {
        const empRecord = updateEmployeeFieldData(e, employeeFieldData);
        setEmployeeFieldData(empRecord);
        setEmployeeProfile(prev => {
            return { ...prev, [e.target.id]: e.target.value };
        });
        setFormDirty(true);
    };
    const onEmployeeUpdateProfileForAdmin = async () => {
        const result = await updateEmployeeDetail(
            id,
            employeeProfile,
            userRole.employeeId
        );
        if (result?.success?.status == HttpCodes.success) {
            ReactGA.event({
                category: "EmployeeProfile",
                action: "UpdateEmployeeTrigger",
                label: "Update Employee Profile Action Taken",
                value: 1
            });
            setEmployeeProfile(employeeProfile);
            setAllEmployeeList(employeesList, employeeProfile);
            setFormDirty(false);
            setIsEdit(false);
            setSeverity("success");
            setResponseMessage(
                HttpVerbsMessage.find(
                    x =>
                        x.page === "employeedetail" &&
                        x.verb === "update" &&
                        x.severity === "success"
                ).message
            );
        } else {
            setSeverity("error");
            setResponseMessage(
                HttpVerbsMessage.find(
                    x.page === "employeedetail" &&
                        x.verb === "update" &&
                        x.severity === "error"
                ).message
            );
        }
        setShowAlert(true);
    };

    const onEmployeeUpdateProfile = async () => {
        const result = await updateEmployeeDetailByEmployees(employeeProfile);
        if (result?.success?.status == HttpCodes.success) {
            ReactGA.event({
                category: "EmployeeProfile",
                action: "UpdateEmployeeTrigger",
                label: "Update Employee Profile Action Taken",
                value: 1
            });
            setEmployeeProfile(employeeProfile);
            setAllEmployeeList(employeesList, employeeProfile);
            setFormDirty(false);
            setIsEdit(false);
            setSeverity("success");
            setResponseMessage(
                HttpVerbsMessage.find(
                    x =>
                        x.page === "employeedetail" &&
                        x.verb === "updateEmployee" &&
                        x.severity === "success"
                ).message
            );
        } else {
            setSeverity("error");
            setResponseMessage(
                HttpVerbsMessage.find(
                    x.page === "employeedetail" &&
                        x.verb === "updateEmployee" &&
                        x.severity === "error"
                ).message
            );
        }
        setShowAlert(true);
    };

    const onDeleteEmployee = async id => {
        if (confirm("Are you sure you want to delete this Employee?")) {
            const result = await handleDeleteEmployee(id, userRole.employeeId);
            if (result?.success?.status == HttpCodes.success) {
                ReactGA.event({
                    category: "EmployeeProfile",
                    action: "DeleteEmployeeTrigger",
                    label: "Delete Employee Action Taken",
                    value: 1
                });
                history.push("/employeebook/");
                setSeverity("success");
                setResponseMessage(
                    HttpVerbsMessage.find(
                        x.page === "employeedetail" &&
                            x.verb === "delete" &&
                            x.severity === "success"
                    ).message
                );
            } else {
                setSeverity("error");
                setResponseMessage(
                    HttpVerbsMessage.find(
                        x.page === "employeedetail" &&
                            x.verb === "delete" &&
                            x.severity === "error"
                    ).message
                );
            }
            setShowAlert(true);
        }
    };
    const handleAlertBarClose = () => setShowAlert(false);
    return (
        <Box mt="40px" width="100%" className="container">
            {showAlert && (
                <Alert onClose={handleAlertBarClose} severity={severity}>
                    {responseMessage}
                </Alert>
            )}
            <EmployeeBasicDetail
                employeeDetail={employeeDetail}
                imgFile={imgFile}
                isEdit={isEdit}
                employeeProfile={employeeProfile}
                designations={designations}
                projectList={projectList}
                getImageSource={getImageSource}
                handleDeleteEmployee={onDeleteEmployee}
                setIsEdit={setIsEdit}
                onEmployeeUpdateProfileForAdmin={
                    onEmployeeUpdateProfileForAdmin
                }
                onEmployeeUpdateProfile={onEmployeeUpdateProfile}
                onCancel={onCancel}
                onHandleFormFieldchange={onHandleFormFieldchange}
                onFileChange={onFileChange}
                onSaveEmployeeImage={onSaveEmployeeImage}
                id={id}
                isAdminNavVisible={isAdminNavVisible}
                isDeleteOptionVisible={isDeleteOptionVisible}
                isFormDirty={isFormDirty}
                isEditOptionVisible={isEditOptionVisible}
                changeView={changeView}
                isListView={isListView}
                isUpdatedEmployeeView={false}
            />
            <Box
                display="flex"
                flexDirection="column"
                alignItems={isMobile ? "flex-start" : ""}
            >
                <Box
                    display={isMobile ? "flex" : ""}
                    justifyContent={isMobile ? "center" : ""}
                    width="100%"
                >
                    <EmployeeQuickFire
                        employeeFieldData={employeeFieldData}
                        isEdit={isEdit}
                        onFieldValueChange={onFieldValueChange}
                    />
                </Box>
                <Box mb="80px">
                    {employeeFieldData
                        ?.filter(record => record.isQuickFire === false)
                        .map(field => {
                            return (
                                <EmployeePersonalDetailFields
                                    key={field.id}
                                    details={field}
                                    isEdit={isEdit}
                                    onFieldchange={e => onFieldValueChange(e)}
                                />
                            );
                        })}
                </Box>
            </Box>
        </Box>
    );
};
export default EmployeeDetails;
