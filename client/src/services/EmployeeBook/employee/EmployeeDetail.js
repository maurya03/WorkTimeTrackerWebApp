import config from "Configurator";
import {
    deleteEmployee,
    uploadEmployeeImage,
    updateEmployeeDetails,
    updateEmployeeDetailsByEmployee
} from "rootpath/services/EmployeeBook/employee/EmployeeService";

const imageMimeTypes = [
    "image/webp",
    "image/png",
    "image/jpeg",
    "image/vnd.microsoft.icon",
    "image/gif",
    "image/bmp",
    "image/jpg"
];

export const validateImage = file => {
    if (!file) {
        alert(`No file selected !!`);
        return false;
    }
    var img = file.target.files[0];
    //Validation of only image type allowed to upload
    if (!imageMimeTypes.includes(img.type)) {
        alert(`Only Image allowed to upload !!`);
        return false;
    }
    if (
        img.width > config.employeeImageWidth ||
        img.height > config.employeeImageHeight
    ) {
        alert(
            `Employee image height and width must not exceed ${config.employeeImageWidth}px by ${config.employeeImageHeight}px !!`
        );
        return false;
    }
    var size = parseFloat(img.size);
    var maxSizeKB = config.employeeImageSize; //Size in KB.
    var maxSize = maxSizeKB * 1024; //File size is returned in Bytes.
    if (size > maxSize) {
        alert(`Max image file size ${maxSizeKB}kb allowed.`);
        return false;
    }
    return true;
};

export const getImageSource = imageByteAray => {
    if (imageByteAray) {
        return "data:image/png;base64," + imageByteAray;
    }
};

export const handleDeleteEmployee = async (id, loggedInEmployeeId) => {
    return await deleteEmployee(id, loggedInEmployeeId);
};

export const saveEmployeeImage = async (employeeId, imageData) => {
    if (imageData) {
        let form = new FormData();
        form.append("employeeImgFile", imageData);
        form.append("employeeId", employeeId);
        await uploadEmployeeImage(form);
    } else {
        alert("No image found to save !!");
    }
};

export const validateUpdateEmployee = employeeProfile => {
    if (employeeProfile) {
        if (!employeeProfile.fullName && employeeProfile.fullName == "") {
            alert("Employee full name require !!");
            return false;
        }
    }
    return true;
};

export const updateEmployeeFieldData = (field, employeeFieldData) => {
    return employeeFieldData.map(record => {
        if (record.id === field.target.id) {
            return { ...record, answere: [field.target.value] };
        }
        return record;
    });
};

export const updateEmployeeDetail = async (
    employeeId,
    employeeObj,
    loggedInEmployeeId
) => {
    if (validateUpdateEmployee(employeeObj)) {
        return await updateEmployeeDetails(
            employeeId,
            employeeObj,
            loggedInEmployeeId
        );
    }
};

export const updateEmployeeDetailByEmployees = async employeeObj => {
    if (validateUpdateEmployee(employeeObj)) {
        return await updateEmployeeDetailsByEmployee(employeeObj);
    }
};

export const HttpCodes = {
    success: 200,
    notFound: 404,
    badRequest: 400
};

export const HttpVerbsMessage = [
    {
        page: "employeedetail",
        severity: "success",
        message: "Employee deleted successfully !!",
        verb: "delete"
    },
    {
        page: "employeedetail",
        severity: "error",
        message: "Error occured while deleting employee !!",
        verb: "delete"
    },
    {
        page: "employeedetail",
        severity: "success",
        message: "Employee details updated successfully !!",
        verb: "update"
    },
    {
        page: "employeedetail",
        severity: "success",
        message: "Your request to update profile detail sent successfully !!",
        verb: "updateEmployee"
    },
    {
        page: "employeedetail",
        severity: "error",
        message: "Error occured while updating employee record !!",
        verb: "update"
    },
    {
        page: "employeedetail",
        severity: "error",
        message:
            "Error occured while sending request to update profile record !!",
        verb: "updateEmployee"
    },
    {
        page: "manageEmployee",
        severity: "success",
        message: "Updated employee details approved successfully !!",
        verb: "approve"
    },
    {
        page: "manageEmployee",
        severity: "success",
        message: "Updated employee details rejected successfully !!",
        verb: "reject"
    }
];
