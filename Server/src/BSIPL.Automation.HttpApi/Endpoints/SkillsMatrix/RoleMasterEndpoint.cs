using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.Domain.Shared.Enum;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace BSIPL.Automation.Endpoints.SkillsMatrix
{
    public static class RoleMasterEndpoint
    {
        public static WebApplication MapRoleMasterEndpoints(this WebApplication app)
        {
            var roleRoute = app.MapGroup("api/v1").WithTags("Role");

            _ = roleRoute.MapGet("/roles", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetRoleListAsync();
                return (result);
            });

            _ = roleRoute.MapGet("/userRoleDetail", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetRoleByEmailIdAsync(contextAccessor.HttpContext.Request.Headers["emailId"].ToString());
                return (result);
            });

            _ = roleRoute.MapGet("/emloyeeRoleTeamWise", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromQuery] int teamId, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetEmployeeRoleDetail(teamId);
                return (result);
            });

            _ = roleRoute.MapPost("/emloyeeRoleTeamWise", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] List<EmployeeRoleDetailApplicationContractsModel> postClient, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);

                if (role != null && role.RoleName == RoleEnum.Admin.ToString()) // only admin can add client
                {
                    await skillsMatrixService.PostEmployeeWithRoleAsync(postClient,emailId);
                }

            });

            return app;
        }
    }
}
