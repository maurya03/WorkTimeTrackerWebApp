using BSIPL.Automation.Domain.Shared.Enum;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;

namespace BSIPL.Automation.Web.Policy
{
    public class AdminRoleRequirementHandler : AuthorizationHandler<AdminRoleRequirement>
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ISkillsMatrixService _skillsMatrixService;
        public AdminRoleRequirementHandler(IHttpContextAccessor httpContextAccessor, ISkillsMatrixService skillsMatrixService)
        {
            _httpContextAccessor = httpContextAccessor;
            _skillsMatrixService = skillsMatrixService;
        }

        protected override async Task HandleRequirementAsync(AuthorizationHandlerContext context, AdminRoleRequirement requirement)
        {
            var role = await _skillsMatrixService.GetRoleByEmailIdAsync(_httpContextAccessor.HttpContext.Request.Headers["emailId"].ToString());
            if (role != null && role.RoleName == RoleEnum.Admin.ToString())
            {
                context.Succeed(requirement);
            }
            else
            {

                _httpContextAccessor.HttpContext.Response.StatusCode = StatusCodes.Status401Unauthorized;
                _httpContextAccessor.HttpContext.Response.ContentType = "application/json";
                await _httpContextAccessor.HttpContext.Response.WriteAsJsonAsync(new { StatusCode = StatusCodes.Status401Unauthorized, Message = "Unauthorized. Required admin role." });
                await _httpContextAccessor.HttpContext.Response.CompleteAsync();

                context.Fail();

            }

        }
    }
}
