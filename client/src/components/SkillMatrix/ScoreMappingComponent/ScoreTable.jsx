import React from "react";
import MaterialTable from "@material-table/core";
import css from "./ScoreMapping.css";
import { KeyboardArrowDown, KeyboardArrowUp } from "@material-ui/icons";
import {
    handleClientScoreChange,
    handleEmployeeScoreChange
} from "rootpath/services/SkillMatrix/ScoreService/ScoreService.js";

const ScoreCell = ({ value, onIncrease, onDecrease }) => {
    return (
        <div className={css.cell}>
            <span className={css.scoreAlign}>{value}</span>
            <div className={css.buttons}>
                <KeyboardArrowUp onClick={onIncrease} />
                <KeyboardArrowDown
                    className={css.arrowDown}
                    onClick={onDecrease}
                />
            </div>
        </div>
    );
};

const ScoreTable = ({
    params,
    setTableData,
    tableData,
    dataToSave,
    setDataToSave,
    identifier,
    subCategoryMappings,
    setSubCategoryMappings,
    setIsButtonDisable
}) => {
    const getEmployeeScoreColumns = () => {
        if (params.length === 0) {
            return [];
        }

        const columns = [
            {
                title: "SubCategory Name",
                field: "subCategoryName",
                sortable: false,
                cellStyle: {
                    padding: "6px 16px",
                    textOverflow: "ellipsis",
                    overflow: "hidden",
                    whiteSpace: "nowrap"
                }
            },
            {
                title: "Client Expected Score",
                field: "clientExpectedScore",
                sorting: false,
                searchable: false,
                cellStyle: {
                    padding: "6px 16px",
                    textOverflow: "ellipsis",
                    overflow: "hidden",
                    whiteSpace: "nowrap"
                }
            }
        ];

        const employeeNames = new Set();
        params.forEach(row => {
            row.employeeList.forEach(employee => {
                const columnName = employee.employeeName;

                if (!employeeNames.has(columnName)) {
                    employeeNames.add(columnName);
                    const column = {
                        title: columnName,
                        render: row => {
                            const employeeData = row.employeeList.find(
                                e => e.employeeName === columnName
                            );
                            if (employeeData) {
                                return (
                                    <ScoreCell
                                        value={employeeData.employeeScore}
                                        onIncrease={() =>
                                            handleEmployeeScoreChange(
                                                columnName,
                                                row.subCategoryId,
                                                "increase",
                                                tableData,
                                                setTableData,
                                                dataToSave,
                                                setDataToSave,
                                                setIsButtonDisable
                                            )
                                        }
                                        onDecrease={() =>
                                            handleEmployeeScoreChange(
                                                columnName,
                                                row.subCategoryId,
                                                "decrease",
                                                tableData,
                                                setTableData,
                                                dataToSave,
                                                setDataToSave,
                                                setIsButtonDisable
                                            )
                                        }
                                    />
                                );
                            } else {
                                return null;
                            }
                        },
                        ignoreRowClick: true,
                        sorting: false,
                        cellStyle: {
                            padding: "6px 16px",
                            textOverflow: "ellipsis",
                            overflow: "hidden",
                            whiteSpace: "nowrap"
                        },
                        searchable: false
                    };

                    columns.push(column);
                }
            });
        });

        return columns;
    };
    const clientScoreColumns = [
        {
            title: "Sub Category Name",
            field: "subCategoryName",
            cellStyle: {
                padding: "6px 16px",
                textOverflow: "ellipsis",
                overflow: "hidden",
                whiteSpace: "nowrap"
            }
        },
        {
            title: "Expected Score",
            sortable: true,
            sorting: false,
            render: rowData => (
                <ScoreCell
                    value={rowData.clientExpectedScore}
                    onIncrease={() => {
                        handleClientScoreChange(
                            rowData,
                            "increase",
                            subCategoryMappings,
                            setSubCategoryMappings,
                            setIsButtonDisable
                        );
                    }}
                    onDecrease={() =>
                        handleClientScoreChange(
                            rowData,
                            "decrease",
                            subCategoryMappings,
                            setSubCategoryMappings,
                            setIsButtonDisable
                        )
                    }
                />
            ),
            cellStyle: {
                padding: "6px 16px",
                textOverflow: "ellipsis",
                overflow: "hidden",
                whiteSpace: "nowrap"
            }
        }
    ];
    const columns =
        identifier === "employeeScorePage"
            ? getEmployeeScoreColumns()
            : clientScoreColumns;

    return (
        <MaterialTable
            columns={columns}
            data={tableData}
            options={{
                toolbar: true,
                maxBodyHeight: "100%",
                sorting: true,
                thirdSortClick: false,
                search: true,
                pageSize: 20,
                headerStyle: {
                    backgroundColor: "#17072b",
                    color: "#fff"
                },
                showTitle: false,
                draggable: false
                // fixedColumns: {
                //     left: 2,
                //     right: 0,
                //     top: 1
                // }
            }}
            style={{
                height: "100%"
            }}
        />
    );
};

export default ScoreTable;
