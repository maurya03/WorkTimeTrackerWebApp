import MaterialTable from "@material-table/core";
import React, {
    useCallback,
    useEffect,
    useLayoutEffect,
    useRef,
    useState
} from "react";
import styles from "rootpath/components/Timesheet/TimesheetListTable/TimesheetListTable.css";
import {
    approve_timesheet,
    approved,
    pending,
    reject_timesheet,
    rejected,
    employee
} from "rootpath/components/Timesheet/Constants";
import { Done, Close } from "@material-ui/icons";
import Checkbox from "@mui/material/Checkbox";
import TimesheetListToolbarContainer from "rootpath/components/Timesheet/TimesheetListToolbar/TimesheetListToolbarContainer";
import DetailPanel from "rootpath/components/Timesheet2.0/DetailPanelComponent/DetailPanel";
const TimesheetListTable = ({
    userRole,
    status,
    approverPending,
    checkboxStatus,
    selectedTimesheetlist,
    data,
    handleTitleCheckboxChange,
    handleCheckboxChange,
    checkboxState,
    isDetailPanel,
    setIsDetailPanel,
    setTimesheetId,
    handleOpen,
    handleSingleTimesheetApproveOrReject,
    remarks,
    fetchTimesheet,
    setSkipRows,
    setSearchedText,
    skipRows,
    loading,
    setLoading,
    showSelfRecordsOnly,
    toggleSelfAndAdminRecords
    // searchedText
}) => {
    const tableEl = useRef();
    const [distanceBottom, setDistanceBottom] = useState(0);
    const [hasMore] = useState(true);
    const [totalTimesheet, setTotalTimesheet] = useState(0);
    // const [loading, setLoading] = useState(false);
    useEffect(() => {
        setTotalTimesheet(data[0]?.totalCount);
    }, [data]);
    const handleSearchChange = async e => {
        setSearchedText(e.target.value);
        await fetchTimesheet(0, e.target.value);

        setSkipRows(0);
    };

    // useEffect(() => {
    //     fetchTimesheet(0);
    // }, [searchedText]);
    const loadMore = async () => {
        setLoading(true);
        const skipRow = skipRows + 10;
        setSkipRows(skipRow);
        await fetchTimesheet(skipRow);
        setLoading(false);
    };
    const scrollListener = useCallback(() => {
        if (totalTimesheet !== data.length) {
            let bottom =
                tableEl.current.tableContainerDiv.current.scrollHeight -
                tableEl.current.tableContainerDiv.current.clientHeight;
            if (!distanceBottom) {
                setDistanceBottom(Math.round(bottom * 0.1));
            }
            if (
                tableEl.current.tableContainerDiv.current.scrollTop >
                    bottom - distanceBottom &&
                hasMore &&
                !loading
            ) {
                loadMore();
            }
        }
    }, [hasMore, loadMore, loading, distanceBottom]);
    useLayoutEffect(() => {
        const tableRef = tableEl.current.tableContainerDiv.current;
        tableRef.addEventListener("scroll", scrollListener);
        return () => {
            tableRef.removeEventListener("scroll", scrollListener);
        };
    }, [scrollListener]);
    const tableActions = [
        // {
        //     icon: () => (
        //         <NavLink
        //             to="/timesheet/detail"
        //             onClick={rowData => setTimesheetId(rowData.timesheetId)}
        //         >
        //             <Visibility className={styles.viewTimesheet} />
        //         </NavLink>
        //     ),
        //     tooltip: "View timesheet",
        //     onClick: (e, rowData) => handleDetail(e, rowData)
        // },
        !(
            userRole.roleName === employee ||
            status !== pending ||
            approverPending
        ) && {
            icon: () => <Done />,
            tooltip: approve_timesheet,
            onClick: (e, rowData) =>
                handleSingleTimesheetApproveOrReject(
                    approved,
                    rowData,
                    data,
                    remarks
                ),
            disabled: selectedTimesheetlist.length > 0
        },
        !(
            userRole.roleName === employee ||
            (showSelfRecordsOnly !== false &&
                (userRole.roleName == "Reporting_Manager" ||
                    userRole.roleName == "Approver" ||
                    userRole.roleName == "HR")) ||
            status === rejected ||
            approverPending
        ) && {
            icon: () => <Close />,
            tooltip: reject_timesheet,
            onClick: (e, rowData) => handleOpen(rowData),
            disabled: selectedTimesheetlist.length > 0
        }
    ];
    const columns = [
        {
            hidden:
                approverPending ||
                (showSelfRecordsOnly == true &&
                    (userRole.roleName == "Reporting_Manager" ||
                        userRole.roleName == "Approver" ||
                        userRole.roleName == "HR")) ||
                userRole.roleName === employee ||
                status === rejected,
            title: (
                <Checkbox
                    checked={checkboxStatus}
                    indeterminate={
                        selectedTimesheetlist.length > 0 &&
                        data.length > 0 &&
                        selectedTimesheetlist.length < data.length
                    }
                    onChange={() =>
                        handleTitleCheckboxChange(
                            selectedTimesheetlist.length > 0
                        )
                    }
                    style={{ padding: "0", marginLeft: "9px", color: "white" }}
                />
            ),
            sorting: false,
            width: "calc(100%-100px)",
            render: rowData => (
                <Checkbox
                    type="checkbox"
                    onChange={() => handleCheckboxChange(rowData.timesheetId)}
                    checked={checkboxState[rowData.timesheetId] || false}
                    id={"checkbox_" + rowData.timesheetId}
                />
            )
        },
        {
            title: "Emp Id",
            field: "employeeId",
            sortable: true,
            width: "calc(100%-20px)",
            searchable: false,
            render: rowData => (
                <div title={rowData.employeeId} className={styles.rowAlign}>
                    {rowData.employeeId}
                </div>
            )
        },
        {
            title: "Client",
            field: "clientName",
            sortable: true,
            width: "calc(100%-20px)",
            searchable: false,
            render: rowData => (
                <div title={rowData.clientName} className={styles.rowAlign}>
                    {rowData.clientName}
                </div>
            )
        },
        {
            title: "Name",
            field: "employeeName",
            width: "calc(100%-20px)",
            sortable: true,
            searchable: true,
            render: rowData => (
                <div title={rowData.employeeName} className={styles.rowEllipse}>
                    {rowData.employeeName}
                </div>
            )
        },
        {
            title: "Total Hours",
            field: "totalHours",
            width: "calc(100%-20px)",
            filtering: false,
            sortable: true,
            render: rowData => (
                <div title={rowData.totalHours} className={styles.rowAlign}>
                    {rowData.totalHours}
                </div>
            )
        },
        {
            title: "Status",
            field: "statusName",
            width: "calc(100%-20px)",
            sortable: true,
            searchable: false,
            render: rowData => (
                <div title={rowData.statusName} className={styles.rowAlign}>
                    {rowData.statusName}
                </div>
            )
        },
        {
            hidden: status !== rejected,
            title: "Remarks",
            field: "remarks",
            width: "calc(100%-20px)",
            filtering: false,
            sortable: true,
            render: rowData => (
                <div title={rowData.remarks} className={styles.rowEllipse}>
                    {rowData.remarks}
                </div>
            )
        },
        {
            title: "Week Start Date",
            field: "weekStartDate",
            width: "calc(100%-20px)",
            sortable: true,
            searchable: false,
            render: rowData =>
                new Date(rowData.weekStartDate).toLocaleDateString("en-gb", {
                    day: "2-digit",
                    month: "short",
                    year: "numeric"
                })
        },
        {
            title: "Week End Date",
            field: "weekEndDate",
            width: "calc(100%-20px)",
            sortable: true,
            searchable: false,
            render: rowData =>
                new Date(rowData.weekEndDate).toLocaleDateString("en-gb", {
                    day: "2-digit",
                    month: "short",
                    year: "numeric"
                })
        },
        status == approved
            ? {
                  title: "Approved On",
                  field: "approvedDate",
                  width: "calc(100%-20px)",
                  sortable: true,
                  searchable: false,
                  render: rowData =>
                      new Date(rowData.approvedDate).toLocaleDateString(
                          "en-gb",
                          {
                              day: "2-digit",
                              month: "short",
                              year: "numeric"
                          }
                      )
              }
            : {
                  title: "Created On",
                  field: "createdDate",
                  width: "calc(100%-20px)",
                  sortable: true,
                  searchable: false,
                  render: rowData =>
                      new Date(rowData.createdDate).toLocaleDateString(
                          "en-gb",
                          {
                              day: "2-digit",
                              month: "short",
                              year: "numeric"
                          }
                      )
              }
    ];
    return (
        <>
            <TimesheetListToolbarContainer
                status={status}
                approverPending={approverPending}
                handleSearchChange={handleSearchChange}
                showSelfRecordsOnly={showSelfRecordsOnly}
                toggleSelfAndAdminRecords={toggleSelfAndAdminRecords}
            />
            <MaterialTable
                key={status}
                tableRef={tableEl}
                isLoading={loading}
                title=""
                columns={columns}
                data={data ? data : []}
                onSearchChange={handleSearchChange}
                options={{
                    emptyRowsWhenPaging: false,
                    searchFieldStyle: {
                        width: 400,
                        position: "relative",
                        right: "20px"
                    },
                    paging: false,
                    maxBodyHeight: "450px",
                    overflow: "hidden",
                    // overflowY: "hidden",
                    // overflowX: "hidden",
                    search:
                        userRole.roleName !== employee &&
                        (status === rejected ||
                            status === approved ||
                            (status === pending && !approverPending)),
                    toolbar: false,
                    actionsColumnIndex: -1,
                    detailPanelType: "single",
                    headerStyle: {
                        backgroundColor: "#17072b",
                        overflow: "hidden",
                        color: "#fff",
                        position: "sticky",
                        top: 0,
                        right: 0,
                        zIndex: 1,
                        // paddingRight: "15px",
                        overflowX: "hidden"
                    },
                    cellStyle: {
                        textOverflow: "ellipsis",
                        whiteSpace: "nowrap",
                        overflow: "hidden",
                        maxWidth: 100
                    },
                    draggable: false
                }}
                actions={tableActions}
                style={{
                    height: "100%",
                    width: "100%"
                }}
                detailPanel={rowData => {
                    //setTimesheetId(rowData.rowData.timesheetId);
                    return (
                        <DetailPanel
                            timeSheetid={rowData.rowData.timesheetId}
                        ></DetailPanel>
                        // <TimesheetDetailsContainer
                        //     isTimesheetDetail={false}
                        //     isDetailPanel={isDetailPanel}
                        //     setIsDetailPanel={setIsDetailPanel}
                        //     panelStartDate={rowData.rowData.weekStartDate}
                        //     panelEndDate={rowData.rowData.weekEndDate}
                        // />
                    );
                }}
                onRowClick={(event, rowData, toggleDetailPanel) =>
                    toggleDetailPanel(3)
                }
            />
        </>
    );
};
export default TimesheetListTable;
