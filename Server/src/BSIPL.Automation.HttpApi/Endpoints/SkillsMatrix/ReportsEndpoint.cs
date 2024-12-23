using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.SkillsMatrixServiceInterface;

namespace BSIPL.Automation.Endpoints.SkillsMatrix
{
    public static class ReportsEndpoint
    {
        public static WebApplication MapReportsEndpoints(this WebApplication app)
        {
            var reportRoute = app.MapGroup("api/v1").WithTags("Reports");

            _ = reportRoute.MapGet("/reportByCategoryAndClient", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromQuery] int CategoryId, [FromQuery] int ClientId, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var result = await skillsMatrixService.GetReportByCategoryAndClientAsync(emailId,CategoryId, ClientId);
                return result;
            });

            _ = reportRoute.MapGet("/skillsegmentbycategoryreports", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor, [FromQuery] int year, [FromQuery] int month, [FromQuery] int? categoryId = null, [FromQuery] int? clientId = null, [FromQuery] int? teamId = null) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var result = await skillsMatrixService.SkillsSegmentByCategoryAsync(emailId,categoryId, clientId, teamId, year, month);
                return result;
            });

            _ = reportRoute.MapPost("/employeeScoreReportByClientCategory", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] PostSkillMatrixReportModel postSkillMatrix, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var result = await skillsMatrixService.GetEmployeeScoreReportByCategoryClientAsync(postSkillMatrix,emailId);
                return result;
            });

            return app;
        }
    }
}
