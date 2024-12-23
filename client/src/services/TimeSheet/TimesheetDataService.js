import { timeSheetEntryByIdApi } from "rootpath/components/Timesheet/TimesheetDetails/TimesheetDetailsFunction";
import {
    UpdateTimesheetStatusByReviewer,
    TimeSheetDetailByDates,
    TimeSheetDetailCreatedOnBehalf
} from "rootpath/services/TimeSheet/TimeSheetPostAndGetServices";
import { updateStatusCode } from "rootpath/components/Timesheet/Constants";

export const groupBy = (array, groupKeys) => {
    return array.reduce((result, currentItem) => {
        const groupKey = groupKeys.map(key => currentItem[key]);
        const groupKeyString = groupKey.join("");
        result[groupKeyString] = result[groupKeyString] || {
            groupKey,
            rows: []
        };
        const internalRow = {};
        for (const key in currentItem) {
            if (!groupKeys.includes(key)) {
                internalRow[key] = currentItem[key];
            }
        }
        result[groupKeyString].rows.push(internalRow);
        return result;
    }, {});
};
export const weekData = [
    { 1: "Sun" },
    { 2: "Mon" },
    { 3: "Tue" },
    { 4: "Wed" },
    { 5: "Thu" },
    { 6: "Fri" },
    { 7: "Sat" }
];
export const mapTimesheetData = async (timesheetId, params, IsBehalf) => {
    let dayOfWeekMapping = [];
    const enteries = IsBehalf
        ? await TimeSheetDetailCreatedOnBehalf(params)
        : timesheetId
        ? await timeSheetEntryByIdApi(timesheetId)
        : await TimeSheetDetailByDates(params);
    if (Object.keys(enteries).length > 0 && enteries.response) {
        const msg = enteries.response.data.ResponseMessage;
        return { tableData, msg };
    }
    const enteriesGrouped = groupBy(enteries, [
        "taskDescription",
        "timeSheetCategoryId",
        "timeSheetSubCategoryId",
        "statusId",
        "timesheetId"
    ]);
    Object.values(enteriesGrouped) &&
        Object.values(enteriesGrouped).map(row => {
            let eachData = {};
            eachData.taskDescription = row.groupKey[0];
            eachData.timeSheetCategoryId = row.groupKey[1];
            eachData.timeSheetSubCategoryId = row.groupKey[2];
            eachData.statusId = row.groupKey[3];
            eachData.timesheetId = row.groupKey[4];
            row.rows.map(item => {
                eachData.projectId = item.projectId;
                eachData.date = item.date;
                eachData[Object.values(weekData[item.dayOfWeek - 1])[0]] =
                    item.hoursWorked;
                weekData.map(day => {
                    if (Object.keys(day)[0] == item.dayOfWeek) {
                        eachData[day[item.dayOfWeek]] =
                            item.hoursWorked?.toString();
                    }
                });
            });
            dayOfWeekMapping = [...dayOfWeekMapping, eachData];
        });
    const tableData = dayOfWeekMapping.map((row, index) => ({
        ...row,
        id: index
    }));
    return tableData;
};
export const mapTimesheetPostData = (
    enteries,
    selectedWeek,
    selectedEmployee,
    timesheetId
) => {
    let hourlyData = [];
    let toPost = {};
    const checkList = Object.values(weekData);
    enteries.map(row => {
        checkList.map(item => {
            if (row[item[Object.keys(item)[0]]]) {
                let eachData = {};
                eachData.DayOfWeek = Object.keys(item)[0];
                eachData.HoursWorked = parseFloat(
                    row[item[Object.keys(item)[0]]]
                );
                eachData.taskDescription = row.taskDescription;
                eachData.TimeSheetCategoryID = row.timeSheetCategoryId;
                eachData.TimeSheetSubCategoryID = row.timeSheetSubCategoryId;
                eachData.ProjectId = row.projectId;
                hourlyData = [...hourlyData, eachData];
            }
        });
    });
    toPost.HourlyData = hourlyData;
    toPost.WeekStartDate = selectedWeek.split(" ")[0];
    toPost.WeekEndDate = selectedWeek.split(" ")[1];
    toPost.StatusId = 1;
    toPost.Remarks = "";
    toPost.TimesheetId = timesheetId;
    if (selectedEmployee) {
        toPost.OnBehalfTimesheetCreatedFor = selectedEmployee;
    }
    return toPost;
};
export const formatDate = date => {
    var d = new Date(date),
        month = "" + (d.getMonth() + 1),
        day = "" + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = "0" + month;
    if (day.length < 2) day = "0" + day;

    return [year, month, day].join("-");
};
export const convertToYYYYMMDD = dateString => {
    const date = new Date(dateString);
    const yyyy = date.getFullYear();
    const mm = String(date.getMonth() + 1).padStart(2, "0");
    const dd = String(date.getDate()).padStart(2, "0");
    return `${yyyy}-${mm}-${dd}`;
};
export const getWeekStartDate = date => {
    const dayOfWeek = date.getDay();
    const diff = date.getDate() - dayOfWeek + 1;
    return new Date(date.setDate(diff));
};
export const createTimesheetDataForReview = async (
    status,
    rows,
    timesheetList,
    remarks
) => {
    let selectedTimesheet = [];
    let selectedEmailListAndWeek = [];
    timesheetList.forEach(timesheet => {
        if (rows.find(x => x == timesheet.timesheetId)) {
            selectedTimesheet.push({
                employeeId: timesheet.employeeId,
                timesheetId: timesheet.timesheetId
            });
            selectedEmailListAndWeek = [
                ...selectedEmailListAndWeek,
                {
                    EmailId: timesheet.emailId,
                    WeekStartDate: timesheet.weekStartDate,
                    WeekEndDate: timesheet.weekEndDate,
                    Status: status,
                    Remarks: remarks ?? ""
                }
            ];
        }
    });
    const data = {
        status: status,
        employeeIds: selectedTimesheet.map(x => x.employeeId).join(", "),
        timesheetIds: selectedTimesheet.map(x => x.timesheetId).join(", "),
        remarks: remarks
    };

    const result = await UpdateTimesheetStatusByReviewer(
        data,
        selectedEmailListAndWeek
    );
    if (result.status == updateStatusCode) {
        return true;
    } else {
        return false;
    }
};
export const handleProjectChange = (event, rowData, employeeProject, data) => {
    rowData.projectId =
        employeeProject.length === 1
            ? parseInt(employeeProject[0].id)
            : parseInt(rowData.projectId);
    return data.map(row =>
        row.id === rowData.id
            ? { ...row, projectId: parseInt(event.target.value) }
            : row
    );
};
export const handleSelectChange = (
    event,
    rowData,
    bindingList,
    data,
    keyName,
    dataCopy
) => {
    const missingObjects = data.filter(
        obj1 => !dataCopy.current.find(obj2 => obj1.id === obj2.id)
    );
    dataCopy.current = [...dataCopy.current, ...missingObjects];
    rowData[keyName] =
        bindingList.length === 1
            ? parseInt(bindingList[0][keyName])
            : parseInt(rowData[keyName]);
    return dataCopy.current.map(row =>
        row.id === rowData.id
            ? { ...row, [keyName]: parseInt(event.target.value) }
            : row
    );
};
export const renderEditSubCategory = (
    rowData,
    handletEditSubCategoryChange
) => {
    rowData.timeSheetSubCategoryId && delete rowData["timeSheetSubCategoryId"];
    const filteredSubcategories = getSubCategoryOptions(
        rowData.timeSheetCategoryId ??
            timesheetCategories[0].timeSheetCategoryId
    );
    return (
        <select
            className={css.subcatdropdown}
            title={
                rowData.timeSheetSubCategoryId
                    ? filteredSubcategories.length > 0 &&
                      filteredSubcategories.find(
                          x =>
                              x.timeSheetSubCategoryId ===
                              rowData.timeSheetSubCategoryId
                      ).timeSheetSubCategoryName
                    : filteredSubcategories.length > 0 &&
                      filteredSubcategories[0].timeSheetSubCategoryName
            }
            value={
                data.length > 0 &&
                data.find(x => x.id === rowData.id).timeSheetSubCategoryId
            }
            placeholder="Select SubCategory"
            onChange={event => handletEditSubCategoryChange(event, rowData)}
        >
            {filteredSubcategories.map(item => (
                <option
                    key={item.timeSheetSubCategoryId}
                    value={item.timeSheetSubCategoryId}
                >
                    {item.timeSheetSubCategoryName}
                </option>
            ))}
        </select>
    );
};
export const getSubCategoryOptions = (subCategories, categoryId) => {
    const filteredSubcategory =
        subCategories.length > 0 &&
        subCategories.filter(
            x => x.timeSheetCategoryId === parseInt(categoryId)
        );
    return filteredSubcategory;
};
const validateHours = value => {
    return value >= 0 && value < 13;
};
export const onCategoryChange = (
    event,
    rowData,
    timesheetCategories,
    data,
    timesheetSubCategories,
    dataCopy
) => {
    const updatedRowDataState = handleSelectChange(
        event,
        rowData,
        timesheetCategories,
        data,
        "timeSheetCategoryId",
        dataCopy
    );
    const filteredSubcat = getFilteredSubcategories(
        timesheetSubCategories,
        updatedRowDataState[rowData.id].timeSheetCategoryId
    );
    rowData.timeSheetSubCategoryId =
        filteredSubcat.length > 0
            ? filteredSubcat[0].timeSheetSubCategoryId
            : undefined;
    updatedRowDataState[rowData.id].timeSheetSubCategoryId =
        rowData.timeSheetSubCategoryId;
    return updatedRowDataState;
};
export const handleOnRowDelete = (
    data,
    postTimeSheetData,
    setSummationData,
    setData,
    id,
    timesheetCategories,
    timesheetSubCategories,
    employeeProject,
    setShowActionColumn,
    setIsEditMode,
    setHourValue,
    dataCopy
) => {
    const missingObjects = data.filter(
        obj1 => !dataCopy.current.find(obj2 => obj1.id === obj2.id)
    );
    dataCopy.current = [...dataCopy.current, ...missingObjects];
    let dataAfterDelete = dataCopy.current.filter(x => x.id !== id);
    const rowTodelete = dataCopy.current.find(x => x.id === id);
    CountValidRows([rowTodelete]) > 0 &&
        postTimeSheetData([rowTodelete], "Deleted");
    const gridTotal = columnSummation(dataAfterDelete);
    setSummationData([gridTotal.columnSum]);
    if (dataAfterDelete.length === 0) {
        setShowActionColumn(false);
        setIsEditMode(true);
        setHourValue({});
        AddNewRow(
            timesheetCategories,
            timesheetSubCategories,
            setData,
            [],
            employeeProject
        );
    } else {
        setData([...dataAfterDelete]);
        dataCopy.current = [...dataAfterDelete];
        dataAfterDelete.length > 1
            ? setShowActionColumn(true)
            : setShowActionColumn(false);
    }
};
export const setPartialSubmission = (
    setIsTimesheetWithPartialSubmission,
    setIsProjectSelectionDisabled,
    status
) => {
    setIsTimesheetWithPartialSubmission(status);
    setIsProjectSelectionDisabled(status);
};
export const summationColumns = (
    isEditMode,
    isDetailPanel,
    selectedTimesheetStatus,
    isSubmitted,
    data,
    showActionColumn
) => {
    return [
        {
            hidden:
                !isSubmitted &&
                isDetailPanel &&
                !selectedTimesheetStatus.rejected,
            field:
                !isSubmitted &&
                isDetailPanel &&
                !selectedTimesheetStatus.rejected
                    ? ""
                    : "headerTotal",
            width: !isDetailPanel ? "12%" : "10%"
        },
        {
            field:
                !isSubmitted &&
                isDetailPanel &&
                !selectedTimesheetStatus.rejected
                    ? "headerTotal"
                    : "",
            width: !isDetailPanel ? "20%" : "12%"
        },
        {
            width: !isDetailPanel ? "11%" : "11%"
        },
        {
            width: !isDetailPanel ? "17%" : "15%"
        },
        {
            field: "Sun",
            type: isEditMode ? "text" : "numeric",
            width: "5%"
        },
        {
            field: "Mon",
            type: isEditMode ? "text" : "numeric",
            width: "5%"
        },
        {
            field: "Tue",
            type: isEditMode ? "text" : "numeric",
            width: "5%"
        },
        {
            field: "Wed",
            type: isEditMode ? "text" : "numeric",
            width: "5%"
        },
        {
            field: "Thu",
            type: isEditMode ? "text" : "numeric",
            width: "5%"
        },
        {
            field: "Fri",
            type: isEditMode ? "text" : "numeric",
            width: "5%"
        },
        {
            field: "Sat",
            type: isEditMode ? "text" : "numeric",
            width: "5%"
        },
        {
            field: "",
            hidden: !showActionColumn || isSubmitted ? true : false
        }
    ];
};
const day = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
export const columnSummation = data => {
    const sums = { headerTotal: "Total" };
    let rowSums = [];
    data.forEach(row => {
        let rowSum = 0;
        day.forEach(element => {
            if (row[element]) {
                rowSum = rowSum + parseFloat(row[element]);
                sums[element] =
                    (parseFloat(sums[element]) || 0) + parseFloat(row[element]);
            }
        });
        rowSums = [...rowSums, rowSum];
    });
    sums["total"] =
        rowSums.length > 0 ? rowSums.reduce((acc, curr) => acc + curr) : 0;
    return { columnSum: sums, rowSum: rowSums };
};
export const handleTextFieldChange = (
    event,
    rowData,
    keyName,
    errors,
    data,
    setHourValue,
    setErrors,
    setData,
    setSummationData,
    dataCopy,
    setValidRowCount,
    hourValue
) => {
    // if(data.length>0){
    //     dataCopy.current=[];
    // }
    const exists = dataCopy.current.find(x => x.id === rowData.id);
    if (!exists) {
        dataCopy.current.push({
            id: rowData.id,
            projectId: rowData.projectId,
            timeSheetCategoryId: rowData.timeSheetCategoryId,
            timeSheetSubCategoryId: rowData.timeSheetSubCategoryId
        });
    }
    let { value } = event.target;
    const newErrors = { ...errors };
    if (value.length > 4) {
        return false;
    }
    if (value && !validateHours(parseFloat(value))) {
        value = value.charAt(0) === "-" ? "" : value.charAt(0);
    }
    setHourValue(prev => {
        return { ...prev, [`${keyName}_${rowData.id}`]: value };
    });
    let updatedRowDataState = [];
    if (value) {
        newErrors[rowData.id] = {
            ...newErrors[rowData.id],
            [keyName]: !validateHours(parseFloat(value))
        };
        setErrors[newErrors];
        const updatedDataRow = dataCopy.current.find(x => x.id === rowData.id);
        if (updatedDataRow) {
            updatedRowDataState =
                GetAllFilledRows(dataCopy.current).length > 0
                    ? dataCopy.current.map(row =>
                          row.id === updatedDataRow.id ? updatedDataRow : row
                      )
                    : data.map(row =>
                          row.id === updatedDataRow.id ? updatedDataRow : row
                      );
            updatedRowDataState = updatedRowDataState.map(row =>
                row.id === rowData.id ? { ...row, [keyName]: value } : row
            );
            dataCopy.current = updatedRowDataState;
        } else {
            const missingObjects = data.filter(
                obj1 => !dataCopy.current.find(obj2 => obj1.id === obj2.id)
            );
            updatedRowDataState = missingObjects.map(row =>
                row.id === rowData.id ? { ...row, [keyName]: value } : row
            );
            dataCopy.current = [...dataCopy.current, ...updatedRowDataState];
        }
        const gridTotal = columnSummation(updatedRowDataState);
        setSummationData([gridTotal.columnSum]);
    } else {
        GetAllFilledRows(dataCopy.current).length > 0
            ? dataCopy.current.map(row =>
                  row.id === rowData.id ? delete row[keyName] : row
              )
            : data.map(row =>
                  row.id === rowData.id ? delete row[keyName] : row
              );
        const gridTotal = columnSummation(dataCopy.current);
        setSummationData([gridTotal.columnSum]);
    }
    const lastElement = data[data.length - 1];
    if (!dataCopy.current.find(x => x.id === lastElement.id)) {
        dataCopy.current.push(lastElement);
    }

    setData(dataCopy.current);
    // dataCopy.current.pop();
    var validRows = CountValidRows(dataCopy.current);
    setValidRowCount(validRows);
};
export const handleTaskTitleChange = (
    data,
    rowData,
    event,
    setData,
    setTasktxt,
    setShowActionColumn,
    dataCopy,
    setIsError,
    setValidRowCount,
    listOfduplicateTask
) => {
    const updatedDataRow = dataCopy.current.find(x => x.id === rowData.id);
    let updatedRowDataState = [];
    if (updatedDataRow) {
        updatedRowDataState =
            GetAllFilledRows(dataCopy.current).length > 0
                ? dataCopy.current.map(row =>
                      row.id === updatedDataRow.id ? updatedDataRow : row
                  )
                : data.map(row =>
                      row.id === updatedDataRow.id ? updatedDataRow : row
                  );
        updatedRowDataState = updatedRowDataState.map(row =>
            row.id === rowData.id
                ? {
                      ...row,
                      taskDescription: event.target.value
                  }
                : row
        );
        dataCopy.current = updatedRowDataState;
    } else {
        const missingObjects = data.filter(
            obj1 => !dataCopy.current.find(obj2 => obj1.id === obj2.id)
        );
        updatedRowDataState = missingObjects.map(row =>
            row.id === rowData.id
                ? {
                      ...row,
                      taskDescription: event.target.value
                  }
                : row
        );
        dataCopy.current = [...dataCopy.current, ...updatedRowDataState];
    }
    var validRows = CountValidRows(dataCopy.current);
    setValidRowCount(validRows);
};
export const CountValidRows = data => {
    let validRowCount = 0;
    data.forEach(row1 => {
        let isHoursPresent = false;
        day.forEach(element => {
            if (row1[element]) {
                isHoursPresent = true;
            }
        });
        if (isHoursPresent && row1.taskDescription) {
            validRowCount++;
        }
    });
    return validRowCount;
};
export const GetAllFilledRows = data => {
    let filledRows = [];
    data.forEach(row1 => {
        let isHoursPresent = false;
        day.forEach(element => {
            if (row1[element]) {
                isHoursPresent = true;
            }
        });
        if (isHoursPresent || row1.taskDescription) {
            filledRows = [...filledRows, row1];
        }
    });
    return filledRows;
};
const duplicateTasksList = (
    array,
    key,
    indexValue,
    categoryId,
    subCategoryId,
    projectId
) => {
    return array.reduce((list, obj, index) => {
        const value = obj[key];
        const duplicateIndexValue = obj[indexValue];
        const category = obj[categoryId];
        const subCategory = obj[subCategoryId];
        const projectid = obj[projectId];
        const combinedKey = `${category}_${subCategory}_${projectid}_${value}`;
        if (!list[combinedKey]) {
            list[combinedKey] = {
                values: [obj],
                indexes: [duplicateIndexValue]
            };
        } else {
            value && list[combinedKey].values.push(obj);
            value && list[combinedKey].indexes.push(duplicateIndexValue);
        }
        return list;
    }, {});
};
export const handleSaveClick = (
    data,
    setIsError,
    setData,
    setIsEditMode,
    setDataBeforeEdit,
    postTimeSheetData,
    setSummationData,
    setShowActionColumn,
    dataCopy,
    timeSheetEmployees,
    listOfduplicateTask,
    setListOfDuplicateTasks,
    isBehalf
) => {
    let finalRowToPost = [];
    let isInvalidRow = {};
    let isValidTable = true;
    const duplicateTasks = duplicateTasksList(
        dataCopy.current,
        "taskDescription",
        "id",
        "timeSheetCategoryId",
        "timeSheetSubCategoryId",
        "projectId"
    );
    const listOfduplicateTasks = Object.entries(duplicateTasks).filter(
        ([key, value]) => value.values.length > 1
    );
    if (listOfduplicateTasks.length > 0) {
        listOfduplicateTasks.forEach(([key, value]) => {
            value.indexes.forEach(x => {
                isInvalidRow = {
                    ...isInvalidRow,
                    [`taskduplicate_${x}`]: true
                };
            });
        });
        setIsError(isInvalidRow);

        if (isInvalidRow) {
            setListOfDuplicateTasks(duplicateTasks);
            isValidTable = false;
        }
    }
    dataCopy.current.forEach(row => {
        if (
            !row.timeSheetSubCategoryId ||
            !row.timeSheetCategoryId ||
            !row.projectId
        ) {
            isValidTable = false;
        }
        let isHoursPresent = false;
        let isZero = false;
        for (let i = 0; i < day.length; i++) {
            if (row[day[i]] && parseFloat(row[day[i]]) === 0) {
                isHoursPresent = false;
                isZero = true;
                isValidTable = false;
                break;
            }
            if (row[day[i]]) {
                isHoursPresent = true;
            }
        }
        if (isHoursPresent || row.taskDescription) {
            if (!row.timeSheetSubCategoryId) {
                isInvalidRow = {
                    ...isInvalidRow,
                    [`subCategory_${row.id}`]: true
                };
                isValidTable = false;
            }
            if (!row.timeSheetCategoryId) {
                isInvalidRow = {
                    ...isInvalidRow,
                    [`category_${row.id}`]: true
                };
                isValidTable = false;
            }
            if (!row.projectId) {
                isInvalidRow = {
                    ...isInvalidRow,
                    [`project_${row.id}`]: true
                };
                isValidTable = false;
            }
            if (isHoursPresent && row.taskDescription && isValidTable) {
                finalRowToPost = [...finalRowToPost, row];
            }
            if (!isHoursPresent && !row.taskDescription) {
                isInvalidRow = {
                    ...isInvalidRow,
                    [`tasktxt_${row.id}`]: true
                };

                isValidTable = false;
            }
            if (!isHoursPresent && row.taskDescription) {
                isInvalidRow = {
                    ...isInvalidRow,
                    [`hourtxt_${row.id}`]: true
                };
                // setIsError(isInvalidRow);
                isValidTable = false;
            }
            if (isHoursPresent && !row.taskDescription) {
                isInvalidRow = {
                    ...isInvalidRow,
                    [`tasktxt_${row.id}`]: true
                };
                // setIsError(isInvalidRow);
                isValidTable = false;
            }
        } else {
            if (isZero) {
                isInvalidRow = {
                    ...isInvalidRow,
                    [`hourtxt_${row.id}`]: true
                };
                isInvalidRow = {
                    ...isInvalidRow,
                    [`tasktxt_${row.id}`]: true
                };
                // setIsError(isInvalidRow);
                isValidTable = false;
            }
        }
        // const listOfduplicateTasks = Object.entries(duplicateTasks).filter(
        //     ([key, value]) => value.values.length > 1
        // );
        // if (listOfduplicateTasks.length > 0) {
        //     listOfduplicateTasks.forEach(([key, value]) => {
        //         value.indexes.forEach(x => {
        //             isInvalidRow = {
        //                 ...isInvalidRow,
        //                 [`taskduplicate_${x}`]: true
        //             };
        //         });
        //     });
        //     setIsError(isInvalidRow);

        //     if (isInvalidRow) {
        //         setListOfDuplicateTasks(duplicateTasks);
        //     }

        //     // return;
        // }
        setIsError(isInvalidRow);
        // if (isHoursPresent || row.taskDescription) {

        // }

        // else if (isHoursPresent && !row.taskDescription) {
        //     isInvalidRow = {
        //         ...isInvalidRow,
        //         [`tasktxt_${row.id}`]: true
        //     };
        //     setIsError(isInvalidRow);
        //     isValidTable = false;
        // } else if (!isHoursPresent && row.taskDescription) {
        //     isInvalidRow = {
        //         ...isInvalidRow,
        //         [`hourtxt_${row.id}`]: true
        //     };
        //     setIsError(isInvalidRow);
        //     isValidTable = false;
        // }
    });
    if (isValidTable) {
        dataCopy.current = finalRowToPost;
        setData(dataCopy.current);
        if (timeSheetEmployees.length > 0 || !isBehalf) {
            setIsEditMode(false);
        }
        setDataBeforeEdit(finalRowToPost);
        finalRowToPost.length > 0 && postTimeSheetData(finalRowToPost, "Saved");
        const gridTotal = columnSummation(finalRowToPost);
        setSummationData([gridTotal.columnSum]);
        setShowActionColumn(true);
    }
};
export const handleAddRowClick = (
    setIsEditMode,
    timesheetSubCategories,
    timesheetCategories,
    setData,
    data,
    employeeProject,
    setShowActionColumn,
    timesheetDetail,
    isSubmitted,
    dataCopy
) => {
    if (
        timesheetCategories.length === 0 ||
        (timesheetDetail.length > 0 && data.length === 0) ||
        isSubmitted
    ) {
        return;
    }
    setIsEditMode(true);
    data.length === 0 ? setShowActionColumn(false) : setShowActionColumn(true);
    AddNewRow(
        timesheetCategories,
        timesheetSubCategories,
        setData,
        data,
        employeeProject,
        dataCopy
    );
};
export const getFilteredSubcategories = (
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
    timesheetCategories,
    timesheetSubCategories,
    setData,
    data,
    employeeProject,
    dataCopy
) => {
    const filteredSubcategories =
        timesheetCategories.length > 0 &&
        getFilteredSubcategories(
            timesheetSubCategories,
            timesheetCategories[0].timeSheetCategoryId
        );
    setData([
        ...data,
        {
            id: data.length === 0 ? 0 : data[data.length - 1].id + 1,
            projectId:
                employeeProject.length > 0 ? employeeProject[0].projectId : "",
            timeSheetCategoryId:
                timesheetCategories.length > 0
                    ? timesheetCategories[0].timeSheetCategoryId
                    : "",
            timeSheetSubCategoryId:
                filteredSubcategories.length > 0
                    ? filteredSubcategories[0].timeSheetSubCategoryId
                    : ""
        }
    ]);
};
