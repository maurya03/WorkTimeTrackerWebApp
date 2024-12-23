using BSIPL.Automation.ApplicationModels.Timesheet;
using BSIPL.Automation.Contracts.Interface;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Endpoints.Timesheet
{
    public static class ReportsEndpoint
    {
        public static WebApplication MapTimesheetReportsEndpoints(this WebApplication app)
        {
            var reportRoute = app.MapGroup("api/v1").WithTags("Reports");

            _ = reportRoute.MapPost("/getTimesheetReport", async ([FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor, [FromBody] TimesheetReportModel input) =>
            {
                var EmailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var result = await timeSheetService.GetTimesheetReportAsync(EmailId, input);
                return result;
            });

            _ = reportRoute.MapGet("/generateTimesheetWeeklyReport/startDate/{startDate:dateTime}/endDate/{endDate:dateTime}", async ([FromRoute] DateTime startDate, DateTime endDate, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                return await timeSheetService.GetTimesheetWeeklyReport(startDate, endDate, true, false);
            });

            _ = reportRoute.MapGet("/generateTimesheetWeeklyExcelReport/startDate/{startDate:dateTime}/endDate/{endDate:dateTime}", async ([FromRoute] DateTime startDate, DateTime endDate, [FromServices] ITimeSheetService timeSheetService, IHttpContextAccessor contextAccessor) =>
            {
                return await timeSheetService.GetTimesheetWeeklyReport(startDate, endDate, false, true);
            });


            return app;
        }
    }
}
