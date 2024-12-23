using BSIPL.Automation.ApplicationModels.UserCredential;
using System.Threading.Tasks;

namespace BSIPL.Automation
{
    public interface IUserCredentialService
    {
        /// <summary>
        /// Register User
        /// </summary>
        /// <param name="loginUserDetails"></param>
        /// <returns></returns>
        Task AddUser(LoginUserDetails loginUserDetails);

        /// <summary>
        /// Validate User, who is trying to login.
        /// </summary>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        Task<bool> ValidateUser(string username, string password);
    }
}
