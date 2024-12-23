using BSIPL.Automation.ApplicationModels.UserCredential;
using BSIPL.Automation.EntityFrameworkCore;
using Dapper;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories.Dapper;
using Volo.Abp.EntityFrameworkCore;

namespace BSIPL.Automation
{
    public class UserCredentialRepository : DapperRepository<AutomationDbContext>, IUserCredentialRepository
    {
        public UserCredentialRepository(IDbContextProvider<AutomationDbContext> dbContextProvider) : base(dbContextProvider)
        {

        }
        public async Task<LoginUserDetails> LoginUser(string emailId, string password)
        {
            var dbConnection = await GetDbConnectionAsync();
            return await dbConnection.QuerySingleOrDefaultAsync<LoginUserDetails>($"EXEC usp_getUserDetailsByEmailId {emailId}",
                transaction: await GetDbTransactionAsync());
        }

        public async Task RegisterUser(LoginUserDetails loginUserDetails)
        {
            var dbConnection = await GetDbConnectionAsync();
            await dbConnection.QuerySingleOrDefault($"EXEC usp_insertUserRegistrationDetail",
                transaction: await GetDbTransactionAsync());
        }
    }
}
