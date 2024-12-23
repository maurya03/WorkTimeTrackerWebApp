import React from "react";
import Box from "@mui/material/Box";
import Stack from "@mui/material/Stack";
import Button from "@mui/material/Button";
import Typography from "@mui/material/Typography";
import Avatar from "@mui/material/Avatar";
import TextField from "@mui/material/TextField";
import styles from "rootpath/components/EmployeeBook/EmployeeDetails/EmployeeDetails.css";
import useMediaQuery from "@mui/material/useMediaQuery";

const EmployeeBasicDetail = props => {
    const {
        employeeDetail,
        imgFile,
        isEdit,
        employeeProfile,
        designations,
        projectList,
        getImageSource,
        handleDeleteEmployee,
        setIsEdit,
        onEmployeeUpdateProfileForAdmin,
        onEmployeeUpdateProfile,
        onCancel,
        onHandleFormFieldchange,
        onFileChange,
        onSaveEmployeeImage,
        id,
        isAdminNavVisible,
        isDeleteOptionVisible,
        isFormDirty,
        isEditOptionVisible,
        changeView,
        isListView,
        isUpdatedEmployeeView
    } = props;
    const isTab = useMediaQuery("(min-width: 768px) and (max-width:1024px)");
    const isMobile = useMediaQuery("(max-width:767px)");
    return (
        <Box>
            <Stack
                direction="row"
                justifyContent={isEdit ? "end" : "space-between"}
                mb="20px"
            >
                {!isEdit && !isUpdatedEmployeeView && (
                    <Button
                        variant="contained"
                        size="medium"
                        sx={{
                            marginRight: "20px",
                            backgroundColor: "#FA8072"
                        }}
                        onClick={() => {
                            changeView(true);
                        }}
                    >
                        Back to List
                    </Button>
                )}

                <Box display="flex" justifyContent="end">
                    {isAdminNavVisible && (
                        <Stack direction="row" right="0" height="40px">
                            {isEdit ? (
                                <>
                                    <Button
                                        variant="contained"
                                        size="medium"
                                        sx={{
                                            marginLeft: "20px",
                                            backgroundColor: "#bb0000"
                                        }}
                                        onClick={onCancel}
                                    >
                                        Cancel
                                    </Button>
                                    <Button
                                        variant="contained"
                                        size="medium"
                                        sx={{ marginLeft: "20px" }}
                                        onClick={
                                            onEmployeeUpdateProfileForAdmin
                                        }
                                        disabled={!isFormDirty}
                                    >
                                        Save
                                    </Button>
                                </>
                            ) : (
                                <>
                                    {isDeleteOptionVisible && (
                                        <Button
                                            variant="contained"
                                            size="medium"
                                            sx={{
                                                marginLeft: "20px",
                                                backgroundColor: "#bb0000"
                                            }}
                                            onClick={() =>
                                                handleDeleteEmployee(id)
                                            }
                                        >
                                            Delete
                                        </Button>
                                    )}
                                    <Button
                                        variant="contained"
                                        size="medium"
                                        sx={{ marginLeft: "20px" }}
                                        onClick={() => setIsEdit(!isEdit)}
                                    >
                                        Edit
                                    </Button>
                                </>
                            )}
                        </Stack>
                    )}
                    {!isAdminNavVisible && isEditOptionVisible && (
                        <Stack direction="row" right="0" height="40px">
                            {isEdit ? (
                                <>
                                    <Button
                                        variant="contained"
                                        size="medium"
                                        sx={{
                                            marginLeft: "20px",
                                            backgroundColor: "#bb0000"
                                        }}
                                        onClick={onCancel}
                                    >
                                        Cancel
                                    </Button>
                                    <Button
                                        variant="contained"
                                        size="medium"
                                        sx={{ marginLeft: "20px" }}
                                        onClick={onEmployeeUpdateProfile}
                                        disabled={!isFormDirty}
                                    >
                                        Save
                                    </Button>
                                </>
                            ) : (
                                <>
                                    <Button
                                        variant="contained"
                                        size="medium"
                                        sx={{ marginLeft: "20px" }}
                                        onClick={() => setIsEdit(!isEdit)}
                                    >
                                        Edit
                                    </Button>
                                </>
                            )}
                        </Stack>
                    )}
                </Box>
            </Stack>
            <Box display={isMobile ? "" : "flex"} position="relative" mb="20px">
                <Stack
                    direction="column"
                    justifyContent="flex-start"
                    alignItems="center"
                    margin={isMobile ? "20px" : ""}
                >
                    <Avatar
                        src={employeeDetail.profilePictureUrl}
                        marginLeft="30px"
                        sx={{ width: 250, height: 250, borderRadius: "10px" }}
                    />
                    {isEdit && (
                        <>
                            <TextField
                                type="file"
                                id="imgFile"
                                name="imgFile"
                                size="medium"
                                sx={{ marginTop: "10px", width: "250px" }}
                                onInput={e => onFileChange(e)}
                            />
                            <Button
                                variant="contained"
                                size="medium"
                                sx={{ marginTop: "10px" }}
                                onClick={e => onSaveEmployeeImage(e)}
                                disabled={
                                    imgFile === null || imgFile === undefined
                                }
                            >
                                Upload Image
                            </Button>
                        </>
                    )}
                </Stack>
                <Box
                    width="100%"
                    height="250"
                    display="flex"
                    justifyContent={isMobile ? "center" : "flex-start"}
                    alignItems={isMobile ? "center" : "flex-start"}
                >
                    <Stack ml={isMobile ? "0" : "40px"}>
                        <Stack direction="row" alignItems="center" mb="10px">
                            <Stack
                                direction="row"
                                justifyContent="space-between"
                                sx={{ width: isMobile ? "155px" : "170px" }}
                            >
                                <Typography
                                    variant="h6"
                                    fontSize="16px"
                                    fontWeight="600"
                                >
                                    Employee Name
                                </Typography>
                                <Typography
                                    variant="h6"
                                    fontSize="16px"
                                    fontWeight="600"
                                >
                                    :
                                </Typography>
                            </Stack>
                            {isEdit ? (
                                <input
                                    width="200px"
                                    type="text"
                                    className={
                                        "form-control " + styles.inputFullName
                                    }
                                    id="fullName"
                                    name="fullName"
                                    value={employeeProfile.fullName}
                                    onChange={e => onHandleFormFieldchange(e)}
                                />
                            ) : (
                                <Typography
                                    variant="body2"
                                    fontSize="14px"
                                    ml="10px"
                                    sx={{
                                        width: isMobile
                                            ? "calc(100 % - 155px)"
                                            : "auto"
                                    }}
                                >
                                    {employeeDetail.fullName}
                                </Typography>
                            )}
                        </Stack>
                        <Stack direction="row" alignItems="center" mb="10px">
                            <Stack
                                direction="row"
                                justifyContent="space-between"
                                sx={{ width: isMobile ? "155px" : "170px" }}
                            >
                                <Typography
                                    variant="h6"
                                    fontSize="16px"
                                    fontWeight="600"
                                >
                                    Designation
                                </Typography>
                                <Typography
                                    variant="h6"
                                    fontSize="16px"
                                    fontWeight="600"
                                >
                                    :
                                </Typography>
                            </Stack>
                            {isEdit ? (
                                <select
                                    className={
                                        "form-control selectBox " +
                                        styles.inputFullName
                                    }
                                    name="designationId"
                                    id="designationId"
                                    value={employeeProfile.designationId}
                                    onChange={e => onHandleFormFieldchange(e)}
                                >
                                    {designations &&
                                        designations.length > 0 &&
                                        designations.map(designation => (
                                            <option
                                                key={designation.id}
                                                value={designation.id}
                                            >
                                                {designation.designation}
                                            </option>
                                        ))}
                                </select>
                            ) : (
                                <Typography
                                    variant="body2"
                                    fontSize="14px"
                                    ml="10px"
                                    sx={{
                                        width: isMobile
                                            ? "calc(100 % - 155px)"
                                            : "auto"
                                    }}
                                >
                                    {employeeDetail.designation}
                                </Typography>
                            )}
                        </Stack>
                        <Stack direction="row" alignItems="center" mb="10px">
                            <Stack
                                direction="row"
                                justifyContent="space-between"
                                sx={{ width: isMobile ? "155px" : "170px" }}
                            >
                                <Typography
                                    variant="h6"
                                    fontSize="16px"
                                    fontWeight="600"
                                >
                                    Project/Team
                                </Typography>
                                <Typography
                                    variant="h6"
                                    fontSize="16px"
                                    fontWeight="600"
                                >
                                    :
                                </Typography>
                            </Stack>
                            {isEdit ? (
                                <select
                                    className={
                                        "form-control selectBox " +
                                        styles.inputFullName
                                    }
                                    name="projectId"
                                    id="projectId"
                                    value={employeeProfile.projectId}
                                    onChange={e => onHandleFormFieldchange(e)}
                                >
                                    {projectList &&
                                        projectList.length > 0 &&
                                        projectList.map(project => (
                                            <option
                                                key={project.id}
                                                value={project.id}
                                            >
                                                {project.projectName}
                                            </option>
                                        ))}
                                </select>
                            ) : (
                                <Typography
                                    variant="body2"
                                    fontSize="14px"
                                    ml="10px"
                                    sx={{
                                        width: isMobile
                                            ? "calc(100 % - 155px)"
                                            : "auto"
                                    }}
                                >
                                    {employeeDetail.project}
                                </Typography>
                            )}
                        </Stack>
                        <Stack direction="row" alignItems="center" mb="10px">
                            <Stack
                                direction="row"
                                justifyContent="space-between"
                                sx={{ width: isMobile ? "155px" : "170px" }}
                            >
                                <Typography
                                    variant="h6"
                                    fontSize="16px"
                                    fontWeight="600"
                                >
                                    Year of Experience
                                </Typography>
                                <Typography
                                    variant="h6"
                                    fontSize="16px"
                                    fontWeight="600"
                                >
                                    :
                                </Typography>
                            </Stack>
                            {isEdit ? (
                                <input
                                    type="number"
                                    className={
                                        "form-control " + styles.inputFullName
                                    }
                                    id="experienceYear"
                                    min={0}
                                    max={30}
                                    name="experienceYear"
                                    value={employeeProfile.experienceYear}
                                    onChange={e => onHandleFormFieldchange(e)}
                                />
                            ) : (
                                <Typography
                                    variant="body2"
                                    fontSize="14px"
                                    ml="10px"
                                    sx={{
                                        width: isMobile
                                            ? "calc(100 % - 155px)"
                                            : "auto"
                                    }}
                                >
                                    {employeeDetail.experienceYear}
                                </Typography>
                            )}
                        </Stack>
                        <Stack direction="row" alignItems="center" mb="10px">
                            <Stack
                                direction="row"
                                justifyContent="space-between"
                                sx={{ width: isMobile ? "155px" : "170px" }}
                            >
                                <Typography
                                    variant="h6"
                                    fontSize="16px"
                                    fontWeight="600"
                                >
                                    Native Place
                                </Typography>
                                <Typography
                                    variant="h6"
                                    fontSize="16px"
                                    fontWeight="600"
                                >
                                    :
                                </Typography>
                            </Stack>
                            {isEdit ? (
                                <input
                                    type="text"
                                    className={
                                        "form-control " + styles.inputFullName
                                    }
                                    id="nativePlace"
                                    name="nativePlace"
                                    value={employeeProfile.nativePlace}
                                    onChange={e => onHandleFormFieldchange(e)}
                                />
                            ) : (
                                <Typography
                                    variant="body2"
                                    fontSize="14px"
                                    ml="10px"
                                    sx={{
                                        width: isMobile
                                            ? "calc(100 % - 155px)"
                                            : "auto"
                                    }}
                                >
                                    {employeeDetail.nativePlace}
                                </Typography>
                            )}
                        </Stack>
                    </Stack>
                </Box>
            </Box>
        </Box>
    );
};
export default EmployeeBasicDetail;
