using Microsoft.AspNetCore.Authorization;
using System.Collections.Generic;
using System;

namespace BSIPL.Automation.Web.Auth
{
    public class RoleRequirement : IAuthorizationRequirement
    {
        public IEnumerable<string> RequiredRoles { get; }

        public RoleRequirement(IEnumerable<string> requiredRole)
        {
            RequiredRoles = requiredRole ?? throw new ArgumentNullException("No Roles Assigned in the policy");
        }
    }
}
