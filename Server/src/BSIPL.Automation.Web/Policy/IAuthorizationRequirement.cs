using Microsoft.AspNetCore.Authorization;

namespace BSIPL.Automation.Web.Policy
{
    public class AdminRoleRequirement : IAuthorizationRequirement
    {
        public AdminRoleRequirement(string role) => Role = role;
        public string Role { get; set; }
    }
}
