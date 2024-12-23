using System.Collections.Generic;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class GetSkillsMatrixJoinTablesApplicationContractsModel
    {
        public string? ClientName { get; set; }
        public string? TeamName { get; set; }
        public int? EmployeeID { get; set; }
        public string? EmployeeName { get; set; }
        public string? CategoryName { get; set; }
        public string? SubCategoryName { get; set; }
        public int? ClientExpectedScore { get; set; }
        public int EmployeeScore { get; set; }
        public List<EmployeeSkillScoreModel> EmployeeList { get; set; }
        public int? SubCategoryId { get; set; }
    }
}
