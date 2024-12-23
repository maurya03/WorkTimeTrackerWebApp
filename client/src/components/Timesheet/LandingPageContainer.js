import LandingPage from "./LandingPage";
import { connect } from "react-redux";
import { useState } from "react";
import { timeSheetEntryByIdApi, postTimeSheetApi } from "./LandingPageFunction";
import { setTimeSheetEnteries } from "../../redux/common/actions";
const mapStateToProps = state => ({
    timesheetEnteries: state.timeSheetOps.timeSheetEnteries
});

const mapDispatchToProps = dispatch => {
    const groupBy = (array, groupKeys) => {
        return array.reduce((result, currentItem) => {
            const groupKey = groupKeys.map(key => currentItem[key]);
            const groupKeyString = groupKey.join("");
            result[groupKeyString] = result[groupKeyString] || {
                groupKey,
                rows: []
            };
            const internalRow = {};
            for (const key in currentItem) {
                if (!groupKeys.includes(key)) {
                    internalRow[key] = currentItem[key];
                }
            }
            result[groupKeyString].rows.push(internalRow);
            return result;
        }, {});
    };
    const weekData = [
        { 1: "Sun" },
        { 2: "Mon" },
        { 3: "Tue" },
        { 4: "Wed" },
        { 5: "Thu" },
        { 6: "Fri" },
        { 7: "Sat" }
    ];
    return {
        fetchTimeSheetEnteries: async () => {
            let dayOfWeekMapping = [];
            const enteries = await timeSheetEntryByIdApi(6);
            const enteriesGrouped = groupBy(enteries, [
                "tasktitle",
                "timeSheetCategoryId",
                "timeSheetSubCategoryId"
            ]);
            Object.values(enteriesGrouped) &&
                Object.values(enteriesGrouped).map(row => {
                    let eachData = {};
                    eachData.tasktitle = row.groupKey[0];
                    eachData.timeSheetCategoryId = row.groupKey[1];
                    eachData.timeSheetSubCategoryId = row.groupKey[2];
                    row.rows.map(item => {
                        eachData.projectId = item.projectId;
                        eachData[
                            Object.values(weekData[item.dayOfWeek - 1])[0]
                        ] = item.hoursWorked;
                        weekData.map(day => {
                            if (Object.keys(day)[0] == item.dayOfWeek) {
                                eachData[day[item.dayOfWeek]] =
                                    item.hoursWorked?.toString();
                            }
                        });
                    });
                    dayOfWeekMapping = [...dayOfWeekMapping, eachData];
                });
            const tableData = dayOfWeekMapping.map((row, index) => ({
                ...row,
                id: index
            }));
            dispatch(setTimeSheetEnteries(tableData));
        },
        postTimeSheetApi: async enteries => {
            const checkList = Object.values(weekData);
            let totalHours = 0;
            let hourlyData = [];
            let toPost = {};
            enteries.map(row => {
                checkList.map(item => {
                    if (row[item[Object.keys(item)[0]]]) {
                        let eachData = {};
                        eachData.DayOfWeek = Object.keys(item)[0];
                        eachData.HoursWorked = parseFloat(
                            row[item[Object.keys(item)[0]]]
                        );
                        eachData.TaskTitle = row.tasktitle;
                        eachData.TimeSheetCategoryID = row.timeSheetCategoryId;
                        eachData.TimeSheetSubCategoryID =
                            row.timeSheetSubCategoryId;
                        eachData.ProjectId = row.projectId;
                        totalHours += parseFloat(
                            row[item[Object.keys(item)[0]]]
                        );
                        hourlyData = [...hourlyData, eachData];
                    }
                });
            });
            toPost.HourlyData = hourlyData;
            toPost.TotalHours = totalHours;
            toPost.Weeknumber = 8;
            toPost.EntryYear = 2024;
            toPost.StatusId = 1;
            toPost.Remarks = "asas";
            await postTimeSheetApi(toPost);
        }
    };
};

const LandingPageContainer = connect(
    mapStateToProps,
    mapDispatchToProps
)(LandingPage);
export default LandingPageContainer;
