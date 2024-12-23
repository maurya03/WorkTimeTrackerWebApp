import React, { useState, useEffect, useRef, useMemo } from "react";
import MaterialTable from "@material-table/core";
import Box from "@mui/material/Box";
import {
    createTimesheetColumns,
    tableOptions
} from "rootpath/components/Timesheet2.0/CreateTimesheetComponent/CreateTimesheetColumns";
import { tableActions } from "rootpath/components/Timesheet2.0/CreateTimesheetComponent/CreateTimesheetActions";
import {
    AddNewRow,
    GetFilteredSubcategories
} from "rootpath/services/Timesheet2.0/TimesheetService";
import ViewToolbar from "rootpath/components/Timesheet2.0/Common/Toolbar";
import css from "rootpath/components/Timesheet2.0/CreateTimesheetComponent/CreateTimesheet.css";

const CreateTimesheet = ({
    timesheetCategories,
    timesheetSubCategories,
    employeeProject,
    fetchEmployeeProject,
    fetchTimesheetCategory,
    fetchTimesheetSubCategory,
    fetchTimesheetWeekDate,
    startDate,
    endDate
}) => {
    const [selectedWeek, setSelectedWeek] = useState("");
    const dataCopy = useRef([]);
    const [data, setData] = useState([]);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        fetchEmployeeProject();
        fetchTimesheetCategory();
        fetchTimesheetSubCategory();
        fetchTimesheetWeekDate();
    }, [
        fetchEmployeeProject,
        fetchTimesheetCategory,
        fetchTimesheetSubCategory,
        fetchTimesheetWeekDate
    ]);
    useEffect(() => {
        if (
            timesheetCategories.length &&
            timesheetSubCategories.length &&
            employeeProject.length
        ) {
            setIsLoading(false);
        }
    }, [timesheetCategories, timesheetSubCategories, employeeProject]);
    useEffect(() => {
        if (!isLoading) {
            const allRows = AddNewRow(
                employeeProject,
                timesheetCategories,
                timesheetSubCategories,
                data
            );
            setData(allRows);
            setSelectedWeek(`${startDate} ${endDate}`);
            dataCopy.current = allRows;
        }
    }, [isLoading]);
    const columnValues = useMemo(
        () =>
            createTimesheetColumns(
                employeeProject,
                timesheetCategories,
                timesheetSubCategories,
                GetFilteredSubcategories,
                setData,
                dataCopy
            ),
        [timesheetCategories, timesheetSubCategories, employeeProject]
    );
    const tableAction = useMemo(
        () =>
            tableActions(
                setData,
                dataCopy,
                employeeProject,
                timesheetCategories,
                timesheetSubCategories,
                startDate,
                endDate
            ),
        [setData, dataCopy.current]
    );
    return isLoading ? (
        <div>Loading...</div>
    ) : (
        <div className={css.table}>
            <Box className={css.header}>Create Timesheet</Box>
            <MaterialTable
                columns={columnValues}
                data={data}
                options={tableOptions}
                actions={tableAction}
                components={{
                    Toolbar: props => (
                        <ViewToolbar
                            toolbarProps={props}
                            selectedWeek={selectedWeek}
                        />
                    )
                }}
            />
        </div>
    );
};
export default CreateTimesheet;
