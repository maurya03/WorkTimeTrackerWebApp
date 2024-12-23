using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.Domain.Shared.Enum;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace BSIPL.Automation.Endpoints.SkillsMatrix
{
    public static class EmployeeDetailsEndpoint
    {
        public static WebApplication MapEmployeeDetailsEndpoints(this WebApplication app)
        {
            var employeeDetailsRoute = app.MapGroup("api/v1").WithTags("EmployeeDetails");

            _ = employeeDetailsRoute.MapGet("/employeesDetails", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetEmployeeDetailsAsync(contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString());
                return (result);
            });

            _ = employeeDetailsRoute.MapPost("/employeeDetails", async ([FromServices] IValidationService validationService,[FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] EmployeeDetailsApplicationContractsModel postEmployee, IHttpContextAccessor contextAccessor) =>
            {
       
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);

                if ((role != null) && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.HR.ToString()))
                {
                    var errorList = await validationService.ValidateAddEmployee(postEmployee, emailId);
                    if (errorList != null && errorList.Count >0)
                    {
                        return Results.BadRequest(errorList);
                    }
                        await skillsMatrixService.AddEmployeeAsync(postEmployee, emailId);
                    return Results.Ok();
                }
                return Results.Unauthorized();

            });

            _ = employeeDetailsRoute.MapDelete("/employeeDetails", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromServices] IValidationService validationService,[FromQuery] string employeeId, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);

                if (role == null && role.RoleName != RoleEnum.Admin.ToString())
                {
                    return Results.Unauthorized();
                }

                await skillsMatrixService.DeleteEmployeeByIdAsync(employeeId);
                return Results.Ok();
            });

            _ = employeeDetailsRoute.MapGet("/employeeDetailsByTeamId", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromQuery] int TeamId, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetEmployeesByTeamIdAsync(TeamId);
                return result;
            });
            _ = employeeDetailsRoute.MapGet("/employeeType", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetEmployeeTypeApplicationContractsListAsync();
                return result;
            });

            _ = employeeDetailsRoute.MapGet("/employeerole", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();

                var result = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                return result;
            });
            _ = employeeDetailsRoute.MapGet("/employeeRoles", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetEmployeeRoleListAsync();
                return result;
            });
            _ = employeeDetailsRoute.MapGet("/employeeDesignation", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetEmployeeDesignationListAsync();
                return result;
            });

            return app;
        }
    }
}
