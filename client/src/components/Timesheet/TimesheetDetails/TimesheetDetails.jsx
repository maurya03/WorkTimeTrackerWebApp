import React, {
    Fragment,
    useState,
    useEffect,
    forwardRef,
    useRef
} from "react";
import MaterialTable from "@material-table/core";
import css from "./TimesheetDetails.css";
import {
    AddCircle,
    Save,
    CloseSharp,
    EditRounded,
    Delete,
    DeleteOutline
} from "@material-ui/icons";
import cx from "classnames";
import Alert from "@mui/material/Alert";
import {
    updateTimeSheetStatusApi,
    submitTimesheetonbehalf
} from "rootpath/components/Timesheet/TimesheetDetails/TimesheetDetailsFunction";
import SelectDropdown from "rootpath/components/Timesheet/Common/SelectDropdown";
import MTableLabel from "rootpath/components/Timesheet/Common/MTableLabel";
import TableToolbar from "rootpath/components/Timesheet/TimesheetDetails/TableToolBar";
import Footer from "../Footer/Footer";
import TextareaAutosize from "@material-ui/core/TextareaAutosize";
import { makeStyles } from "@material-ui/core";
import { red, green } from "@material-ui/core/colors";
import TextField from "@mui/material/TextField";
import FormControl from "@mui/material/FormControl";
import {
    convertToYYYYMMDD,
    getWeekStartDate,
    handleSelectChange,
    handleTextFieldChange,
    onCategoryChange,
    handleOnRowDelete,
    summationColumns,
    columnSummation,
    handleTaskTitleChange,
    handleSaveClick,
    handleAddRowClick,
    getFilteredSubcategories,
    CountValidRows,
    AddNewRow
} from "rootpath/services/TimeSheet/TimesheetDataService";
import {
    employee,
    admin,
    create_draft,
    create_timesheet_behalf
} from "rootpath/components/Timesheet/Constants";

