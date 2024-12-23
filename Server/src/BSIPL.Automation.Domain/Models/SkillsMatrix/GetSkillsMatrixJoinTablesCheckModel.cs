using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace BSIPL.Automation.Models.SkillsMatrix
{
    public class GetSkillsMatrixJoinTablesCheckModel
    {
        public string? clientName { get; set; }
        [ForeignKey(nameof(clientName))]
        public ClientMasterModel? ClientMasterModel { get; set; }

        public string? teamName { get; set; }
        [ForeignKey(nameof(teamName))]
        public TeamMasterModel? TeamMasterModel { get; set; }


        public string? categoryName { get; set; }
        [ForeignKey(nameof(categoryName))]
        public CategoryMasterModel? CategoryMasterModel { get; set; }

        public string? subCategoryName { get; set; }
        [ForeignKey(nameof(subCategoryName))]
        public SubCategoryMappingModel? SubCategoryMappingModel { get; set; }
        public int? subCategoryId { get; set; }
        public int? teamId { get; set; }


        public int? clientExpectedScore { get; set; }
        [ForeignKey(nameof(clientExpectedScore))]
        public SubCategoryMappingModel? SubCategoryMappingModels { get; set; }
        public List<EmployeeSkillMatrixModel> EmployeeList { get; set; }
    }
}
