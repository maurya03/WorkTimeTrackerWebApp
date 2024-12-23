export const ValidateUpdate = (rowData) =>{
    let errorMessages = [];
    if (
        rowData.timesheetManagerId === "Manager" &&
        rowData.timesheetApproverId1 === "Approver1" &&
        rowData.timesheetApproverId2 === "Approver2"
    ) {
        errorMessages.push({
            field: "dropdown",
            error: `please select any approval dropdown for : ${rowData.employeeName}`
        });
    }

    if (
        rowData.timesheetManagerId === 0 &&
        rowData.timesheetApproverId1 === 0 &&
        rowData.timesheetApproverId2 === 0
    ) {
        errorMessages.push({
            field: "dropdown",
            error: `please select any approval dropdown for : ${rowData.employeeName}`
        });
    }

    return errorMessages;
}
