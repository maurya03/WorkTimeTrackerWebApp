using BSIPL.Automation.ApplicationModels;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.SkillsMatrixServiceInterface
{
    public interface IDashboardService
    {
        Task<List<DashboardLineChartModel>> GetDashboardLineChartModelAsync(string clientId, string functionType);

        Task<List<DashboardLineChartModel>> GetDashboardLineChartTrendEmployeeAsync(string clientId, string teamId, string employeeId,string functionType);
        Task<List<dynamic>> GetDashboardBarDataTeamWiseAsync(string clientId,string teamName, string chartType, string functionType);
        
        Task<List<dynamic>> GetDashboardBarChartModelAsync(string clientId, string functionType);

        Task<IList<DashboardShortCut>> GetDashboardBoxDataAsync(string clientId,string startRange, string endRange, string functionType);
        Task<IList<DashboardShortCut>> GetDashboardBoxDataAsync(string clientId, string functionType);

        Task<List<dynamic>> GetDashboardBarChartModelCategoryWiseAsync(string clientId, string functionType);

        Task<List<dynamic>> GetDashboardBarChartCategoryTeamWiseScoreAsync(string clientId, string functionType);
        Task<List<dynamic>> GetDashboardBarChartCategoryTeamWiseScoreAsync(string clientId, string TeamName, string functionType);
    }
}