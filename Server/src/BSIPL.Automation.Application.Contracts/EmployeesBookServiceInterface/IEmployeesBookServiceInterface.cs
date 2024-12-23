using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.EmployeesBookModels;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;

namespace BSIPL.Automation.EmployeesBookServiceInterface
{
    public interface IEmployeesBookService : IApplicationService
    {
        Task<IList<ProjectsApplicationContractsModel>> GetProjectListAsync();
        Task<IList<ProjectsApplicationContractsModel>> GetProjectListByEmailAsync(string emailId);
        Task<ProjectsApplicationContractsModel> GetProjectByIdAsync(int id);
        Task<EmployeeSearchContractsModel> GetEmployeesWithSearchListAsync(int projectId, string interests,string sortBy,string searchText,int page,int pageSize, string emailId);
        Task<EmployeeMasterApplicationContractsModel> GetEmployeeDetailByIdAsync(string employeeId);
        Task<EmployeeMasterApplicationContractsModel> GetUpdatedEmployeeDetailByIdAsync(string employeeId);
        Task<int> UpdateEmployeeDetailAsync(string employeeId, EmployeeMasterApplicationContractsModel putEmployeeDetailApplicationContractsModel);
        Task<int> DeleteEmployeeByIdAsync(string employeeId, string emailId);
        Task<IList<EmployeeMasterApplicationContractsModel>> GetUpdatedEmployeeDetailsAsync();
        Task<int> AddEmployeeMasterUpdateAsync(EmployeeMasterApplicationContractsModel postEmployeeDetailApplicationContractsModel);
        Task<int> UpdateEmployeeDetailByIdAsync(string employeeId, EmployeeMasterApplicationContractsModel updatedEmployee);
        Task DeleteUpdatedEmployeeDetailByIdAsync(string employeeId);
        Task<IList<RoleApplicationContractsModel>> GetRoleListAsync();
        Task<AssignedRolesApplicationContractsModel> GetAssignedRoleAsync(string emailId);
        Task<int> AddEmployeeRoleMapAsync(string emailId, EmployeeRoleMapApplicationContractsModel postEmployeeRoleMap);
        Task<int> AddEmployeeExcelAsync(string emailId, IList<EmployeeMasterApplicationContractsModel> postEmployeeExcel);
        Task<IList<EmployeeForRoleApplicationContractsModel>> GetEmployeesAsync();
        Task<IList<DesignationApplicationContractsModel>> GetDesignationsAsync();
        Task UpdateEmployeeImageUrlAsync(string employeeId, string imagePath);
        Task<LoginModelApplicationContractsModel> LoginWindowAuth(LoginModelApplicationContractsModel model, string domain, string instance, string tenantId, string clientId, string resource, string scope, string grantType, string clientSecret);
        Task<IList<AnalyticalReportsApplicationContractsModel>> GetGoogleAnalyticalReport(DateTime startDate, DateTime endDate);
        Task<AnalyticsReportApplicationContractsModel> GetAnalyticsReportAsync(string filter, DateTime startDate, DateTime endDate);
        Task AddLogAsync(LoggerApplicationContractsModel addLog);
    }
}