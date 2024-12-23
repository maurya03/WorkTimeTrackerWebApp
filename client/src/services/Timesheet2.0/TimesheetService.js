import {
    convertToYYYYMMDD,
    getWeekStartDate,
    formatDate
} from "rootpath/services/TimeSheet/TimesheetDataService";
import {
    approved,
    pending,
    rejected,
    employee
} from "rootpath/components/Timesheet/Constants";

export const GetFilteredSubcategories = (
    timesheetSubCategories,
    categoryId
) => {
    const filteredSubCategories =
        timesheetSubCategories.length > 0 &&
        timesheetSubCategories.filter(
            x => x.timeSheetCategoryId === parseInt(categoryId)
        );
    return filteredSubCategories;
};
export const AddNewRow = (
    employeeProject,
    timesheetCategories,
    timesheetSubCategories,
    data
) => {
    const filteredSubcategories =
        timesheetCategories.length > 0
            ? GetFilteredSubcategories(
                  timesheetSubCategories,
                  timesheetCategories[0].timeSheetCategoryId
              )
            : [];

    const newId = data.length ? data[data.length - 1].id + 1 : 0;
    return [
        ...data,
        {
            id: newId,
            projectId: employeeProject[0]?.projectId || null,
            timeSheetCategoryId:
                timesheetCategories[0].timeSheetCategoryId || null,
            timeSheetSubCategoryId:
                filteredSubcategories[0].timeSheetSubCategoryId || null
        }
    ];
};

export const handleTaskTitleChange = (
    e,
    rowData,
    dataCopy,
    employeeProject,
    timesheetCategories,
    timesheetSubCategories,
    setData
) => {
    rowData.taskDescription = e.target.value;
    const { tableData, ...restItem } = rowData;
    dataCopy.current[rowData.id] = restItem;

    const lastId = dataCopy.current[dataCopy.current.length - 1]?.id;
    if (parseInt(e.target.id.split("_")[1]) === lastId) {
        AddRow(
            setData,
            dataCopy,
            employeeProject,
            timesheetCategories,
            timesheetSubCategories
        );
    }
};
export const handleTaskHourChange = (e, rowData, dataCopy, KeyName) => {
    const hour = parseFloat(e.target.value);
    if (isNaN(hour)) {
        delete rowData[KeyName];
    } else {
        rowData[KeyName] = hour;
    }
    const { tableData, ...restItem } = rowData;
    dataCopy.current[rowData.id] = restItem;
};
export const handleProjectChange = (e, rowData, setData, dataCopy) => {
    rowData.projectId = parseInt(e.target.value);
    const { tableData, ...restItem } = rowData;
    dataCopy.current[rowData.id] = restItem;
    setData([...dataCopy.current]);
};
export const handleCategoryChange = (
    e,
    rowData,
    setData,
    dataCopy,
    timesheetSubCategories
) => {
    rowData.timeSheetCategoryId = parseInt(e.target.value);
    const filteredSubcategories = GetFilteredSubcategories(
        timesheetSubCategories,
        rowData.timeSheetCategoryId
    );
    rowData.timeSheetSubCategoryId =
        filteredSubcategories[0].timeSheetSubCategoryId;
    const { tableData, ...restTableData } = rowData;
    dataCopy.current[rowData.id] = restTableData;
    setData([...dataCopy.current]);
};
export const handleSubCategoryChange = (e, rowData, setData, dataCopy) => {
    rowData.timeSheetSubCategoryId = parseInt(e.target.value);
    const { tableData, ...restItem } = rowData;
    dataCopy.current[rowData.id] = restItem;
    setData([...dataCopy.current]);
};
export const AddRow = (
    setData,
    dataCopy,
    employeeProject,
    timesheetCategories,
    timesheetSubCategories
) => {
    const allRows = AddNewRow(
        employeeProject,
        timesheetCategories,
        timesheetSubCategories,
        dataCopy.current
    );
    setData(allRows);
    dataCopy.current = allRows;
};
export const CancelClick = (setData, dataCopy) => {
    const row = [dataCopy.current[0]];
    setData(row);
    dataCopy.current = row;
};
export const InitDate = () => {
    const weekDate = new Date();
    return GetStartAndEndDates(weekDate);
};
const GetStartAndEndDates = weekDate => {
    const weekStartDate = getWeekStartDate(weekDate);
    const startDate = convertToYYYYMMDD(
        weekStartDate.setDate(weekStartDate.getDate() - 1)
    );
    const endDate = convertToYYYYMMDD(
        weekStartDate.setDate(weekStartDate.getDate() + 6)
    );
    return { startDate, endDate };
};
const ValidRows = data => {
    return data.filter(row => isValidRow(row));
};
const isAllHorsNonZero = data => {
    let isHourNonZero = true;
    data.forEach(rowIetems => {
        Object.keys(dayOfWeek).forEach(day => {
            if (isZeroHour(rowIetems, day)) {
                isHourNonZero = false;
            }
        });
    });
    return isHourNonZero;
};
const dayOfWeek = {
    Sun: "1",
    Mon: "2",
    Tue: "3",
    Wed: "4",
    Thu: "5",
    Fri: "6",
    Sat: "7"
};
const isAllRowsVaild = data => {
    let isAllTasksFilled = true;
    let isAllRowsHoursFilled = true;
    data.forEach(rowIetems => {
        if (!rowIetems["taskDescription"]) {
            isAllTasksFilled = false;
        }
        if (!isHoursFilled(rowIetems)) {
            isAllRowsHoursFilled = false;
        }
    });

    return isAllTasksFilled && isAllRowsHoursFilled;
};
export const isValidRow = rowIetems => {
    let isTaskFilled = false;
    if (rowIetems["taskDescription"]) {
        isTaskFilled = true;
    }
    return isHoursFilled(rowIetems) || isTaskFilled;
};
export const isHoursFilled = rowIetems => {
    let isFilled = false;
    Object.keys(dayOfWeek).forEach(day => {
        if (rowIetems[day]) {
            isFilled = true;
        }
    });
    return isFilled;
};
export const isZeroHour = (rowIetems, keyName) => {
    return parseFloat(rowIetems[keyName]) === 0;
};
export const mapTimesheetPostData = (
    enteries,
    startDate,
    endDate,
    timesheetId
) => {
    let hourlyData = [];
    let toPost = {};
    enteries.forEach(row => {
        Object.keys(dayOfWeek).forEach(day => {
            if (row[day]) {
                let eachData = {};
                eachData.DayOfWeek = dayOfWeek[day];
                eachData.HoursWorked = row[day];
                eachData.taskDescription = row.taskDescription;
                eachData.TimeSheetCategoryID = row.timeSheetCategoryId;
                eachData.TimeSheetSubCategoryID = row.timeSheetSubCategoryId;
                eachData.ProjectId = row.projectId;
                hourlyData = [...hourlyData, eachData];
            }
        });
    });
    toPost.HourlyData = hourlyData;
    toPost.WeekStartDate = startDate;
    toPost.WeekEndDate = endDate;
    toPost.StatusId = 1;
    toPost.Remarks = "";
    toPost.TimesheetId = timesheetId ?? 0;
    return toPost;
};
export const DeleteRowClick = (dataCopy, idTodelete, setData) => {
    dataCopy.current = dataCopy.current.filter(x => x.id != idTodelete);
    setData([...dataCopy.current]);
};
export const handleHoursInput = event => {
    const value = event.target.value;
    if (value < 0 || value > 12) {
        event.target.value = "";
    }
};

