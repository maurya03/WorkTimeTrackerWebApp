using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.Domain.Shared.Enum;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BSIPL.Automation.Endpoints.SkillsMatrix
{
    public static class ClientMasterEndpoint
    {
        public static WebApplication MapClientMasterEndpoints(this WebApplication app)
        {
            var clientRoute = app.MapGroup("api/v1").WithTags("Client");

            _ = clientRoute.MapGet("/clients", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor, [FromQuery] int isWithTeam) =>
            {
                var result = await skillsMatrixService.GetClientAsync(contextAccessor.HttpContext.Request.Headers["emailId"].ToString(), isWithTeam);
                return (result);
            });

            _ = clientRoute.MapDelete("/client", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromQuery] int Id, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if ((role != null) && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.HR.ToString()))
                {
                    await skillsMatrixService.DeleteClient(Id);
                    return Results.Ok();
                }
                return Results.Unauthorized();
            });

            _ = clientRoute.MapPut("/client", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] EditClientTeamsApplicationContractsModel editClientTeamsObj, IHttpContextAccessor contextAccessor, [FromServices] IValidationService validationService) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if ((role != null) && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.HR.ToString()))
                {
                    var validationList = await validationService.ValidateUpdateClient(editClientTeamsObj, emailId);
                    if (validationList.Count > 0)
                    {
                        return Results.BadRequest(validationList);
                    }

                    await skillsMatrixService.EditClient(editClientTeamsObj, emailId);
                    return Results.Ok();
                }
                return Results.Unauthorized();

            });

            _ = clientRoute.MapPost("/client", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] ClientMasterApplicationContractsModel postClient, IHttpContextAccessor contextAccessor, [FromServices] IValidationService validationService) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if ((role != null) && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.HR.ToString()))
                {
                    var validationList = await validationService.ValidateAddClient(postClient, emailId);
                    if (validationList.Count > 0)
                    {
                        return Results.BadRequest(validationList);
                    }

                    await skillsMatrixService.AddClientAsync(postClient, emailId);
                    return Results.Ok();
                }
                return Results.Unauthorized();

            });
            return app;
        }
    }
}
