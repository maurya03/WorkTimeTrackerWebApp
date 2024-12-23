import TableRow from "@material-ui/core/TableRow";
import TableCell from "@material-ui/core/TableCell";
import React from "react";
import { removeDecimal } from "rootpath/components/Timesheet2.0/EditTimesheetV2Component/EditUtility";
export const detailTableHeader = () => {
    return (
        <TableRow>
            <TableCell style={{ color: "#FFFFFF", width: "20%" }}>
                Task Description
            </TableCell>
            <TableCell style={{ color: "#FFFFFF", width: "10%" }}>
                Category
            </TableCell>
            <TableCell style={{ color: "#FFFFFF", width: "20%" }}>
                Sub Category
            </TableCell>
            <TableCell style={{ color: "#FFFFFF", width: "5%" }}>Sun</TableCell>
            <TableCell style={{ color: "#FFFFFF", width: "5%" }}>Mon</TableCell>
            <TableCell style={{ color: "#FFFFFF", width: "5%" }}>Tue</TableCell>
            <TableCell style={{ color: "#FFFFFF", width: "5%" }}>Wed</TableCell>
            <TableCell style={{ color: "#FFFFFF", width: "5%" }}>Thu</TableCell>
            <TableCell style={{ color: "#FFFFFF", width: "5%" }}>Fri</TableCell>
            <TableCell style={{ color: "#FFFFFF", width: "5%" }}>Sat</TableCell>
        </TableRow>
    );
};
export const tableRowForSum = daySums => {
    return (
        <TableRow
            style={{
                backgroundColor: "#dfdfdf"
            }}
        >
            <TableCell colSpan={3} style={{ fontWeight: "800" }}>
                Total
            </TableCell>
            {days.map(day => {
                return (
                    <>
                        <TableCell style={{ fontWeight: "800" }}>
                            {daySums[day] ? removeDecimal(daySums[day]) : ""}
                        </TableCell>
                    </>
                );
            })}
        </TableRow>
    );
};
export const days = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
