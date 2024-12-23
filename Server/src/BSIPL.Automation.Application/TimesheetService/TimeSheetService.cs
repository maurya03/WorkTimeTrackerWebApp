using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.ApplicationModels.Timesheet;
using BSIPL.Automation.Contracts.Interface;
using BSIPL.Automation.Domain.Interface;
using BSIPL.Automation.Domain.Shared.Enums;
using BSIPL.Automation.EntityFrameworkCore;
using BSIPL.Automation.Models;
using BSIPL.Automation.Models.SkillsMatrix;
using BSIPL.Automation.Models.Timesheet;
using BSIPL.Automation.ScheduledTaskServiceInterface;
using BSIPL.Automation.ServiceInterface.Validation;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Volo.Abp.ObjectMapping;


namespace BSIPL.Automation.ServiceImplementation
{
    public class TimeSheetService : ITimeSheetService
    {
        private readonly ITimeSheetRepository _timeSheetRepository;
        private readonly IScheduledTaskService _scheduledTaskService;
        public IObjectMapper<AutomationEntityFrameworkCoreModule> _objectMapper { get; }
        public IHttpContextAccessor _contextAccessor;
        public readonly string StatusType = "submitted";
        public TimeSheetService(ITimeSheetRepository timeSheetRepository, IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper, IHttpContextAccessor contextAccessor, IScheduledTaskService scheduledTaskService)
        {
            _timeSheetRepository = timeSheetRepository;
            _objectMapper = objectMapper;
            _contextAccessor = contextAccessor;
            _scheduledTaskService = scheduledTaskService;
        }

