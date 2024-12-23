using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.ApplicationModels.Timesheet;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;

namespace BSIPL.Automation.Contracts.Interface
{
    public interface ITimeSheetService : IApplicationService
    {
        Task<int> AddTimeSheetEntry(TimesheetDto timesheetEntryDtoObj, bool isDeleted);
        Task<TimesheetViewDetailsDtoModel> CreateTimesheet(CreateTimesheetDtoModel createDtoData);
        Task<TimesheetViewDetailsDtoModel> CreateTimesheetV2(CreateTimesheetDtoModel createDtoData);
        Task<IList<TimeSheetListDtoModel>> GetTimeSheetsAsync(int statusId, TimesheetGetDto timesheetDtoObj);
        Task<IList<TimeSheetDetailListDtoModel>> GetTimeSheetByEntryId(int timesheetId);
        Task<IList<TimeSheetDetailListDtoModel>> GetTimeSheetByDates(TimesheetListByDatesDtoModel timesheetDates);
        Task<TimesheetViewDetailsDtoModel> ViewTimesheetByDates(TimesheetListByDatesDtoModel timesheetDates);
        Task<IList<TimeSheetDetailWithCreatedTypeListDtoModel>> GetTimeSheetCreatedOnbehalf(TimesheetListByDatesDtoModel timesheetDates);
        Task<int> UpdateTimesheetStatusForApprover(TimesheetUpdateStatusDtoModel timesheetDetails, int statusId);
        Task<int> UpdateTimeSheetStatusForEmployee(UpdateTimeSheetDtoModel updateTimeSheet, int statusId, string onBehalfEmpId = "");
        Task<IList<EmployeeProjectDtoModel>> GetProjectsForEmployeeAsync(string emailId);
        Task<IList<TimesheetCategoryDtoModel>> GetCategoryListAsync();
        Task<IList<TimesheetCategoryDtoModel>> GetCategoryListAsync(string employeeId = "");
        Task<IList<TimesheetSubCategoryDtoModel>> GetSubCategoryListAsync();
        Task<IList<TimesheetEmployeeDtoModel>> GetEmployeeTimesheetsAsync(int projectId = 0);
        Task<IList<TimesheetSubCategoryDtoModel>> GetTimesheetSubcategoryListAsync(int categoryId);
        Task<IList<TimesheetCategoryDtoModel>> GetCategoryById(int categoryId);
        Task AddCategoryAsync(TimesheetCategoryDtoModel postCategory);
        Task AddSubCategoryAsync(TimesheetSubCategoryDtoModel postSubCategory);
        Task EditCategoryAsync(TimesheetCategoryDtoModel Category, int? id);
        Task EditSubCategoryAsync(TimesheetSubCategoryDtoModel subCategory, int? Id);
        Task DeleteCategoryAsync(int Id);
        Task RemoveTimesheetEntryById(string Ids);
        Task DeleteSubCategoryAsync(int subCategoryId);
        Task<IList<ClientMasterApplicationContractsModel>> GetProjectsForOnBehalfEmployeesAsync(string employeeId);
        Task<TimesheetCategoryDtoModel> GetCategoryByNameAsync(TimesheetCategoryDtoModel postCategory);
        Task<TimesheetSubCategoryDtoModel> GetSubCategoryByNameAsync(TimesheetSubCategoryDtoModel postSubCategory);
        Task UpdateEmployeeDetailsAsync(TimesheetEmployeeDetailsDtoModel employeeDetails);
        Task<IList<TimesheetEmployeeDetailsDtoModel>> GetAllEmployeeDetails();
        Task<IList<TimesheetDeleteEmployeeListDtoModel>> GetAllDeleteEmployeeListAsync();
        Task HardDeleteEmployeeListAsync(string employeeList);
        Task RecoverDeleteEmployeeListAsync(string employeeList);
        Task BulkUpdateEmployeeDetailsAsync(IList<TimesheetEmployeeDetailsDtoModel> bulkEmployeeDetails);
        Task SendStatusEmail(IList<EmailAndWeekDto> emailAndWeekListDto);
        Task SendEmailReminderForTimesheetAsync();
        Task SubmitTimeSheeetAndFetchEmailSAsync();
        Task<TimesheetViewDetailsDtoModel> ViewTimesheetById(int timesheetId);
        Task<TimesheetDetail> GetTimesheetDetailCategory(int Id);
        Task<TimesheetDetail> GetTimesheetDetailSubCategory(int Id);
        Task<IList<TimesheetCategoryDtoModel>> GetTimesheetCategoryListAsync();
        Task<IList<TimesheetEmployeeDetailsDtoModel>> GetEmployeeDetailsByTeamIdAsync(int teamId);
        Task<TimesheetApproval> GetApprovalList(int clientId, int teamId);
        Task<IList<dynamic>> GetTimesheetReportAsync(string EmailId, TimesheetReportModel input);
        Task<IList<TimesheetStatusDtoModel>> GetTimesheetStatusesAsync();
        Task<byte[]> GetTimesheetWeeklyReport(DateTime? sDate=null, DateTime? eDate=null, bool isPdfButtonClick = false, bool isExcelButtonClick = false);
        Task GetTimesheetMonthlyReport();
        Task<IList<ManagerAndApproverDtoModel>> GetManagerAndApproverAsync(string employeeId);
        Task<IList<TimesheetNotificationDomainModel>> GetTimesheetEmailDataAsync(string emailId, TimesheetNotificationModel emailData);
        Task SendEmailNotificationAsync(EmailNotificationModel emailData);
    }
}