const TimesheetDetails = ({
    selectedProject,
    timesheetId,
    fetchtimesheetDetail,
    fetchtimesheetDetailByDate,
    fetchTimesheetEmployee,
    fetchEmployeeProject,
    fetchTimesheetCategory,
    fetchTimesheetSubCategory,
    fetchProjectsForOnBehalfEmployee,
    fetchTimesheetDetailCreatedOnBehalf,
    resetTimesheetDetail,
    timesheetDetail,
    postTimeSheetApi,
    timesheetCategories,
    timesheetSubCategories,
    employeeProject,
    timesheetEmployees,
    isTimesheetDetail,
    isBehalfOpen,
    isDetailPanel,
    setIsDetailPanel,
    selectedTimesheetStatus,
    userRole,
    displayHeader,
    clients,
    fetchClientList,
    panelStartDate,
    panelEndDate,
    summationData,
    setSummationData,
    listOfduplicateTask,
    setListOfDuplicateTasks,
    setShowAlert
}) => {
    const [data, setData] = useState([]);
    const dataCopy = useRef([]);
    const [dataBeforeEdit, setDataBeforeEdit] = useState([]);
    const [dataWithColSum, setDataWithColSum] = useState([]);
    const [success, setSuccess] = useState(false);
    const [initialTimesheetId, setInitialTimesheetId] = useState(0);
    const [alertSeverity, setAlertSeverity] = useState("");
    const [alertMessage, setAlertMessage] = useState("");
    const [selectedRow, setSelectedRow] = useState(null);
    const [toggleCalenderDisplay, setToggleCalenderDisplay] = useState(false);
    const [weekSelected, setWeekSelected] = useState("");
    const [selectedEmployee, setSelectedEmployee] = useState("");
    const [totalForRow, setTotalForRow] = useState([]);
    const [isEditMode, setIsEditMode] = useState(true);
    const [errors, setErrors] = useState({});
    const [isError, setIsError] = useState({});
    const [hourValue, setHourValue] = useState({});
    const [tasktxt, setTasktxt] = useState({});
    const [isSubmitted, setIsSubmitted] = useState(true);
    const [timesheetTitle, setTimesheetTitle] = useState("");
    const [isBehalf, setIsBehalf] = useState(false);
    const [dayStart, setDayStart] = useState(null);
    const [dayEnd, setDayEnd] = useState(null);
    const [selectedClient, setSelectedClient] = useState(false);
    const [canEdit, setCanEdit] = useState(true);
    const [validRowCount, setValidRowCount] = useState(0);
    const [isCancelled, setIsCancelled] = useState(false);
    const [showActionColumn, setShowActionColumn] = useState(true);
    const [hideToolbar, setHideToolbar] = useState(true);
    const [messageForApprovedOrSubmitted, setMessageForApprovedOrSubmitted] =
        useState("");
    useEffect(() => {
        if (selectedTimesheetStatus.approved) {
            setHideToolbar(false);
        }
    }, [canEdit]);
    const [isProjectSelectionDisabled, setIsProjectSelectionDisabled] =
        useState(false);
    const [
        isTimesheetWithPartialSubmission,
        setIsTimesheetWithPartialSubmission
    ] = useState(false);
    const showAlert = (alertSeverity, alertMessage) => {
        setSuccess(true);
        setAlertSeverity(alertSeverity);
        setAlertMessage(alertMessage);
        setTimeout(() => {
            setSuccess(false);
        }, 5000);
    };
    const useStyles = makeStyles(theme => ({
        root: {
            "& .css-1mbunh-MuiPaper-root": {
                boxShadow: "none"
            },
            "& .css-ig9rso-MuiToolbar-root": {
                height: 8
            },
            "& .css-11w94w9-MuiTableCell-root": {
                textAlign: "center"
            },
            "& .css-1ex1afd-MuiTableCell-root": {
                fontWeight: "800",
                fontSize: "large"
            },
            "& .css-1qgma8u-MuiButtonBase-root-MuiTableSortLabel-root:hover": {
                color: "#fff"
            },
            "& .css-1qgma8u-MuiButtonBase-root-MuiTableSortLabel-root.Mui-active":
                {
                    color: "#fff"
                }
        }
    }));
    const classes = useStyles();
    const handleChange = e => {
        const employee = timesheetEmployees.find(
            x => x.employeeId === parseInt(e.target.value)
        );
        setSelectedEmployee(employee.employeeId);
    };
    const duplicateCheckFunc = rowData => {
        setIsError(prev => {
            return {
                ...prev,
                [`tasktxt_${rowData.id}`]: false
            };
        });
        const listOfduplicateTasks = Object.entries(listOfduplicateTask).filter(
            ([key, value]) => value.values.length > 1
        );
        if (listOfduplicateTasks.length > 0) {
            listOfduplicateTasks.map(([key, value]) => {
                if (value.indexes.length === 2) {
                    value.indexes.map(id => {
                        setIsError(prev => {
                            return {
                                ...prev,
                                [`taskduplicate_${id}`]: false
                            };
                        });
                    });
                } else {
                    value.indexes.map(id => {
                        console.log(id);
                        id === rowData.id &&
                            setIsError(prev => {
                                return {
                                    ...prev,
                                    [`taskduplicate_${id}`]: false
                                };
                            });
                    });
                }
            });
        }
    };
    const tableSummationColumns = summationColumns(
        isEditMode,
        isDetailPanel,
        selectedTimesheetStatus,
        isSubmitted,
        data,
        showActionColumn
    );
    const renderTextfield = (rowData, keyName) => {
        const isNumeric = !isNaN(parseInt(rowData[keyName]));
        const isZero = parseFloat(rowData[keyName]) === 0;
        const isLastRow = parseInt(rowData.id) === data[data.length - 1].id;
        const hasError =
            isError[`hourtxt_${rowData.id}`] ||
            (hourValue[`${keyName}_${rowData.id}`] && isZero);

        return isEditMode ? (
            <TextField
                id={`${keyName}_${rowData.id}`}
                variant="standard"
                value={
                    hourValue[`${keyName}_${rowData.id}`] ?? rowData[keyName]
                }
                type="number"
                className={css.textField}
                error={hasError}
                helperText={isZero ? "Incorrect entry." : ""}
                onChange={event =>
                    handleTextFieldChange(
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
                        hourValue,
                        listOfduplicateTask
                    )
                }
                onFocus={event => {
                    if (isLastRow) {
                        setShowActionColumn(true);
                        AddNewRow(
                            timesheetCategories,
                            timesheetSubCategories,
                            setData,
                            data,
                            employeeProject,
                            dataCopy
                        );
                    }
                    setIsError(prev => ({
                        ...prev,
                        [`hourtxt_${rowData.id}`]: false
                    }));
                }}
            />
        ) : isNumeric ? (
            rowData[keyName]
        ) : (
            ""
        );
    };
    const renderEditProject = rowData => {
        rowData.projectId =
            employeeProject.length === 1
                ? employeeProject[0].projectId
                : rowData.projectId;
        const hasError = isError[`project_${rowData.id}`];
        return (
            <SelectDropdown
                cssClass={`${
                    hasError ? css.catDropdownWithError : css.catDropdown
                }`}
                onChangeFunction={event => {
                    const updatedRowDataState = handleSelectChange(
                        event,
                        rowData,
                        employeeProject,
                        data,
                        "projectId",
                        dataCopy
                    );
                    dataCopy.current = updatedRowDataState;
                    setData(dataCopy.current);
                    setIsError(prev => {
                        return {
                            ...prev,
                            [`project_${rowData.id}`]: false
                        };
                    });
                }}
                bindingData={employeeProject}
                keyName="projectId"
                value="clientName"
                defaultValue={
                    employeeProject.length === 1
                        ? employeeProject[0]["projectId"]
                        : data.length > 0
                        ? data.find(x => x.id === rowData.id)["projectId"]
                        : ""
                }
                id={`project_${rowData.id}`}
                title={
                    rowData["projectId"] &&
                    employeeProject.find(
                        x => x["projectId"] === rowData["projectId"]
                    )
                        ? employeeProject.find(
                              x => x["projectId"] === rowData["projectId"]
                          )["clientName"]
                        : employeeProject.length > 0 &&
                          employeeProject[0]["clientName"]
                }
                isDisabled={isProjectSelectionDisabled}
            />
        );
    };
    const renderEditSubCategory = rowData => {
        const filteredSubcategories = getFilteredSubcategories(
            timesheetSubCategories,
            rowData.timeSheetCategoryId ??
                timesheetCategories[0].timeSheetCategoryId
        );
        const hasError = isError[`subCategory_${rowData.id}`];
        return (
            <SelectDropdown
                cssClass={`${
                    hasError ? css.subCatDropdownWithError : css.subCatDropdown
                }`}
                onChangeFunction={event => {
                    const updatedRowDataState = handleSelectChange(
                        event,
                        rowData,
                        filteredSubcategories,
                        data,
                        "timeSheetSubCategoryId",
                        dataCopy
                    );
                    dataCopy.current = updatedRowDataState;
                    setData(dataCopy.current);
                }}
                bindingData={filteredSubcategories}
                keyName="timeSheetSubCategoryId"
                value="timeSheetSubCategoryName"
                defaultValue={
                    filteredSubcategories.length === 1
                        ? filteredSubcategories[0]["timeSheetSubCategoryId"]
                        : data.length > 0
                        ? data.find(x => x.id === rowData.id)[
                              "timeSheetSubCategoryId"
                          ]
                        : ""
                }
                id={`subCategory_${rowData.id}`}
                title={
                    rowData["timeSheetSubCategoryId"] &&
                    filteredSubcategories.find(
                        x =>
                            x["timeSheetSubCategoryId"] ===
                            rowData["timeSheetSubCategoryId"]
                    )
                        ? filteredSubcategories.find(
                              x =>
                                  x["timeSheetSubCategoryId"] ===
                                  rowData["timeSheetSubCategoryId"]
                          )["timeSheetSubCategoryName"]
                        : filteredSubcategories.length > 0 &&
                          filteredSubcategories[0]["timeSheetSubCategoryName"]
                }
                isDisabled={false}
            />
        );
    };
    const renderEditCategory = rowData => {
        const hasError = isError[`category_${rowData.id}`];
        return (
            <SelectDropdown
                cssClass={`${
                    hasError ? css.catDropdownWithError : css.catDropdown
                }`}
                rowData={rowData}
                onChangeFunction={event => {
                    const updatedRowDataState = onCategoryChange(
                        event,
                        rowData,
                        timesheetCategories,
                        data,
                        timesheetSubCategories,
                        dataCopy
                    );
                    dataCopy.current = updatedRowDataState;
                    setData(dataCopy.current);
                    setIsError(prev => {
                        return {
                            ...prev,
                            [`category_${rowData.id}`]: false,
                            [`subCategory_${rowData.id}`]: false
                        };
                    });
                }}
                bindingData={timesheetCategories}
                keyName="timeSheetCategoryId"
                value="timeSheetCategoryName"
                defaultValue={
                    timesheetCategories.length === 1
                        ? timesheetCategories[0]["timeSheetCategoryId"]
                        : data.length > 0
                        ? data.find(x => x.id === rowData.id)[
                              "timeSheetCategoryId"
                          ]
                        : ""
                }
                id={`category_${rowData.id}`}
                title={
                    rowData["timeSheetCategoryId"] &&
                    timesheetCategories.find(
                        x =>
                            x["timeSheetCategoryId"] ===
                            rowData["timeSheetCategoryId"]
                    )
                        ? timesheetCategories.find(
                              x =>
                                  x["timeSheetCategoryId"] ===
                                  rowData["timeSheetCategoryId"]
                          )["timeSheetCategoryName"]
                        : timesheetCategories.length > 0 &&
                          timesheetCategories[0]["timeSheetCategoryName"]
                }
                isDisabled={false}
            />
        );
    };
    const tableColumns = [
        {
            hidden: isDetailPanel,
            title: "Project",
            field: "projectId",
            width: "12%",
            render: rowData =>
                isEditMode ? (
                    renderEditProject(rowData)
                ) : (
                    <MTableLabel
                        rowData={rowData}
                        bindingList={employeeProject}
                        keyName="projectId"
                        value="clientName"
                    />
                )
        },
        {
            title: "Task title",
            field: "taskDescription",
            width: "20%",
            render: rowData =>
                isEditMode ? (
                    <Fragment>
                        <TextareaAutosize
                            style={{
                                width: "100%",
                                minHeight: 45,
                                marginTop: 6,
                                border: isError[`tasktxt_${rowData.id}`]
                                    ? "2px solid red"
                                    : "1px solid"
                            }}
                            defaultValue={rowData.taskDescription}
                            id={`tasktxt_${rowData.id}`}
                            columns={3}
                            onFocus={event => {
                                duplicateCheckFunc(rowData);
                            }}
                            onChange={event => {
                                if (
                                    timesheetEmployees.length == 0 &&
                                    isBehalf
                                ) {
                                    showAlert(
                                        "error",
                                        "Please select the employee first"
                                    );
                                    return;
                                }
                                if (
                                    parseInt(event.target.id.split("_")[1]) ===
                                    data[data.length - 1].id
                                ) {
                                    setShowActionColumn(true);
                                    AddNewRow(
                                        timesheetCategories,
                                        timesheetSubCategories,
                                        setData,
                                        data,
                                        employeeProject,
                                        dataCopy
                                    );
                                }
                                handleTaskTitleChange(
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
                                );
                            }}
                        />
                        {isError[`tasktxt_${rowData.id}`] && (
                            <div
                                style={{
                                    color: "red",
                                    fontSize: "x-small"
                                }}
                            >
                                Invalid task description
                            </div>
                        )}
                        {isError[`taskduplicate_${rowData.id}`] && (
                            <div
                                style={{
                                    color: "red",
                                    fontSize: "x-small"
                                }}
                            >
                                Duplicate task description
                            </div>
                        )}
                    </Fragment>
                ) : (
                    rowData.taskDescription
                )
        },
        {
            title: "Category",
            field: "timeSheetCategoryId",
            width: "11%",
            render: rowData =>
                isEditMode ? (
                    renderEditCategory(rowData)
                ) : (
                    <MTableLabel
                        rowData={rowData}
                        bindingList={timesheetCategories}
                        keyName="timeSheetCategoryId"
                        value="timeSheetCategoryName"
                    />
                )
        },
        {
            title: "SubCategory",
            field: "timeSheetSubCategoryId",
            width: "17%",
            render: rowdata =>
                isEditMode
                    ? renderEditSubCategory(rowdata)
                    : rowdata.timeSheetSubCategoryId && (
                          <label>
                              {timesheetSubCategories.length > 0 &&
                                  timesheetSubCategories.filter(
                                      x =>
                                          x.timeSheetSubCategoryId ===
                                          rowdata.timeSheetSubCategoryId
                                  )[0].timeSheetSubCategoryName}
                          </label>
                      )
        },
        {
            title: "Sun",
            field: "Sun",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Sun")
        },
        {
            title: "Mon",
            field: "Mon",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Mon")
        },
        {
            title: "Tue",
            field: "Tue",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Tue")
        },
        {
            title: "Wed",
            field: "Wed",
            width: "5%",
            type: "numeric",
            cellStyle: row => {
                const rowStyling = {};
                return rowStyling;
            },
            render: rowData => renderTextfield(rowData, "Wed")
        },
        {
            title: "Thu",
            field: "Thu",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Thu")
        },
        {
            title: "Fri",
            field: "Fri",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Fri")
        },
        {
            title: "Sat",
            field: "Sat",
            width: "5%",
            type: "numeric",
            render: rowData => renderTextfield(rowData, "Sat")
        }
    ];
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
    const bindTimesheetDetail = (
        selectedProject,
        fetchEmployeeProject,
        isBehalfOpen,
        fetchTimesheetCategory,
        fetchTimesheetSubCategory,
        timesheetDetail,
        GetStartAndEndDates,
        setDayStart,
        setDayEnd,
        setWeekSelected,
        timesheetId,
        fetchtimesheetDetail,
        setInitialTimesheetId,
        fetchtimesheetDetailByDate
    ) => {
        fetchTimesheetCategory();
        fetchTimesheetSubCategory();
        // const weekDate = new Date();
        // let { startDate, endDate } = GetStartAndEndDates(weekDate);
        // const weekStartDate = getWeekStartDate(weekDate);
        // startDate = convertToYYYYMMDD(
        //     weekStartDate.setDate(weekStartDate.getDate() - 1)
        // );
        // setDayStart(
        //     new Date(weekStartDate.setDate(weekStartDate.getDate() - 15))
        // );
        // setDayEnd(
        //     new Date(weekStartDate.setDate(weekStartDate.getDate() + 28))
        // );
        // weekStartDate.setDate(weekStartDate.getDate() - 13);
        // endDate = convertToYYYYMMDD(
        //     weekStartDate.setDate(weekStartDate.getDate() + 6)
        // );
        // setWeekSelected(startDate + " " + endDate);
        fetchEmployeeProject();
        // if (isDetailPanel && timesheetId) {
        //     fetchtimesheetDetail(timesheetId);
        //     setInitialTimesheetId(parseInt(timesheetId));
        // } else {
        //     const dates = {
        //         startDate: startDate,
        //         endDate: endDate
        //     };
        //     fetchtimesheetDetailByDate(
        //         dates,
        //         setIsTimesheetWithPartialSubmission,
        //         setIsProjectSelectionDisabled
        //     );
        // }
    };
    useEffect(() => {
        const weekDate = new Date();
        setIsSubmitted(false);
        let { startDate, endDate } = GetStartAndEndDates(weekDate);
        const weekStartDate = getWeekStartDate(weekDate);
        startDate = convertToYYYYMMDD(
            weekStartDate.setDate(weekStartDate.getDate() - 1)
        );
        setDayStart(
            new Date(weekStartDate.setDate(weekStartDate.getDate() - 15))
        );
        setDayEnd(
            new Date(weekStartDate.setDate(weekStartDate.getDate() + 28))
        );
        weekStartDate.setDate(weekStartDate.getDate() - 13);
        endDate = convertToYYYYMMDD(
            weekStartDate.setDate(weekStartDate.getDate() + 6)
        );
        setWeekSelected(startDate + " " + endDate);
        if (isDetailPanel && timesheetId) {
            fetchtimesheetDetail(timesheetId);
            setInitialTimesheetId(parseInt(timesheetId));
        } else {
            const dates = {
                startDate: startDate,
                endDate: endDate
            };
            fetchtimesheetDetailByDate(
                dates,
                setIsTimesheetWithPartialSubmission,
                setIsProjectSelectionDisabled
            );
        }
    }, []);

    useEffect(() => {
        timesheetDetail = [];
        bindTimesheetDetail(
            selectedProject,
            fetchEmployeeProject,
            isBehalfOpen,
            fetchTimesheetCategory,
            fetchTimesheetSubCategory,
            timesheetDetail,
            GetStartAndEndDates,
            setDayStart,
            setDayEnd,
            setWeekSelected,
            timesheetId,
            fetchtimesheetDetail,
            setInitialTimesheetId,
            fetchtimesheetDetailByDate
        );
        setTimesheetTitle(create_draft);
        // setIsSubmitted(false);
        return () => {
            resetTimesheetDetail();
        };
    }, [fetchtimesheetDetail, fetchtimesheetDetailByDate]);
    useEffect(() => {
        if (timesheetDetail.length > 0) {
            if (isTimesheetWithPartialSubmission && !isDetailPanel) {
                setIsSubmitted(false);
                const timeDetailToShow = timesheetDetail.filter(
                    x => x.statusId === 1 || x.statusId === 3
                );
                setData(timeDetailToShow);
                dataCopy.current = timeDetailToShow;
                setInitialTimesheetId(timeDetailToShow[0].timesheetId);

                setIsEditMode(false);
                const gridTotal = columnSummation(timeDetailToShow);
                setSummationData([gridTotal.columnSum]);
                isDetailPanel
                    ? setShowActionColumn(false)
                    : setShowActionColumn(true);
            } else {
                setData(timesheetDetail);
                dataCopy.current = timesheetDetail;
                if (
                    timesheetDetail[0].statusId === 2 ||
                    timesheetDetail[0].statusId === 4
                ) {
                    !isDetailPanel &&
                        setMessageForApprovedOrSubmitted(
                            "Timesheet already submitted"
                        );
                    setIsSubmitted(true);
                    if (!isDetailPanel) {
                        setData([]);
                        dataCopy.current = [];
                    }
                } else {
                    setIsSubmitted(false);
                    setData(timesheetDetail);
                    dataCopy.current = timesheetDetail;
                }
                setIsEditMode(false);
                const gridTotal = columnSummation(timesheetDetail);
                setSummationData([gridTotal.columnSum]);
                isDetailPanel
                    ? setShowActionColumn(false)
                    : setShowActionColumn(true);
            }
        } else {
            setInitialTimesheetId(0);
            dataCopy.current = [];
            const gridTotal = columnSummation(timesheetDetail);
            setSummationData([gridTotal.columnSum]);
            if (!isDetailPanel || canEdit)
                handleAddRowClick(
                    setIsEditMode,
                    timesheetSubCategories,
                    timesheetCategories,
                    setData,
                    [],
                    employeeProject,
                    setShowActionColumn,
                    timesheetDetail,
                    isSubmitted,
                    dataCopy
                );
            // setIsAdd(true);
        }
    }, [timesheetDetail]);

    useEffect(() => {
        if (userRole.roleName !== employee) {
            setDataBeforeEdit([]);
            isBehalf
                ? setTimesheetTitle(create_timesheet_behalf)
                : setTimesheetTitle(create_draft);
            if (isBehalf) {
                setHourValue({});
                fetchClientList();
                setData([]);
                dataCopy.current = [];
                if (userRole.roleName !== employee) {
                    setSelectedClient(employeeProject[0].projectId);
                }
            }
            isBehalf
                ? getOnbehalfTimesheetForEmployee(
                      weekSelected,
                      GetStartAndEndDates,
                      selectedEmployee,
                      isBehalf,
                      fetchTimesheetDetailCreatedOnBehalf,
                      showAlert,
                      setCanEdit,
                      setData,
                      canEdit,
                      timesheetDetail,
                      setIsEditMode,
                      timesheetSubCategories,
                      timesheetCategories,
                      employeeProject,
                      employeeProject[0].projectId
                  )
                : bindTimesheetDetail(
                      selectedProject,
                      fetchEmployeeProject,
                      isBehalfOpen,
                      fetchTimesheetCategory,
                      fetchTimesheetSubCategory,
                      timesheetDetail,
                      GetStartAndEndDates,
                      setDayStart,
                      setDayEnd,
                      setWeekSelected,
                      timesheetId,
                      fetchtimesheetDetail,
                      setInitialTimesheetId,
                      fetchtimesheetDetailByDate
                  );
        }
    }, [isBehalf]);
    useEffect(() => {
        if (userRole.roleName !== employee) {
            if (selectedEmployee) {
                setHourValue({});
                setData([]);
                dataCopy.current = [];
            }
            getOnbehalfTimesheetForEmployee(
                weekSelected,
                GetStartAndEndDates,
                selectedEmployee,
                isBehalf,
                fetchTimesheetDetailCreatedOnBehalf,
                showAlert,
                setCanEdit,
                setData,
                canEdit,
                timesheetDetail,
                setIsEditMode,
                timesheetSubCategories,
                timesheetCategories,
                employeeProject,
                selectedClient
            );
        }
    }, [selectedEmployee]);
    useEffect(() => {
        if (clients.length > 0 && isBehalf) {
            setSelectedClient(clients[0].id);
            fetchTimesheetEmployee(clients[0].id);
        }
    }, [clients]);
    useEffect(() => {
        if (selectedClient) {
            fetchEmployeeProject(
                clients.find(x => x.id === selectedClient),
                isBehalf
            );
            fetchTimesheetEmployee(selectedClient);
            setHourValue({});
            setData([]);
            dataCopy.current = [];
        }
    }, [selectedClient]);
    useEffect(() => {
        const validRows = CountValidRows(data);
        setValidRowCount(validRows);
    }, [data]);
    useEffect(() => {
        if (userRole.roleName !== employee) {
            if (timesheetEmployees.length > 0) {
                setSelectedEmployee(timesheetEmployees[0].employeeId);
                getOnbehalfTimesheetForEmployee(
                    weekSelected,
                    GetStartAndEndDates,
                    timesheetEmployees[0].employeeId,
                    isBehalf,
                    fetchTimesheetDetailCreatedOnBehalf,
                    showAlert,
                    setCanEdit,
                    setData,
                    canEdit,
                    timesheetDetail,
                    setIsEditMode,
                    timesheetSubCategories,
                    timesheetCategories,
                    employeeProject,
                    selectedClient
                );
            } else {
                setIsEditMode(true);
                resetTimesheetDetail();
            }
        }
    }, [timesheetEmployees]);
    useEffect(() => {
        if (isCancelled && data.length === 0) {
            setIsEditMode(true);
            handleAddRowClick(
                setIsEditMode,
                timesheetSubCategories,
                timesheetCategories,
                setData,
                [],
                employeeProject,
                setShowActionColumn,
                timesheetDetail,
                isSubmitted,
                dataCopy
            );
            setIsCancelled(false);
            const gridTotal = columnSummation([]);
            setSummationData([gridTotal.columnSum]);
        } else {
            isCancelled && setIsEditMode(false);
        }
    }, [isCancelled]);
    // useEffect(() => {
    //     if (
    //         timesheetDetail.length === 0 &&
    //         weekSelected &&
    //         timesheetCategories.length > 0 &&
    //         timesheetSubCategories.length > 0
    //     ) {
    //         handleAddRowClick(
    //             setIsEditMode,
    //             timesheetSubCategories,
    //             timesheetCategories,
    //             setData,
    //             [],
    //             employeeProject,
    //             setShowActionColumn,
    //             timesheetDetail,
    //             isSubmitted,
    //             dataCopy,
    //         );
    //     }
    // }, [weekSelected, timesheetDetail]);
    const postUpdateData = async (status, startDate, endDate) => {
        const selectedEmailListAndWeek = [
            {
                EmailId:
                    selectedEmployee && isBehalf
                        ? timesheetEmployees.find(
                              x => x.employeeId === selectedEmployee
                          ).emailId
                        : localStorage.getItem("userEmailId") ?? "",
                WeekStartDate: startDate,
                WeekEndDate: endDate,
                Status: "submitted",
                Remarks: ""
            }
        ];
        const timesheetId = initialTimesheetId;
        const data = {
            status: status,
            startDate: startDate,
            endDate: endDate,
            timesheetId: selectedTimesheetStatus.rejected
                ? initialTimesheetId
                : isBehalf
                ? initialTimesheetId
                : 0
        };
        return selectedEmployee && isBehalf
            ? await submitTimesheetonbehalf(
                  selectedEmployee,
                  data,
                  selectedEmailListAndWeek
              )
            : await updateTimeSheetStatusApi(data, selectedEmailListAndWeek);
    };
    const handleSubmitClick = async () => {
        const result = await postUpdateData(
            "pending",
            isDetailPanel
                ? convertToYYYYMMDD(panelStartDate)
                : weekSelected.split(" ")[0],
            isDetailPanel
                ? convertToYYYYMMDD(panelEndDate)
                : weekSelected.split(" ")[1]
        );
        if (result.status === 202) {
            setShowAlert(true, "success", "Timesheet submitted successfully!");
            setIsSubmitted(true);
        }
    };
    const postTimeSheetData = async (gridData, actionName) => {
        const createdTimesheetId = await postTimeSheetApi(
            gridData,
            isDetailPanel
                ? convertToYYYYMMDD(panelStartDate) +
                      " " +
                      convertToYYYYMMDD(panelEndDate)
                : weekSelected,
            isBehalf && selectedEmployee,
            initialTimesheetId,
            actionName
        );
        if (Object.keys(initialTimesheetId).length > 1) {
            showAlert(
                "error",
                Object.values(initialTimesheetId.response.data)[1]
            );
            return;
        } else {
            setInitialTimesheetId(createdTimesheetId);
        }
    };
    const headerStyles = {
        backgroundColor: "#17072b",
        color: "#fff",
        position: "sticky",
        top: 0,
        right: 0,
        zIndex: 1,
        // paddingRight: "15px",
        overflowX: "hidden",
        "&:hover": {
            color: "#fff"
        }
    };
    const getOnbehalfTimesheetForEmployee = (
        weekSelected,
        GetStartAndEndDates,
        selectedEmployee,
        isBehalf,
        fetchTimesheetDetailCreatedOnBehalf,
        showAlert,
        setCanEdit,
        setData,
        canEdit,
        timesheetDetail,
        setIsEditMode,
        timesheetSubCategories,
        timesheetCategories,
        employeeProject,
        selectedClientId
    ) => {
        const selectedDate = weekSelected
            ? new Date(weekSelected.split(" ")[0])
            : new Date();
        const { startDate, endDate } = GetStartAndEndDates(selectedDate);
        const params = {
            startDate: startDate,
            endDate: endDate,
            isBehalf: true,
            empId: selectedEmployee,
            clientId: selectedClientId
        };
        const result =
            selectedEmployee &&
            isBehalf &&
            fetchTimesheetDetailCreatedOnBehalf(
                params,
                showAlert,
                setCanEdit,
                setData,
                setIsTimesheetWithPartialSubmission,
                setIsProjectSelectionDisabled,
                dataCopy,
                setMessageForApprovedOrSubmitted,
                setIsSubmitted
            );
        if (canEdit && isBehalf && timesheetDetail.length > 0) {
            handleAddRowClick(
                setIsEditMode,
                timesheetSubCategories,
                timesheetCategories,
                setData,
                [],
                employeeProject,
                setShowActionColumn,
                timesheetDetail,
                isSubmitted,
                dataCopy
            );
        }
    };
    return (
        <Fragment>
            <div
                className={cx(css.dashboardView, {
                    [css.panelWidth]: isDetailPanel
                })}
            >
                {success ? (
                    <Alert
                        variant="filled"
                        severity={alertSeverity}
                        style={{
                            position: "absolute",
                            width: "100%",
                            zIndex: 2
                        }}
                    >
                        {alertMessage}
                    </Alert>
                ) : null}
                {!isDetailPanel && (
                    <div
                        className={cx(css.contentHeader, {
                            [css.panelHeader]: isDetailPanel
                        })}
                    >
                        <div title={timesheetTitle} className={css.title}>
                            {timesheetTitle}
                        </div>
                        {userRole.roleName !== employee && (
                            <button
                                onClick={() => {
                                    setIsSubmitted(false);
                                    setIsBehalf(!isBehalf);
                                    setData([]);
                                    dataCopy.current = [];
                                    setHourValue({});
                                }}
                                className={"btn btn-primary " + css.m10}
                            >
                                {isBehalf
                                    ? create_draft
                                    : create_timesheet_behalf}
                            </button>
                        )}
                    </div>
                )}
                {isBehalf && (
                    <div className={css.clientSelector}>
                        {userRole.roleName === admin && (
                            <div className={css.clientContainer}>
                                <label className={css.clientLabel}>
                                    Client:{" "}
                                </label>
                                <FormControl className={css.formControl}>
                                    <SelectDropdown
                                        onChangeFunction={event => {
                                            setIsSubmitted(false);
                                            setSelectedClient(
                                                event.target.value
                                            );
                                        }}
                                        bindingData={clients}
                                        keyName="id"
                                        value="clientName"
                                        defaultValue={selectedClient}
                                        title=""
                                        isDisabled={false}
                                    />
                                </FormControl>
                            </div>
                        )}
                        <div className={css.clientContainer}>
                            <label className={css.employeeLabel}>
                                Employee:{" "}
                            </label>
                            <FormControl className={css.formControl}>
                                <SelectDropdown
                                    onChangeFunction={event => {
                                        setIsSubmitted(false);
                                        handleChange(event);
                                    }}
                                    bindingData={timesheetEmployees}
                                    keyName="employeeId"
                                    value="employeeName"
                                    defaultValue={selectedEmployee}
                                    title=""
                                    isDisabled={false}
                                />
                            </FormControl>
                        </div>
                    </div>
                )}
                <div className={`${css.container} ${classes.root}`}>
                    <MaterialTable
                        columns={tableColumns}
                        style={css.table}
                        data={data}
                        title=""
                        onRowClick={(evt, selectedRow) => {
                            setSelectedRow(selectedRow.tableData.id);
                        }}
                        options={{
                            maxBodyHeight: "350px",
                            search: false,
                            actionsColumnIndex: -1,
                            paging: false,
                            tableLayout: "fixed",
                            rowStyle: rowData => ({
                                backgroundColor:
                                    selectedRow === rowData.tableData.id
                                        ? "rgb(228 228 233)"
                                        : "#FFF",
                                textAlign: "center"
                            }),
                            headerStyle: headerStyles,
                            selection: false,
                            maxColumnSort: 0,
                            showTitle: true,
                            toolbar: !isDetailPanel,
                            draggable: false
                        }}
                        actions={[
                            data.length > 0 &&
                                !isEditMode &&
                                !selectedTimesheetStatus.approverPending &&
                                !isSubmitted && {
                                    icon: () => <EditRounded />,
                                    tooltip: "Edit",
                                    onClick: (event, rowData) => {
                                        if (
                                            employeeProject.length > 0 &&
                                            !isDetailPanel &&
                                            isTimesheetWithPartialSubmission
                                        ) {
                                            fetchEmployeeProject(
                                                employeeProject.find(
                                                    x =>
                                                        x.projectId ===
                                                        data[0].projectId
                                                ),
                                                isBehalf,
                                                isTimesheetWithPartialSubmission
                                            );
                                        }
                                        setIsCancelled(false);
                                        setHourValue({});
                                        setIsError([]);
                                        setIsEditMode(true);
                                        data.length === 1 &&
                                            setShowActionColumn(false);
                                        if (data.length > 0) {
                                            setDataBeforeEdit(data);
                                            setShowActionColumn(true);
                                            AddNewRow(
                                                timesheetCategories,
                                                timesheetSubCategories,
                                                setData,
                                                data,
                                                employeeProject
                                            );
                                        } else {
                                            setDataBeforeEdit(dataBeforeEdit);
                                        }
                                    },
                                    isFreeAction: true
                                },
                            !selectedTimesheetStatus.approverPending &&
                                isEditMode &&
                                canEdit && {
                                    icon: () => <AddCircle />,
                                    tooltip: "Add Row",
                                    onClick: () => {
                                        setIsCancelled(false);
                                        handleAddRowClick(
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
                                        );
                                    },
                                    isFreeAction: true
                                },
                            isEditMode &&
                                validRowCount > 0 && {
                                    icon: () => (
                                        <Save style={{ color: green[500] }} />
                                    ),
                                    tooltip: "Save All",
                                    onClick: () => {
                                        handleSaveClick(
                                            data,
                                            setIsError,
                                            setData,
                                            setIsEditMode,
                                            setDataBeforeEdit,
                                            postTimeSheetData,
                                            setSummationData,
                                            setShowActionColumn,
                                            dataCopy,
                                            timesheetEmployees,
                                            listOfduplicateTask,
                                            setListOfDuplicateTasks,
                                            isBehalf
                                        );
                                    },
                                    isFreeAction: true
                                },
                            isEditMode &&
                                validRowCount > 0 &&
                                data.length > 0 && {
                                    icon: () => (
                                        <CloseSharp
                                            style={{ color: red[500] }}
                                        />
                                    ),
                                    tooltip: "Cancel",
                                    onClick: (event, rowData) => {
                                        setHourValue({});
                                        setIsError([]);
                                        setIsCancelled(true);
                                        setShowActionColumn(true);
                                        let dataToSet;
                                        dataBeforeEdit.length > 0
                                            ? (dataToSet = dataBeforeEdit)
                                            : (dataToSet = []);
                                        setData(dataToSet);
                                        dataCopy.current = dataToSet;
                                        const gridTotal =
                                            columnSummation(dataToSet);
                                        setSummationData([gridTotal.columnSum]);
                                    },
                                    isFreeAction: true
                                },
                            !isEditMode &&
                                !isSubmitted && {
                                    icon: () => (
                                        <Footer
                                            initialTimesheetId={
                                                initialTimesheetId
                                            }
                                            weekSelected={weekSelected}
                                            postUpdateData={postUpdateData}
                                            postTimeSheetApi={postTimeSheetApi}
                                            data={data}
                                            selectedEmployee={selectedEmployee}
                                            setInitialTimesheetId={
                                                setInitialTimesheetId
                                            }
                                            isDetailPanel={isDetailPanel}
                                            setIsDetailPanel={setIsDetailPanel}
                                            showAlert={showAlert}
                                            selectedTimesheetStatus={
                                                selectedTimesheetStatus
                                            }
                                            isBehalfOpen={isBehalfOpen}
                                            userRole={userRole}
                                            isEditMode={isEditMode}
                                            handleSubmitClick={
                                                handleSubmitClick
                                            }
                                            isSubmitted={isSubmitted}
                                            canEdit={canEdit}
                                            isBehalf={isBehalf}
                                        />
                                    ),
                                    tooltip: "Submit Timesheet",
                                    isFreeAction: true
                                },
                            !selectedTimesheetStatus.approverPending &&
                                !selectedTimesheetStatus.submitted &&
                                !isSubmitted &&
                                showActionColumn && {
                                    icon: forwardRef((props, ref) => (
                                        <Delete
                                            {...props}
                                            ref={ref}
                                            className={cx({
                                                [css.deleteOutline]:
                                                    isDetailPanel
                                            })}
                                        />
                                    )),
                                    tooltip: "Delete",
                                    onClick: (event, rowData) => {
                                        handleOnRowDelete(
                                            data,
                                            postTimeSheetData,
                                            setSummationData,
                                            setData,
                                            rowData.id,
                                            timesheetCategories,
                                            timesheetSubCategories,
                                            employeeProject,
                                            setShowActionColumn,
                                            setIsEditMode,
                                            setHourValue,
                                            dataCopy
                                        );
                                    }
                                }
                        ]}
                        localization={{
                            body: {
                                emptyDataSourceMessage:
                                    messageForApprovedOrSubmitted
                            },
                            header: {
                                actions: "Action"
                            }
                        }}
                        components={{
                            Toolbar: props => (
                                <TableToolbar
                                    timesheetEmployees={timesheetEmployees}
                                    setMessageForApprovedOrSubmitted={
                                        setMessageForApprovedOrSubmitted
                                    }
                                    isBehalf={isBehalf}
                                    selectedEmployee={selectedEmployee}
                                    selectedClient={selectedClient}
                                    handleChange={event => handleChange(event)}
                                    isDetailPanel={isDetailPanel}
                                    setToggleCalenderDisplay={
                                        setToggleCalenderDisplay
                                    }
                                    weekSelected={weekSelected}
                                    toggleCalenderDisplay={
                                        toggleCalenderDisplay
                                    }
                                    setWeekSelected={setWeekSelected}
                                    selectedTimesheetStatus={
                                        selectedTimesheetStatus
                                    }
                                    fetchtimesheetDetailByDate={
                                        fetchtimesheetDetailByDate
                                    }
                                    dayStart={dayStart}
                                    dayEnd={dayEnd}
                                    setData={setData}
                                    setHourValue={setHourValue}
                                    setSummationData={setSummationData}
                                    setCanEdit={setCanEdit}
                                    showAlert={showAlert}
                                    fetchTimesheetDetailCreatedOnBehalf={
                                        fetchTimesheetDetailCreatedOnBehalf
                                    }
                                    setIsTimesheetWithPartialSubmission={
                                        setIsTimesheetWithPartialSubmission
                                    }
                                    setIsProjectSelectionDisabled={
                                        setIsProjectSelectionDisabled
                                    }
                                    setShowActionColumn={setShowActionColumn}
                                    setIsSubmitted={setIsSubmitted}
                                    props={props}
                                    dataCopy={dataCopy}
                                />
                            )
                        }}
                    />
                </div>
                <div className={classes.root}>
                    {data.length > 0 ? (
                        <MaterialTable
                            columns={tableSummationColumns}
                            data={summationData}
                            title=""
                            options={{
                                search: false,
                                actionsColumnIndex: -1,
                                paging: false,
                                tableLayout: "fixed",
                                rowStyle: rowData => ({
                                    fontWeight: "bold",
                                    backgroundColor: "rgb(191 205 191)"
                                }),
                                selection: false,
                                maxColumnSort: 0,
                                showTitle: false,
                                toolbar: false,
                                draggable: false
                            }}
                            components={{
                                Header: props => null
                            }}
                            localization={{
                                body: {
                                    emptyDataSourceMessage: ""
                                },
                                header: {
                                    actions: "Actions"
                                }
                            }}
                        />
                    ) : null}
                </div>
                <br />
            </div>
        </Fragment>
    );
};
export default TimesheetDetails;
