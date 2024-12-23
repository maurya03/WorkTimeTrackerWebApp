using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.SkillsMatrixServiceInterface
{
    public interface IValidationService
    {
        Task<IList<ValidationErrorMessage>> ValidateAddClient(ClientMasterApplicationContractsModel clientMaster, string emailId);
        Task<IList<ValidationErrorMessage>> ValidateUpdateClient(EditClientTeamsApplicationContractsModel clientMaster, string emailId);
        Task<IList<ValidationErrorMessage>> ValidateAddTeam(TeamMasterApplicationContractsModel teamMaster, string emailId);
        Task<IList<ValidationErrorMessage>> ValidateUpdateTeam(TeamMasterApplicationContractsModel teamMaster, string emailId);
        Task<IList<ValidationErrorMessage>> ValidateAddEmployee(EmployeeDetailsApplicationContractsModel employeeMaster, string emailId);
        Task<IList<ValidationErrorMessage>> ValidateUpdateEmployee(EditTeamEmployeesUpdateApplicationContractsModel employeeMaster, string emailId);
        Task<IList<ValidationErrorMessage>> ValidateAddCategory(CategoryMasterApplicationContractsModel categoryMaster, string emailId);
        Task<IList<ValidationErrorMessage>> ValidateUpdateCategory(CategoryMasterApplicationContractsModel categoryMaster, int? categoryId);
        Task<IList<ValidationErrorMessage>> ValidateAddSubCategory(SubCategoryMasterApplicationContractsModel subCategory);
        Task<IList<ValidationErrorMessage>> ValidateUpdateSubCategory(SubCategoryMasterApplicationContractsModel subCategory, int? subCategoryId);
        Task<IList<ValidationErrorMessage>> ValidateClientExpectedScore(IList<PostSubCategoryMappingApplicationContractsModel> clientExpectedScoreList);
        Task<IList<ValidationErrorMessage>> ValidateEmployeeScore(IList<EmployeeScoreModel> postSkillMatrix);
        Task<bool> ValidateDeleteEmployee(string employeeId);
    }
}