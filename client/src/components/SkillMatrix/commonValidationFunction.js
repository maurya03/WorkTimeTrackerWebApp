import { errorMessage } from "./commonValidationMessage";
export const validateEmployee = employee => {
    let errorArray = [];
    var regex = /^[ &.A-Za-z0-9_-]*$/;
    var regexForName = /^[\sA-Za-z]*$/;
    var regexForEmail = /^[^\s@]+@bhavnacorp\.com$/i;

    if (employee.bhavnaEmployeeId?.trim() === "") {
        errorArray.push({
            error: errorMessage.emptyIdError,
            field: "bhavnaEmployeeId"
        });
    }

    if (employee.emailId?.trim() === "") {
        errorArray.push({
            error: errorMessage.emptyEmailId,
            field: "emailId"
        });
    }
    if (
        !employee.emailId?.match(regexForEmail) &&
        employee.emailId?.trim() !== ""
    ) {
        errorArray.push({
            error: errorMessage.invalidEmailId,
            field: "emailId"
        });
    }
    if (employee.employeeName?.trim() === "") {
        errorArray.push({
            error: errorMessage.emptyNameError,
            field: "Name"
        });
    }
    if (!employee.bhavnaEmployeeId?.match(regex)) {
        errorArray.push({
            error: errorMessage.specialCharError,
            field: "bhavnaEmployeeId"
        });
    }
    if (
        !employee.employeeName?.match(regexForName) &&
        employee.employeeName?.trim() !== ""
    ) {
        errorArray.push({
            error: errorMessage.invalidNameError,
            field: "Name"
        });
    }
    return errorArray;
};
export const validationInput = (state, title) => {
    let errorArray = [];
    var regex = /^[ &.A-Za-z0-9_-]*$/;
    
    if (state === "Remarks" && title === "") {
        errorArray.push({
            error: errorMessage.rejectRemarks,
            field: "Remarks"
        });
    }

    if (state[`${title}Name`]?.trim() === "") {
        errorArray.push({
            error: errorMessage.emptyNameError,
            field: "Name"
        });
    }

    if (state[`${title}Function`]?.trim() === "") {
        errorArray.push({
            error: errorMessage.emptyFunctionError,
            field: "Function"
        });
    }

    if (state[`${title}Description`]?.trim() === "") {
        errorArray.push({
            error: errorMessage.emptyDescriptionError,
            field: "Description"
        });
    }

    if (state[`${title}Name`] && !state[`${title}Name`].match(regex)) {
        errorArray.push({
            error: errorMessage.specialCharError,
            field: "Name"
        });
    }

    if (state[`${title}Function`] && !state[`${title}Function`].match(regex)) {
        errorArray.push({
            error: errorMessage.specialCharError,
            field: "Function"
        });
    }
    if (
        state[`${title}Description`] &&
        !state[`${title}Description`].match(regex)
    ) {
        errorArray.push({
            error: errorMessage.specialCharError,
            field: "Description"
        });
    }
    return errorArray;
};

export const validateEditObj = (state, title, subTitle) => {
    const errorObj =
        title === "client"
            ? {
                  id: state.id,
                  [`${title}Error`]: validationInput(state, title),
                  [`${subTitle}Errors`]: state[`${subTitle}s`].map(sub =>
                      validationInput(sub, subTitle)
                  )
              }
            : title === "category"
            ? {
                  id: state.id,
                  [`${title}Error`]: validationInput(state, title),
                  [`${subTitle}Errors`]: state.subCategories.map(sub =>
                      validationInput(sub, subTitle)
                  )
              }
            : title === "team" && {
                  id: state.id,
                  [`${title}Error`]: validationInput(state, title),
                  [`${subTitle}Errors`]: state[`${subTitle}s`].map(sub =>
                      validationInput(sub, subTitle)
                  )
              };
    return errorObj;
};
