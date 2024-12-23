using BSIPL.Automation.Endpoints.EmployeesBook;
using BSIPL.Automation.Endpoints;
using BSIPL.Automation.Endpoints.SkillsMatrix;
using Microsoft.AspNetCore.Builder;
using BSIPL.Automation.Endpoints.ShareIdea;
using BSIPL.Automation.Endpoints.V2;
using BSIPL.Automation.Endpoints.Timesheet;
using BSIPL.Automation.Endpoints.ShareIdea;
using BSIPL.Automation.Endpoints.User;

namespace BSIPL.Automation
{
    public static class EndpointsHandler
    {
        public static WebApplication ConfigureEndpoints(this WebApplication app)
        {
            app.MapSkillsMatrixEndpoints();
            app.MapClientMasterEndpoints();
            app.MapTeamMasterEndpoints();
            app.MapCategoryMasterEndpoints();
            app.MapEmployeeDetailsEndpoints();
            app.MapRoleMasterEndpoints();
            app.MapTimeSheetEndPoints();
            app.MapV2TimeSheetEndPoints();
            app.DashBoardEndpoints();
            app.MapEmployeesBookEndpoints();
            app.MapShareIdeaEndpoints();
            app.MapApplicationAccessEndpoint();
            app.MapReportsEndpoints();
            app.MapTimesheetReportsEndpoints();
            app.MapImportEndpoint();
            app.MapUserEndpoints();
            return app;
        }
    }
}