        public async Task<int> AddTimeSheetEntry(TimesheetDto timesheetEntryDtoObj, bool isDeleted)
        {
            var mapEditTeamEmployees = _objectMapper.Map<TimesheetDto, Timesheet>(timesheetEntryDtoObj);
            var hourlyData = _objectMapper.Map<List<TimesheetDetail>, List<TimesheetEntryItems>>(timesheetEntryDtoObj.HourlyData);
            mapEditTeamEmployees.EmailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            if (!timesheetEntryDtoObj.OnBehalfTimesheetCreatedFor.Equals(0))
            {
                var emailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
                mapEditTeamEmployees.OnBehalfTimesheetCreatedByEmail = emailId;
            }
            var timesheetId = await _timeSheetRepository.PostTimeSheetAsync(hourlyData, mapEditTeamEmployees, isDeleted);
            //var entriesDto = _objectMapper.Map<IList<TimeSheetDetailListDomainModel>, IList<TimeSheetDetailListDtoModel>>(entries);
            return timesheetId;
        }
        public async Task<TimesheetViewDetailsDtoModel> CreateTimesheet(CreateTimesheetDtoModel createDtoData)
        {
            var timesheetItems = _objectMapper.Map<CreateTimesheetDtoModel, Timesheet>(createDtoData);
            var timesheetDetails = new List<TimesheetDetail>();
            foreach (var timesheetRow in createDtoData.TaskRows)
            {
                var taskList = _objectMapper.Map<TimesheetTaskDtoModel, List<TimesheetDetail>>(timesheetRow);
                timesheetDetails.AddRange(taskList);
            }
            timesheetItems.EmailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            timesheetItems.WeekStartDate = createDtoData.WeekStartDate;
            timesheetItems.WeekEndDate = createDtoData.WeekEndDate;
            timesheetItems.StatusID = (int)(TimeSheetStatuses.Draft);
            var hourlyData = _objectMapper.Map<List<TimesheetDetail>, List<TimesheetEntryItems>>(timesheetDetails);
            await _timeSheetRepository.PostTimeSheetAsync(hourlyData, timesheetItems, false);

            TimesheetListByDatesDtoModel timesheetDates = new() { StartDate = createDtoData.WeekStartDate, EndDate = createDtoData.WeekEndDate };
            return await ViewTimesheetByDates(timesheetDates);
        }
        public async Task<TimesheetViewDetailsDtoModel> CreateTimesheetV2(CreateTimesheetDtoModel createDtoData)
        {
            var timesheetItems = _objectMapper.Map<CreateTimesheetDtoModel, Timesheet>(createDtoData);
            var clientWiseHoursTotal = _objectMapper.Map<List<ClientWiseHoursTotalDto>, List<ClientWiseHoursTotal>>(createDtoData.ClientWiseHoursTotal);
            var timesheetDetails = new List<TimesheetDetail>();
            var clientHours = new List<ClientWiseHoursTotal>();
            foreach (var timesheetRow in createDtoData.TaskRows)
            {
                var taskList = _objectMapper.Map<TimesheetTaskDtoModel, List<TimesheetDetail>>(timesheetRow);
                timesheetDetails.AddRange(taskList);
            }
            timesheetItems.EmailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            timesheetItems.WeekStartDate = createDtoData.WeekStartDate;
            timesheetItems.WeekEndDate = createDtoData.WeekEndDate;
            timesheetItems.StatusID = createDtoData.StatusId;
            var hourlyData = _objectMapper.Map<List<TimesheetDetail>, List<TimesheetEntryItems>>(timesheetDetails);
            await _timeSheetRepository.PostTimeSheetV2Async(hourlyData, timesheetItems, clientWiseHoursTotal);

            TimesheetListByDatesDtoModel timesheetDates = new() { StartDate = createDtoData.WeekStartDate, EndDate = createDtoData.WeekEndDate };
            return await ViewTimesheetByDates(timesheetDates);
        }
        public async Task<IList<TimeSheetListDtoModel>> GetTimeSheetsAsync(int statusId, TimesheetGetDto timesheetDtoObj)
        {
            timesheetDtoObj.EmailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            var entries = await _timeSheetRepository.GetTimeSheetsAsync(statusId, timesheetDtoObj);
            var entriesDto = _objectMapper.Map<IList<TimeSheetListModel>, IList<TimeSheetListDtoModel>>(entries);
            return entriesDto.ToList();
        }
        public async Task<IList<TimeSheetDetailListDtoModel>> GetTimeSheetByEntryId(int timesheetId)
        {
            var emailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            var entries = await _timeSheetRepository.GetTimeSheetByEntryId(timesheetId, emailId);
            var entriesDto = _objectMapper.Map<IList<TimeSheetDetailListDomainModel>, IList<TimeSheetDetailListDtoModel>>(entries);
            return entriesDto.ToList();
        }
        public async Task<IList<TimeSheetDetailListDtoModel>> GetTimeSheetByDates(TimesheetListByDatesDtoModel timesheetDates)
        {
            var emailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            var entries = await _timeSheetRepository.GetTimeSheetByDates(timesheetDates, emailId);
            var entriesDto = _objectMapper.Map<IList<TimeSheetDetailListDomainModel>, IList<TimeSheetDetailListDtoModel>>(entries);
            return entriesDto.ToList();
        }
        public async Task<TimesheetViewDetailsDtoModel> ViewTimesheetByDates(TimesheetListByDatesDtoModel timesheetDates)
        {
            TimesheetViewDetailsDtoModel response = new TimesheetViewDetailsDtoModel();
            IList<TimesheetViewListDtoModel> timesheetDetails = new List<TimesheetViewListDtoModel>();
            var emailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            var timesheetData = await _timeSheetRepository.GetTimeSheetByDates(timesheetDates, emailId);
            MapTimesheetDetail(response, timesheetDetails, timesheetData);
            response.timesheetData = timesheetDetails;
            return response;
        }
        public async Task<TimesheetViewDetailsDtoModel> ViewTimesheetById(int timesheetId)
        {
            TimesheetViewDetailsDtoModel response = new TimesheetViewDetailsDtoModel();
            IList<TimesheetViewListDtoModel> timesheetDetails = new List<TimesheetViewListDtoModel>();
            var emailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            var timesheetData = await _timeSheetRepository.GetTimeSheetByEntryId(timesheetId, emailId);
            MapTimesheetDetail(response, timesheetDetails, timesheetData);
            response.timesheetData = timesheetDetails;
            return response;
        }
        private void MapTimesheetDetail(TimesheetViewDetailsDtoModel response, IList<TimesheetViewListDtoModel> timesheetDetails, IList<TimeSheetDetailListDomainModel> timesheetData)
        {
            var timesheetEntries = _objectMapper.Map<IList<TimeSheetDetailListDomainModel>, IList<TimeSheetDetailListDtoModel>>(timesheetData);

            if (timesheetEntries.Count > 0)
            {
                response.StatusId = timesheetEntries[0].StatusId;
                foreach (var item in timesheetEntries)
                {
                    if (timesheetDetails != null && timesheetDetails.Count > 0)
                    {
                        TimesheetViewListDtoModel existingTimesheet = timesheetDetails.FirstOrDefault(obj => obj.CategoryName == item.CategoryName &&
                       obj.ProjectName == item.ProjectName && obj.SubCategoryName == item.SubCategoryName && obj.TaskDescription == item.TaskDescription)!;
                        if (existingTimesheet != null)
                        {
                            existingTimesheet.TimesheetDetailId.Add(item.TimesheetDetailId);
                            existingTimesheet.Sun = item.DayOfWeek == 1 ? item.HoursWorked.ToString() : existingTimesheet.Sun;
                            existingTimesheet.Mon = item.DayOfWeek == 2 ? item.HoursWorked.ToString() : existingTimesheet.Mon;
                            existingTimesheet.Tue = item.DayOfWeek == 3 ? item.HoursWorked.ToString() : existingTimesheet.Tue;
                            existingTimesheet.Wed = item.DayOfWeek == 4 ? item.HoursWorked.ToString() : existingTimesheet.Wed;
                            existingTimesheet.Thu = item.DayOfWeek == 5 ? item.HoursWorked.ToString() : existingTimesheet.Thu;
                            existingTimesheet.Fri = item.DayOfWeek == 6 ? item.HoursWorked.ToString() : existingTimesheet.Fri;
                            existingTimesheet.Sat = item.DayOfWeek == 7 ? item.HoursWorked.ToString() : existingTimesheet.Sat;
                        }
                        else
                        {

                            var detail = TimesheetUtlity.AddTimesheetDetail(item);
                            timesheetDetails.Add(detail);
                        }
                    }
                    else
                    {
                        var detail = TimesheetUtlity.AddTimesheetDetail(item);
                        timesheetDetails.Add(detail);

                    }
                }
            }
        }

