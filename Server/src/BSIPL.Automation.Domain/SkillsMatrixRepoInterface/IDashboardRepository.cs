using BSIPL.Automation.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.SkillsMatrixRepoInterface
{
    public interface IDashboardRepository
    {
        Task<IList<dynamic>> DashboardLineData(string clientId, string functionType);
        Task<IList<dynamic>> DashboardLineDataTrendEmployeeWise(string clientId,string teamId, string employeeId,string functionType);
        Task<IList<DashboardDomainShortCut>> DashboardShortCut(string clientId, string startRange, string endRange, string functionType);
        Task<IList<dynamic>> DashboardBarDataTeamWise(string clientId, string teamName, string functionType);
        Task<IList<DashboardDomainShortCut>> DashboardShortCut(string clientId, string functionType);
    }
}