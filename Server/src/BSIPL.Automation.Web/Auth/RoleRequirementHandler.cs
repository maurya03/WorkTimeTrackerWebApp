using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using BSIPL.Automation.SkillsMatrixService;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using static BSIPL.Automation.Web.Middleware.AuthMiddleware;
using System.Collections.Generic;
using BSIPL.Automation.ApplicationModels.Timesheet;
using BSIPL.Automation.SkillsMatrixServiceInterface;

namespace BSIPL.Automation.Web.Auth
{

    public class RoleRequirementHandler : AuthorizationHandler<RoleRequirement>
    {
        private readonly List<RoleHierarchy> roleHierarchies = new List<RoleHierarchy> { new RoleHierarchy { RoleName = "Reporting_Manager", DefaultRoles = { "Employee", "Approver", "Manager" } }, new RoleHierarchy { RoleName = "Approver", DefaultRoles = { "Employee", "Approver" } }, new RoleHierarchy { RoleName = "Employee", DefaultRoles = { "Employee"} } };        
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ISkillsMatrixService _skillsMatrixService;
        public RoleRequirementHandler(IHttpContextAccessor httpContextAccessor, ISkillsMatrixService skillsMatrixService)
        {
            _httpContextAccessor = httpContextAccessor;
            _skillsMatrixService = skillsMatrixService;
        }

        protected async override Task HandleRequirementAsync(AuthorizationHandlerContext context, RoleRequirement roleRequirement)
        {
            
            var httpContext = _httpContextAccessor.HttpContext;            
            var token = httpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");            
            if (!string.IsNullOrEmpty(token))
            {
                try
                {
                    var userEmailId = GetEmailAddressFromToken(token);
                    httpContext.Request.Headers["emailId"] = userEmailId;

                    var empDetails = await _skillsMatrixService.GetRoleByEmailIdAsync(userEmailId);
                    httpContext.Request.Headers["employeeId"] = empDetails.EmployeeId.ToString() ?? throw new InvalidOperationException("EmployeeId not found ");
                    httpContext.Request.Headers["teamId"] = empDetails.TeamId.ToString() ?? throw new InvalidOperationException("teamId not found ");
                    var defaultsRoles = roleHierarchies.Where(x => x.RoleName == empDetails?.RoleName).ToList().SingleOrDefault();
                    bool containsAny = roleRequirement.RequiredRoles.ToList().Any(role => defaultsRoles!.DefaultRoles.Any(defaultsRole => string.Equals(role, defaultsRole, StringComparison.OrdinalIgnoreCase)));
                    if (containsAny)
                    {
                        context.Succeed(roleRequirement);
                    }
                    else
                    {
                        context.Fail();
                    }
                }
                catch (Exception)
                {
                    BaseResponse response = new BaseResponse(StatusCodes.Status401Unauthorized, "Unauthorized");
                    httpContext.Response.StatusCode = response.StatusCode;
                    httpContext.Response.ContentType = "application/json";
                }
            }           
            else
            {
                BaseResponse response = new BaseResponse(StatusCodes.Status401Unauthorized, "Unauthorized");
                httpContext.Response.StatusCode = response.StatusCode;
                httpContext.Response.ContentType = "application/json";
            }
        }
        private string GetEmailAddressFromToken(string token)
        {
            var email = string.Empty;
            if (!string.IsNullOrEmpty(token))
            {
                var handler = new JwtSecurityTokenHandler();
                var readToken = handler.ReadJwtToken(token);
                email = readToken.Claims.First(claim => claim.Type == "upn").Value; // By default, on Azure AD the UPN is set to [email protected] to ensure a globally unique value
            }
            return email;
        }
    }
}
