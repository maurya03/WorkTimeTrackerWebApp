import { newRow } from "rootpath/components/Timesheet2.0/CreateTimesheetV2Component/CreateConstants";
import { GetFilteredSubcategories } from "rootpath/services/Timesheet2.0/TimesheetService";
import { postApi } from "rootpath/services/baseApiService";
const baseURL = "api/v2";
export const hasError = (index, row, errors) => {
    return (
        errors[index] &&
        !(
            row.sun ||
            row.mon ||
            row.tue ||
            row.wed ||
            row.thu ||
            row.fri ||
            row.sat
        )
    );
};
export const handleHoursInput = event => {
    const value = event.target.value;
    if (value < 0 || value > 12) {
        event.target.value = "";
    }
};
export const validateDuplicateTask = data => {
    const duplicateTasks = [];
    const duplicateErrors = data.map(row => {
        if (row.taskDescription.trim() !== "") {
            const key = `${row.projectId}-${row.timeSheetCategoryId}-${
                row.timeSheetSubCategoryId
            }-${row.taskDescription.trim()}`;
            if (duplicateTasks.includes(key)) {
                return true;
            } else {
                duplicateTasks.push(key);
                return false;
            }
        } else {
            return false;
        }
    });
    return duplicateErrors;
};
export const isZero = (row, field) => {
    return row[field] == "0";
};
export const validateTimesheet = data => {
    const newErrors = data.map(row => {
        if (
            (row.sun ||
                row.mon ||
                row.tue ||
                row.wed ||
                row.thu ||
                row.fri ||
                row.sat) &&
            !row.taskDescription.trim()
        ) {
            return true;
        } else if (
            row.taskDescription.trim() &&
            !(
                row.sun ||
                row.mon ||
                row.tue ||
                row.wed ||
                row.thu ||
                row.fri ||
                row.sat
            )
        ) {
            return true;
        }
        return false;
    });
    return newErrors;
};
export const mapTimesheetData = (data, dates, statusId) => {
    const filteredData = data.filter(
        row =>
            row.taskDescription.trim() !== "" &&
            (row.sun.trim() !== "" ||
                row.mon.trim() !== "" ||
                row.tue.trim() !== "" ||
                row.wed.trim() !== "" ||
                row.thu.trim() !== "" ||
                row.fri.trim() !== "" ||
                row.sat.trim() !== "")
    );
    const mappedDataObj = {
        taskRows: filteredData.map(item => {
            const hours = {
                sun: item.sun || "",
                mon: item.mon || "",
                tue: item.tue || "",
                wed: item.wed || "",
                thu: item.thu || "",
                fri: item.fri || "",
                sat: item.sat || ""
            };
            const nonEmptyHours = Object.entries(hours).filter(
                ([_, hour]) => hour !== ""
            );
            return {
                projectId: item.projectId,
                taskDescription: item.taskDescription,
                timeSheetCategoryID: item.timeSheetCategoryId,
                timeSheetSubcategoryID: item.timeSheetSubCategoryId,
                hoursWorked: JSON.stringify(Object.fromEntries(nonEmptyHours))
            };
        }),
        weekStartDate: dates.startDate,
        weekEndDate: dates.endDate,
        statusId: statusId
    };
    const hours = mappedDataObj.taskRows.reduce((acc, item) => {
        const hoursWorked = Object.values(JSON.parse(item.hoursWorked)).reduce(
            (a, b) => a + parseFloat(b),
            0
        );
        const project = acc.find(proj => proj.projectId === item.projectId);
        if (project) {
            project.totalHours += hoursWorked;
        } else {
            acc.push({ projectId: item.projectId, totalHours: hoursWorked });
        }
        return acc;
    }, []);
    mappedDataObj.clientWiseHoursTotal = hours;
    return mappedDataObj;
};
export const postTimesheet = async mappedData => {
    const url = `${baseURL}/createTimesheet`;
    const response = await postApi(url, mappedData)
        .then(res => {
            return { success: res };
        })
        .catch(error => {
            return { error: error };
        });
    return response;
};
export const addNewRow = (project, categories, subCategories, data) => {
    let row = newRow(data);
    row.timeSheetCategoryId = categories[0].timeSheetCategoryId;
    row.timeSheetSubCategoryId = GetFilteredSubcategories(
        subCategories,
        categories[0].timeSheetCategoryId
    )[0].timeSheetSubCategoryId;
    row.projectId = project[0]?.projectId;
    return row;
};
export const onProjectChange = (event, id, data, setData) => {
    const projectValue = event.target.value;
    const newData = data.map(item => {
        if (item.id === id) {
            return { ...item, projectId: projectValue };
        }
        return item;
    });
    setData(newData);
};
export const onCategoryChange = (
    event,
    id,
    index,
    data,
    setData,
    setSelectedSubcategories,
    setSelectedCategories,
    timesheetSubCategories
) => {
    const categoryValue = event.target.value;
    setSelectedCategories(prevState => {
        const newState = [...prevState];
        newState[id - 1] = categoryValue;
        return newState;
    });
    const subCategories = GetFilteredSubcategories(
        timesheetSubCategories,
        categoryValue
    );
    setSelectedSubcategories(prevState => {
        const newState = [...prevState];
        const subCategory = subCategories[0].timeSheetSubCategoryId;
        newState[id - 1] = subCategory;
        return newState;
    });
    const newData = [...data];
    newData[index]["timeSheetCategoryId"] = categoryValue;
    newData[index]["timeSheetSubCategoryId"] =
        subCategories[0].timeSheetSubCategoryId;
    setData(newData);
};
export const onSubCategoryChange = (
    e,
    id,
    index,
    data,
    setData,
    setSelectedSubcategories
) => {
    const subCategoryValue = e.target.value;
    setSelectedSubcategories(prevState => {
        const newState = [...prevState];
        newState[id - 1] = subCategoryValue;
        return newState;
    });
    const newData = [...data];
    newData[index]["timeSheetSubCategoryId"] = subCategoryValue;
    setData(newData);
};
export const onAddRow = (
    employeeProject,
    timesheetCategories,
    timesheetSubCategories,
    data,
    setData,
    setSelectedCategories,
    setSelectedSubcategories,
    setErrors
) => {
    const row = addNewRow(
        employeeProject,
        timesheetCategories,
        timesheetSubCategories,
        data
    );
    setData([...data, row]);
    setSelectedCategories(prevState => [
        ...prevState,
        timesheetCategories[0].timeSheetCategoryId
    ]);
    setSelectedSubcategories(prevState => [
        ...prevState,
        GetFilteredSubcategories(
            timesheetSubCategories,
            timesheetCategories[0].timeSheetCategoryId
        )[0].timeSheetSubCategoryId
    ]);
    setErrors(prevState => [...prevState, false]);
};
export const onChange = (
    id,
    field,
    value,
    index,
    employeeProject,
    timesheetCategories,
    timesheetSubCategories,
    data,
    setSelectedCategories,
    setSelectedSubcategories,
    setShowSaveCancel,
    setData,
    setErrors,
    setDuplicateErrors,
    duplicateErrors,
    errors
) => {
    let showSaveBool = false;
    let row = {};
    if (index + 1 === data.length) {
        row = addNewRow(
            employeeProject,
            timesheetCategories,
            timesheetSubCategories,
            data
        );
        setSelectedCategories(prevState => [
            ...prevState,
            timesheetCategories[0].timeSheetCategoryId
        ]);
        setSelectedSubcategories(prevState => [
            ...prevState,
            GetFilteredSubcategories(
                timesheetSubCategories,
                timesheetCategories[0].timeSheetCategoryId
            )[0].timeSheetSubCategoryId
        ]);
        errors.push(false);
    }
    const newData = data.map(item => {
        if (item.id === id) {
            return { ...item, [field]: value };
        }
        return item;
    });
    newData.forEach(row => {
        if (
            row.taskDescription &&
            (row.sun ||
                row.mon ||
                row.tue ||
                row.wed ||
                row.thu ||
                row.fri ||
                row.sat)
        ) {
            showSaveBool = true;
        }
    });
    if (Object.keys(row).length > 0) {
        newData.push(row);
    }
    duplicateErrors[index] = false;
    errors[index] = false;
    setShowSaveCancel(showSaveBool);
    setData(newData);
    setErrors(errors);
    setDuplicateErrors(duplicateErrors);
};

