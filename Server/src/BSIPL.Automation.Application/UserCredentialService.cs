using BSIPL.Automation.ApplicationModels.UserCredential;
using BSIPL.Automation.Domain.Interface;
using BSIPL.Automation.EntityFrameworkCore;
using BSIPL.Automation.ScheduledTaskServiceInterface;
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;
using Volo.Abp.ObjectMapping;

namespace BSIPL.Automation
{
    public class UserCredentialService : IUserCredentialService
    {
        private readonly IUserCredentialRepository _userCredentialRepository;
        public IObjectMapper<AutomationEntityFrameworkCoreModule> _objectMapper { get; }
        public IHttpContextAccessor _contextAccessor;

        /// <summary>
        /// Constructor to inject repository.
        /// </summary>
        /// <param name="userCredentialRepository"></param>
        /// <param name="objectMapper"></param>
        /// <param name="contextAccessor"></param>
        public UserCredentialService(IUserCredentialRepository userCredentialRepository, IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper, IHttpContextAccessor contextAccessor)
        {
            _userCredentialRepository = userCredentialRepository;
            _objectMapper = objectMapper;
            _contextAccessor = contextAccessor;
        }
        /// <summary>
        /// Register User.
        /// </summary>
        /// <param name="loginUserDetails"></param>
        /// <returns></returns>
        public async Task AddUser(LoginUserDetails loginUserDetails)
        {
            await _userCredentialRepository.RegisterUser(loginUserDetails);
        }

        /// <summary>
        /// Validate User during login.
        /// </summary>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public async Task<bool> ValidateUser(string email, string password)
        {
            var userDetails = await _userCredentialRepository.LoginUser(email, password);
            if (userDetails.Email == email)
                return true;
            else return false;
        }
    }
}
