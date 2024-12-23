using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using System.Collections.Generic;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;

namespace BSIPL.Automation.SkillsMatrixServiceInterface
{
    public interface ISkillsMatrixService : IApplicationService
    {
        Task<IList<CategoryMasterApplicationContractsModel>> GetCategoryListAsync(); 
        Task<IList<CategoryMasterApplicationContractsModel>> GetCategoryWithTeamScoreListAsync(int teamId, int isWithScore = 0);
        Task<IList<ClientMasterApplicationContractsModel>> GetClientAsync(string emailId, int withTeam = 0);
        Task<IList<TeamMasterApplicationContractsModel>> GetClientTeamsAsync(int clientId, string functionType);
        Task<IList<TeamMasterApplicationContractsModel>> GetClientManagerTeamsAsync(int clientId, string employeeId);
        Task<IList<SkillsMatrixApplicationContractsModel>> GetAllSkillsMatrixAsync();
        Task<IList<GetSkillsMatrixJoinTablesApplicationContractsModel>> GetSkillsMatrixJoinTablesAsync(string EmailId);

        Task<IList<GetSkillsMatrixJoinTablesApplicationContractsModel>> GetSkillsMatrixJoinTablesCheckAsync(PostSkillMatrixTableContractsModel postSkillMatrix);

        Task<IList<SubCategoryMasterApplicationContractsModel>> GetSubCategoryListAsync();
        Task<IList<TeamMasterApplicationContractsModel>> GetTeamsAsync(string EmailId);
        Task<IList<SubCategoryMasterApplicationContractsModel>> GetSubCategoryByCategoryIdAsync(int categoryId);
        Task<IList<SubCategoryMappingApplicationContractsModel>> GetSubCategoryMappingAsync();
        Task<IList<SubCategoryClientMappingScoreModel>> GetTeamSubCategoryByIdAsync(int teamId);
        Task<IList<EmployeeDetailsApplicationContractsModel>> GetEmployeeDetailsAsync(string EmailId);
        Task<EmployeeDetailsApplicationContractsModel> GetEmployeeDetailByEmailIdAsync(string EmailId);
        Task<IList<EmployeeDetailsApplicationContractsModel>> GetEmployeesByTeamIdAsync(int TeamId);
        Task<EmployeeMasterApplicationContractsModel> GetEmployeeMasterByEmailIdAsync(string EmailId);

        Task<IList<SkillsMatrixApplicationContractsModel>> GetEmployeeScoresById(int teamId);

        Task AddClientAsync(ClientMasterApplicationContractsModel postClient, string emailId);
        Task AddTeamAsync(TeamMasterApplicationContractsModel postTeam, string emailId);
        Task UpdateTeamDetailAsync(TeamMasterApplicationContractsModel teamDetail, string emailId);
        Task AddEmployeeAsync(EmployeeDetailsApplicationContractsModel postEmployee, string emailId);
        Task AddCategoryAsync(CategoryMasterApplicationContractsModel postCategory, string emailId);
        Task AddSubCategoryAsync(SubCategoryMasterApplicationContractsModel postSubCategory, string emailId);
        Task AddSubCategoryMappingAsync(IList<PostSubCategoryMappingApplicationContractsModel> postSubCategoryMapping, string emailId);
        Task AddSkillMatrixAsync(IList<EmployeeScoreModel> postSkillMatrix, string emailId);
        Task EditCategoryAsync(CategoryMasterApplicationContractsModel Category, int? id, string emailId);
        Task EditSubCategoryAsync(SubCategoryMasterApplicationContractsModel subCategory, int? Id, string emailId);

        Task UpdateSubCategoryMappingAsync(SubCategoryMappingApplicationContractsModel putSubCategoryMapping);
        Task DeleteEmployeeByIdAsync(string employeeId);
        Task DeleteTeamByTeamId(int teamId);
        Task DeleteClient(int Id);
        Task DeleteCategory(int Id);
        Task DeleteSubCategoryById(int subCategoryId);
        Task EditClient(EditClientTeamsApplicationContractsModel editClientTeams, string emailId);
        Task EditCategorySubcategory(EditCategorySubcategoryApplicationContractsModel editCategorySubcategoryObj);
        Task EditTeamEmployees(EditTeamEmployeesApplicationContractsModel editTeamEmployeesObj);
        Task UpdateEmployee(EditTeamEmployeesUpdateApplicationContractsModel editTeamEmployeesObj, string emailId);

        Task<EmployeeWithRoleModel?> GetRoleByEmailIdAsync(string? EmailId);
        Task<IList<RolesApplicationContractsModel>> GetRoleListAsync();
        Task<RolesApplicationContractsModel> GetRoleByIdAsync(int RoleId);
        Task<IList<EmployeeRolesApplicationContractsModel>> GetEmployeeRolesListAsync();
        Task<IList<EmployeeRolesApplicationContractsModel>> GetEmployeeRolesListByEmployeeIdAsync(string EmployeeId);

        Task AddEmployeeRole(int employeeId, int RoleId);
        Task EditEmployeeRole(int EmployeeRoleID, int RoleId);
        Task DeleteEmployeeRole(int EmployeeRoleID);

        Task<TeamMasterApplicationContractsModel> GetTeamByIdAsync(int? teamId = 0);
        Task<IList<EmployeeRoleDetailApplicationContractsModel>> GetEmployeeRoleDetail(int teamId = 0);

        Task PostEmployeeWithRoleAsync(IList<EmployeeRoleDetailApplicationContractsModel> postEmployeeWithRole, string emailId);

        Task<IList<ApplicationAccessModel?>> GetApplicationAccessList(string? EmailId);

        Task<IList<dynamic>> GetReportByCategoryAndClientAsync(string emailId, int categoryId, int clientId);
        Task<IList<SkillSegementCategoryApplicationContractModel>> SkillsSegmentByCategoryAsync(string emailId, int? categoryId, int? clientId, int? teamId, int year, int month);
        Task<IList<EmployeeTypeApplicationContractsModel>> GetEmployeeTypeApplicationContractsListAsync();
        Task<IList<dynamic>> GetEmployeeScoreReportByCategoryClientAsync(PostSkillMatrixReportModel postSkillMatrix, string EmailId);
        Task<IList<RolesApplicationContractsModel>> GetEmployeeRoleListAsync();
        Task<IList<DesignationsApplicationContractsModel>> GetEmployeeDesignationListAsync();
        Task ExecuteAndLogArchiveProcess(string status);
    }
}