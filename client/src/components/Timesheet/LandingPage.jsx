import React, { Fragment, useState, useEffect } from "react";
import MaterialTable from "@material-table/core";
import css from "./LandingPage.css";
import { object } from "prop-types";
const originalData = [
    {
        id: "client 1",
        name: "Jasnah",
        booleanValue: false
    },
    {
        id: "client 2",
        name: "Dal",
        booleanValue: true
    },
    {
        id: "client 3",
        name: "Kal",
        booleanValue: false
    }
];
const Project = [
    { Id: 18, ClientName: "ML" },
    { Id: 19, ClientName: "Mercell" }
];
const Category = [
    { timeSheetCategoryId: 1, timeSheetCategoryName: "CO Holiday" },
    { timeSheetCategoryId: 2, timeSheetCategoryName: "CO Idle Time" },
    { timeSheetCategoryId: 3, timeSheetCategoryName: "CO Leave" },
    { timeSheetCategoryId: 4, timeSheetCategoryName: "Engg Engineering" }
];
const SubCategory = [
    {
        timeSheetSubCategoryId: "1",
        timeSheetSubcategoryName: "Dev Unit Testing",
        timeSheetCategoryId: 4
    },
    {
        timeSheetSubCategoryId: "2",
        timeSheetSubcategoryName: "Dev Code Review",
        timeSheetCategoryId: 4
    },
    {
        timeSheetSubCategoryId: "3",
        timeSheetSubcategoryName: "Dev Defect Fixing",
        timeSheetCategoryId: 4
    },
    {
        timeSheetSubCategoryId: "4",
        timeSheetSubcategoryName: "Dev Dataset Refresh and Domo Sync",
        timeSheetCategoryId: 4
    }
];
const testData = [
    {
        dayOfWeek: 2,
        hoursWorked: 2.0,
        entryDate: "2024-03-04T00:00:00",
        tasktitle: "Worked ON CPL-244",
        timeSheetCategoryId: 2,
        timeSheetSubCategoryId: 2,
        projectId: 2
    },
    {
        dayOfWeek: 4,
        hoursWorked: 3.5,
        entryDate: "2024-03-05T00:00:00",
        tasktitle: "Worked ON CPL-212 and debugged code with other tool",
        timeSheetCategoryId: 2,
        timeSheetSubCategoryId: 2,
        projectId: 2
    }
];
const LandingPage = ({
    fetchTimeSheetEnteries,
    timesheetEnteries,
    postTimeSheetApi
}) => {
    const [data, setData] = useState([]);
    let weekData = [
        { 1: "Sun" },
        { 2: "Mon" },
        { 3: "Tue" },
        { 4: "Wed" },
        { 5: "Thu" },
        { 6: "Fri" },
        { 7: "Sat" }
    ];
    //const [data, setData] = useState([]);
    // let dayOfWeekMapping = [];
    // timesheetEnteries &&
    //     timesheetEnteries.map(row => {
    //         let eachData = {};
    //         eachData.entryDate = row.entryDate;
    //         eachData.tasktitle = row.tasktitle;
    //         eachData.timeSheetCategoryId = row.timeSheetCategoryId;
    //         eachData.timeSheetSubCategoryId = row.timeSheetSubCategoryId;
    //         eachData.projectId = row.projectId;
    //         eachData[Object.values(weekData[row.dayOfWeek - 1])[0]] =
    //             row.hoursWorked;
    //         weekData.map(day => {
    //             if (Object.keys(day)[0] == row.dayOfWeek) {
    //                 eachData[day[row.dayOfWeek]] = row.hoursWorked?.toString();
    //             } else {
    //                 eachData[Object.values(day)[0]] = "";
    //             }
    //         });
    //         dayOfWeekMapping = [...dayOfWeekMapping, eachData];
    //     });
    const [projects, setProjects] = useState(Project);
    const handleSaveClick = () => {
        postTimeSheetApi(data);
    };
    const isHoursValid = value => {
        return value === "" || (value >= 1 && value < 9);
    };
    const tableColumns = [
        {
            title: "Project",
            field: "projectId",
            width: "5%",
            editComponent: props => {
                return (
                    <select
                        value={props.value}
                        onChange={e => props.onChange(parseInt(e.target.value))}
                    >
                        <option value="" disabled selected>
                            Select Project
                        </option>
                        {projects.length > 1 &&
                            projects.map(item => (
                                <option key={item.Id} value={item.Id}>
                                    {item.ClientName}
                                </option>
                            ))}
                    </select>
                );
            },
            render: rowdata => (
                <label>
                    {
                        Project.filter(x => x.Id == rowdata.projectId)[0]
                            .ClientName
                    }
                </label>
            )
        },
        {
            title: "Task title",
            field: "tasktitle",
            cellStyle: row => {
                const rowStyling = {
                    width: "60px",
                    padding: "20px 171px"
                };
                return rowStyling;
            }
        },
        {
            title: "Category",
            field: "timeSheetCategoryId",
            width: "10%",
            render: rowdata => (
                <label>
                    {
                        Category.filter(
                            x =>
                                x.timeSheetCategoryId ==
                                rowdata.timeSheetCategoryId
                        )[0].timeSheetCategoryName
                    }
                </label>
            ),
            editComponent: props => {
                return (
                    <select
                        value={props.value}
                        onChange={e => props.onChange(parseInt(e.target.value))}
                    >
                        <option value="" disabled selected>
                            Select Project
                        </option>
                        {Category.length > 1 &&
                            Category.map(item => (
                                <option
                                    key={item.timeSheetCategoryId}
                                    value={item.timeSheetCategoryId}
                                >
                                    {item.timeSheetCategoryName}
                                </option>
                            ))}
                    </select>
                );
            }
        },
        {
            title: "SubCategory",
            field: "timeSheetSubCategoryId",
            width: "10%",
            //lookup: { 34: "İstanbul", 63: "Şanlıurfa" },
            render: rowdata => (
                <label>
                    {
                        SubCategory.filter(
                            x =>
                                x.timeSheetSubCategoryId ==
                                rowdata.timeSheetSubCategoryId
                        )[0].timeSheetSubcategoryName
                    }
                </label>
            ),
            editComponent: props => {
                return (
                    <select
                        value={props.value}
                        onChange={e => props.onChange(parseInt(e.target.value))}
                    >
                        <option value="" disabled selected>
                            Select Project
                        </option>
                        {SubCategory.length > 1 &&
                            SubCategory.map(item => (
                                <option
                                    key={item.timeSheetSubCategoryId}
                                    value={item.timeSheetSubCategoryId}
                                >
                                    {item.timeSheetSubcategoryName}
                                </option>
                            ))}
                    </select>
                );
            }
        },
        {
            title: "Sun",
            field: "Sun",
            width: "0.5%",
            type: "numeric",
            validate: rowData => rowData.Sun && isHoursValid(rowData.Sun)
            // cellStyle: row => {
            //     const rowStyling = {
            //         padding: "0px 0px"
            //     };
            //     return rowStyling;
            // }
        },
        {
            title: "Mon",
            field: "Mon",
            width: "0.5%",
            type: "numeric",
            validate: rowData => rowData.Mon && isHoursValid(rowData.Mon)
        },
        {
            title: "Tue",
            field: "Tue",
            width: "0.5%",
            type: "numeric",
            validate: rowData => rowData.Tue && isHoursValid(rowData.Tue)
        },
        {
            title: "Wed",
            field: "Wed",
            width: "0.5%",
            type: "numeric",
            cellStyle: row => {
                const rowStyling = {};
                return rowStyling;
            },
            validate: rowData => rowData.Wed && isHoursValid(rowData.Wed)
        },
        {
            title: "Thu",
            field: "Thu",
            width: "0.5%",
            type: "numeric",
            validate: rowData => rowData.Thu && isHoursValid(rowData.Thu)
        },
        {
            title: "Fri",
            field: "Fri",
            width: "0.5%",
            type: "numeric",
            validate: rowData => rowData.Fri && isHoursValid(rowData.Fri)
        },
        {
            title: "Sat",
            field: "Sat",
            width: "0.5%",
            type: "numeric",
            cellStyle: row => {
                const rowStyling = {};
                return rowStyling;
            },
            validate: rowData => rowData.Sat && isHoursValid(rowData.Sat)
        }
    ];
    useEffect(() => {
        fetchTimeSheetEnteries();
    }, []);
    useEffect(() => {
        setData(timesheetEnteries);
    }, [timesheetEnteries]);

    return (
        <Fragment>
            <div style={{ width: "100%" }}>
                <MaterialTable
                    columns={tableColumns}
                    style={css.table}
                    data={data}
                    title="Material Table - Checkbox field  "
                    options={{
                        search: false,
                        actionsColumnIndex: -1,
                        paging: false,
                        draggable: false,
                        // padding: "dense",
                        rowStyle: row => {
                            const rowStyling = {
                                padding: "20px 171px"
                                // fontSize: "12px",
                                // fontFamily: "none"
                            };
                            // if (row.sl % 2) {
                            //     rowStyling.backgroundColor = "#f2f2f2";
                            // }
                            return rowStyling;
                        }
                    }}
                    editable={{
                        onRowAdd: newData =>
                            new Promise((resolve, reject) => {
                                setTimeout(() => {
                                    if (Object.keys(newData).length === 0) {
                                        reject(
                                            new Error(
                                                "Select at least one department."
                                            )
                                        );
                                    } else {
                                        newData = {
                                            ...newData,
                                            id: data.length + 1
                                            // entryDate: "",
                                            // tasktitle: newData.tasktitle || "",
                                            // timeSheetCategoryId:
                                            //     newData.timeSheetCategoryId || "",
                                            // timeSheetSubCategoryId:
                                            //     newData.timeSheetSubCategoryId ||
                                            //     "",
                                            // Mon: newData.Mon || "",
                                            // Sun: newData.Sun || "",
                                            // Tue: newData.Tue || "",
                                            // Wed: newData.Wed || "",
                                            // Thu: newData.Thu || "",
                                            // Fri: newData.Fri || "",
                                            // Sat: newData.Sat || ""
                                        };
                                        setData([...data, newData]);

                                        resolve();
                                    }
                                }, 1000);
                            }),
                        onRowUpdate: (newData, oldData) =>
                            new Promise((resolve, reject) => {
                                setTimeout(() => {
                                    console.log("old data: ", oldData);
                                    console.log("new data: ", newData);
                                    const dataUpdate = [...data];
                                    const index = oldData.tableData.id;
                                    dataUpdate[index] = newData;
                                    setData([...dataUpdate]);
                                    //console.log(data);
                                    resolve();
                                }, 1000);
                            }),
                        onRowDelete: oldData =>
                            new Promise((resolve, reject) => {
                                setTimeout(() => {
                                    const dataDelete = [...data];
                                    const index = oldData.id;
                                    //dataDelete.splice(index, 1);
                                    setData([
                                        ...dataDelete.filter(
                                            x => x.id !== index
                                        )
                                    ]);

                                    resolve();
                                }, 1000);
                            })
                    }}
                />
                <button onClick={handleSaveClick}></button>
            </div>
        </Fragment>
    );
};

export default LandingPage;