export const enabledDates = () => {
    const weekDate = new Date();
    const weekStartDate = getWeekStartDate(weekDate);
    const dayStart = new Date(
        weekStartDate.setDate(weekStartDate.getDate() - 16)
    );
    const dayEnd = new Date(
        weekStartDate.setDate(weekStartDate.getDate() + 28)
    );
    return { dayStart: dayStart, dayEnd: dayEnd };
};
export const calculateDaySums = timesheetDetails => {
    const sums = {
        sun: 0,
        mon: 0,
        tue: 0,
        wed: 0,
        thu: 0,
        fri: 0,
        sat: 0
    };
    timesheetDetails.forEach(row => {
        for (const key in sums) {
            sums[key] += row[key]
                ? parseFloat(parseFloat(row[key]).toFixed(2))
                : 0;
        }
    });
    return sums;
};
export const handleDelete = (selectedWeek, e, ids, onDelete) => {
    const dates = {
        startDate: formatDate(selectedWeek.from),
        endDate: formatDate(selectedWeek.to)
    };
    onDelete(e, ids, dates);
};
export const getTitleText = (status, userRole, approverPending) => {
    switch (status) {
        case approved:
            return "Approved Timesheet";
        case rejected:
            return "Rejected Timesheet";
        case pending:
            if (userRole.roleName !== employee && !approverPending) {
                return "Timesheet Management";
            } else {
                return "My Pending Timesheet";
            }
        default:
            return "Timesheet Management";
    }
};
