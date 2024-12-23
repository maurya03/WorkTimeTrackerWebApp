using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.Timesheet;
using BSIPL.Automation.Contracts.Interface;
using BSIPL.Automation.Domain.Shared.Enum;
using BSIPL.Automation.Domain.Shared.Enums;
using BSIPL.Automation.ScheduledTaskServiceInterface;
using BSIPL.Automation.ServiceInterface.Validation;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;

namespace BSIPL.Automation.Endpoints
{
    public static class TimeSheetEndPoints
    {
        public static WebApplication MapTimeSheetEndPoints(this WebApplication app)
        {
            var timesheetRoute = app.MapGroup("api/v1").WithTags("TimeSheet");
            var categoryRoute = app.MapGroup("api/v1").WithTags("TimeSheetCategory");

            _ = timesheetRoute.MapPost("/savetimesheet", async ([FromServices] ITimeSheetValidation validation,[FromServices] ITimeSheetService timeSheetService, [FromBody] TimesheetDto timesheetEntryDtoObj, [FromQuery] bool isDeleted, IHttpContextAccessor contextAccessor) =>
            {
                var categories = await timeSheetService.GetCategoryListAsync();
                foreach(var hourlyData in timesheetEntryDtoObj.HourlyData)
                {
                    var subCategories = await timeSheetService.GetTimesheetSubcategoryListAsync(hourlyData.TimeSheetCategoryID);
                    var ValidationList = validation.ValidateSaveTimesheet(hourlyData, categories, subCategories);
                    if (ValidationList.Count > 0)
                    {
                        return Results.BadRequest(ValidationList);
                    }
                }

                var trimmiedDescriptions = timesheetEntryDtoObj.HourlyData.Select(hourlyData => hourlyData.TaskDescription?.Trim());
                timesheetEntryDtoObj.HourlyData = timesheetEntryDtoObj.HourlyData.Zip(trimmiedDescriptions, (hourlyData, trimmedDesc) =>
                {
                    hourlyData.TaskDescription = trimmedDesc;
                    return hourlyData;
                }).ToList();
                timesheetEntryDtoObj.Remarks = timesheetEntryDtoObj.Remarks.Trim();
                var result = await timeSheetService.AddTimeSheetEntry(timesheetEntryDtoObj, isDeleted);
                return Results.Ok(result);
            });
            _ = timesheetRoute.MapPost("/sendemail", async ([FromServices] ITimeSheetService timeSheetService, [FromBody] List<EmailAndWeekDto> emailAndWeekObj) =>
            {
               await timeSheetService.SendStatusEmail(emailAndWeekObj);
            });
            _ = timesheetRoute.MapPost("/getTimesheetStatusWise", async ([FromServices] ITimeSheetValidation validation, [FromServices] ISkillsMatrixService skillsMatrixService,[FromServices] ITimeSheetService timeSheetService, [FromBody] TimesheetGetDto TimesheetDtoObj, IHttpContextAccessor contextAccessor) =>
            {
                TimeSheetStatuses sheetStatuses;
                IList<TimeSheetListDtoModel> TimeSheetList = new List<TimeSheetListDtoModel>();
                var clients = await skillsMatrixService.GetClientAsync(contextAccessor.HttpContext.Request.Headers["emailId"].ToString());

                var ValidationList = validation.ValidateGetTimesheetStatusWise(TimesheetDtoObj, clients);
                if (ValidationList.Count > 0)
                {
                     return Results.BadRequest(ValidationList);
                }
                TimeSheetList = Enum.TryParse(TimesheetDtoObj.Status, ignoreCase: true, out sheetStatuses) == true ? await timeSheetService.GetTimeSheetsAsync((int)sheetStatuses, TimesheetDtoObj) : throw new InvalidCastException("Invalid status");
                return Results.Ok(TimeSheetList);
            });

            _ = timesheetRoute.MapGet("/gettimesheetbyentryid/timesheetId/{timesheetId:int}", async ([FromServices] ITimeSheetValidation validation, [FromServices] ITimeSheetService timeSheetService, [FromRoute] int timesheetId, IHttpContextAccessor contextAccessor) =>
            {
                IList<TimeSheetEntryListDtoModel> TimeSheetList = new List<TimeSheetEntryListDtoModel>();
                var ValidationList = validation.ValidateGetTimesheetForTImesheetId(timesheetId);
                if (ValidationList.Count > 0)
                {
                    return Results.BadRequest(ValidationList);
                }
                var result = await timeSheetService.GetTimeSheetByEntryId(timesheetId);
                return Results.Ok(result);
            });

            _ = timesheetRoute.MapGet("/gettimesheetbydates/startDate/{startDate:dateTime}/endDate/{endDate:dateTime}", async ([FromRoute] DateTime startDate, DateTime endDate, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                TimesheetListByDatesDtoModel timesheetDates = new() { StartDate = startDate, EndDate = endDate };
                return await timeSheetService.GetTimeSheetByDates(timesheetDates);
            });
            _ = timesheetRoute.MapGet("/gettimesheetdetailcreatedonbehlaf", async ([FromQuery] DateTime startDate, [FromQuery] DateTime endDate, [FromQuery] bool IsBehalf, [FromQuery] int empId, [FromQuery] int clientId, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                TimesheetListByDatesDtoModel timesheetDates = new() { StartDate = startDate, EndDate = endDate, Isbehalf = IsBehalf, EmpId = empId, ClientId = clientId };
                return await timeSheetService.GetTimeSheetCreatedOnbehalf(timesheetDates);
            });
            _ = timesheetRoute.MapGet("/getemployeeprojects", async ([FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await timeSheetService.GetProjectsForEmployeeAsync(contextAccessor.HttpContext.Request.Headers["emailId"].ToString());
                return (result);
            });
            _ = timesheetRoute.MapGet("/getProjectsForOnBehalfEmployees/employeeid/{employeeId}", async ([FromServices] ITimeSheetValidation validation, [FromServices] ITimeSheetService timeSheetService, [FromRoute] string employeeId, IHttpContextAccessor contextAccessor) =>
            {
                var employeeDetailsList = await timeSheetService.GetAllEmployeeDetails();
                var ValidationList = validation.ValidateGetTimesheetForEmployeeId(employeeId, employeeDetailsList);
                if (ValidationList.Count > 0)
                {
                    return Results.BadRequest(ValidationList);
                }
                var result = await timeSheetService.GetProjectsForOnBehalfEmployeesAsync(employeeId);
                return Results.Ok(result);
            });
            _ = timesheetRoute.MapPatch("/updateTimesheetStatusForApprover", async ([FromServices] ITimeSheetValidation validation, [FromServices] ITimeSheetService timeSheetService, [FromBody] TimesheetUpdateStatusDtoModel timesheetDetails, IHttpContextAccessor contextAccessor) =>
            {
                TimeSheetStatuses sheetStatuses;
                var employeeDetailsList = await timeSheetService.GetAllEmployeeDetails();
                var ValidationList = validation.ValidateUpdateTimesheetStatusForApprover(timesheetDetails, employeeDetailsList);
                if (ValidationList.Count > 0)
                {
                    return Results.BadRequest(ValidationList);
                }
                var rowsAffected = Enum.TryParse(timesheetDetails.Status, ignoreCase: true, out sheetStatuses) == true ? await timeSheetService.UpdateTimesheetStatusForApprover(timesheetDetails, (int)sheetStatuses) : throw new InvalidCastException("Invalid status");
                return rowsAffected > 0 ? Results.Accepted() : Results.Unauthorized();
            });
            _ = timesheetRoute.MapPatch("/updateTimesheetStatusForEmployee", async ([FromServices] ITimeSheetValidation validation, [FromServices] ITimeSheetService timeSheetService, [FromServices] IScheduledTaskService scheduledTaskService,[FromBody] UpdateTimeSheetDtoModel updateTimeSheet, IHttpContextAccessor contextAccessor) =>
            {
                var ValidationList = validation.ValidateUpdateTimesheetStatusForEmployee(updateTimeSheet);
                if (ValidationList.Count > 0)
                {
                    return Results.BadRequest(ValidationList);
                }
                var rowsAffected = Enum.TryParse<TimeSheetStatuses>(updateTimeSheet.Status, ignoreCase: true, out TimeSheetStatuses sheetStatuses) == true ? await timeSheetService.UpdateTimeSheetStatusForEmployee(updateTimeSheet, (int)sheetStatuses) : throw new InvalidCastException("Invalid status");
                //if (rowsAffected > 0) {scheduledTaskService.SendEmail(contextAccessor.HttpContext.Request.Headers["emailId"].ToString(), "submitted", updateTimeSheet.StartDate.ToString("d"), updateTimeSheet.EndDate.ToString("d")); }
                return rowsAffected > 0 ? Results.Accepted() : Results.Unauthorized();
            });

            _ = timesheetRoute.MapPatch("/submitTimesheetonbehalf/employeeId/{employeeId}", async ([FromServices] ITimeSheetValidation validation, [FromServices] ITimeSheetService timeSheetService, [FromRoute] string employeeId, [FromBody] UpdateTimeSheetDtoModel updateTimeSheet, IHttpContextAccessor contextAccessor) =>
            {
                var employeeDetailsList = await timeSheetService.GetAllEmployeeDetails();
                var ValidationList = validation.ValidateGetTimesheetForEmployeeId(employeeId, employeeDetailsList);
                var ValidationList1 = validation.ValidateUpdateTimesheetStatusForEmployee(updateTimeSheet);
                ((List<ValidationErrorMessage>)ValidationList).AddRange(ValidationList1);
                if (ValidationList.Count > 0)
                {
                    return Results.BadRequest(ValidationList);
                }
                var rowsAffected = await timeSheetService.UpdateTimeSheetStatusForEmployee(updateTimeSheet, (int)TimeSheetStatuses.Pending, employeeId);
                return rowsAffected > 0 ? Results.Accepted() : Results.Unauthorized();
            });

            _ = categoryRoute.MapGet("/timesheetCategories", async ([FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await timeSheetService.GetCategoryListAsync();
                return result;
            });

            _ = categoryRoute.MapPost("/timesheetCategory", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromServices] ITimeSheetService timeSheetService, [FromBody] TimesheetCategoryDtoModel postCategory, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);

                if (role != null && role.RoleName == RoleEnum.Admin.ToString())
                {
                    var categoryDetail = await timeSheetService.GetCategoryByNameAsync(postCategory);
                    if (categoryDetail != null)
                    {
                        return Results.BadRequest("Category with the same name already exists.");
                    }
                    await timeSheetService.AddCategoryAsync(postCategory);
                    return Results.Ok();
                }
                return Results.Unauthorized();
            });

