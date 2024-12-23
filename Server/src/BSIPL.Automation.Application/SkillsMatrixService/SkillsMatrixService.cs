using BSIPL.Automation.EntityFrameworkCore;
using BSIPL.Automation.SkillsMatrixRepoInterface;
using BSIPL.Automation.SkillsMatrixServiceInterface;

//using BSIPL.Automation.StoryTrackerRepoInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Volo.Abp.ObjectMapping;
using BSIPL.Automation.Models.SkillsMatrix;
using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.Models;

namespace BSIPL.Automation.SkillsMatrixService
{
    public class SkillsMatrixService : ISkillsMatrixService
    {
        private readonly ISkillsMatrixRepository skillMatrixRepository;
        public IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper { get; }

        public SkillsMatrixService(ISkillsMatrixRepository skillsMatrixRepository, IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper)
        {
            this.skillMatrixRepository = skillsMatrixRepository;
            this.objectMapper = objectMapper;
        }



        public async Task<IList<GetSkillsMatrixJoinTablesApplicationContractsModel>> GetSkillsMatrixJoinTablesAsync(string EmailId)
        {
            var domainResult = await skillMatrixRepository.GetSkillsMatrixJoinTablesListAsync(EmailId);
            return domainResult.Select(item => objectMapper.Map<GetSkillsMatrixJoinTablesModel,
                GetSkillsMatrixJoinTablesApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<GetSkillsMatrixJoinTablesApplicationContractsModel>> GetSkillsMatrixJoinTablesCheckAsync(PostSkillMatrixTableContractsModel postSkillMatrix)
        {
            var postSkillsMatrix = objectMapper.Map<PostSkillMatrixTableContractsModel, PostSkillMatrixTableModel>(postSkillMatrix);
            var domainResult = await skillMatrixRepository.GetSkillsMatrixJoinTablesListCheckAsync(postSkillsMatrix);
            var applicationResult = new List<GetSkillsMatrixJoinTablesApplicationContractsModel>();

            foreach (var item in domainResult)
            {
                var employees = (await skillMatrixRepository.SkillMatrixEmployeeList(item.teamId, item.subCategoryId)).ToList();
                var empAppResult = new List<EmployeeSkillScoreModel>();
                foreach (var employee in employees)
                {
                    employee.SubCategoryId = item.subCategoryId;
                    var empStory = objectMapper.Map<EmployeeSkillMatrixModel, EmployeeSkillScoreModel>(employee);
                    empAppResult.Add(empStory);
                }
                var applicationStory = objectMapper.Map<GetSkillsMatrixJoinTablesCheckModel, GetSkillsMatrixJoinTablesApplicationContractsModel>(item);
                applicationStory.EmployeeList = empAppResult;
                applicationResult.Add(applicationStory);
            }
            return applicationResult;
        }

        public async Task<IList<SkillsMatrixApplicationContractsModel>> GetAllSkillsMatrixAsync()
        {
            var domainResult = await skillMatrixRepository.GetAllSkillsMatrixOrListByEmployeeIdAsync();
            return domainResult.Select(item => objectMapper.Map<SkillsMatrixModel, SkillsMatrixApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<CategoryMasterApplicationContractsModel>> GetCategoryListAsync()
        {
            var domainResult = await skillMatrixRepository.GetCategoryListAsync();
            return domainResult.Select(item => objectMapper.Map<CategoryMasterModel, CategoryMasterApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<CategoryMasterApplicationContractsModel>> GetCategoryWithTeamScoreListAsync(int teamId, int isWithScore = 0)
        {
            var domainResult = await skillMatrixRepository.GetCategoryWithTeamScoreListAsync(isWithScore, teamId);
            return domainResult.Select(item => objectMapper.Map<CategoryMasterModel, CategoryMasterApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<ClientMasterApplicationContractsModel>> GetClientAsync(string emailId, int withTeam = 0)
        {
            var domainResult = await skillMatrixRepository.GetClientListAsync(emailId, withTeam);
            return domainResult.Select(item => objectMapper.Map<ClientMasterModel, ClientMasterApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<SubCategoryMasterApplicationContractsModel>> GetSubCategoryListAsync()
        {
            var domainResult = await skillMatrixRepository.GetSubCategoryListAsync();
            return domainResult.Select(item => objectMapper.Map<SubCategoryMasterModel, SubCategoryMasterApplicationContractsModel>(item)).ToList();
        }


        public async Task<IList<TeamMasterApplicationContractsModel>> GetTeamsAsync(string EmailId)
        {
            var domainResult = await skillMatrixRepository.GetTeamListAsync(EmailId);
            return domainResult.Select(item => objectMapper.Map<TeamMasterModel, TeamMasterApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<TeamMasterApplicationContractsModel>> GetClientTeamsAsync(int clientId, string functionType)
        {
            var domainResult = await skillMatrixRepository.GetClientTeamListAsync(clientId, functionType);
            return domainResult.Select(item => objectMapper.Map<TeamMasterModel, TeamMasterApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<TeamMasterApplicationContractsModel>> GetClientManagerTeamsAsync(int clientId, string employeeId)
        {
            var domainResult = await skillMatrixRepository.GetClientManagerTeamListAsync(clientId, employeeId);
            return domainResult.Select(item => objectMapper.Map<TeamMasterModel, TeamMasterApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<SubCategoryMasterApplicationContractsModel>> GetSubCategoryByCategoryIdAsync(int categoryId)
        {
            var domainResult = await skillMatrixRepository.GetSubCategoryAndCategoryListAsync(categoryId);
            return domainResult.Select(item => objectMapper.Map<SubCategoryMasterModel, SubCategoryMasterApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<EmployeeDetailsApplicationContractsModel>> GetEmployeesByTeamIdAsync(int teamId)
        {
            var domainResult = await skillMatrixRepository.GetEmployeeDetailsTeamWiseListAsync(teamId);
            return domainResult.Select(item => objectMapper.Map<EmployeeDetailsModel, EmployeeDetailsApplicationContractsModel>(item)).ToList();
        }

        public async Task<EmployeeMasterApplicationContractsModel> GetEmployeeMasterByEmailIdAsync(string EmailId)
        {
            var employeeMaster = await skillMatrixRepository.GetEmployeeMasterByEmailIdAsync(EmailId);
            var applicationStory = objectMapper.Map<EmployeeMasterModel, EmployeeMasterApplicationContractsModel>(employeeMaster);
            return applicationStory;
        }


        public async Task<IList<SubCategoryMappingApplicationContractsModel>> GetSubCategoryMappingAsync()
        {
            var domainResult = await skillMatrixRepository.GetSubCategoryMappingListAsync();
            return domainResult.Select(item => objectMapper.Map<SubCategoryMappingModel, SubCategoryMappingApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<SubCategoryClientMappingScoreModel>> GetTeamSubCategoryByIdAsync(int teamId)
        {
            var domainResult = await skillMatrixRepository.GetTeamSubCategoryMappingListAsync(teamId);
            var scoringObjList = new List<SubCategoryClientMappingScoreModel>();
            return domainResult.Select(item =>
            {
                var applicationStory = objectMapper.Map<SubCategoryMappingModel, SubCategoryMappingApplicationContractsModel>(item);
                return new SubCategoryClientMappingScoreModel
                {
                    SubCategoryId = (int)applicationStory.SubCategoryId,
                    ExpectedClientScore = applicationStory.ClientExpectedScore
                };
            }).ToList();
        }


        public async Task<IList<EmployeeDetailsApplicationContractsModel>> GetEmployeeDetailsAsync(string EmailId)
        {

            var domainResult = await skillMatrixRepository.GetEmployeeDetailsListAsync(EmailId);
            return domainResult.Select(item => objectMapper.Map<EmployeeDetailsModel, EmployeeDetailsApplicationContractsModel>(item)).ToList();
        }

        public async Task<EmployeeDetailsApplicationContractsModel> GetEmployeeDetailByEmailIdAsync(string EmailId)
        {
            var domainResult = await skillMatrixRepository.GetEmployeeDetailsAsync(EmailId);
            return objectMapper.Map<EmployeeDetailsModel, EmployeeDetailsApplicationContractsModel>(domainResult);
        }

        public async Task AddClientAsync(ClientMasterApplicationContractsModel postClient, string emailId)
        {
            var postClientData = objectMapper.Map<ClientMasterApplicationContractsModel, ClientMasterModel>(postClient);
            await skillMatrixRepository.AddClientAsync(postClientData, emailId);
        }

        public async Task AddTeamAsync(TeamMasterApplicationContractsModel postTeam, string emailId)
        {
            var postTeamData = objectMapper.Map<TeamMasterApplicationContractsModel, TeamMasterModel>(postTeam);
            await skillMatrixRepository.AddTeamAsync(postTeamData, emailId);
        }

        public async Task UpdateTeamDetailAsync(TeamMasterApplicationContractsModel teamDetail, string emailId)
        {
            var putTeamData = objectMapper.Map<TeamMasterApplicationContractsModel, TeamMasterModel>(teamDetail);
            await skillMatrixRepository.UpdateTeamDetailAsync(putTeamData, emailId);
        }

        public async Task AddCategoryAsync(CategoryMasterApplicationContractsModel postCategory, string emailId)
        {
            var postCategoryData = objectMapper.Map<CategoryMasterApplicationContractsModel, CategoryMasterModel>(postCategory);
            await skillMatrixRepository.AddCategoryAsync(postCategoryData, emailId);
        }

        public async Task AddEmployeeAsync(EmployeeDetailsApplicationContractsModel postEmployee, string emailId)
        {
            postEmployee.CreatedById = emailId;
            var postEmployeeData = objectMapper.Map<EmployeeDetailsApplicationContractsModel, EmployeeDetailsModel>(postEmployee);
            await skillMatrixRepository.AddEmployeeAsync(postEmployeeData);
        }

        public async Task AddSubCategoryAsync(SubCategoryMasterApplicationContractsModel postSubCategory, string emailId)
        {
            var postSubCategoryData = objectMapper.Map<SubCategoryMasterApplicationContractsModel, SubCategoryMasterModel>(postSubCategory);
            await skillMatrixRepository.AddSubCategoryMasterAsync(postSubCategoryData, emailId);
        }

        public async Task AddSubCategoryMappingAsync(IList<PostSubCategoryMappingApplicationContractsModel> postSubCategoryMapping, string emailId)
        {
            foreach (var item in postSubCategoryMapping)
            {
                var SubCategoryMappingList = new SubCategoryMappingApplicationContractsModel();
                SubCategoryMappingList.TeamId = item.TeamId;
                SubCategoryMappingList.SubCategoryId = item.SubCategoryId;
                SubCategoryMappingList.ClientExpectedScore = item.ClientExpectedScore;
                var postSubCategoryMappingData = objectMapper.Map<SubCategoryMappingApplicationContractsModel, SubCategoryMappingModel>(SubCategoryMappingList);

                await skillMatrixRepository.AddSubCategoryMappingAsync(postSubCategoryMappingData, emailId);

            }
        }

        public async Task AddSkillMatrixAsync(IList<EmployeeScoreModel> postSkillMatrix, string emailId)
        {
            List<SkillsMatrixApplicationContractsModel> listOfPostSkillsMatrixMapping = new List<SkillsMatrixApplicationContractsModel>();
            foreach (var item in postSkillMatrix)
            {
                var SkillMatrixList = new SkillsMatrixApplicationContractsModel();
                SkillMatrixList.Id = item.Id;
                SkillMatrixList.BhavnaEmployeeId = item.BhavnaEmployeeId;
                SkillMatrixList.EmployeeScore = item.EmployeeScore;
                SkillMatrixList.SubCategoryId = item.SubcategoryId;
                listOfPostSkillsMatrixMapping.Add(SkillMatrixList);
            }
            foreach (var postItem in listOfPostSkillsMatrixMapping)
            {
                var postSkillsMatrixData = objectMapper.Map<SkillsMatrixApplicationContractsModel, SkillsMatrixModel>(postItem);
                await skillMatrixRepository.AddSkillMatrixAsync(postSkillsMatrixData, emailId);
            }
        }

        public async Task UpdateSubCategoryMappingAsync(SubCategoryMappingApplicationContractsModel putSubCategoryMapping)
        {
            var putSubCategoryMappingData = objectMapper.Map<SubCategoryMappingApplicationContractsModel, SubCategoryMappingModel>(putSubCategoryMapping);
            await skillMatrixRepository.UpdateSubCategoryMappingAsync(putSubCategoryMappingData);
        }

        public async Task<IList<SkillsMatrixApplicationContractsModel>> GetEmployeeScoresById(int teamId)
        {
            var domainResult = await skillMatrixRepository.GetEmployeeScores(teamId);
            return domainResult.Select(item => objectMapper.Map<SkillsMatrixModel, SkillsMatrixApplicationContractsModel>(item)).ToList();
        }

        public async Task DeleteEmployeeByIdAsync(string employeeId)
        {
            await skillMatrixRepository.DeleteEmployee(employeeId);
        }

        public async Task DeleteTeamByTeamId(int teamId)
        {
            await skillMatrixRepository.DeleteTeam(teamId);
        }

        public async Task DeleteClient(int Id)
        {
            await skillMatrixRepository.DeleteClient(Id);
        }

        public async Task DeleteCategory(int Id)
        {
            await skillMatrixRepository.DeleteCategory(Id);
        }

        public async Task DeleteSubCategoryById(int subCategoryId)
        {
            await skillMatrixRepository.DeleteSubCategory(subCategoryId);
        }
        public async Task EditClient(EditClientTeamsApplicationContractsModel editClientTeams, string emailId)
        {
            var editClientTeam = objectMapper.Map<EditClientTeamsApplicationContractsModel, EditClientTeamsModel>(editClientTeams);
            await skillMatrixRepository.EditClient(editClientTeam, emailId);
        }

        public async Task EditCategorySubcategory(EditCategorySubcategoryApplicationContractsModel editCategorySubcategoryObj)
        {
            var mapEditCategorySubcategory = objectMapper.Map<EditCategorySubcategoryApplicationContractsModel, EditCategorySubcategoryModel>(editCategorySubcategoryObj);
            mapEditCategorySubcategory.SubCategories = editCategorySubcategoryObj.SubCategories.Select(subCategory =>
            objectMapper.Map<SubCategoryMasterApplicationContractsModel, SubCategoryMasterModel>(subCategory)).ToList();
            await skillMatrixRepository.EditCategorySubcategory(mapEditCategorySubcategory);
        }

        public async Task EditCategoryAsync(CategoryMasterApplicationContractsModel Category, int? Id, string emailId)
        {
            var categoryDetail = objectMapper.Map<CategoryMasterApplicationContractsModel, CategoryMasterModel>(Category);
            await skillMatrixRepository.EditCategoryAsync(categoryDetail, Id, emailId);
        }

        public async Task EditSubCategoryAsync(SubCategoryMasterApplicationContractsModel subCategory, int? Id, string emailId)
        {
            var subCategoryDetail = objectMapper.Map<SubCategoryMasterApplicationContractsModel, SubCategoryMasterModel>(subCategory);
            await skillMatrixRepository.EditSubCategoryAsync(subCategoryDetail, Id, emailId);
        }

        public async Task EditTeamEmployees(EditTeamEmployeesApplicationContractsModel editTeamEmployeesObj)
        {
            var mapEditTeamEmployees = objectMapper.Map<EditTeamEmployeesApplicationContractsModel, EditTeamEmployeesModel>(editTeamEmployeesObj);
            mapEditTeamEmployees.Employees = editTeamEmployeesObj.Employees.Select(employee =>
            objectMapper.Map<EmployeeDetailsApplicationContractsModel, EmployeeDetailsModel>(employee)).ToList();
            await skillMatrixRepository.EditTeamEmployees(mapEditTeamEmployees);
        }

        public async Task UpdateEmployee(EditTeamEmployeesUpdateApplicationContractsModel updateEmployeesObj, string emailId)
        {
            updateEmployeesObj.UpdatedById = emailId;
            var mapEditTeamEmployees = objectMapper.Map<EditTeamEmployeesUpdateApplicationContractsModel, EditTeamEmployeesModelUpdate>(updateEmployeesObj);
            await skillMatrixRepository.updateEmployees(mapEditTeamEmployees);
        }

        #region Roles Related Service

        public async Task<IList<RolesApplicationContractsModel>> GetEmployeeRoleListAsync()
        {
            var domainResult = await skillMatrixRepository.GetRoleListAsync();
            return domainResult.Select(item => objectMapper.Map<RolesModel, RolesApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<RolesApplicationContractsModel>> GetRoleListAsync()
        {
            var domainResult = await skillMatrixRepository.GetRoleListAsync();
            return domainResult.Select(item => objectMapper.Map<RolesModel, RolesApplicationContractsModel>(item)).ToList();
        }

        public async Task<RolesApplicationContractsModel> GetRoleByIdAsync(int RoleId)
        {
            return objectMapper.Map<RolesModel, RolesApplicationContractsModel>(await skillMatrixRepository.GetRoleByIdAsync(RoleId));
        }

        public async Task<EmployeeWithRoleModel?> GetRoleByEmailIdAsync(string? EmailId)
        {
            var result = await skillMatrixRepository.GetEmployeeRoleDetailByEmailIdAsync(EmailId);
            return result;
        }

        public async Task<IList<EmployeeRolesApplicationContractsModel>> GetEmployeeRolesListAsync()
        {
            var employeeRole = await skillMatrixRepository.GetEmployeeRolesListAsync();
            var applicationResult = new List<EmployeeRolesApplicationContractsModel>();
            foreach (var role in employeeRole)
            {
                var applicationStory = objectMapper.Map<EmployeeRolesModel, EmployeeRolesApplicationContractsModel>(role);
                applicationResult.Add(applicationStory);
            }
            return applicationResult;
        }

        public async Task<IList<EmployeeRolesApplicationContractsModel>> GetEmployeeRolesListByEmployeeIdAsync(string EmployeeId)
        {
            var domainResult = await skillMatrixRepository.GetEmployeeRolesListByEmployeeIdAsync(EmployeeId);
            return domainResult.Select(item => objectMapper.Map<EmployeeRolesModel, EmployeeRolesApplicationContractsModel>(item)).ToList();
        }

        public Task AddEmployeeRole(int employeeId, int RoleId)
        {
            throw new NotImplementedException();
        }

        public Task EditEmployeeRole(int EmployeeRoleID, int RoleId)
        {
            throw new NotImplementedException();
        }

        public Task DeleteEmployeeRole(int EmployeeRoleID)
        {
            throw new NotImplementedException();
        }

        public async Task<TeamMasterApplicationContractsModel> GetTeamByIdAsync(int? teamId = 0)
        {
            var applicationResult = new TeamMasterApplicationContractsModel();
            if (teamId > 0)
            {
                var result = await skillMatrixRepository.GetTeamByIdAsync(teamId);
                var applicationStory = objectMapper.Map<TeamMasterModel, TeamMasterApplicationContractsModel>(result);
                return applicationStory;
            }

            return applicationResult;
        }
        #endregion

        private List<RoleDetailModel> GetEmployeeRole(List<EmployeeRolesApplicationContractsModel> EmployeeRole, List<RolesApplicationContractsModel> Roles, string BhavnaEmployeeId)
        {
            var result = new List<RoleDetailModel>();
            if (Roles != null && Roles.Count > 0)
            {
                foreach (var role in Roles)
                {
                    var roleDetail = new RoleDetailModel()
                    {
                        RoleName = role.RoleName,
                        Id = role.RoleId,
                        value = EmployeeRole.Exists(a => a.EmployeeId == BhavnaEmployeeId && a.RoleId == role.RoleId)
                    };
                    result.Add(roleDetail);
                };
            }
            return result;
        }

        public async Task<IList<EmployeeRoleDetailApplicationContractsModel>> GetEmployeeRoleDetail(int teamId)
        {
            var employeeRole = await GetEmployeeRolesListAsync();
            var roleList = await GetRoleListAsync();
            var employeeByTeam = await skillMatrixRepository.GetEmployeeDetailsTeamWiseListAsync(teamId);
            var result = new List<EmployeeRoleDetailApplicationContractsModel>();
            if (employeeByTeam != null)
            {
                foreach (var records in employeeByTeam)
                {
                    var empRoleDetail = new EmployeeRoleDetailApplicationContractsModel()
                    {
                        EmployeeId = records.BhavnaEmployeeId,
                        EmployeeName = records.EmployeeName,
                        Email = records.EmailId,
                        Roles = GetEmployeeRole(employeeRole.ToList(), roleList.ToList(), records.BhavnaEmployeeId)
                    };
                    result.Add(empRoleDetail);
                }
            }
            return result;
        }

        public async Task PostEmployeeWithRoleAsync(IList<EmployeeRoleDetailApplicationContractsModel> postEmployeeWithRole, string emailId)
        {
            if (postEmployeeWithRole != null && postEmployeeWithRole.Count > 0)
            {
                foreach (var employee in postEmployeeWithRole)
                {
                    // We have assumed that only one role per employee is allowed only.. Multiple roles to employee not allowed for now...
                    await skillMatrixRepository.PostEmployeeWithRoleAsync(employee, emailId);
                }
            }
        }
        public async Task<IList<ApplicationAccessModel?>> GetApplicationAccessList(string? emailId)
        {
            var record = await skillMatrixRepository.GetApplicationAccessListAsync(emailId);
            var returnResult = new List<ApplicationAccessModel>();

            foreach (var rec in record)
            {
                var applicationAccessModel = new ApplicationAccessModel();
                applicationAccessModel.RoleId = rec.RoleId;
                applicationAccessModel.ApplicationId = rec.ApplicationId;
                applicationAccessModel.ApplicationName = rec.ApplicationName;
                applicationAccessModel.EmployeeId = rec.EmployeeId;
                applicationAccessModel.RoleName = rec.RoleName;
                applicationAccessModel.ApplicationPath = rec.ApplicationPath;
                applicationAccessModel.CanDelete = rec.CanDelete;
                applicationAccessModel.CanView = rec.CanView;
                applicationAccessModel.CanEdit = rec.CanEdit;

                returnResult.Add(applicationAccessModel);

            }
            return returnResult;
        }

        #region Report Service
        public async Task<IList<dynamic>> GetReportByCategoryAndClientAsync(string emailId, int categoryId, int clientId)
        {
            var rawReportData = await skillMatrixRepository.GetReportByCategoryAndClientAsync(emailId,categoryId, clientId);
            return rawReportData.ToList();
        }

        public async Task<IList<SkillSegementCategoryApplicationContractModel>> SkillsSegmentByCategoryAsync(string emailId, int? categoryId, int? clientId, int? teamId, int year, int month)
        {
            var rawReportData = await skillMatrixRepository.SkillsSegmentByCategoryAsync(emailId, categoryId, clientId, teamId, year, month);
            return rawReportData.Select(item => objectMapper.Map<SkillSegementCategoryModel, SkillSegementCategoryApplicationContractModel>(item)).ToList();
        }

        public async Task<IList<EmployeeTypeApplicationContractsModel>> GetEmployeeTypeApplicationContractsListAsync()
        {
            var domainResult = await skillMatrixRepository.GetEmployeeTypes();
            return domainResult.Select(item => objectMapper.Map<EmployeeTypeModel, EmployeeTypeApplicationContractsModel>(item)).ToList();
        }

        public async Task<IList<DesignationsApplicationContractsModel>> GetEmployeeDesignationListAsync()
        {
            var domainResult = await skillMatrixRepository.GetEmployeeDesignations();
            return objectMapper.Map< IList<DesignationsModel>, IList<DesignationsApplicationContractsModel>>(domainResult);
        }
        public async Task<IList<dynamic>> GetEmployeeScoreReportByCategoryClientAsync(PostSkillMatrixReportModel postSkillMatrix, string EmailId)
        {
            var empScoreReportData = await skillMatrixRepository.GetEmployeeScoreReportByCategoryClientAsync(postSkillMatrix,EmailId);
            return empScoreReportData.ToList();
        }
        #endregion

        public async Task ExecuteAndLogArchiveProcess(string status)
        { 
            await skillMatrixRepository.ExecuteArchiveProcess();
            await skillMatrixRepository.SaveOrUpdateArchiveProcessLog(DateTime.Now, status);
        }
    }
}