        public async Task<IList<TimeSheetDetailWithCreatedTypeListDtoModel>> GetTimeSheetCreatedOnbehalf(TimesheetListByDatesDtoModel timeSheetParams)
        {
            var emailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            var entries = await _timeSheetRepository.GetTimeSheetCreatedOnbehalf(timeSheetParams, emailId);
            var entriesDto = _objectMapper.Map<IList<TimeSheetDetailWithCreatedTypeListDomainModel>, IList<TimeSheetDetailWithCreatedTypeListDtoModel>>(entries);
            return entriesDto.ToList();
        }
        public async Task<IList<EmployeeProjectDtoModel>> GetProjectsForEmployeeAsync(string emailId)
        {
            var domainResult = await _timeSheetRepository.GetProjectsForEmployeeAsync(emailId);
            return domainResult.Select(item => _objectMapper.Map<EmployeeProject, EmployeeProjectDtoModel>(item)).ToList();
        }
        public async Task<IList<ClientMasterApplicationContractsModel>> GetProjectsForOnBehalfEmployeesAsync(string employeeId)
        {
            var domainResult = await _timeSheetRepository.GetProjectsForOnBehalfEmployeesAsync(employeeId);
            return domainResult.Select(item => _objectMapper.Map<ClientMasterModel, ClientMasterApplicationContractsModel>(item)).ToList();
        }
        public async Task<int> UpdateTimesheetStatusForApprover(TimesheetUpdateStatusDtoModel timesheetDetails, int statusId)
        {
            var emailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            var updateTimesheet = _objectMapper.Map<TimesheetUpdateStatusDtoModel, TimesheetUpdateStatusDomain>(timesheetDetails);
            updateTimesheet.EmailId = emailId;
            var count = await _timeSheetRepository.UpdateTimesheetStatusForApprover(updateTimesheet, statusId);
            return count;
        }
        public async Task SendStatusEmail(IList<EmailAndWeekDto> emailAndWeekListDto)
        {
            bool isManagerEmail = emailAndWeekListDto.Any(x => x.Status.ToLower() == StatusType.ToLower());
            IList<ManagerAndApproverEmailsAndOtherFields> managerAndApproverEmails = new List<ManagerAndApproverEmailsAndOtherFields>();
            if (emailAndWeekListDto.Any(x => x.Status.ToLower() == StatusType.ToLower()))
            {
                var emailAndWeekListDomain = _objectMapper.Map<IList<EmailAndWeekDto>, IList<EmailAndWeekDomainModel>>(emailAndWeekListDto);
                managerAndApproverEmails = await _timeSheetRepository.ManagerAndApproverEmailsForEmployeeAsync(emailAndWeekListDomain);
            }
            foreach (var emailAndWeek in emailAndWeekListDto)
            {
                if (emailAndWeek.EmailId != null)
                {
                    await _scheduledTaskService.SendStatusEmail(emailAndWeek.EmailId, emailAndWeek.Status, emailAndWeek.WeekStartDate.ToString("d"), emailAndWeek.WeekEndDate.ToString("d"), emailAndWeek.Remarks, "", false);
                }
            }
            foreach (var managerapproverEmail in managerAndApproverEmails)
            {
                if (managerapproverEmail.ManagerEmailId != null)
                {
                    await _scheduledTaskService.SendStatusEmail(managerapproverEmail.ManagerEmailId, StatusType, managerapproverEmail.WeekStartDate.ToString("d"), managerapproverEmail.WeekEndDate.ToString("d"), emailAndWeekListDto.Select(x => x.Remarks).SingleOrDefault() ?? "", managerapproverEmail.FullName, true);
                }
                if (managerapproverEmail.ApproverEmailId1 != null && managerapproverEmail.ManagerEmailId != managerapproverEmail.ApproverEmailId1)
                {
                    await _scheduledTaskService.SendStatusEmail(managerapproverEmail.ApproverEmailId1, StatusType, managerapproverEmail.WeekStartDate.ToString("d"), managerapproverEmail.WeekEndDate.ToString("d"), emailAndWeekListDto.Select(x => x.Remarks).SingleOrDefault() ?? "", managerapproverEmail.FullName, true);
                }
                if (managerapproverEmail.ApproverEmailId2 != null && managerapproverEmail.ApproverEmailId1 != managerapproverEmail.ApproverEmailId2 && managerapproverEmail.ManagerEmailId != managerapproverEmail.ApproverEmailId2)
                {
                    await _scheduledTaskService.SendStatusEmail(managerapproverEmail.ApproverEmailId2, StatusType, managerapproverEmail.WeekStartDate.ToString("d"), managerapproverEmail.WeekEndDate.ToString("d"), emailAndWeekListDto.Select(x => x.Remarks).SingleOrDefault() ?? "", managerapproverEmail.FullName, true);
                }

            }
        }
        public async Task SendEmailReminderForTimesheetAsync()
        {
            var currentDate = DateTime.Today;
            var weekStartDate = currentDate.AddDays(-(int)currentDate.DayOfWeek);
            var weekEndDate = weekStartDate.AddDays(6);
            var emailList = await _timeSheetRepository.EmailListForNotsubmittedTimesheetAsync(weekStartDate, weekEndDate);
            foreach (var email in emailList)
            {
                await _scheduledTaskService.SendReminderEmail(email, weekStartDate.ToString("d"), weekEndDate.ToString("d"));
            }
        }
        public async Task SubmitTimeSheeetAndFetchEmailSAsync()
        {
            var currentDate = DateTime.Today;
            var weekStartDate = currentDate.AddDays(-(int)currentDate.DayOfWeek - 7);
            var weekEndDate = weekStartDate.AddDays(6);
            var emailList = await _timeSheetRepository.SubmitTimeSheeetAndFetchEmailSAsync(weekStartDate, weekEndDate);
            IList<EmailAndWeekDto> emailAndWeekListDto = new List<EmailAndWeekDto>();
            foreach (var email in emailList)
            {
                var emailAndWeek = new EmailAndWeekDto();
                emailAndWeek.EmailId = email;
                emailAndWeek.WeekEndDate = weekEndDate;
                emailAndWeek.WeekStartDate = weekStartDate;
                emailAndWeek.Remarks = "Automated Timesheet submission by the system";
                emailAndWeek.Status = StatusType;
                emailAndWeekListDto.Add(emailAndWeek);
            }
            await SendStatusEmail(emailAndWeekListDto);
        }
        public async Task<byte[]> GetTimesheetWeeklyReport(DateTime? sDate = null, DateTime? eDate = null, bool isPdfButtonClick = false, bool isExcelButtonClick = false)
        {
            var currentDate = DateTime.Today;
            int daysUntilPreviousSunday = ((int)currentDate.DayOfWeek - (int)DayOfWeek.Sunday + 7) % 7;
            DateTime lastSunday = currentDate.AddDays(-daysUntilPreviousSunday);
            DateTime startDate = sDate ?? lastSunday.AddDays(-7);
            DateTime endDate = eDate ??lastSunday.AddDays(-1);
            int noOfWeeks = ((int)((endDate - startDate).TotalDays / 7));
            var clientList = await _timeSheetRepository.GetClients();
            var timesheetList = await _timeSheetRepository.GetTimesheetReportExcel(startDate, endDate);
            var timesheetDetailByClient = new List<TimesheetReportDetails>();
            var timesheetDetailForAllClient = await _timeSheetRepository.GetTimesheetPDFReport(startDate, endDate, 0);
            timesheetDetailByClient.Add(timesheetDetailForAllClient);

            foreach (var item in clientList)
            {

                int clientId = item.Id;
                var timesheetSummary = await _timeSheetRepository.GetTimesheetPDFReport(startDate, endDate, clientId);
                timesheetSummary.clientId = item.Id;
                timesheetSummary.clientName = item.ClientName;
                timesheetSummary.AdrenalineLeaves = await _timeSheetRepository.GetAdrenalineLeaves(startDate, endDate, clientId);
                var TimesheetSubCategoryWiseHR = (List<TimesheetSubCategoryWiseEfforts>)(item.Id == 46 ? await _timeSheetRepository.GetSubCategoryReport(startDate, endDate, item.Id, "HR") : []);
                var TimesheetSubCategoryWiseTA = (List<TimesheetSubCategoryWiseEfforts>)(item.Id == 46 ? await _timeSheetRepository.GetSubCategoryReport(startDate, endDate, item.Id, "TA") : []);
                var TimesheetSubCategoryWiseIT = (List<TimesheetSubCategoryWiseEfforts>)(item.Id == 46 ? await _timeSheetRepository.GetSubCategoryReport(startDate, endDate, item.Id, "IT") : []);
                var TimesheetSubCategoryWiseops = (List<TimesheetSubCategoryWiseEfforts>)(item.Id == 46 ? await _timeSheetRepository.GetSubCategoryReport(startDate, endDate, item.Id, "Ops") : []);
                if (item.ClientName.Equals("G&A"))
                {
                    var timesheetFunctionWiseEfforts = new List<List<TimesheetSubCategoryWiseEfforts>>();
                    timesheetFunctionWiseEfforts.Add(TimesheetSubCategoryWiseHR);
                    timesheetFunctionWiseEfforts.Add(TimesheetSubCategoryWiseTA);
                    timesheetFunctionWiseEfforts.Add(TimesheetSubCategoryWiseIT);
                    timesheetFunctionWiseEfforts.Add(TimesheetSubCategoryWiseops);

                    timesheetSummary.timesheetFunctionWiseEfforts = timesheetFunctionWiseEfforts;
                }
                timesheetDetailByClient.Add(timesheetSummary);

            }
            var summary = await _timeSheetRepository.GetTimesheetConsultantReport(startDate, endDate, 0);
            summary.clientId = -1;
            summary.clientName = "Consultant Effort Summary";
            timesheetDetailByClient.Add(summary);
            byte[] writer = Array.Empty<byte>();
            if ((isPdfButtonClick == false))
            {
                writer = TimesheetUtlity.ExportToExcel(timesheetList, startDate, endDate, isExcelButtonClick, "Week");
            }
            if (isExcelButtonClick == false)
            {
                writer = TimesheetUtlity.GenerateTimesheetReportPDF(timesheetDetailByClient, startDate, endDate, noOfWeeks, clientList, isPdfButtonClick, "Week");
            }
            return writer;
        }
        public async Task GetTimesheetMonthlyReport()
        {
            var currentDate = DateTime.Today;
            DateTime previousMonthDate = currentDate.AddMonths(-1);
            DateTime startDate = TimesheetUtlity.GetFirstSunday(previousMonthDate.Year, previousMonthDate.Month);
            DateTime endDate = TimesheetUtlity.GetLastSaturday(previousMonthDate.Year, previousMonthDate.Month);
            int noOfWeeks = (int)((endDate - startDate).TotalDays / 7);
            var clientList = await _timeSheetRepository.GetClients();
            var timesheetDetailByClient = new List<TimesheetReportDetails>();
            var timesheetDetailByAllClient = await _timeSheetRepository.GetTimesheetPDFReport(startDate, endDate, 0);
            timesheetDetailByClient.Add(timesheetDetailByAllClient);
            foreach (var item in clientList)
            {
                int clientId = item.Id;
                var timesheetSummary = await _timeSheetRepository.GetTimesheetPDFReport(startDate, endDate, clientId);
                timesheetSummary.clientId = clientId;
                timesheetSummary.clientName = item.ClientName;
                timesheetSummary.AdrenalineLeaves = await _timeSheetRepository.GetAdrenalineLeaves(startDate, endDate, clientId);
                var TimesheetSubCategoryWiseHR = (List<TimesheetSubCategoryWiseEfforts>)(item.Id == 46 ? await _timeSheetRepository.GetSubCategoryReport(startDate, endDate, item.Id, "HR") : []);
                var TimesheetSubCategoryWiseTA = (List<TimesheetSubCategoryWiseEfforts>)(item.Id == 46 ? await _timeSheetRepository.GetSubCategoryReport(startDate, endDate, item.Id, "TA") : []);
                var TimesheetSubCategoryWiseIT = (List<TimesheetSubCategoryWiseEfforts>)(item.Id == 46 ? await _timeSheetRepository.GetSubCategoryReport(startDate, endDate, item.Id, "IT") : []);
                var TimesheetSubCategoryWiseops = (List<TimesheetSubCategoryWiseEfforts>)(item.Id == 46 ? await _timeSheetRepository.GetSubCategoryReport(startDate, endDate, item.Id, "Ops") : []);
                if (item.ClientName.Equals("G&A"))
                {
                    var timesheetFunctionWiseEfforts = new List<List<TimesheetSubCategoryWiseEfforts>>();
                    timesheetFunctionWiseEfforts.Add(TimesheetSubCategoryWiseHR);
                    timesheetFunctionWiseEfforts.Add(TimesheetSubCategoryWiseTA);
                    timesheetFunctionWiseEfforts.Add(TimesheetSubCategoryWiseIT);
                    timesheetFunctionWiseEfforts.Add(TimesheetSubCategoryWiseops);

                    timesheetSummary.timesheetFunctionWiseEfforts = timesheetFunctionWiseEfforts;
                }
                timesheetDetailByClient.Add(timesheetSummary);

            }
            var summary = await _timeSheetRepository.GetTimesheetConsultantReport(startDate, endDate, 0);
            summary.clientId = -1;
            summary.clientName = "Consultant Effort Summary";
            timesheetDetailByClient.Add(summary);
            var timesheetList = await _timeSheetRepository.GetTimesheetReportExcel(startDate, endDate);
            TimesheetUtlity.ExportToExcel(timesheetList, startDate, endDate, false, "Month");
            TimesheetUtlity.GenerateTimesheetReportPDF(timesheetDetailByClient, startDate, endDate, noOfWeeks, clientList, false, "Month");
        }
        public async Task<int> UpdateTimeSheetStatusForEmployee(UpdateTimeSheetDtoModel updateTimeSheet, int statusId, string onBehalfEmpId = "")
        {
            var emailId = _contextAccessor.HttpContext!.Request.Headers["emailId"].ToString();
            var updateTimeSheetDoamin = _objectMapper.Map<UpdateTimeSheetDtoModel, UpdateTimeSheetDomainModel>(updateTimeSheet);
            updateTimeSheetDoamin.EmailId = emailId;
            return await _timeSheetRepository.UpdateTimeSheetStatusForEmployee(updateTimeSheetDoamin, statusId, onBehalfEmpId);
        }
        public async Task<IList<TimesheetSubCategoryDtoModel>> GetSubCategoryListAsync()
        {
            var subCategoryList = await _timeSheetRepository.GetSubCategoryListAsync();
            return subCategoryList.Select(item => _objectMapper.Map<TimesheetSubCategoryDomainModel, TimesheetSubCategoryDtoModel>(item)).ToList();
        }
        public async Task<IList<TimesheetEmployeeDtoModel>> GetEmployeeTimesheetsAsync(int projectId = 0)
        {
            IList<TimesheetEmployeeDtoModel> list = new List<TimesheetEmployeeDtoModel>();
            var emailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            var employeeList = await _timeSheetRepository.GetEmployeeTimesheetsAsync(emailId, projectId);
            return employeeList.Count > 0 ? _objectMapper.Map<IList<TimesheetEmployeeDomainModel>, List<TimesheetEmployeeDtoModel>>(employeeList) : list;
        }
        public async Task<IList<TimesheetCategoryDtoModel>> GetCategoryListAsync()
        {
            var emailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            var categoryList = await _timeSheetRepository.GetCategoryListAsync(emailId);
            return _objectMapper.Map<IList<TimesheetCategoryDomainModel>, IList<TimesheetCategoryDtoModel>>(categoryList);
        }
        public async Task<IList<TimesheetCategoryDtoModel>> GetCategoryListAsync(string employeeId = "")
        {
            var emailId = _contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            var categoryList = await _timeSheetRepository.GetCategoryListAsync(emailId, employeeId);
            return _objectMapper.Map<IList<TimesheetCategoryDomainModel>, IList<TimesheetCategoryDtoModel>>(categoryList);

        }
        public async Task<IList<TimesheetSubCategoryDtoModel>> GetTimesheetSubcategoryListAsync(int categoryId)
        {
            var subCategoryList = await _timeSheetRepository.GetTimesheetSubcategoryListAsync(categoryId);
            return _objectMapper.Map<IList<TimesheetSubCategoryDomainModel>, IList<TimesheetSubCategoryDtoModel>>(subCategoryList);
        }
        public async Task<IList<TimesheetCategoryDtoModel>> GetCategoryById(int categoryId)
        {
            var category = await _timeSheetRepository.GetCategoryById(categoryId);
            return _objectMapper.Map<IList<TimesheetCategoryDomainModel>, IList<TimesheetCategoryDtoModel>>(category);

        }