            _ = categoryRoute.MapPut("/timesheetCategory/{Id}", async ([FromRoute] int? Id, [FromBody] TimesheetCategoryDtoModel Category, [FromServices] ISkillsMatrixService skillsMatrixService, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                if (Id.HasValue)
                {
                    if (Category.TimeSheetCategoryName.IsNullOrWhiteSpace() || Category.Function.IsNullOrWhiteSpace())
                    {
                        throw new Exception("Name or Function is empty");
                    }
                    else
                    {
                        var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                        var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);

                        if (role != null && role.RoleName == RoleEnum.Admin.ToString())
                        {
                            var categorExist = await timeSheetService.GetCategoryById((int)Id);
                            if (categorExist == null)
                            {
                                return Results.BadRequest("Category does not Exist");
                            }

                            var categoryList = await timeSheetService.GetTimesheetCategoryListAsync();
                            var isNameExist = categoryList.Where(x => x.TimeSheetCategoryName.Trim().ToLower() == Category.TimeSheetCategoryName.Trim().ToLower() && x.TimeSheetCategoryId != Id.Value).ToList();
                            if (isNameExist.Count > 0)
                            {
                                return Results.BadRequest("Category with the same name already exists.");
                            }

                            await timeSheetService.EditCategoryAsync(Category, Id);
                            return Results.Ok();
                        }
                    }
                }
                return Results.NoContent();
            });
            _ = categoryRoute.MapDelete("/timesheetCategory/{Id}", async ([FromServices] ITimeSheetValidation validation, [FromRoute] int Id, [FromServices] ISkillsMatrixService skillsMatrixService, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                var ErrorMessage = await validation.ValidateDeleteTimesheetCategory(Id);
                if (ErrorMessage.Count > 0)
                {
                    return Results.BadRequest(ErrorMessage);
                }

                if (role != null && role.RoleName == RoleEnum.Admin.ToString())
                {
                    await timeSheetService.DeleteCategoryAsync(Id);
                }

                return Results.Ok();
            });
            _ = categoryRoute.MapGet("/timesheetSubCategoriesByCategoryId", async ([FromServices] ITimeSheetValidation validation, [FromQuery] int CategoryId, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var categories = await timeSheetService.GetCategoryListAsync();
                var ValidationList = validation.ValidateUpdateTimesheetSubCategoryBYCategoryId(CategoryId, categories);
                if (ValidationList.Count > 0)
                {
                    return Results.BadRequest(ValidationList);
                }
                var result = await timeSheetService.GetTimesheetSubcategoryListAsync(CategoryId);
                return Results.Ok(result);
            });

