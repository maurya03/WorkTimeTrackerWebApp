import React, { useState, useEffect } from "react";
import MaterialTable from "@material-table/core";
import css from "rootpath/components/Timesheet/DeleteEmployee/DeleteEmployee.css";
import CustomAlert from "rootpath/components/CustomAlert";
import Button from "rootpath/components/SkillMatrix/Button/Button";
const DeleteEmployee = ({
    fetchDeleteEmployeeList,
    deleteEmployeeList,
    hardDeleteEmployeeList,
    recoverDeleteEmployeeList,
    title,
    setShowAlert,
    alert
}) => {
    const [columns, setColumns] = useState([]);
    const [data, setData] = useState([]);
    const [selectedData, setSelectedData] = useState([]);
    useEffect(() => {
        fetchDeleteEmployeeList();
    }, [fetchDeleteEmployeeList]);
    useEffect(() => {
        if (deleteEmployeeList && deleteEmployeeList.length > 0) {
            const columnValue = getColumns(deleteEmployeeList[0]);
            setColumns(columnValue);
            setData(deleteEmployeeList);
        }
    }, [deleteEmployeeList]);
    const getColumns = obj => {
        let columnNames = Object.keys(obj);
        let columns = [];
        let columnObj;

        columnNames.forEach(col => {
            columnObj = {
                title: col.charAt(0).toUpperCase() + col.slice(1),
                field: col,
                sortable: false,
                cellStyle: {
                    padding: "6px 16px",
                    textOverflow: "ellipsis",
                    overflow: "hidden",
                    whiteSpace: "nowrap"
                }
            };
            columns.push(columnObj);
        });

        return columns;
    };
    const onApprove = async () => {
        const list = selectedData.map(item => item.employeeId).join(",");
        if (list.length > 0) {
            const result = await hardDeleteEmployeeList(list);
            fetchDeleteEmployeeList();
            setSelectedData([]);
            if (result.success)
                setShowAlert(
                    true,
                    "success",
                    "Employee details deleted successfully!"
                );
            else setShowAlert(true, "error", "Error deleting employee details");
        }
    };
    const onReject = async () => {
        const list = selectedData.map(item => item.employeeId).join(",");
        if (list.length > 0) {
            const result = await recoverDeleteEmployeeList(list);
            fetchDeleteEmployeeList();
            setSelectedData([]);
            if (result.success)
                setShowAlert(
                    true,
                    "success",
                    "Employee details rejected successfully!"
                );
            else
                setShowAlert(true, "error", "Error rejecting employee details");
        }
    };
    return (
        <div className={css.container}>
            {alert.setAlertOpen && Object.keys(alert).length > 0 && (
                <CustomAlert
                    open={alert.setAlertOpen}
                    severity={alert.severity}
                    message={alert.message}
                    onClose={() => setShowAlert(false, "", "")}
                ></CustomAlert>
            )}
            <div className={css.contentHeader}>
                <div title={`${title}`} className={css.title}>
                    {title}
                </div>
                {selectedData.length > 0 && (
                    <div>
                        <Button
                            className={css.contentHeaderButtons}
                            handleClick={onApprove}
                            value="Approve"
                        />
                        <Button
                            className={css.contentHeaderButtons}
                            handleClick={onReject}
                            value="Reject"
                        />
                    </div>
                )}
            </div>
            <div className={css.table}>
                {deleteEmployeeList.length > 0 ? (
                    <MaterialTable
                        columns={columns}
                        data={data}
                        options={{
                            search: true,
                            toolbar: true,
                            actionsColumnIndex: -1,
                            pageSize: 20,
                            selection: true,
                            paging: true,
                            showSelectAllCheckbox: false,
                            showTextRowsSelected: false,
                            headerStyle: {
                                backgroundColor: "#17072b",
                                color: "#fff"
                            },
                            showEmptyDataSourceMessage: true,
                            showTitle: false,
                            draggable: false
                        }}
                        onSelectionChange={rowData => {
                            setSelectedData(rowData);
                        }}
                    />
                ) : (
                    <div className={css.noRecords}>
                        There are no records to display
                    </div>
                )}
            </div>
        </div>
    );
};

export default DeleteEmployee;
