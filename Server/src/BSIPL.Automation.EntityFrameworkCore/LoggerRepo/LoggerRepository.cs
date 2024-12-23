using BSIPL.Automation.EntityFrameworkCore;

using BSIPL.Automation.LoggerRepoInterface;
using BSIPL.Automation.Models;
using BSIPL.Automation.Models.EmployeesBookModels;
using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories.Dapper;
using Volo.Abp.EntityFrameworkCore;

namespace BSIPL.Automation.LoggerRepo
{
    public class LoggerRepository : DapperRepository<AutomationDbContext>, ILoggerRepository
    {
        public LoggerRepository(IDbContextProvider<AutomationDbContext> dbContextProvider) : base(dbContextProvider)
        {

        }

        public async Task AddLog(LoggerModel postLog)
        {
            var dbConnection = await GetDbConnectionAsync();
            var insertQuery = $"INSERT INTO dbo.Logger (LoggerType, LogFrom, Description, Source, CreatedDate) VALUES ('{postLog.LoggerType}','{postLog.LogFrom}', '{postLog.Description.Replace("'", "''")}','{postLog.Source?.Replace("'", "''")}', '{DateTime.Now}')";
            await dbConnection.QueryAsync<LoggerModel>(insertQuery,
               transaction: await GetDbTransactionAsync());
        }

        public async Task<IList<LoggerModel>> GetLogs(string filter)
        {
            var dbConnection = await GetDbConnectionAsync();
            var query = $"SELECT * FROM dbo.Logger WHERE LogFrom = '{filter}'";
            return (await dbConnection.QueryAsync<LoggerModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }
    }
}