using System;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class SkillsMatrixApplicationContractsModel
    {
        public int Id { get; set; }
        public string BhavnaEmployeeId { get; set; }
        public int? SubCategoryId { get; set; }
        public int EmployeeScore { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime ModifiedOn { get; set; }
    }
}
