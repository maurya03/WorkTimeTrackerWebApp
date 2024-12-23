using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.Timesheet;
using BSIPL.Automation.Domain.Interface;
using BSIPL.Automation.EntityFrameworkCore;
using BSIPL.Automation.Models;
using BSIPL.Automation.Models.SkillsMatrix;
using BSIPL.Automation.Models.Timesheet;
using Dapper;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories.Dapper;
using Volo.Abp.EntityFrameworkCore;

namespace BSIPL.Automation.RepositoryImplementation
{
    public class TimeSheetRepository : DapperRepository<AutomationDbContext>, ITimeSheetRepository
    {
        public TimeSheetRepository(IDbContextProvider<AutomationDbContext> dbContextProvider) : base(dbContextProvider)
        {

        }
        public async Task<int> PostTimeSheetAsync(List<TimesheetEntryItems> timesheetEntryItems, Timesheet timesheet, bool isDeleted)
        {
            var dt = new DataTable();
            dt.Columns.Add("DayOfWeek", typeof(int));
            dt.Columns.Add("HourValue", typeof(decimal));
            dt.Columns.Add("TaskDescription", typeof(string));
            dt.Columns.Add("CategoryId", typeof(int));
            dt.Columns.Add("SubCategoryId", typeof(int));
            dt.Columns.Add("ClientId", typeof(int));
            foreach (var timesheetEntryItem in timesheetEntryItems)
            {
                var row = dt.NewRow();
                row["DayOfWeek"] = timesheetEntryItem.DayOfWeek;
                row["HourValue"] = timesheetEntryItem.HoursWorked;
                row["TaskDescription"] = timesheetEntryItem.TaskDescription;
                row["CategoryId"] = timesheetEntryItem.TimeSheetCategoryID;
                row["SubCategoryId"] = timesheetEntryItem.TimeSheetSubcategoryID;
                row["ClientId"] = timesheetEntryItem.ProjectId;
                dt.Rows.Add(row);
            }
            var dbConnection = await GetDbConnectionAsync();
            var param = new { @HourlyData = dt, @EmailId = timesheet.EmailId, @Remarks = timesheet.Remarks, @StatusID = timesheet.StatusID, @WeekStartDate = timesheet.WeekStartDate.ToString("yyyy-MM-dd"), @WeekEndDate = timesheet.WeekEndDate.ToString("yyyy-MM-dd"), @TimesheetId = timesheet.TimesheetId, @IsDeleted = isDeleted };
            var paramForBehalf = new { @HourlyData = dt, @EmailId = timesheet.EmailId, @Remarks = timesheet.Remarks, @StatusID = timesheet.StatusID, @WeekStartDate = timesheet.WeekStartDate.ToString("yyyy-MM-dd"), @WeekEndDate = timesheet.WeekEndDate.ToString("yyyy-MM-dd"), @OnBehalfTimesheetCreatedFor = timesheet.OnBehalfTimesheetCreatedFor, @OnBehalfTimesheetCreatedByEmail = timesheet.OnBehalfTimesheetCreatedByEmail, @IsDeleted = isDeleted };
            return (await dbConnection.QueryAsync<int>("usp_saveTImesheet",
                timesheet.OnBehalfTimesheetCreatedFor == 0 ? param : paramForBehalf,
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).SingleOrDefault();
        }
        public async Task<int> PostTimeSheetV2Async(List<TimesheetEntryItems> timesheetEntryItems, Timesheet timesheet, List<ClientWiseHoursTotal> clientWiseHoursTotal)
        {
            var hourlyData = new DataTable();
            hourlyData.Columns.Add("DayOfWeek", typeof(int));
            hourlyData.Columns.Add("HourValue", typeof(decimal));
            hourlyData.Columns.Add("TaskDescription", typeof(string));
            hourlyData.Columns.Add("CategoryId", typeof(int));
            hourlyData.Columns.Add("SubCategoryId", typeof(int));
            hourlyData.Columns.Add("ClientId", typeof(int));
            foreach (var timesheetEntryItem in timesheetEntryItems)
            {
                var row = hourlyData.NewRow();
                row["DayOfWeek"] = timesheetEntryItem.DayOfWeek;
                row["HourValue"] = timesheetEntryItem.HoursWorked;
                row["TaskDescription"] = timesheetEntryItem.TaskDescription;
                row["CategoryId"] = timesheetEntryItem.TimeSheetCategoryID;
                row["SubCategoryId"] = timesheetEntryItem.TimeSheetSubcategoryID;
                row["ClientId"] = timesheetEntryItem.ProjectId;
                hourlyData.Rows.Add(row);
            }
            var clientHoursTotal = new DataTable();
            clientHoursTotal.Columns.Add("ClientId", typeof(int));
            clientHoursTotal.Columns.Add("TotalHours", typeof(decimal));
            foreach (var item in clientWiseHoursTotal)
            {
                var row = clientHoursTotal.NewRow();
                row["ClientId"] = item.ProjectId;
                row["TotalHours"] = item.TotalHours;
                clientHoursTotal.Rows.Add(row);
            }

            var dbConnection = await GetDbConnectionAsync();
            var param = new { @ClientHoursTotal = clientHoursTotal, @HourlyData = hourlyData, @EmailId = timesheet.EmailId, @Remarks = timesheet.Remarks, @StatusID = timesheet.StatusID, @WeekStartDate = timesheet.WeekStartDate.ToString("yyyy-MM-dd"), @WeekEndDate = timesheet.WeekEndDate.ToString("yyyy-MM-dd"), @TimesheetId = timesheet.TimesheetId };
            var paramForBehalf = new { @HourlyData = hourlyData, @EmailId = timesheet.EmailId, @Remarks = timesheet.Remarks, @StatusID = timesheet.StatusID, @WeekStartDate = timesheet.WeekStartDate.ToString("yyyy-MM-dd"), @WeekEndDate = timesheet.WeekEndDate.ToString("yyyy-MM-dd"), @OnBehalfTimesheetCreatedFor = timesheet.OnBehalfTimesheetCreatedFor, @OnBehalfTimesheetCreatedByEmail = timesheet.OnBehalfTimesheetCreatedByEmail };
            return (await dbConnection.QueryAsync<int>("usp_saveTimesheetV2",
                timesheet.OnBehalfTimesheetCreatedFor == 0 ? param : paramForBehalf,
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).SingleOrDefault();
        }
        public async Task<IList<ManagerAndApproverEmailsAndOtherFields>> ManagerAndApproverEmailsForEmployeeAsync(IList<EmailAndWeekDomainModel> emailAndWeekList)
        {
            var dt = new DataTable();
            dt.Columns.Add("EmailId", typeof(string));
            dt.Columns.Add("WeekStartDate", typeof(DateTime));
            dt.Columns.Add("WeekEndDate", typeof(DateTime));
            foreach (var emailAndWeek in emailAndWeekList)
            {
                var row = dt.NewRow();
                row["EmailId"] = emailAndWeek.EmailId;
                row["WeekStartDate"] = emailAndWeek.WeekStartDate;
                row["WeekEndDate"] = emailAndWeek.WeekEndDate;
                dt.Rows.Add(row);
            }
            var dbConnection = await GetDbConnectionAsync();
            var data = (await dbConnection.QueryAsync<ManagerAndApproverEmailsAndOtherFields>("usp_getManagerEmails",
                new { @EmailAndWeekList = dt },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
            return data;
        }
        public async Task<IList<TimeSheetListModel>> GetTimeSheetsAsync(int statusId, TimesheetGetDto timesheetDtoObj)
        {
            var dbConnection = await GetDbConnectionAsync();
            var data = (await dbConnection.QueryAsync<TimeSheetListModel>("usp_getTimesheetDataStatusWise",
                new { @StatusID = statusId, @EmailId = timesheetDtoObj.EmailId, @ClientId = timesheetDtoObj.ClientId, @StartDate = timesheetDtoObj.StartDate, @EndDate = timesheetDtoObj.EndDate, @IsApproverPending = timesheetDtoObj.IsApproverPending, @SearchedText = timesheetDtoObj.SearchedText, @SkipRows = timesheetDtoObj.SkipRows,
                    @ShowSelfRecordsToggle = timesheetDtoObj.ShowSelfRecordsToggle},
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
            return data;
        }
        public async Task<IList<string>> EmailListForNotsubmittedTimesheetAsync(DateTime StartDate, DateTime EdDate)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<string>("usp_getEmailForUnsubmittedTimesheet",
            new { @WeekStartDate = StartDate, @WeekEndDate = EdDate },
            commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<IList<string>> SubmitTimeSheeetAndFetchEmailSAsync(DateTime StartDate, DateTime EdDate)
        {
            var dbConnection = await GetDbConnectionAsync();
            var data = (await dbConnection.QueryAsync<string>("usp_submitTimesheetAndGetEmails",
            new { @WeekStartDate = StartDate, @WeekEndDate = EdDate },
            commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
            return data;
        }
        public async Task<IList<TimeSheetDetailListDomainModel>> GetTimeSheetByEntryId(int timesheetId, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimeSheetDetailListDomainModel>("usp_getTimeSheetDetailByTimesheetId",
                new { @TimesheetId = timesheetId, @EmailId = emailId },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<IList<TimeSheetDetailListDomainModel>> GetTimeSheetByDates(TimesheetListByDatesDtoModel timesheetDates, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimeSheetDetailListDomainModel>("usp_getTimeSheetDetailByTimesheetId",
                new { @EmailId = emailId, @TimesheetId = 0, @StartDate = timesheetDates.StartDate, @EndDate = timesheetDates.EndDate },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<IList<TimeSheetDetailWithCreatedTypeListDomainModel>> GetTimeSheetCreatedOnbehalf(TimesheetListByDatesDtoModel timesheetParams, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var result = (await dbConnection.QueryAsync<TimeSheetDetailWithCreatedTypeListDomainModel>("usp_getTimeSheetDetailByTimesheetId",
                new { @EmailId = emailId, @TimesheetId = 0, @StartDate = timesheetParams.StartDate, @EndDate = timesheetParams.EndDate, @IsBehalf = timesheetParams.Isbehalf, @SelectedEmployeeIdForBehalf = timesheetParams.EmpId, @ClientId = timesheetParams.ClientId },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
            if (result.Where(x => x.CreatedBy == "self").Count() > 0)
            {
                throw new InvalidOperationException("Timesheet already created");
            }
            return result;
        }
        public async Task<IList<EmployeeProject>> GetProjectsForEmployeeAsync(string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeProject>("usp_getEmployeeProject",
                new { @EmailId = emailId },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<IList<ClientMasterModel>> GetProjectsForOnBehalfEmployeesAsync(string employeeId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<ClientMasterModel>("usp_getEmployeeProject",
                new { @EmailId = string.Empty, @EmployeeId = employeeId },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<int> UpdateTimeSheetStatusForEmployee(UpdateTimeSheetDomainModel updateTimeSheet, int statusId, string onBehalfEmpId = "")
        {
            var dbConnection = await GetDbConnectionAsync();
            return (dbConnection.Execute("usp_updateTimeSheetStatus",
                new { @StatusId = statusId, @EmployeeEmailId = updateTimeSheet.EmailId, @StartDate = updateTimeSheet.StartDate, @EndDate = updateTimeSheet.EndDate, @OnBehlfEmpId = onBehalfEmpId, @TimesheetId = updateTimeSheet.TimesheetId },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync()));
        }
        public async Task<int> UpdateTimesheetStatusForApprover(TimesheetUpdateStatusDomain updateTimeSheet, int statusId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (dbConnection.Execute("usp_UpdateTimeSheetStatusForApprover",
                new { @StatusId = statusId, @EmpIds = updateTimeSheet.EmployeeIds, @TimesheetIds = updateTimeSheet.TimesheetIds, @Remarks = updateTimeSheet.Remarks, @ApproverEmailId = updateTimeSheet.EmailId },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync()));
        }
        public async Task<IList<TimesheetCategoryDomainModel>> GetCategoryListAsync(string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimesheetCategoryDomainModel>($"exec usp_gettimesheetcategory '{emailId}'",
                transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<IList<TimesheetCategoryDomainModel>> GetCategoryListAsync(string emailId, string employeeId = "")
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimesheetCategoryDomainModel>("usp_getTimesheetCategoryByEmployeeId",
                new { @emailId = emailId, @employeeIdParam = employeeId },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();

        }
        public async Task<TimesheetCategoryDomainModel> GetCategoryByNameAsync(string categoryName)
        {
            var dbConnection = await GetDbConnectionAsync();
            var query = $"SELECT * FROM TimeSheetCategory WHERE TimeSheetCategoryName = '{categoryName}'";
            return await dbConnection.QuerySingleOrDefaultAsync<TimesheetCategoryDomainModel>(query, transaction: await GetDbTransactionAsync());
        }
        public async Task<IList<TimesheetSubCategoryDomainModel>> GetSubCategoryListAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimesheetSubCategoryDomainModel>("SELECT * FROM TimeSheetSubcategory",
                transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<TimesheetSubCategoryDomainModel> GetSubCategoryByNameAsync(string SubcategoryName)
        {
            var dbConnection = await GetDbConnectionAsync();
            var query = $"SELECT * FROM TimeSheetSubcategory WHERE TimeSheetSubcategoryName = '{SubcategoryName}'";
            return await dbConnection.QuerySingleOrDefaultAsync<TimesheetSubCategoryDomainModel>(query, transaction: await GetDbTransactionAsync());
        }
        public async Task<IList<TimesheetSubCategoryDomainModel>> GetTimesheetSubcategoryListAsync(int categoryId)
        {
            var dbConnection = await GetDbConnectionAsync();
            string query = $"SELECT * FROM TimeSheetSubcategory WHERE TimeSheetCategoryID = {categoryId}";
            return (await dbConnection.QueryAsync<TimesheetSubCategoryDomainModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<TimesheetEmployeeDetailsModel>> GetAllEmployeeDetails()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimesheetEmployeeDetailsModel>("GetAllEmployeeIds",
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<TimesheetDeleteEmployeeListModel>> GetAllDeleteEmployeeListAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimesheetDeleteEmployeeListModel>("GetSoftDeleteEmployeeList",
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task HardDeleteEmployeeListAsync(string employeeIds)
        {
            var dbConnection = await GetDbConnectionAsync();
            await dbConnection.QueryAsync($"Exec HardDeleteEmployeeByIds '{employeeIds}'", transaction: await GetDbTransactionAsync());
        }

        public async Task RecoverDeleteEmployeeListAsync(string employeeIds)
        {
            var dbConnection = await GetDbConnectionAsync();
            await dbConnection.QueryAsync($"Exec RecoverDeleteEmployeeByIds '{employeeIds}'", transaction: await GetDbTransactionAsync());
        }
        public async Task<IList<TimesheetCategoryDomainModel>> GetCategoryById(int categoryId)
        {
            var dbConnection = await GetDbConnectionAsync();
            string query = $"SELECT * FROM TimeSheetCategory WHERE TimeSheetCategoryID = {categoryId}";
            return (await dbConnection.QueryAsync<TimesheetCategoryDomainModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<IList<TimesheetEmployeeDomainModel>> GetEmployeeTimesheetsAsync(string emailId, int projectId = 0)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimesheetEmployeeDomainModel>("usp_getTimesheetEmployee",
                new { @EmailId = emailId, @ProjectId = projectId },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task AddCategoryAsync(TimesheetCategoryDomainModel postCategory)
        {
            var dbConnection = await GetDbConnectionAsync();
            var insertQuery = $"INSERT INTO dbo.TimeSheetCategory VALUES ('{postCategory.TimeSheetCategoryName}', '{postCategory.Function}')";
            _ = (await dbConnection.QueryAsync<CategoryMasterModel>(insertQuery,
                transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task AddSubCategoryAsync(TimesheetSubCategoryDomainModel postSubCategory)
        {
            var dbConnection = await GetDbConnectionAsync();
            var insertQuery = $"INSERT INTO dbo.TimeSheetSubcategory VALUES ('{postSubCategory.TimeSheetSubCategoryName} ', '{postSubCategory.TimeSheetCategoryId}')";
            _ = (await dbConnection.QueryAsync<SubCategoryMasterModel>(insertQuery,
            transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task EditCategoryAsync(TimesheetCategoryDomainModel postCategory, int? Id)
        {
            var dbConnection = await GetDbConnectionAsync();
            //postCategory.ModifiedOn = DateTime.Now;
            var updateQuery = $"UPDATE dbo.TimeSheetCategory SET [Function] = '{postCategory.Function}', TimeSheetCategoryName = '{postCategory.TimeSheetCategoryName}' WHERE TimeSheetCategoryID = {Id}";
            await dbConnection.QueryAsync<CategoryMasterModel>(updateQuery,
                transaction: await GetDbTransactionAsync());
        }

        public async Task EditSubCategoryAsync(TimesheetSubCategoryDomainModel subCategory, int? Id)
        {
            var dbConnection = await GetDbConnectionAsync();
            //subCategory.ModifiedOn = DateTime.Now;
            var updateQuery = $"UPDATE dbo.TimeSheetSubcategory SET TimeSheetSubCategoryName = '{subCategory.TimeSheetSubCategoryName}', TimeSheetCategoryID = {subCategory.TimeSheetCategoryId} WHERE TimeSheetSubcategoryID = {Id}";
            await dbConnection.QueryAsync<CategoryMasterModel>(updateQuery,
                transaction: await GetDbTransactionAsync());
        }

        public async Task UpdateEmployeeDetailsAsync(TimesheetEmployeeDetailsModel employeeDetails)
        {
            var dbConnection = await GetDbConnectionAsync();
            _ = await dbConnection.QueryAsync<TimesheetEmployeeDetailsModel>("UpdateTimesheetEmployeeDetail",
                new
                {
                    @EmployeeId = employeeDetails.EmployeeId,
                    @TeamId = employeeDetails.TeamId,
                    @ManagerId = employeeDetails.TimesheetManagerId,
                    @FirstApproverId = employeeDetails.TimesheetApproverId1,
                    @SecondApproverId = employeeDetails.TimesheetApproverId2
                },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync());
        }

        public async Task BulkUpdateEmployeeDetailsAsync(IList<TimesheetEmployeeDetailsModel> bulkEmployeeDetails)
        {
            foreach (var entity in bulkEmployeeDetails)
            {
                var dbConnection = await GetDbConnectionAsync();
                _ = await dbConnection.QueryAsync<TimesheetEmployeeDetailsModel>("UpdateTimesheetEmployeeDetail",
                    new
                    {
                        @EmployeeId = entity.EmployeeId,
                        @TeamId = entity.TeamId,
                        @ManagerId = entity.TimesheetManagerId,
                        @FirstApproverId = entity.TimesheetApproverId1,
                        @SecondApproverId = entity.TimesheetApproverId2
                    },
                    commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync());
            }
        }

        public async Task DeleteCategoryAsync(int Id)
        {
            var dbConnection = await GetDbConnectionAsync();

            var deleteQuery = $"DELETE FROM dbo.TimeSheetSubcategory WHERE TimesheetCategoryID={Id}";
            await dbConnection.QueryAsync(deleteQuery, transaction: await GetDbTransactionAsync());
            deleteQuery = $"DELETE FROM dbo.TimeSheetCategory WHERE TimeSheetCategoryID={Id}";
            await dbConnection.QueryAsync(deleteQuery, transaction: await GetDbTransactionAsync());

        }
        public async Task<TimesheetDetail> GetTimesheetDetailCategory(int Id)
        {
            var dbConnection = await GetDbConnectionAsync();
            var response = await dbConnection.QueryAsync<TimesheetDetail>($"SELECT TOP 1 *FROM TimeSheetDetail Where TimeSheetCategoryId={Id}",
            transaction: await GetDbTransactionAsync());
            var timesheetdetail = response.FirstOrDefault();
            return timesheetdetail;
        }
        public async Task<TimesheetDetail> GetTimesheetDetailSubCategory(int Id)
        {
            var dbConnection = await GetDbConnectionAsync();
            var response = await dbConnection.QueryAsync<TimesheetDetail>($"SELECT TOP 1 *FROM TimeSheetDetail Where TimeSheetSubCategoryId={Id}",
                  transaction: await GetDbTransactionAsync());
            var timesheetdetail = response.FirstOrDefault();
            return timesheetdetail;
        }
        public async Task DeleteSubCategoryAsync(int subCategoryId)
        {
            var dbConnection = await GetDbConnectionAsync();

            var query = $"DELETE FROM dbo.TimeSheetSubcategory WHERE TimeSheetSubcategoryID={subCategoryId}";
            await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());
        }
        public async Task RemoveTimesheetEntryById(string Ids)
        {
            var dbConnection = await GetDbConnectionAsync();
            await dbConnection.QueryAsync<int>("[dbo].[usp_DeleteTimesheetDetails]",
                new
                {
                    @TimesheetIds = Ids
                },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync());

        }
        public async Task<IList<TimesheetCategoryDomainModel>> GetTimesheetCategoryListAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimesheetCategoryDomainModel>("SELECT * FROM TimeSheetCategory",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<TimesheetEmployeeDetailsModel>> GetEmployeeDetailsByTeamIdAsync(int teamId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimesheetEmployeeDetailsModel>("GetEmployeeDetailsByTeamId",
                new { @TeamId = teamId },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<TimesheetApprovalDetail> GetApprovalList(int clientId, int teamId)
        {
            var timeSheetApprovalList = new TimesheetApprovalDetail();
            var dbConnection = await GetDbConnectionAsync();
            var result = await dbConnection.QueryMultipleAsync($"EXEC usp_getemployeeapprovalAssigned {clientId},{teamId} ");
            timeSheetApprovalList.ReportingManagerList = (await result.ReadAsync<TimesheetApproverName>()).ToList();
            timeSheetApprovalList.ApproverId1List = (await result.ReadAsync<TimesheetApproverName>()).ToList();
            timeSheetApprovalList.ApproverId2List = timeSheetApprovalList.ApproverId1List;

            return timeSheetApprovalList;
        }

        public async Task<IList<dynamic>> GetTimesheetSubmissionReportAsync(string EmailId, TimesheetReportModel input)
        {

            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<dynamic>($"EXEC usp_getTimesheetSubmissionReportByClientAndTeam '{EmailId}', '{input.ClientId}', '{input.TeamId}', '{input.StatusId}', '{input.StartDate.ToLocalTime().ToString("MM/dd/yyyy")}', '{input.EndDate.ToLocalTime().ToString("MM/dd/yyyy")}'",
                 transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<TimesheetStatusDomainModel>> GetTimesheetStatusList()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimesheetStatusDomainModel>("SELECT * FROM TimeSheetStatus",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<dynamic>> GetTimesheetDayWiseReportAsync(string EmailId, TimesheetReportModel input)
        {

            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<dynamic>($"EXEC usp_getTimesheetDayWiseReport '{EmailId}', '{input.ClientId}', '{input.TeamId}', '{input.StatusId}', '{input.StartDate.ToLocalTime().ToString("MM/dd/yyyy")}', '{input.EndDate.ToLocalTime().ToString("MM/dd/yyyy")}'",
                 transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<dynamic>> GetTimesheetEmployeeSubmussionReportAsync(string EmailId, TimesheetReportModel input)
        {

            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<dynamic>($"EXEC usp_getTimesheetSubmissionReport '{EmailId}', '{input.ClientId}', '{input.TeamId}', '{input.StatusId}', '{input.StartDate.ToLocalTime().ToString("MM/dd/yyyy")}', '{input.EndDate.ToLocalTime().ToString("MM/dd/yyyy")}'",
                 transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<ClientMasterModel>> GetClients()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<ClientMasterModel>($"EXEC usp_GetAllClients", transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<TimesheetReportDetails> GetTimesheetPDFReport(DateTime startDate, DateTime endDate, int clientId)
        {
            var timesheetReportDetails = new TimesheetReportDetails();
            try
            {

                var dbConnection = await GetDbConnectionAsync();
                var result = await dbConnection.QueryMultipleAsync($"EXEC usp_getTimesheetPdfReport '{startDate}','{endDate}',{clientId} ");
                timesheetReportDetails.TimesheetEffortSummary = (await result.ReadAsync<TimesheetEffortSummary>()).ToList();

                timesheetReportDetails.NonProdTimesheetDetails = (await result.ReadAsync<NonProdTimesheetDetail>()).ToList();
                timesheetReportDetails.TimesheetCategoryWiseEfforts = (await result.ReadAsync<TimesheetCategoryWiseEfforts>()).ToList();

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return timesheetReportDetails;
        }
        public async Task<TimesheetReportDetails> GetTimesheetConsultantReport(DateTime startDate, DateTime endDate, int clientId)
        {
            var timesheetReportDetails = new TimesheetReportDetails();
            try
            {
                var dbConnection = await GetDbConnectionAsync();
                var result = await dbConnection.QueryMultipleAsync($"EXEC usp_getTimesheetConsultantReport '{startDate}','{endDate}',{clientId} ");
                timesheetReportDetails.TimesheetEffortSummary = (await result.ReadAsync<TimesheetEffortSummary>()).ToList();

                timesheetReportDetails.TimesheetCategoryWiseEfforts = (await result.ReadAsync<TimesheetCategoryWiseEfforts>()).ToList();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return timesheetReportDetails;
        }
        public async Task<double> GetAdrenalineLeaves(DateTime startDate, DateTime endDate, int clientId)
        {
            double leaves = 0;
            try
            {
                var dbConnection = await GetDbConnectionAsync();
                var result = await dbConnection.QueryAsync<int>($"EXEC [usp_AdrenalineLeave] '{startDate}','{endDate}',{clientId} ");
                leaves = result.ToList().Count == 0 ? 0 : result.ToList()[0];
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

            return  leaves;
        }
        public async Task<IList<TimesheetSubCategoryWiseEfforts>> GetSubCategoryReport(DateTime startDate, DateTime endDate, int clientId, string Function)
        {

                var dbConnection = await GetDbConnectionAsync();
                return (await dbConnection.QueryAsync<TimesheetSubCategoryWiseEfforts>("[usp_getGandAReport]",
                    new { @StartDate = startDate, @EndDate = endDate, @ClientId = clientId, @Function=Function },
                    commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<IList<TimesheetExcelSummaryDomainModel>> GetTimesheetReportExcel(DateTime startDate, DateTime endDate)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimesheetExcelSummaryDomainModel>("usp_getTimesheetReport_excel",
                new { @StartDate = startDate, @EndDate = endDate },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<ManagerAndApproverDomainModel>> GetManagerAndApproverList(string employeeId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<ManagerAndApproverDomainModel>("usp_GetManagerAndApprover",
                new { @EmployeeId = employeeId },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync())).ToList();
        }
        
        public async Task<IList<TimesheetNotificationDomainModel>> GetTimesheetEmailDataAsync(string emailId, TimesheetNotificationModel emailData)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TimesheetNotificationDomainModel>($"EXEC usp_getTimesheetEmailData '{emailId}', '{emailData.ClientId}', '{emailData.TeamId}', '{emailData.StartDate}', '{emailData.EndDate}','{emailData.IsTimesheetCreated}','{emailData.IsTimesheetSubmitted}'",
                 transaction: await GetDbTransactionAsync())).ToList();
        }
    }
}
