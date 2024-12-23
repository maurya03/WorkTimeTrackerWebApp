using BSIPL.Automation.ApplicationModels.UserCredential;
using System.Threading.Tasks;

namespace BSIPL.Automation
{
    public interface IUserCredentialRepository
    {
        /// <summary>
        /// Save the details of registering user.
        /// </summary>
        /// <param name="loginUserDetails"></param>
        /// <returns></returns>
        Task RegisterUser(LoginUserDetails loginUserDetails);

        /// <summary>
        /// Get the registered User details.
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        Task<LoginUserDetails> LoginUser(string userName, string password);
    }
}