        public async Task<TimesheetCategoryDtoModel> GetCategoryByNameAsync(TimesheetCategoryDtoModel postCategory)
        {
            var existingCategory = await _timeSheetRepository.GetCategoryByNameAsync(postCategory.TimeSheetCategoryName);
            if (existingCategory != null)
            {
                var categoryData = _objectMapper.Map<TimesheetCategoryDomainModel, TimesheetCategoryDtoModel>(existingCategory);
                return categoryData;
            }
            return null;

        }

        public async Task AddCategoryAsync(TimesheetCategoryDtoModel postCategory)
        {
            var categoryData = _objectMapper.Map<TimesheetCategoryDtoModel, TimesheetCategoryDomainModel>(postCategory);
            await _timeSheetRepository.AddCategoryAsync(categoryData);
        }

        public async Task<TimesheetSubCategoryDtoModel> GetSubCategoryByNameAsync(TimesheetSubCategoryDtoModel postSubCategory)
        {
            var existingSubCategory = await _timeSheetRepository.GetSubCategoryByNameAsync(postSubCategory.TimeSheetSubCategoryName);
            if (existingSubCategory != null)
            {
                var subCategoryDetail = _objectMapper.Map<TimesheetSubCategoryDomainModel, TimesheetSubCategoryDtoModel>(existingSubCategory);
                return subCategoryDetail;
            }
            return null;
        }
        public async Task AddSubCategoryAsync(TimesheetSubCategoryDtoModel postSubCategory)
        {
            var subCategoryDetail = _objectMapper.Map<TimesheetSubCategoryDtoModel, TimesheetSubCategoryDomainModel>(postSubCategory);
            await _timeSheetRepository.AddSubCategoryAsync(subCategoryDetail);
        }
        public async Task EditCategoryAsync(TimesheetCategoryDtoModel Category, int? Id)
        {
            var categoryDetail = _objectMapper.Map<TimesheetCategoryDtoModel, TimesheetCategoryDomainModel>(Category);
            await _timeSheetRepository.EditCategoryAsync(categoryDetail, Id);
        }

