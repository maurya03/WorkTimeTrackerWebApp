import { formatDate } from "rootpath/services/TimeSheet/TimesheetDataService";

export const onDelete = (
    e,
    id,
    index,
    data,
    selectedWeek,
    deleteTimesheet,
    selectedCategories,
    selectedSubcategories,
    errors,
    setData,
    setSelectedCategories,
    setSelectedSubcategories,
    setErrors,
    setDuplicateErrors,
    duplicateErrors
) => {
    const newData = data.filter(item => item.id !== id);
    if (data[index].timesheetDetailId) {
        const ids = data[index].timesheetDetailId;
        const dates = {
            startDate: formatDate(selectedWeek.from),
            endDate: formatDate(selectedWeek.to)
        };
        deleteTimesheet(e, ids, dates);
    }
    const updatedData = newData.map((item, index) => ({
        ...item,
        id: index + 1
    }));
    selectedCategories.splice(index, 1);
    selectedSubcategories.splice(index, 1);
    errors.splice(index, 1);
    duplicateErrors.splice(index, 1);
    setData(updatedData);
    setSelectedCategories(selectedCategories);
    setSelectedSubcategories(selectedSubcategories);
    setErrors(errors);
    setDuplicateErrors(duplicateErrors);
};
export const onEditRender = (
    timesheetDetails,
    setData,
    setSelectedCategories,
    setSelectedSubcategories,
    setShowSaveCancel,
    setErrors,
    setDuplicateErrors
) => {
    const data = timesheetDetails.map((obj, index) => ({
        ...obj,
        id: index + 1
    }));
    setData(data);
    const selectedCategories = timesheetDetails.map(row => {
        return row.timeSheetCategoryId;
    });
    const selectedSubcategories = timesheetDetails.map(row => {
        return row.timeSheetSubCategoryId;
    });
    const errors = timesheetDetails.map(row => {
        return false;
    });
    setErrors(errors);
    setDuplicateErrors(errors);
    setSelectedCategories(selectedCategories);
    setSelectedSubcategories(selectedSubcategories);
    setShowSaveCancel(true);
};
export const removeDecimal = number => {
    // Check if the decimal part is exactly .5
    if (number != "") {
        if (number % 1 === 0) {
            return Math.trunc(number);
        } else {
            return number;
        }
    }
    return number;
};
