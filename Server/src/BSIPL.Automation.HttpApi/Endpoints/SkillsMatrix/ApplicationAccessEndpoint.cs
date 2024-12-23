using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.Domain.Shared.Enum.EmployeesBookEnum;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace BSIPL.Automation.Endpoints.SkillsMatrix
{
    public static class ApplicationAccessEndpoint
    {
        public static WebApplication MapApplicationAccessEndpoint(this WebApplication app)
        {
            var roleRoute = app.MapGroup("api/v1").WithTags("Application");

            _ = roleRoute.MapGet("/applicationAccess", async ([FromServices] ISkillsMatrixService skillsMatrixService,IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var result = await skillsMatrixService.GetApplicationAccessList(emailId);
                if (result.Count == 0)
                {
                    return Results.Unauthorized();
                }
                return Results.Ok(result);

            });

            return app;
        }
    }
}
