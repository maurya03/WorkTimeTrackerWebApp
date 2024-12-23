using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.EmployeesBookRepoInterface;
using BSIPL.Automation.Extension;
using BSIPL.Automation.SkillsMatrixRepoInterface;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;


namespace BSIPL.Automation.SkillsMatrixService
{
    public class ValidationService : IValidationService
    {
        private readonly ISkillsMatrixRepository skillMatrixRepository;
        private readonly IEmployeesBookRepository employeesBookRepository;
        private readonly string pattern = @"^[a-zA-Z0-9]*$";
        private readonly string patternForName = @"^[a-zA-Z]+$";
        public ValidationService(ISkillsMatrixRepository _skillMatrixRepository, IEmployeesBookRepository _employeesBookRepository)
        {
            skillMatrixRepository = _skillMatrixRepository;
            employeesBookRepository = _employeesBookRepository;
        }
        public async Task<IList<ValidationErrorMessage>> ValidateAddClient(ClientMasterApplicationContractsModel clientMaster, string emailId)
        {
            var errorMessageList = new List<ValidationErrorMessage>();
            if (clientMaster == null)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Client object can't be null" });
                return errorMessageList;
            }
            else if (clientMaster.ClientName.NullOrEmpty() || clientMaster.ClientDescription.NullOrEmpty())
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "ClientName or ClientDescription can't be blank" });
            }

            if (errorMessageList.Count == 0)
            {
                var clientList = await skillMatrixRepository.GetClientListAsync(emailId);
                if (clientList.Count > 0)
                {
                    var isClienNameExist = clientList.Where(x => x.ClientName.ToLower().Trim() == clientMaster.ClientName.ToLower().Trim()).FirstOrDefault();

                    if (isClienNameExist != null)
                    {
                        errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Client Name already exist" });
                    }
                }
            }

            return errorMessageList;
        }

        public async Task<IList<ValidationErrorMessage>> ValidateUpdateClient(EditClientTeamsApplicationContractsModel clientMaster, string emailId)
        {
            var errorMessageList = new List<ValidationErrorMessage>();
            if (clientMaster == null)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Client object can't be null" });
                return errorMessageList;
            }
            else if (clientMaster.ClientName.NullOrEmpty() || clientMaster.ClientDescription.NullOrEmpty())
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "ClientName or ClientDescription can't be blank" });
            }

            if (errorMessageList.Count == 0)
            {
                var clientList = await skillMatrixRepository.GetClientListAsync(emailId);

                var clientAlreadyExistlist = clientList.Where(x => x.Id != clientMaster.Id && x.ClientName == clientMaster.ClientName).ToList();
                if (clientAlreadyExistlist.Count > 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Client name already exist" });
                }
            }

            return errorMessageList;
        }

        public async Task<IList<ValidationErrorMessage>> ValidateAddTeam(TeamMasterApplicationContractsModel teamMaster, string emailId)
        {
            var errorMessageList = new List<ValidationErrorMessage>();
            if (teamMaster == null)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Team object can't be null" });
                return errorMessageList;
            }

            if (teamMaster.TeamName.NullOrEmpty() || teamMaster.TeamDescription.NullOrEmpty())
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Team name or team description can't be blank" });
            }

            if (errorMessageList.Count == 0)
            {
                var teamList = await skillMatrixRepository.GetTeamListAsync(emailId);
                if (teamList != null && teamList.Count > 0)
                {
                    var isNameExist = teamList.Where(x => x.TeamName.Trim().ToLower() == teamMaster.TeamName.Trim().ToLower()).ToList();
                    if (isNameExist.Count > 0)
                    {
                        errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Team name already exist" });
                    }
                }
            }

            return errorMessageList;
        }

        public async Task<IList<ValidationErrorMessage>> ValidateUpdateTeam(TeamMasterApplicationContractsModel teamMaster, string emailId)
        {
            var errorMessageList = new List<ValidationErrorMessage>();
            if (teamMaster == null)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Team object can't be null" });
                return errorMessageList;
            }

            if (teamMaster.TeamName.NullOrEmpty() || teamMaster.TeamDescription.NullOrEmpty())
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Team name or team description can't be blank" });
            }

            if (errorMessageList.Count == 0)
            {
                var teamList = await skillMatrixRepository.GetTeamListAsync(emailId);
                if (teamList != null && teamList.Count > 0)
                {
                    var isNameExist = teamList.Where(x => x.TeamName.Trim().ToLower() == teamMaster.TeamName.Trim().ToLower() && x.Id != teamMaster.Id).ToList();
                    if (isNameExist.Count > 0)
                    {
                        errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Team name already exist" });
                    }
                }
            }

            return errorMessageList;
        }

        public async Task<IList<ValidationErrorMessage>> ValidateAddEmployee(EmployeeDetailsApplicationContractsModel employeeMaster, string emailId)
        {
            var errorMessageList = new List<ValidationErrorMessage>();
            if (employeeMaster == null)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "EmployeeMaster object can't be null" });
                return errorMessageList;
            }

            if (employeeMaster.EmployeeName.NullOrEmpty())
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Employee name can't be blank" });
            }

            if (employeeMaster.Type == 0)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Employee type can't be blank" });
            }

            if (employeeMaster.EmailId.NullOrEmpty())
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "EmailId can't be blank" });
            }

            if (string.IsNullOrEmpty(employeeMaster.BhavnaEmployeeId))
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "EmployeeId can't be blank" });
            }
            else if (!Regex.IsMatch(employeeMaster.BhavnaEmployeeId, pattern))
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Special Charecters are not Allowed in EmployeeId!" });
            }

            if (employeeMaster.Role == 0)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Roles can't be blank" });
            }
            if (employeeMaster.DesignationId == 0)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "DesignationId can't be blank" });
            }

            if (errorMessageList.Count == 0)
            {
                var employeeList = await skillMatrixRepository.GetEmployeeDetailsListAsync(emailId);
                if (employeeList != null && employeeList.Count > 0)
                {
                    var isNameExist = employeeList.Where(x => x.EmployeeName.Trim().ToLower() == employeeMaster.EmployeeName.Trim().ToLower() && x.TeamId == employeeMaster.TeamId).ToList();
                    if (isNameExist.Count > 0)
                    {
                        errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Employee name already exist" });
                    }
                }

                var EmployeeMasterDetail = await skillMatrixRepository.GetAllEmployeeListSm();
                var DoesEmailExist = EmployeeMasterDetail.Where(x =>(x.EmailId != null && x.EmailId.ToLower() == employeeMaster.EmailId.ToLower())).ToList();
                if (DoesEmailExist.Count > 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Email Id already mapped to other employee" });
                }
                var DoesEmployeeIdExist = EmployeeMasterDetail.Where(x => x.EmployeeId == employeeMaster.BhavnaEmployeeId).ToList();
                if(DoesEmployeeIdExist.Count > 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Employee Id already mapped to other employee" });
                }
                int atIndex = employeeMaster.EmailId.IndexOf('@');
                if (atIndex > 0)
                {
                    if (Regex.IsMatch(employeeMaster.EmailId.Substring(0, atIndex).Trim(), "^\\d+$"))
                    {
                        errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Email Id cannot be purely numeric." });
                    }
                }
            }
            return errorMessageList;

        }

        public async Task<IList<ValidationErrorMessage>> ValidateUpdateEmployee(EditTeamEmployeesUpdateApplicationContractsModel employeeMaster, string emailId)
        {
            var errorMessageList = new List<ValidationErrorMessage>();
            if (employeeMaster == null)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "employeeMaster object can't be null" });
                return errorMessageList;
            }

            if (employeeMaster.EmployeeName.NullOrEmpty())
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Employee name can't be blank" });
            }

            if (string.IsNullOrEmpty(employeeMaster.BhavnaEmployeeId))
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "EmployeeId can't be blank" });
            }

            if (errorMessageList.Count == 0)
            {
                var employeeList = await skillMatrixRepository.GetAllEmployeeListSm((int)employeeMaster.TeamId);
                if (employeeList != null && employeeList.Count > 0)
                {
                    var team = employeeList.FirstOrDefault(t => t.TeamId == employeeMaster.TeamId);
                    if(team != null)
                    {
                        if(employeeList.Any(e => e.EmployeeName.Equals(employeeMaster.EmployeeName, System.StringComparison.OrdinalIgnoreCase) && e.EmployeeId != employeeMaster.BhavnaEmployeeId))
                        {
                            errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Employee name already exist" });
                        }
                    }
                    var isEmployeeIdExist = employeeList.Where(x => x.EmployeeId != employeeMaster.BhavnaEmployeeId && x.TeamId == employeeMaster.TeamId && x.EmployeeId == employeeMaster.BhavnaEmployeeId).ToList();
                    if (isEmployeeIdExist.Count > 0)
                    {
                        errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "EmployeeId already exist for this team." });
                    }
                }
                if (Regex.IsMatch(employeeMaster.EmailId.Trim(), "^\\d+$"))
                {
                    errorMessageList.Add(new ValidationErrorMessage()
                    {
                        ErrorMessage = "Email Id cannot be purely numeric."
                    });
                }
                var EmployeeMasterDetail = await skillMatrixRepository.GetAllEmployeeListSm();
                var DoesEmailExist = EmployeeMasterDetail.Where(x => (x.EmailId != null && x.EmailId.ToLower() == employeeMaster.EmailId.ToLower()) && x.EmployeeId != employeeMaster.BhavnaEmployeeId).ToList();
                if (DoesEmailExist.Count > 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Email Id already mapped to other employee" });
                }
            }
            return errorMessageList;
        }

        #region Category & Subcategory Validation

        public async Task<IList<ValidationErrorMessage>> ValidateAddCategory(CategoryMasterApplicationContractsModel categoryMaster, string emailId)
        {
            var errorMessageList = new List<ValidationErrorMessage>();
            if (categoryMaster == null)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "category object can't be null" });
                return errorMessageList;
            }

            if (categoryMaster.CategoryName.NullOrEmpty() || categoryMaster.CategoryDescription.NullOrEmpty() || categoryMaster.CategoryFunction.NullOrEmpty())
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Category Name or Description or Function can't be blank" });
            }

            if (errorMessageList.Count == 0)
            {
                var categoryList = await skillMatrixRepository.GetCategoryListAsync();
                if (categoryList != null && categoryList.Count > 0)
                {
                    var isNameExist = categoryList.Where(x => x.CategoryName.Trim().ToLower() == categoryMaster.CategoryName.Trim().ToLower()).ToList();
                    if (isNameExist.Count > 0)
                    {
                        errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "category name already exist" });
                    }
                }
            }

            return errorMessageList;
        }

        public async Task<IList<ValidationErrorMessage>> ValidateUpdateCategory(CategoryMasterApplicationContractsModel categoryMaster, int? categoryId)
        {

            var errorMessageList = new List<ValidationErrorMessage>();
            if (categoryMaster == null)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "category object can't be null" });
                return errorMessageList;
            }

            if (categoryMaster.CategoryName.NullOrEmpty() || categoryMaster.CategoryDescription.NullOrEmpty() || categoryMaster.CategoryFunction.NullOrEmpty())
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Category Name or Description or Function can't be blank" });
            }

            if (errorMessageList.Count == 0)
            {
                var categoryList = await skillMatrixRepository.GetCategoryListAsync();
                if (categoryList != null && categoryList.Count > 0)
                {
                    var isNameExist = categoryList.Where(x => x.CategoryName.Trim().ToLower() == categoryMaster.CategoryName.Trim().ToLower() && x.Id != categoryId.Value).ToList();
                    if (isNameExist.Count > 0)
                    {
                        errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "category name already exist" });
                    }
                }
            }

            return errorMessageList;
        }

        public async Task<IList<ValidationErrorMessage>> ValidateAddSubCategory(SubCategoryMasterApplicationContractsModel subCategory)
        {
            var errorMessageList = new List<ValidationErrorMessage>();
            if (subCategory == null)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "subCategory object can't be null" });
                return errorMessageList;
            }

            if (subCategory.SubCategoryName.NullOrEmpty() || subCategory.SubCategoryDescription.NullOrEmpty())
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "SubCategory Name or Description can't be blank" });
            }

            if (!subCategory.CategoryId.HasValue)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "CategoryId can't be null" });
            }

            if (errorMessageList.Count == 0)
            {
                var categoryList = (await skillMatrixRepository.GetCategoryListAsync()).Where(x => x.Id == subCategory.CategoryId).ToList();
                if (categoryList.Count == 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "category id not exist." });
                }
                categoryList = (await skillMatrixRepository.GetCategoryListAsync()).Where(x => x.CategoryName.ToLower().Trim() == subCategory.SubCategoryName.ToLower().Trim()).ToList();
                if (categoryList.Count > 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "subCategory shouldn't have same name as category." });
                }
                var subCategoryList = await skillMatrixRepository.GetSubCategoryListAsync();
                var categoryNameList = subCategoryList.Where(x => x.SubCategoryName.ToLower() == subCategory.SubCategoryName.ToLower() && x.CategoryId == subCategory.CategoryId).ToList();
                if (categoryNameList.Count > 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Sub category name already exist." });
                }

            }

            return errorMessageList;
        }

        public async Task<IList<ValidationErrorMessage>> ValidateUpdateSubCategory(SubCategoryMasterApplicationContractsModel subCategory, int? subCategoryId)
        {
            var errorMessageList = new List<ValidationErrorMessage>();
            if (subCategory == null)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "subCategory object can't be null" });
                return errorMessageList;
            }

            if (subCategory.SubCategoryName.NullOrEmpty() || subCategory.SubCategoryDescription.NullOrEmpty())
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "SubCategory Name or Description can't be blank" });
            }

            if (!subCategory.CategoryId.HasValue)
            {
                errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "CategoryId can't be null" });
            }

            if (errorMessageList.Count == 0)
            {
                var categoryList = await skillMatrixRepository.GetSubCategoryAndCategoryListAsync(subCategory.CategoryId.Value);
                if (categoryList.Count == 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "category id not exist." });
                }
                var categoryDuplicateList = (await skillMatrixRepository.GetCategoryListAsync()).Where(x => x.CategoryName.ToLower().Trim() == subCategory.SubCategoryName.ToLower().Trim()).ToList();
                if (categoryDuplicateList.Count > 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "subCategory shouldn't have same name as category." });
                }
                var subCategoryList = await skillMatrixRepository.GetSubCategoryListAsync();
                var categoryNameList = subCategoryList.Where(x => x.SubCategoryName.ToLower() == subCategory.SubCategoryName.ToLower() && x.Id != subCategoryId && x.CategoryId == subCategory.CategoryId).ToList();
                if (categoryNameList.Count > 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Sub category name already exist." });
                }

            }

            return errorMessageList;
        }

        public async Task<IList<ValidationErrorMessage>> ValidateClientExpectedScore(IList<PostSubCategoryMappingApplicationContractsModel> clientExpectedScoreList)
        {
            var errorMessageList = new List<ValidationErrorMessage>();
            var subCategoryList = await skillMatrixRepository.GetSubCategoryListAsync();
            foreach (var subCategory in clientExpectedScoreList)
            {
                var isSubcategoryExist = subCategoryList.Where(x => x.Id == subCategory.Id).ToList().Count > 0;
                if (isSubcategoryExist)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Sub category not exist." });
                }

                if (subCategory.ClientExpectedScore > 4 || subCategory.ClientExpectedScore < 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Client expected score should be between 0 and 4." });
                }

                var teamDetail = await skillMatrixRepository.GetTeamByIdAsync(subCategory.TeamId);
                if (teamDetail == null)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Team doesn't exist." });
                }
            }

            return errorMessageList;
        }

        public async Task<IList<ValidationErrorMessage>> ValidateEmployeeScore(IList<EmployeeScoreModel> postSkillMatrix)
        {
            var errorMessageList = new List<ValidationErrorMessage>();
            var subCategoryList = await skillMatrixRepository.GetSubCategoryListAsync();
            foreach (var postSkill in postSkillMatrix)
            {
                if (postSkill.EmployeeScore > 4 || postSkill.EmployeeScore < 0)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "Client expected score should be between 0 and 4." });
                }

                var isNotSubcategoryExist = subCategoryList.Where(x => x.Id == postSkill.SubcategoryId).ToList().Count == 0;
                if (isNotSubcategoryExist)
                {
                    errorMessageList.Add(new ValidationErrorMessage() { ErrorMessage = "SubCategory does not exist." });
                }
            }
            return errorMessageList;
        }

        public async Task<bool> ValidateDeleteEmployee(string employeeId)
        {
            var result = await skillMatrixRepository.GetAllSkillsMatrixOrListByEmployeeIdAsync(employeeId);
            bool isEmployeeScoreZero = !result.Any(item => item.EmployeeScore != 0);

            return isEmployeeScoreZero;
        }

        #endregion
    }
}