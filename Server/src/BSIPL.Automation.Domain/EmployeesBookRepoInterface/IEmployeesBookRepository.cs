using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.EmployeesBookModels;
using BSIPL.Automation.Models;
using BSIPL.Automation.Models.EmployeesBookModels;
using BSIPL.Automation.Models.Timesheet;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories;

namespace BSIPL.Automation.EmployeesBookRepoInterface
{
    public interface IEmployeesBookRepository : IRepository
    {
        Task<IList<ProjectsModel>> GetProjectListAsync();
        Task<IList<ProjectsModel>> GetProjectListByEmailAsync(string emailId);
        Task<ProjectsModel> GetProjectByIdAsync(int id);
        Task<EmployeeSearchContractsModel> GetEmployeesWithSearchListAsync(int projectId, string interests, string sortBy, string searchText, int page, int pageSize, string emailId);
        Task<EmployeeMasterModel> GetEmployeeDetailByIdAsync(string employeeId);
        Task<EmployeeMasterModel> GetUpdatedEmployeeDetailByIdAsync(string employeeId);
        Task DeleteUpdatedEmployeeDetailByIdAsync(string employeeId);
        Task<IList<EmployeeMasterModel>> GetUpdatedEmployeeDetailsAsync();
        Task<int> AddEmployeeMasterUpdateAsync(EmployeeMasterModel employeeMasterModel);
        Task<int> UpdateEmployeeDetailAsync(string employeeId, EmployeeMasterModel employeeMasterModel);
        Task<int> DeleteEmployeeByIdAsync(string employeeId, string emailId);
        Task<IList<UserRoleModel>> GetRoleListAsync();
        Task<AssignedRolesModel> GetAssignedRoleAsync(string emailId);
        Task<int> AddEmployeeRoleMapAsync(string emailId, EmployeeRoleMapModel postEmployeeRoleMap);
        Task<int> AddEmployeeExcelAsync(string emailId, IList<EmployeeMasterApplicationContractsModel> postEmployeeExcel);
        Task<IList<EmployeeForRoleApplicationContractsModel>> GetEmployeesAsync();
        Task<IList<DesignationApplicationContractsModel>> GetDesignationsAsync();
        Task UpdateEmployeeImageUrlAsync(string employeeId, string imagePath);
        Task<string> GetUserDetailByEmailIdAsync(string emailId);
        Task<AnalyticsReportApplicationContractsModel> GetAnalyticsReportAsync(string filter, DateTime startDate, DateTime endDate);
    }
}