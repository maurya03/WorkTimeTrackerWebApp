using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc;

namespace BSIPL.Automation.Endpoints.SkillsMatrix
{
    public static class DashboardEndpoint
    {
        public static WebApplication DashBoardEndpoints(this WebApplication app)
        {
            _ = app.MapGet("/api/v1/dashboard/line/{clientId}", async (string clientId, [FromQuery] string functionType,[FromServices] IDashboardService dashboardService) =>
            {
                var lineChartList = await dashboardService.GetDashboardLineChartModelAsync(clientId, functionType);
                return lineChartList;
            });

            _ = app.MapGet("/api/v1/dashboard/line/clients/{clientId}/teams/{teamId}/employees/{bhavnaEmployeeId}", async (string clientId, string teamId, string bhavnaEmployeeId, [FromQuery] string functionType,[FromServices] IDashboardService dashboardService) =>
            {
                var lineChartList = await dashboardService.GetDashboardLineChartTrendEmployeeAsync(clientId, teamId, bhavnaEmployeeId, functionType);
                return lineChartList;
            });

            _ = app.MapGet("/api/v1/dashboard/bar/{clientId}", async (string clientId, [FromQuery] string functionType,[FromServices] IDashboardService dashboardService) =>
            {
                var barChartList = await dashboardService.GetDashboardBarChartModelAsync(clientId, functionType);
                return barChartList;
            });

            _= app.MapGet("/api/v1/dashboard/bar/clients/{clientId}/teams/{teamName}", async (string clientId, string teamName, [FromQuery] string functionType,[FromQuery] string chartType,[FromServices] IDashboardService dashboardService) =>
            {
                var barChartList = await dashboardService.GetDashboardBarDataTeamWiseAsync(clientId, teamName, chartType,functionType);
                return barChartList;
            });

            _ = app.MapGet("/api/v1/dashboard/shortcutbox/{clientId}", async (string clientId, [FromQuery] string startRange, [FromQuery] string endRange, [FromQuery] string functionType, [FromServices] IDashboardService dashboardService) =>
            {
                var boxDataList = await dashboardService.GetDashboardBoxDataAsync(clientId, startRange, endRange, functionType);
                return boxDataList;
            });

            _ = app.MapGet("/api/v1/dashboard/shortcutbox/scorenotmaintained/{clientId}", async (string clientId, [FromQuery] string functionType, [FromServices] IDashboardService dashboardService) =>
            {
                var boxDataList = await dashboardService.GetDashboardBoxDataAsync(clientId, functionType);
                return boxDataList;
            });

            _ = app.MapGet("/api/v1/dashboard/bar/teamwise/{clientId}", async (string clientId, [FromQuery] string functionType,[FromServices] IDashboardService dashboardService) =>
            {
                var barDataList = await dashboardService.GetDashboardBarChartModelCategoryWiseAsync(clientId, functionType);
                return barDataList;
            });

            _ = app.MapGet("/api/v1/dashboard/bar/teamwisescore/clients/{clientId}", async (string clientId, [FromQuery] string functionType,[FromServices] IDashboardService dashboardService) =>
            {
                var barChartTeamList = await dashboardService.GetDashboardBarChartCategoryTeamWiseScoreAsync(clientId, functionType);
                return barChartTeamList;
            });

            _ = app.MapGet("/api/v1/dashboard/bar/categorywiseempscore/clients/{clientId}", async (string clientId, [FromQuery] string functionType,[FromQuery] string TeamName, [FromServices] IDashboardService dashboardService) =>
            {
                var barChartCategoryList = await dashboardService.GetDashboardBarChartCategoryTeamWiseScoreAsync(clientId, TeamName, functionType);
                return barChartCategoryList;
            });

           

            return app;
        }
    }
}
