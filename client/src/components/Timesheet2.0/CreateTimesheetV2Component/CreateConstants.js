import TableCell from "@material-ui/core/TableCell";
import TableRow from "@material-ui/core/TableRow";
import React from "react";
import { removeDecimal } from "rootpath/components/Timesheet2.0/EditTimesheetV2Component/EditUtility";
export const newRow = data => {
    return {
        id: data.length + 1,
        projectId: 0,
        taskDescription: "",
        timeSheetCategoryId: 0,
        timeSheetSubCategoryId: 0,
        sun: "",
        mon: "",
        tue: "",
        wed: "",
        thu: "",
        fri: "",
        sat: ""
    };
};

export const tableHeader = showActionColumn => {
    return (
        <TableRow>
            <TableCell style={{ width: "10%", color: "#fff",padding:"6px" }}>
                Project
            </TableCell>
            <TableCell style={{ width: "20%", color: "#fff",padding:"6px" }}>
                Task Description
            </TableCell>
            <TableCell style={{ width: "10%", color: "#fff",padding:"6px" }}>
                Category
            </TableCell>
            <TableCell style={{ width: "20%", color: "#fff",padding:"6px" }}>
                Sub Category
            </TableCell>
            <TableCell style={{ width: "5%", color: "#fff",padding:"6px" }}>Sun</TableCell>
            <TableCell style={{ width: "5%", color: "#fff",padding:"6px" }}>Mon</TableCell>
            <TableCell style={{ width: "5%", color: "#fff",padding:"6px" }}>Tue</TableCell>
            <TableCell style={{ width: "5%", color: "#fff",padding:"6px" }}>Wed</TableCell>
            <TableCell style={{ width: "5%", color: "#fff",padding:"6px" }}>Thu</TableCell>
            <TableCell style={{ width: "5%", color: "#fff",padding:"6px" }}>Fri</TableCell>
            <TableCell style={{ width: "5%", color: "#fff",padding:"6px" }}>Sat</TableCell>
            {showActionColumn && (
                <TableCell style={{ width: "5%", color: "#fff",padding:"6px" }}>
                    Action
                </TableCell>
            )}
        </TableRow>
    );
};
export const tableRowForSum = (daySums, showActionColumn) => {
    return (
        <TableRow
            style={{
                backgroundColor: "#dfdfdf"
            }}
        >
            <TableCell colSpan={4} style={{ fontWeight: "800" }}>
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
            {showActionColumn && <TableCell></TableCell>}
        </TableRow>
    );
};
export const days = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
