using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.Models;
using BSIPL.Automation.Models.SkillsMatrix;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories;

namespace BSIPL.Automation.SkillsMatrixRepoInterface
{
    public interface ISkillsMatrixRepository : IRepository
    {
        Task<IList<CategoryMasterModel>> GetCategoryListAsync(); 
        Task<IList<CategoryMasterModel>> GetCategoryWithTeamScoreListAsync(int teamId, int isWithScore = 0);
        Task<IList<ClientMasterModel>> GetClientListAsync(string EmailId, int withTeam = 0);
        Task<IList<SkillsMatrixModel>> GetAllSkillsMatrixOrListByEmployeeIdAsync(string employeeId = "0");
        Task<IList<GetSkillsMatrixJoinTablesModel>> GetSkillsMatrixJoinTablesListAsync(string EmailId);
        Task<IList<EmployeeSkillMatrixModel>> SkillMatrixEmployeeList(int? teamId, int? subCategoryId);
        Task<IList<GetSkillsMatrixJoinTablesCheckModel>> GetSkillsMatrixJoinTablesListCheckAsync(PostSkillMatrixTableModel postSkillMatrix);
        Task<IList<SubCategoryMasterModel>> GetSubCategoryListAsync();
        Task<IList<EmployeeDetailsModel>> GetEmployeeDetailsListAsync(string EmailId);
        Task<EmployeeDetailsModel> GetEmployeeDetailsAsync(string emailId);
        Task<IList<SubCategoryMasterModel>> GetSubCategoryAndCategoryListAsync(int categoryId);
        Task<IList<EmployeeDetailsModel>> GetEmployeeDetailsTeamWiseListAsync(int teamId);
        Task<IList<TeamMasterModel>> GetTeamListAsync(string EmailId);
        Task<IList<TeamMasterModel>> GetClientTeamListAsync(int clientId, string functionType);
        Task<IList<TeamMasterModel>> GetClientManagerTeamListAsync(int clientId, string employeeId);
        Task<IList<SubCategoryMappingModel>> GetSubCategoryMappingListAsync();
        Task<IList<SubCategoryMappingModel>> GetTeamSubCategoryMappingListAsync(int team);
        Task AddClientAsync(ClientMasterModel postClient, string emailId);
        Task AddTeamAsync(TeamMasterModel postTeam, string emailId);
        Task UpdateTeamDetailAsync(TeamMasterModel TeamDetail, string emailId);
        Task AddCategoryAsync(CategoryMasterModel postCategory, string emailId);
        Task AddEmployeeAsync(EmployeeDetailsModel postEmployee);
        Task<EmployeeMasterModel> GetEmployeeMasterByEmailIdAsync(string EmailId);

        Task AddSubCategoryMappingAsync(SubCategoryMappingModel postSubCategoryMapping, string emailId);
        Task<IList<SubCategoryMappingModel>> UpdateSubCategoryMappingAsync(SubCategoryMappingModel putSubCategoryMapping);
        Task AddSubCategoryMasterAsync(SubCategoryMasterModel postSubCategory, string emailId);
        Task AddSkillMatrixAsync(SkillsMatrixModel postSkillsMatrix, string emailId);
        Task<IList<SkillsMatrixModel>> GetEmployeeScores(int teamId, string employeeId = "0");
        Task DeleteEmployee(string employeeId);
        Task DeleteTeam(int teamId);
        Task DeleteClient(int Id);
        Task DeleteSubCategory(int subCategoryId);
        Task DeleteCategory(int Id);
        Task EditClient(Models.SkillsMatrix.EditClientTeamsModel editClient, string emailId);
        Task EditCategorySubcategory(EditCategorySubcategoryModel editCategorySubcategoryObj);
        Task EditCategoryAsync(CategoryMasterModel editCategory, int? Id, string emailId);
        Task EditSubCategoryAsync(SubCategoryMasterModel subCategory, int? Id, string emailId);
        Task EditTeamEmployees(EditTeamEmployeesModel editTeamEmployeesObj);
        Task updateEmployees(EditTeamEmployeesModelUpdate editTeamEmployeesObj);

        Task<IList<RolesModel>> GetRoleListAsync();
        Task<RolesModel?> GetRoleByIdAsync(int roleId);
        Task<IList<EmployeeRolesModel>> GetEmployeeRolesListAsync();
        Task<IList<EmployeeRolesModel>> GetEmployeeRolesListByEmployeeIdAsync(string employeeId);

        Task<TeamMasterModel?> GetTeamByIdAsync(int? teamId = 0);

        Task AddEmployeeRole(int employeeId, int RoleId);
        Task EditEmployeeRole(int EmployeeRoleID, int RoleId);
        Task DeleteEmployeeRole(int EmployeeRoleID);

        Task<EmployeeWithRoleModel> GetEmployeeRoleDetailByEmailIdAsync(string EmailId);

        Task PostEmployeeWithRoleAsync(EmployeeRoleDetailApplicationContractsModel postEmployeeWithRole, string emailId);

        Task<IList<ApplicationAccessContractModel?>> GetApplicationAccessListAsync(string? emailId);

        Task<IList<dynamic>> GetReportByCategoryAndClientAsync(string emailId, int categoryId, int clientId);
        Task<IList<SkillSegementCategoryModel>> SkillsSegmentByCategoryAsync(string emailId, int? categoryId, int? clientId, int? teamId, int year, int month);
        Task<IList<EmployeeTypeModel>> GetEmployeeTypes();
        Task<IList<dynamic>> GetEmployeeScoreReportByCategoryClientAsync(PostSkillMatrixReportModel postSkillsMatrix, string EmailId);
        Task ExecuteArchiveProcess();
        Task SaveOrUpdateArchiveProcessLog(DateTime month, string status);

        Task<IList<DesignationsModel>> GetEmployeeDesignations();
        Task<IList<EmployeeDetailsModel>> GetAllEmployeeListSm(int teamId = 0);
    }
}