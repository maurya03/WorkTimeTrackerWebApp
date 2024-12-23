using BSIPL.Automation.EntityFrameworkCore;
using BSIPL.Automation.Models;
using BSIPL.Automation.SkillsMatrixRepoInterface;
using Dapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories.Dapper;
using Volo.Abp.EntityFrameworkCore;

namespace BSIPL.Automation.SkillsMatrixRepo
{
    public class DashboardRepository : DapperRepository<AutomationDbContext>, IDashboardRepository
    {
        public DashboardRepository(IDbContextProvider<AutomationDbContext> dbContextProvider) : base(dbContextProvider)
        {

        }

        public async Task<IList<dynamic>> DashboardBarDataTeamWise(string clientId, string teamName,string FunctionType)
        {
            var query = $"exec usp_dashboard_lineData_teamwise {clientId},'{teamName}','{FunctionType}'";
            var dbConnection = await GetDbConnectionAsync();
            var dashBoardList = (await dbConnection.QueryAsync(query,
                transaction: await GetDbTransactionAsync())).ToDynamicList();
            return dashBoardList;
        }

        public async Task<IList<dynamic>> DashboardLineData(string clientId, string functionType)
        {
            var query = $"exec usp_dashboard_lineData {clientId},'{functionType}'";
            var dbConnection = await GetDbConnectionAsync();
            var dashBoardLineList = (await dbConnection.QueryAsync(query,
                transaction: await GetDbTransactionAsync())).ToDynamicList();
            return dashBoardLineList;
        }

        public async Task<IList<dynamic>> DashboardLineDataTrendEmployeeWise(string clientId, string teamId, string bhavnaEmployeeId,string functionType)
        {
            var query = $"exec usp_gettrendlinedataemployee {clientId},{teamId},'{bhavnaEmployeeId}','{functionType}'";
            var dbConnection = await GetDbConnectionAsync();
            var lineDataList = (await dbConnection.QueryAsync(query,
                transaction: await GetDbTransactionAsync())).ToDynamicList();
            return lineDataList;
        }

        public async Task<IList<DashboardDomainShortCut>> DashboardShortCut(string clientId, string startRange, string endRange, string functionType)
        {           
            var query = $"exec usp_dashboardshortcut {clientId}, {startRange},{endRange},'{functionType}'";
            var dbConnection = await GetDbConnectionAsync();
            var domainShortCutList = (await dbConnection.QueryAsync<DashboardDomainShortCut>(query,
                transaction: await GetDbTransactionAsync())).ToList();
            return domainShortCutList;
        }

        public async Task<IList<DashboardDomainShortCut>> DashboardShortCut(string clientId, string functionType)
        {           
            var query = $"exec usp_GetEmployeeSkillNotAvailable {clientId},'{functionType}'";
            var dbConnection = await GetDbConnectionAsync();
            var domainShortCutList = (await dbConnection.QueryAsync<DashboardDomainShortCut>(query,
                transaction: await GetDbTransactionAsync())).ToList();
            return domainShortCutList;
        }
    }
}