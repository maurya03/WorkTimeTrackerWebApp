using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.Domain.Shared.Enum;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace BSIPL.Automation.Endpoints.SkillsMatrix
{
    public static class SkillsMatrixEndpoint
    {
        public static WebApplication MapSkillsMatrixEndpoints(this WebApplication app)
        {
            var skillMatrixRoute = app.MapGroup("api/v1").WithTags("SkillMatrix");

            _ = skillMatrixRoute.MapGet("/skillsMatrices", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetAllSkillsMatrixAsync();
                return result;
            });

            _ = skillMatrixRoute.MapPost("/skillsMatrix", async ([FromServices] IValidationService validationService, [FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] List<EmployeeScoreModel> postSkillMatrix, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var errorMessageList = await validationService.ValidateEmployeeScore(postSkillMatrix);
                if (errorMessageList.Count > 0)
                {
                    return Results.BadRequest(errorMessageList);
                }
                await skillsMatrixService.AddSkillMatrixAsync(postSkillMatrix, emailId);
                return Results.Ok();
            });

            _ = skillMatrixRoute.MapGet("/SkillsMatrixTables", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetSkillsMatrixJoinTablesAsync(contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString());
                return (result);
            });

            _ = skillMatrixRoute.MapPost("/skillsMatrixTablesCheck", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] PostSkillMatrixTableContractsModel postSkillMatrix, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if (role != null && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.Reporting_Manager.ToString()))
                {
                    var result = await skillsMatrixService.GetSkillsMatrixJoinTablesCheckAsync(postSkillMatrix);
                    return result;
                }

                return [];               
            });

            _ = skillMatrixRoute.MapGet("/employeeScoresByTeamId", async ([FromServices] ISkillsMatrixService skillsMatrixService, int teamId, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetEmployeeScoresById(teamId);
                return result;
            });

            return app;
        }
    }
}
