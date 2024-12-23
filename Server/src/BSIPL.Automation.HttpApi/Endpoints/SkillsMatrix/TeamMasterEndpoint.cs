using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.Domain.Shared.Enum;

using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BSIPL.Automation.Endpoints.SkillsMatrix
{
    public static class TeamMasterEndpoint
    {
        public static WebApplication MapTeamMasterEndpoints(this WebApplication app)
        {
            var teamMasterRoute = app.MapGroup("api/v1").WithTags("Team");

            _ = teamMasterRoute.MapGet("/teams", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetTeamsAsync(contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString());
                return (result);
            });

            _ = teamMasterRoute.MapPost("/team", async ([FromServices] IValidationService validationService, [FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] TeamMasterApplicationContractsModel postTeam, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if (role != null && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.Reporting_Manager.ToString() || role.RoleName == RoleEnum.HR.ToString()))
                {
                    var validationList = await validationService.ValidateAddTeam(postTeam, emailId);
                    if (validationList.Count > 0)
                    {
                        return Results.BadRequest(validationList);
                    }

                    await skillsMatrixService.AddTeamAsync(postTeam, emailId);
                    return Results.Ok();
                }

                return Results.Unauthorized();

            });

            _ = teamMasterRoute.MapPut("/team", async ([FromServices] IValidationService validationService, [FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] TeamMasterApplicationContractsModel teamDetail, IHttpContextAccessor contextAccessor) =>
             {
                 var emailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
                 var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                 if (role != null && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.Reporting_Manager.ToString() || role.RoleName == RoleEnum.HR.ToString()))
                 {

                     var validationList = await validationService.ValidateUpdateTeam(teamDetail, emailId);
                     if (validationList.Count > 0)
                     {
                         return Results.BadRequest(validationList);

                     }

                     await skillsMatrixService.UpdateTeamDetailAsync(teamDetail, emailId);
                     return Results.Ok();

                 }
                 return Results.Unauthorized();
             });


            _ = teamMasterRoute.MapDelete("/team", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromQuery] int teamId, IHttpContextAccessor contextAccessor) =>
           {
               var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
               var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);

               if ((role != null) && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.HR.ToString()))
               {
                   await skillsMatrixService.DeleteTeamByTeamId(teamId);
               }
               else if (role != null && role.RoleName == RoleEnum.Reporting_Manager.ToString())
               {
                   //also needs to verify that reporting manager belongs to same client of team
                   var teamRecord = await skillsMatrixService.GetTeamByIdAsync(teamId);
                   if (teamRecord.ClientId == role.ClientId)
                   {
                       await skillsMatrixService.DeleteTeamByTeamId(teamId);
                   }
               }
           });

            _ = teamMasterRoute.MapPut("/teamEmployeesDetails", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] EditTeamEmployeesApplicationContractsModel editTeamEmployeesObj, IHttpContextAccessor contextAccessor) =>
            {
                await skillsMatrixService.EditTeamEmployees(editTeamEmployeesObj);
            });

            _ = teamMasterRoute.MapPut("/teamEmployees", async (IHttpContextAccessor contextAccessor, [FromServices] IValidationService validationService, [FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] EditTeamEmployeesUpdateApplicationContractsModel editTeamEmployeesObj) =>
            {
                var emailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if ((role != null) && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.HR.ToString()))
                {
                    var errorList = await validationService.ValidateUpdateEmployee(editTeamEmployeesObj, emailId);
                    if (errorList != null && errorList.Count > 0)
                    {
                        return Results.BadRequest(errorList);
                    }
                    await skillsMatrixService.UpdateEmployee(editTeamEmployeesObj, emailId);
                    return Results.Ok();
                }
                return Results.Unauthorized();
            });

            _ = teamMasterRoute.MapGet("/clientTeams", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromQuery] int ClientId, [FromQuery] string functionType, IHttpContextAccessor contextAccessor) =>
              {
                  var result = await skillsMatrixService.GetClientTeamsAsync(ClientId, functionType);
                  return result;
              });

            _ = teamMasterRoute.MapGet("/clientManagerTeams", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromQuery] int clientId, [FromQuery] string employeeId, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetClientManagerTeamsAsync(clientId, employeeId);
                return result;
            });

            return app;
        }

    }
}