        public async Task EditSubCategoryAsync(TimesheetSubCategoryDtoModel subCategory, int? Id)
        {
            var subCategoryDetail = _objectMapper.Map<TimesheetSubCategoryDtoModel, TimesheetSubCategoryDomainModel>(subCategory);
            await _timeSheetRepository.EditSubCategoryAsync(subCategoryDetail, Id);
        }
        public async Task DeleteCategoryAsync(int Id)
        {
            await _timeSheetRepository.DeleteCategoryAsync(Id);
        }

        public async Task DeleteSubCategoryAsync(int subCategoryId)
        {
            await _timeSheetRepository.DeleteSubCategoryAsync(subCategoryId);
        }

        public async Task<IList<TimesheetEmployeeDetailsDtoModel>> GetAllEmployeeDetails()
        {
            var employeeDetailsList = await _timeSheetRepository.GetAllEmployeeDetails();
            return employeeDetailsList.Select(item => _objectMapper.Map<TimesheetEmployeeDetailsModel, TimesheetEmployeeDetailsDtoModel>(item)).ToList();
        }
        public async Task<IList<TimesheetDeleteEmployeeListDtoModel>> GetAllDeleteEmployeeListAsync()
        {
            var employeeDetailsList = await _timeSheetRepository.GetAllDeleteEmployeeListAsync();
            return employeeDetailsList.Select(item => _objectMapper.Map<TimesheetDeleteEmployeeListModel, TimesheetDeleteEmployeeListDtoModel>(item)).ToList();
        }

