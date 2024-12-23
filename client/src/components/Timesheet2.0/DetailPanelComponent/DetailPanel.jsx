import React, { useEffect, useState } from "react";
import styles from "rootpath/components/Timesheet2.0/ViewTimesheetComponent/ViewTimesheet.css";
import { calculateDaySums } from "rootpath/services/Timesheet2.0/TimesheetService";
import { getTimesheetById } from "rootpath/services/Timesheet2.0/ViewTimesheetService";
import {
    detailTableHeader,
    tableRowForSum,
    days
} from "rootpath/components/Timesheet2.0/DetailPanelComponent/Constants";
import {
    Table,
    TableBody,
    TableCell,
    TableContainer,
    TableHead,
    TableRow
} from "@material-ui/core";
import Paper from "@mui/material/Paper";
import { removeDecimal } from "rootpath/components/Timesheet2.0/EditTimesheetV2Component/EditUtility";
const DetailPanel = ({ timeSheetid }) => {
    const [data, setData] = useState([]);
    useEffect(() => {
        getTimesheetDetail();
    }, [timeSheetid]);
    const getTimesheetDetail = async () => {
        const res = await getTimesheetById(timeSheetid);
        setData(res.timesheetData);
    };
    const daySums = calculateDaySums(data);
    return (
        <>
            <div className={styles.table}>
                <TableContainer component={Paper}>
                    <Table>
                        <TableHead style={{ backgroundColor: "#17072B" }}>
                            {detailTableHeader()}
                        </TableHead>
                        <TableBody>
                            {data?.map((row, index) => (
                                <TableRow key={row.id}>
                                    <TableCell>{row.taskDescription}</TableCell>
                                    <TableCell>{row.categoryName}</TableCell>
                                    <TableCell>{row.subCategoryName}</TableCell>
                                    {days.map(day => {
                                        return (
                                            <TableCell>
                                                {row[day] &&
                                                    removeDecimal(row[day])}
                                            </TableCell>
                                        );
                                    })}
                                </TableRow>
                            ))}{" "}
                            {data.length > 0 && tableRowForSum(daySums)}
                        </TableBody>
                    </Table>
                </TableContainer>
            </div>
        </>
    );
};
export default DetailPanel;