            _ = categoryRoute.MapPost("/timesheetSubCategory", async ([FromBody] TimesheetSubCategoryDtoModel postSubCategory, [FromServices] ISkillsMatrixService skillsMatrixService, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);

                if (role != null && role.RoleName == RoleEnum.Admin.ToString())
                {
                    var subCategoryDetail = await timeSheetService.GetSubCategoryByNameAsync(postSubCategory);
                    if (subCategoryDetail != null)
                    {
                        return Results.BadRequest("SubCategory with the same name already exists.");
                    }
                    await timeSheetService.AddSubCategoryAsync(postSubCategory);
                    return Results.Ok();
                }

                return Results.Unauthorized();

            });

            _ = categoryRoute.MapPut("/timesheetSubCategory/{Id}", async ([FromRoute] int? Id, [FromBody] TimesheetSubCategoryDtoModel SubCategory, [FromServices] ISkillsMatrixService skillsMatrixService, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {

                if (Id.HasValue)
                {
                    if (SubCategory.TimeSheetSubCategoryName.IsNullOrWhiteSpace() || !SubCategory.TimeSheetCategoryId.HasValue)
                    {
                        throw new Exception("Subcategory Name or CategoryId is empty");
                    }
                    else
                    {
                        var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                        var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);

                        if (role != null && role.RoleName == RoleEnum.Admin.ToString())
                        {
                            var subCategoryExist = await timeSheetService.GetTimesheetSubcategoryListAsync((int)Id);
                            if (subCategoryExist == null)
                            {
                                return Results.BadRequest("SubCategoryName does not exists.");
                            }
                            var subCategoryDetail = await timeSheetService.GetSubCategoryByNameAsync(SubCategory);
                            if (subCategoryDetail != null)
                            {
                                return Results.BadRequest("SubCategory with the same name already exists.");
                            }

                            if (subCategoryDetail != null && subCategoryDetail.TimeSheetSubCategoryId != SubCategory.TimeSheetSubCategoryId)
                            {
                                return Results.BadRequest("SubCategory with the same name already exists.");
                            }
                            await timeSheetService.EditSubCategoryAsync(SubCategory, Id);
                            return Results.Ok();

                        }
                        return Results.Unauthorized();
                    }
                }
                return Results.NoContent();

            });

            _ = timesheetRoute.MapGet("/getallemployeedetails", async ([FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await timeSheetService.GetAllEmployeeDetails();
                return result;
            });

            _ = timesheetRoute.MapGet("/getDeleteEmployeeList", async ([FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await timeSheetService.GetAllDeleteEmployeeListAsync();
                return result;
            });

            _ = timesheetRoute.MapDelete("/hardDeleteEmployeeList/{employeeList}", async ([FromServices] ITimeSheetService timeSheetService, [FromRoute] string employeeList, IHttpContextAccessor contextAccessor) =>
            {
                await timeSheetService.HardDeleteEmployeeListAsync(employeeList);
                return Results.Ok();
            });

            _ = timesheetRoute.MapPut("/recoverDeleteEmployeeList/{employeeList}", async ([FromServices] ITimeSheetService timeSheetService, [FromRoute] string employeeList, IHttpContextAccessor contextAccessor) =>
            {
                await timeSheetService.RecoverDeleteEmployeeListAsync(employeeList);
                return Results.Ok();
            });

            _ = timesheetRoute.MapPut("/timesheetemployeedetails", async ([FromServices] ITimeSheetValidation validation, [FromServices] ITimeSheetService timeSheetService, [FromBody] TimesheetEmployeeDetailsDtoModel employeeDetails, IHttpContextAccessor contextAccessor) =>
            {
                await timeSheetService.UpdateEmployeeDetailsAsync(employeeDetails);
                return Results.Ok();
            });

            _ = timesheetRoute.MapPut("/timesheetemployeedetailslist", async ([FromServices] ITimeSheetValidation validation, [FromServices] ITimeSheetService timeSheetService, [FromBody] IList<TimesheetEmployeeDetailsDtoModel> bulkEmployeeDetails, IHttpContextAccessor contextAccessor) =>
            {
                await timeSheetService.BulkUpdateEmployeeDetailsAsync(bulkEmployeeDetails);
                return Results.Ok();
            });

            _ = categoryRoute.MapDelete("/timesheetSubCategory/{subCategoryId}", async ([FromServices] ITimeSheetValidation validation, [FromRoute] int subCategoryId, [FromServices] ISkillsMatrixService skillsMatrixService, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var subCategories = await timeSheetService.GetSubCategoryListAsync();
                var ValidationList = await validation.ValidateDeleteTimesheetBySubCategoryId(subCategoryId, subCategories);
                if (ValidationList.Count > 0)
                {
                    return Results.BadRequest(ValidationList);
                }
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);

                if (role != null && role.RoleName == RoleEnum.Admin.ToString())
                {
                    await timeSheetService.DeleteSubCategoryAsync(subCategoryId);
                }
                return Results.Ok();
            });
            _ = timesheetRoute.MapGet("/timesheetSubCategory", async ([FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await timeSheetService.GetSubCategoryListAsync();
                return result;
            });
            _ = timesheetRoute.MapGet("/gettimesheetemployee", async ([FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await timeSheetService.GetEmployeeTimesheetsAsync();
                return result;
            });
            _ = timesheetRoute.MapGet("/gettimesheetemployeebyprojectid/projectId/{projectId}", async ([FromServices] ITimeSheetValidation validation, [FromRoute] int projectId, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var ValidationList = validation.ValidateGetTimesheetEmployeeByProjectId(projectId);
                if (ValidationList.Count > 0)
                {
                    return Results.BadRequest(ValidationList);
                }
                var result = await timeSheetService.GetEmployeeTimesheetsAsync(projectId);
                return Results.Ok(result);
            });
            _ = timesheetRoute.MapGet("/getemployeedetailbyteamid/teamId/{teamId:int}", async ([FromRoute] int teamId, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await timeSheetService.GetEmployeeDetailsByTeamIdAsync(teamId);
                return result;
            });

            _ = timesheetRoute.MapGet("/timesheetapproval/projectId/{projectId:int}/team/{teamId:int}", async ([FromRoute] int projectId, [FromRoute] int teamId,[FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await timeSheetService.GetApprovalList(projectId, teamId);
                return Results.Ok(result);
            });

            _ = timesheetRoute.MapGet("/getTimesheetStatuses", async ([FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await timeSheetService.GetTimesheetStatusesAsync();
                return Results.Ok(result);
            });

            _ = timesheetRoute.MapGet("/getManagerAndApprover/employeeid/{employeeId}", async ([FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor,[FromRoute] string employeeId) =>
            {
                var result = await timeSheetService.GetManagerAndApproverAsync(employeeId);
                return Results.Ok(result);
            });

            _ = timesheetRoute.MapPost("/getTimesheetEmailData", async ([FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor, [FromBody] TimesheetNotificationModel emailData) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var result = await timeSheetService.GetTimesheetEmailDataAsync(emailId!, emailData);
                return result;
            });

            _ = timesheetRoute.MapPost("/sendEmailNotification", async ([FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor, [FromBody] EmailNotificationModel emailData) =>
            {

                await timeSheetService.SendEmailNotificationAsync(emailData);
                return Results.Ok();
            });

            return app;
        }
    }
}