        public async Task HardDeleteEmployeeListAsync(string employeeIds)
        {
            await _timeSheetRepository.HardDeleteEmployeeListAsync(employeeIds);
        }

        public async Task RecoverDeleteEmployeeListAsync(string employeeIds)
        {
            await _timeSheetRepository.RecoverDeleteEmployeeListAsync(employeeIds);
        }

        public async Task UpdateEmployeeDetailsAsync(TimesheetEmployeeDetailsDtoModel employeeDetails)
        {
            var updateEmployeeDetails = _objectMapper.Map<TimesheetEmployeeDetailsDtoModel, TimesheetEmployeeDetailsModel>(employeeDetails);
            await _timeSheetRepository.UpdateEmployeeDetailsAsync(updateEmployeeDetails);
        }

        public async Task BulkUpdateEmployeeDetailsAsync(IList<TimesheetEmployeeDetailsDtoModel> bulkEmployeeDetails)
        {
            var bulkUpdateEmployeeList = bulkEmployeeDetails.Select(item => _objectMapper.Map<TimesheetEmployeeDetailsDtoModel, TimesheetEmployeeDetailsModel>(item)).ToList();
            await _timeSheetRepository.BulkUpdateEmployeeDetailsAsync(bulkUpdateEmployeeList);
        }
        public async Task RemoveTimesheetEntryById(string Ids)
        {
            await _timeSheetRepository.RemoveTimesheetEntryById(Ids);
        }
        public async Task<TimesheetDetail> GetTimesheetDetailCategory(int Id)
        {

            var categoryList = await _timeSheetRepository.GetTimesheetDetailCategory(Id);
            return _objectMapper.Map<TimesheetDetail, TimesheetDetail>(categoryList);
        }
        public async Task<TimesheetDetail> GetTimesheetDetailSubCategory(int Id)
        {
            var subCategoryList = await _timeSheetRepository.GetTimesheetDetailSubCategory(Id);
            return _objectMapper.Map<TimesheetDetail, TimesheetDetail>(subCategoryList);
        }
        public async Task<IList<TimesheetCategoryDtoModel>> GetTimesheetCategoryListAsync()
        {
            var categoryList = await _timeSheetRepository.GetTimesheetCategoryListAsync();
            return _objectMapper.Map<IList<TimesheetCategoryDomainModel>, IList<TimesheetCategoryDtoModel>>(categoryList).ToList();
        }


