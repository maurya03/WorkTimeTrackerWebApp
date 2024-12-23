import React, { useState, useEffect } from "react";
import MaterialTable from "@material-table/core";
import {
    getColumns,
    onExport
} from "rootpath/components/Timesheet/TimesheetReports/Constants";
import css from "rootpath/components/Timesheet/TimesheetReports/Report.css";
import DownloadIcon from "@mui/icons-material/Download";
import { CSVLink } from "react-csv";

const ReportTable = ({ data, reportType }) => {
    const [columns, setColumns] = useState([]);

    useEffect(() => {
        if (data.length > 0) {
            const columnValue = getColumns(data[0]);
            setColumns(columnValue);
        }
    }, [data, reportType]);

    if (data.length > 0) {
        return (
            <MaterialTable
                columns={columns}
                data={data}
                options={{
                    toolbar: true,
                    maxBodyHeight: "100%",
                    thirdSortClick: false,
                    search: true,
                    pageSize: 20,
                    headerStyle: {
                        backgroundColor: "#17072b",
                        color: "#ffff"
                    },
                    showTitle: false,
                    exportButton: true,
                    exportAllData: true,
                    draggable: false
                }}
                style={{
                    height: "100%"
                }}
                actions={[
                    {
                        icon: () => (
                            <CSVLink
                                data={onExport(data, columns, reportType)}
                                filename={reportType + ".csv"}
                            >
                                <DownloadIcon
                                    style={{ color: "rgba(23, 7, 43)" }}
                                />
                            </CSVLink>
                        ),
                        tooltip: "Export Data",
                        isFreeAction: true
                    }
                ]}
            />
        );
    } else {
        return (
            <div className={css.noRecords}>There are no records to display</div>
        );
    }
};

export default ReportTable;
