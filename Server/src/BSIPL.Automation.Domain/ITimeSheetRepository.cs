using BSIPL.Automation.ApplicationModels.Timesheet;
using BSIPL.Automation.Models;
using BSIPL.Automation.Models.SkillsMatrix;
using BSIPL.Automation.Models.Timesheet;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories;

namespace BSIPL.Automation.Domain.Interface
{
    public interface ITimeSheetRepository : IRepository
    {
        Task<int> PostTimeSheetAsync(List<TimesheetEntryItems> timesheetEntryItems, Timesheet timesheet, bool isDeleted);
        Task<int> PostTimeSheetV2Async(List<TimesheetEntryItems> timesheetEntryItems, Timesheet timesheet, List<ClientWiseHoursTotal> clientWiseHoursTotal);
        Task<IList<TimeSheetListModel>> GetTimeSheetsAsync(int statusId, TimesheetGetDto timesheetDtoObj);
        Task<IList<TimeSheetDetailListDomainModel>> GetTimeSheetByEntryId(int entryId, string emailId);
        Task<IList<TimeSheetDetailListDomainModel>> GetTimeSheetByDates(TimesheetListByDatesDtoModel timesheetDates, string emailId);
        Task<IList<TimeSheetDetailWithCreatedTypeListDomainModel>> GetTimeSheetCreatedOnbehalf(TimesheetListByDatesDtoModel timesheetParams, string emailId);
        Task<int> UpdateTimeSheetStatusForEmployee(UpdateTimeSheetDomainModel updateTimeSheet, int statusId, string onBehalfEmpId = "");
        Task<int> UpdateTimesheetStatusForApprover(TimesheetUpdateStatusDomain updateTimeSheet, int statusId);
        Task<IList<EmployeeProject>> GetProjectsForEmployeeAsync(string emailId);
        Task<IList<TimesheetCategoryDomainModel>> GetCategoryListAsync(string emailId);
        Task<IList<TimesheetCategoryDomainModel>> GetCategoryListAsync(string emailId, string employeeId = "");
        Task<TimesheetCategoryDomainModel> GetCategoryByNameAsync(string categoryName);
        Task<TimesheetSubCategoryDomainModel> GetSubCategoryByNameAsync(string SubcategoryName);
        Task AddCategoryAsync(TimesheetCategoryDomainModel postCategory);
        Task<IList<TimesheetSubCategoryDomainModel>> GetSubCategoryListAsync();
        Task AddSubCategoryAsync(TimesheetSubCategoryDomainModel postSubCategory);
        Task EditCategoryAsync(TimesheetCategoryDomainModel editCategory, int? Id);
        Task EditSubCategoryAsync(TimesheetSubCategoryDomainModel subCategory, int? Id);
        Task DeleteCategoryAsync(int Id);
        Task DeleteSubCategoryAsync(int subCategoryId);
        Task RemoveTimesheetEntryById(string Ids);
        Task<IList<TimesheetSubCategoryDomainModel>> GetTimesheetSubcategoryListAsync(int categoryId);
        Task<IList<TimesheetEmployeeDetailsModel>> GetAllEmployeeDetails();
        Task<IList<TimesheetDeleteEmployeeListModel>> GetAllDeleteEmployeeListAsync();
        Task HardDeleteEmployeeListAsync(string employeeIds);
        Task RecoverDeleteEmployeeListAsync(string employeeIds);
        Task<IList<TimesheetCategoryDomainModel>> GetCategoryById(int categoryId);
        Task<IList<TimesheetEmployeeDomainModel>> GetEmployeeTimesheetsAsync(string emailId, int projectId = 0);
        Task<IList<ClientMasterModel>> GetProjectsForOnBehalfEmployeesAsync(string employeeId);
        Task UpdateEmployeeDetailsAsync(TimesheetEmployeeDetailsModel employeeDetails);
        Task BulkUpdateEmployeeDetailsAsync(IList<TimesheetEmployeeDetailsModel> bulkEmployeeDetails);
        Task<IList<ManagerAndApproverEmailsAndOtherFields>> ManagerAndApproverEmailsForEmployeeAsync(IList<EmailAndWeekDomainModel> emailAndWeekList);
        Task<IList<string>> EmailListForNotsubmittedTimesheetAsync(DateTime StartDate, DateTime EdDate);
        Task<IList<string>> SubmitTimeSheeetAndFetchEmailSAsync(DateTime StartDate, DateTime EdDate);
        Task<TimesheetDetail> GetTimesheetDetailCategory(int Id);
        Task<TimesheetDetail> GetTimesheetDetailSubCategory(int Id);
        Task<IList<TimesheetCategoryDomainModel>> GetTimesheetCategoryListAsync();
        Task<IList<TimesheetEmployeeDetailsModel>> GetEmployeeDetailsByTeamIdAsync(int teamIds);
        Task<TimesheetApprovalDetail> GetApprovalList(int clientId, int teamId);
        Task<IList<dynamic>> GetTimesheetSubmissionReportAsync(string EmailId, TimesheetReportModel input);
        Task<IList<TimesheetStatusDomainModel>> GetTimesheetStatusList();
        Task<IList<dynamic>> GetTimesheetDayWiseReportAsync(string EmailId, TimesheetReportModel input);
        Task<IList<dynamic>> GetTimesheetEmployeeSubmussionReportAsync(string EmailId, TimesheetReportModel input);
        Task<IList<ClientMasterModel>> GetClients();
        Task<IList<TimesheetExcelSummaryDomainModel>> GetTimesheetReportExcel(DateTime startDate, DateTime endDate);
        Task<TimesheetReportDetails> GetTimesheetPDFReport(DateTime startDate, DateTime endDate, int clientId);
        Task<TimesheetReportDetails> GetTimesheetConsultantReport(DateTime startDate, DateTime endDate, int clientId);
        Task<double> GetAdrenalineLeaves(DateTime startDate, DateTime endDate, int clientId);
        Task<IList<TimesheetSubCategoryWiseEfforts>> GetSubCategoryReport(DateTime startDate, DateTime endDate, int clientId, string Function);
        Task<IList<ManagerAndApproverDomainModel>> GetManagerAndApproverList(string employeeId);
        Task<IList<TimesheetNotificationDomainModel>> GetTimesheetEmailDataAsync(string emailId, TimesheetNotificationModel input);
    }
}