export const validateHours = data => {
    const errors = data.map(row => {
        if (
            row.sun == "0" ||
            row.mon == "0" ||
            row.tue == "0" ||
            row.wed == "0" ||
            row.thu == "0" ||
            row.fri == "0" ||
            row.sat == "0"
        ) {
            return true;
        }
        return false;
    });
    return errors;
};
export const onSave = async (
    setDuplicateErrors,
    setErrors,
    saveTimesheet,
    data,
    selectedWeek,
    isEditMode,
    handleCancel,
    daySums,
    statusId
) => {
    const newErrors = validateTimesheet(data);
    const duplicateErrors = validateDuplicateTask(data);
    const hoursError = validateHours(data);
    const error = newErrors.some(value => value === true);
    const duplicateError = duplicateErrors.some(value => value === true);
    const hourError = hoursError.some(value => value === true);
    if (error || duplicateError || hourError) {
        setDuplicateErrors(duplicateErrors);
        setErrors(newErrors);
    } else {
        await saveTimesheet(
            data,
            selectedWeek,
            daySums,
            statusId,
            isEditMode,
            handleCancel
        );
    }
};
export const onDelete = (
    e,
    id,
    index,
    data,
    selectedCategories,
    selectedSubcategories,
    duplicateErrors,
    errors,
    setData,
    setSelectedCategories,
    setSelectedSubcategories,
    setErrors,
    setDuplicateErrors,
    setShowSaveCancel
) => {
    let showSaveBool = false;
    const newData = data.filter(item => item.id !== id);
    const updatedData = newData.map((item, index) => ({
        ...item,
        id: index + 1
    }));
    newData.forEach(row => {
        if (
            row.taskDescription &&
            (row.sun ||
                row.mon ||
                row.tue ||
                row.wed ||
                row.thu ||
                row.fri ||
                row.sat)
        ) {
            showSaveBool = true;
        }
    });
    setShowSaveCancel(showSaveBool);
    selectedCategories.splice(index, 1);
    selectedSubcategories.splice(index, 1);
    duplicateErrors.splice(index, 1);
    errors.splice(index, 1);
    setData(updatedData);
    setSelectedCategories(selectedCategories);
    setSelectedSubcategories(selectedSubcategories);
    setErrors(errors);
    setDuplicateErrors(duplicateErrors);
};
export const onCancel = (
    employeeProject,
    timesheetCategories,
    timesheetSubCategories,
    data,
    setData,
    setErrors,
    setShowSaveCancel,
    setDuplicateErrors,
    setSelectedCategories,
    setSelectedSubcategories
) => {
    const row = addNewRow(
        employeeProject,
        timesheetCategories,
        timesheetSubCategories,
        data
    );
    setData([row]);
    setErrors([false]);
    setShowSaveCancel(false);
    setInitialCategorySubCategory(
        setSelectedCategories,
        setSelectedSubcategories,
        timesheetSubCategories,
        timesheetCategories
    );
    setDuplicateErrors([false]);
};
export const setInitialCategorySubCategory = (
    setSelectedCategories,
    setSelectedSubcategories,
    timesheetSubCategories,
    timesheetCategories
) => {
    setSelectedCategories([timesheetCategories[0].timeSheetCategoryId]);
    setSelectedSubcategories([
        GetFilteredSubcategories(
            timesheetSubCategories,
            timesheetCategories[0].timeSheetCategoryId
        )[0].timeSheetSubCategoryId
    ]);
};
export const onComponentRender = (
    employeeProject,
    timesheetCategories,
    timesheetSubCategories,
    data,
    setData,
    setErrors,
    setDuplicateErrors,
    setSelectedCategories,
    setSelectedSubcategories
) => {
    const row = addNewRow(
        employeeProject,
        timesheetCategories,
        timesheetSubCategories,
        data
    );
    const initialRow = [...data, row];
    setData(initialRow);
    setInitialCategorySubCategory(
        setSelectedCategories,
        setSelectedSubcategories,
        timesheetSubCategories,
        timesheetCategories
    );
    setErrors([false]);
    setDuplicateErrors([false]);
};
