import React, { useState, useEffect, Fragment } from "react";
import MaterialTable from "@material-table/core";
import {
    getColumns,
    onExport
} from "rootpath/components/SkillMatrix/Reports/Constants";
import css from "rootpath/components/SkillMatrix/Reports/Report.css";
import Stack from "@mui/material/Stack";
import CircularProgress, {
    circularProgressClasses
} from "@mui/material/CircularProgress";
import DownloadIcon from "@mui/icons-material/Download";
import { CSVLink } from "react-csv";

const ReportTable = ({ data, reportType, isLoading }) => {
    const [columns, setColumns] = useState([]);

    useEffect(() => {
        if (data && data.length > 0) {
            const columnValue = getColumns(data[0], reportType);
            setColumns(columnValue);
        }
    }, [data, reportType]);

    if (!isLoading) {
        return (
            <div className={css.table}>
                <MaterialTable
                    columns={columns}
                    data={data}
                    options={{
                        toolbar: true,
                        search: true,
                        maxBodyHeight: "100%",
                        actionsColumnIndex: -1,
                        pageSize: data.length > 0 ? 20 : 5,
                        headerStyle: {
                            backgroundColor: "#17072b",
                            color: "#fff"
                        },
                        draggable: false,
                        showTitle: false,
                        exportButton: true,
                        exportAllData: true
                    }}
                    localization={{
                        body: {
                            emptyDataSourceMessage: (
                                <div className={css.noRecords}>
                                    There are no records to display
                                </div>
                            )
                        }
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
                                    <DownloadIcon />
                                </CSVLink>
                            ),
                            tooltip: "Export Data",
                            isFreeAction: true
                        }
                    ]}
                ></MaterialTable>
            </div>
        );
    } else {
        return (
            <Stack className={css.displayLoading}>
                <CircularProgress
                    variant="indeterminate"
                    disableShrink
                    sx={{
                        animationDuration: "550ms",
                        position: "absolute",
                        [`& .${circularProgressClasses.circle}`]: {
                            strokeLinecap: "round"
                        }
                    }}
                    size={40}
                    thickness={4}
                />
            </Stack>
        );
    }
};

export default ReportTable;
