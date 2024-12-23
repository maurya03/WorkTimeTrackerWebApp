using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.ApplicationModels.Timesheet;
using BSIPL.Automation.Contracts.Interface;
using BSIPL.Automation.Domain.Shared.Enums;
using BSIPL.Automation.ServiceInterface.Validation;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BSIPL.Automation.TimesheetService.Validation
{
    public class TimeSheetValidation : ITimeSheetValidation
    {
        private readonly ITimeSheetService _timeSheetService;
        public TimeSheetValidation(ITimeSheetService timeSheetService)
        {
            _timeSheetService = timeSheetService;
        }
        public IList<ValidationErrorMessage> ValidateGetTimesheetForTImesheetId(int timesheetId)
        {
            var errors = new List<ValidationErrorMessage>();
            if(timesheetId <= 0)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Timesheet Id can not be less than 0." });
            }
            return errors;
        }
        public IList<ValidationErrorMessage> ValidateGetTimesheetForEmployeeId(string employeeId, IList<TimesheetEmployeeDetailsDtoModel> employeeDetails)
        {
            var errors = new List<ValidationErrorMessage>();
            if (string.IsNullOrEmpty(employeeId))
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Employee id can not be null" });
            }
            else
            {
                bool exist = employeeDetails.Any(emp => emp.EmployeeId == employeeId);
                if (!exist)
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = $"Employee Id: '{employeeId}' doesn't exist." });
                }
            }
            return errors;
        }

        public IList<ValidationErrorMessage> ValidateGetTimesheetEmployeeByProjectId(int projectId)
        {
            var errors = new List<ValidationErrorMessage>();
            if(projectId <= 0)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Project id can not be equal or less than 0." });
            }
            return errors;
        }

        public async Task<IList<ValidationErrorMessage>> ValidateDeleteTimesheetBySubCategoryId(int subCategorId, IList<TimesheetSubCategoryDtoModel> subCategories)
        {
            var errors = new List<ValidationErrorMessage>();
            var MatchingTimesheetRecords = await _timeSheetService.GetTimesheetDetailSubCategory(subCategorId);
            if (MatchingTimesheetRecords != null)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Cannot delete the Timesheet SubCategory as Timesheet Detail contains this subcategory " });
            }
            if (subCategorId <= 0)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Sub category id can not be equal or less than 0." });
            }
            else
            {
                bool exist = subCategories.Any(subCategory => subCategory.TimeSheetSubCategoryId == subCategorId);
                if (!exist)
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = $"Sub category id '{subCategorId}' doesn't exist." });
                }
            }
            return errors;
        }

        public IList<ValidationErrorMessage> ValidateGetTimesheetStatusWise(TimesheetGetDto timesheetDtoObj, IList<ClientMasterApplicationContractsModel> clients)
        {
            var errors = new List<ValidationErrorMessage>();
            if(timesheetDtoObj == null)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Timesheet input data is null." });
            }
            else
            {
                var trimmed = timesheetDtoObj.ClientId.Trim();
                if (String.IsNullOrEmpty(trimmed))
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = "Client Id can not be null or empty" });
                }
                else
                {
                    var listofIDs = timesheetDtoObj.ClientId.Split(',').ToList();
                    var listofID = listofIDs.Select(int.Parse).ToList();
                    foreach (var id in listofID)
                    {
                        bool exist = clients.Any(client => client.Id == id);
                        if (!exist)
                        {
                            errors.Add(new ValidationErrorMessage() { ErrorMessage = $"Client Id '{id}' does not exists." });
                        }
                    }
                }

                Enum.TryParse(timesheetDtoObj.Status, out TimeSheetStatuses status);
                trimmed = timesheetDtoObj.Status.Trim();
                if (String.IsNullOrEmpty(trimmed))
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = "Status can not be null or empty." });
                }
                else if(!Enum.IsDefined(typeof(TimeSheetStatuses), status))
                {
                      errors.Add(new ValidationErrorMessage() { ErrorMessage = $"Status '{timesheetDtoObj.Status}' is not defined." });
                }
            }
            return errors;
        }

        public IList<ValidationErrorMessage> ValidateSaveTimesheet(TimesheetDetail hourlyData, IList<TimesheetCategoryDtoModel> timesheetCategories, IList<TimesheetSubCategoryDtoModel> timesheetSubCategories)
        {
            var errors = new List<ValidationErrorMessage>();
            if(hourlyData == null)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Timesheet can not be null to save." });
            }
            else
            {
                bool exist = timesheetCategories.Any(category => category.TimeSheetCategoryId == hourlyData.TimeSheetCategoryID);

                if(!exist)
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = $"Category Ids '{hourlyData.TimeSheetCategoryID}' does not exist." });
                }

                exist = timesheetSubCategories.Any(subCategory => subCategory.TimeSheetSubCategoryId == hourlyData.TimeSheetSubcategoryID);

                if (!exist)
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = $"Sub category Ids '{hourlyData.TimeSheetSubcategoryID}' does not exist." });
                }

                /*if(hourlyData.StatusId <= 0 || hourlyData.StatusId > 4)
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = "Status id should be between 1 to 4." });
                }*/

                if(String.IsNullOrEmpty(hourlyData.TaskDescription.Trim()))
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = "Task Description can not be empty." });
                }

                if(hourlyData.HoursWorked > 12)
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = "An employee can work max 12 hrs a day." });
                }
            }
            return errors;
        }       
        public IList<ValidationErrorMessage> ValidateTimesheet(TimesheetEmployeeDetailsDtoModel timesheetEmployeeDetails, IList<TimesheetEmployeeDetailsDtoModel> employeeDetails)
        {
            var errors = new List<ValidationErrorMessage>();
            if (timesheetEmployeeDetails == null)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Employee Details can not be null." });
            }
            else
            {
                bool exist = employeeDetails.Any(emp => emp.EmployeeId ==  timesheetEmployeeDetails.EmployeeId);
                if (!exist)
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = $"Employee Id: '{timesheetEmployeeDetails.EmployeeId}' doesn't exist." });
                }

                if (string.IsNullOrEmpty(timesheetEmployeeDetails.TimesheetManagerId))
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = "Manager id should not be null" });
                }

                if (string.IsNullOrEmpty(timesheetEmployeeDetails.TimesheetApproverId1))
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = "First approver id should not be null" });
                }

                if (string.IsNullOrEmpty(timesheetEmployeeDetails.TimesheetApproverId2))
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = "Second approver id should not be null" });
                }
            }

            return errors;
        }

        public IList<ValidationErrorMessage> ValidateUpdateTimesheetStatusForApprover(TimesheetUpdateStatusDtoModel timesheetUpdate, IList<TimesheetEmployeeDetailsDtoModel> employeeDetails)
        {
            var errors = new List<ValidationErrorMessage>();
            if(timesheetUpdate == null)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Please provide Timesheet details to update." });
            }
            else
            {
                if (String.IsNullOrEmpty(timesheetUpdate.EmployeeIds))
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = "Employee id can not be null or empty." });
                }
                else
                {
                    var listofIDs = timesheetUpdate.EmployeeIds.Split(',').ToList();
                    var listofID = listofIDs.Select(x => x.Trim()).ToList();
                    foreach (var id in listofID)
                    {
                        bool exist = employeeDetails.Any(emp => emp.EmployeeId == id);
                        if (!exist)
                        {
                            errors.Add(new ValidationErrorMessage() { ErrorMessage = $"Employee Id: '{id}' doesn't exist." });
                        }
                    }
                }
                if (String.IsNullOrEmpty(timesheetUpdate.TimesheetIds))
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = "Timesheet id can not be null or empty." });
                }
                Enum.TryParse(timesheetUpdate.Status, out TimeSheetStatuses status);
                var trimmed = timesheetUpdate.Status.Trim();
                if (String.IsNullOrEmpty(trimmed))
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = "Status can not be null or empty." });
                }
                else if (!Enum.IsDefined(typeof(TimeSheetStatuses), status))
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = $"Status '{timesheetUpdate.Status}' is not defined." });
                }
            }
            return errors;
        }

        public IList<ValidationErrorMessage> ValidateUpdateTimesheetStatusForEmployee(UpdateTimeSheetDtoModel updateTimeSheet)
        {
            var errors = new List<ValidationErrorMessage>();
            if (updateTimeSheet == null)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Please provide Timesheet details to update." });
            }
            
            return errors;
        }

        public IList<ValidationErrorMessage> ValidateUpdateTimesheetSubCategoryBYCategoryId(int categoryId, IList<TimesheetCategoryDtoModel> categories)
        {
            var errors = new List<ValidationErrorMessage>();
            if (categoryId <= 0)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Category Id can not be equal or less than 0." });
            }
            else
            {
                var exist = categories.Any(category => category.TimeSheetCategoryId == categoryId);
                if (!exist) 
                {
                    errors.Add(new ValidationErrorMessage() { ErrorMessage = $"Category Id '{categoryId}' doesn't exist." });
                }
            }
            return errors;
        }
        public async Task<IList<ValidationErrorMessage>> ValidateDeleteTimesheetCategory(int Id)
        {
            var errors = new List<ValidationErrorMessage>();
            var MatchingTimesheetRecords = await _timeSheetService.GetTimesheetDetailCategory(Id);
            if (MatchingTimesheetRecords != null)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Cannot Delete the Timesheet Category as Timesheet Detail contains this category" });

            }
            return errors;

        }
        public async Task<IList<ValidationErrorMessage>> ValidateCreateTimesheet(CreateTimesheetDtoModel createTimesheetDtoModel)
        {
            var categories = await _timeSheetService.GetCategoryListAsync();
            foreach (var timesheetRow in createTimesheetDtoModel.TaskRows)
            {
                var subCategories = await _timeSheetService.GetTimesheetSubcategoryListAsync(timesheetRow.CategoryID);
                var ValidationList = ValidateRow(timesheetRow, categories, subCategories);
                if (ValidationList.Count > 0)
                {
                    return ValidationList.ToList();
                }
            }
            return new List<ValidationErrorMessage>();
        }
        private IList<ValidationErrorMessage> ValidateRow(TimesheetTaskDtoModel timesheetTask, IList<TimesheetCategoryDtoModel> timesheetCategories, IList<TimesheetSubCategoryDtoModel> timesheetSubCategories)
        {
            var errors = new List<ValidationErrorMessage>();


            bool exist = timesheetCategories.Any(category => category.TimeSheetCategoryId == timesheetTask?.CategoryID);

            if (!exist)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = $"Category doesn't exist." });
            }

            exist = timesheetSubCategories.Any(subCategory => subCategory.TimeSheetSubCategoryId == timesheetTask?.SubCategoryID);

            if (!exist)
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = $"SubCategoryId doesn't exist." });
            }
            if (String.IsNullOrEmpty(timesheetTask?.TaskDescription.Trim()))
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "Task Description can't be empty." });
            }
            var hoursData = JsonConvert.DeserializeObject<Dictionary<string, string>>(timesheetTask.HoursWorked);
            if (hoursData.Values.Any(value => !decimal.TryParse(value, out decimal decimalValue) || decimalValue <= 0 || decimalValue > 12))
            {
                errors.Add(new ValidationErrorMessage() { ErrorMessage = "An employee hours worked can't be empty or 0 and max 12 hrs a day." });
            }

            return errors;
        }
    }
}