        public async Task<IList<TimesheetEmployeeDetailsDtoModel>> GetEmployeeDetailsByTeamIdAsync(int teamId)
        {
            IList<TimesheetEmployeeDetailsDtoModel> list = new List<TimesheetEmployeeDetailsDtoModel>();
            var employeeList = await _timeSheetRepository.GetEmployeeDetailsByTeamIdAsync(teamId);
            return employeeList.Count > 0 ? _objectMapper.Map<IList<TimesheetEmployeeDetailsModel>, List<TimesheetEmployeeDetailsDtoModel>>(employeeList) : list;
        }

        public async Task<TimesheetApproval> GetApprovalList(int clientId, int teamId)
        {
            var result = await _timeSheetRepository.GetApprovalList(clientId, teamId);
            return _objectMapper.Map<TimesheetApprovalDetail, TimesheetApproval>(result);
        }

        public async Task<IList<dynamic>> GetTimesheetReportAsync(string EmailId, TimesheetReportModel input)
        {
            var result = new List<dynamic>();
            switch (input.ReportType)
            {
                case "TimesheetReport":
                    result = (List<dynamic>)await _timeSheetRepository.GetTimesheetSubmissionReportAsync(EmailId, input);
                    break;
                case "Timesheet Detail Report":
                    result = (List<dynamic>)await _timeSheetRepository.GetTimesheetDayWiseReportAsync(EmailId, input);
                    break;
                case "Timesheet Submission Report":
                    result = (List<dynamic>)await _timeSheetRepository.GetTimesheetEmployeeSubmussionReportAsync(EmailId, input);
                    break;
            }
            return result;
        }

