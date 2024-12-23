using BSIPL.Automation.ApplicationModels.Timesheet;
using BSIPL.Automation.Contracts.Interface;
using BSIPL.Automation.ServiceInterface.Validation;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Linq;

namespace BSIPL.Automation.Endpoints.V2
{
    public static class TimesheetEndpoints
    {
        public static WebApplication MapV2TimeSheetEndPoints(this WebApplication app)
        {
            var timesheetRoute = app.MapGroup("api/v2").WithTags("TimeSheet");
            var categoryRoute = app.MapGroup("api/v2").WithTags("TimeSheetCategory");

            _ = categoryRoute.MapGet("/timesheetCategories/Employees", async ([FromServices] ITimeSheetService timeSheetService, [FromQuery] string employeeId, IHttpContextAccessor contextAccessor) =>
            {
                var result = await timeSheetService.GetCategoryListAsync(employeeId);
                return result;
            });
            _ = timesheetRoute.MapGet("/viewtimesheet/startDate/{startDate:dateTime}/endDate/{endDate:dateTime}", async ([FromRoute] DateTime startDate, DateTime endDate, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                TimesheetListByDatesDtoModel timesheetDates = new() { StartDate = startDate, EndDate = endDate };
                return await timeSheetService.ViewTimesheetByDates(timesheetDates);
            });
            _ = timesheetRoute.MapDelete("/removeTimesheetEntryById/{Ids}", async ([FromRoute] string Ids, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                    await timeSheetService.RemoveTimesheetEntryById(Ids);

            });
            _ = timesheetRoute.MapPost("/createTimesheet", async ([FromServices] ITimeSheetValidation validation, [FromServices] ITimeSheetService timeSheetService, [FromBody] CreateTimesheetDtoModel createTimesheetDtoModel,IHttpContextAccessor contextAccessor) =>
            {
                var errorList =await validation.ValidateCreateTimesheet(createTimesheetDtoModel);
                return errorList.Count > 0? Results.BadRequest(errorList): Results.Ok(await timeSheetService.CreateTimesheetV2(createTimesheetDtoModel));
            });
            _ = timesheetRoute.MapGet("/viewtimesheetid/timesheetId/{timesheetId:int}", async ([FromServices] ITimeSheetValidation validation, [FromServices] ITimeSheetService timeSheetService, [FromRoute] int timesheetId, IHttpContextAccessor contextAccessor) =>
            {
                IList<TimeSheetEntryListDtoModel> TimeSheetList = new List<TimeSheetEntryListDtoModel>();
                var ValidationList = validation.ValidateGetTimesheetForTImesheetId(timesheetId);
                if (ValidationList.Count > 0)
                {
                    return Results.BadRequest(ValidationList);
                }
                var result = await timeSheetService.ViewTimesheetById(timesheetId);
                return Results.Ok(result);
            });
            return app;
        }
    }
}
