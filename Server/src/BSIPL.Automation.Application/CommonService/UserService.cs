using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.CommonServiceInterface;
using Microsoft.AspNetCore.Http;
using System;
using System.Threading.Tasks;

namespace BSIPL.Automation.CommonService
{
    public class UserService : IUserService
    {
        private readonly IHttpContextAccessor contextAccessor;
        public UserService(IHttpContextAccessor _contextAccessor)
        {
            contextAccessor = _contextAccessor;

        }
        public Task<UserApplicationContractsModel> UserInfo()
        {
            var EmailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            if (string.IsNullOrEmpty(EmailId))
                throw new Exception("Login EmailId is null or empty");
            var result = new UserApplicationContractsModel() { EmailId = EmailId };
            return Task.FromResult(result);
        }
    }
}