        public async Task<IList<TimesheetStatusDtoModel>> GetTimesheetStatusesAsync()
        {
            var result = await _timeSheetRepository.GetTimesheetStatusList();
            return _objectMapper.Map<IList<TimesheetStatusDomainModel>, IList<TimesheetStatusDtoModel>>(result);
        }

        public async Task<IList<ManagerAndApproverDtoModel>> GetManagerAndApproverAsync(string employeeId)
        {
            var result = await _timeSheetRepository.GetManagerAndApproverList(employeeId);
            return _objectMapper.Map<IList<ManagerAndApproverDomainModel>, IList<ManagerAndApproverDtoModel>>(result);
        }
        public async Task<IList<TimesheetNotificationDomainModel>> GetTimesheetEmailDataAsync(string emailId, TimesheetNotificationModel emailData)
        {
            return (List<TimesheetNotificationDomainModel>)await _timeSheetRepository.GetTimesheetEmailDataAsync(emailId, emailData);
        }

        public async Task SendEmailNotificationAsync(EmailNotificationModel emailData)
        {
            foreach (var emailId in emailData.EmailIds!)
            {
                await _scheduledTaskService.SendReminderEmail(emailId, emailData.StartDate.ToString("d"), emailData.EndDate.ToString("d"));
            }
            
        }
    }
}