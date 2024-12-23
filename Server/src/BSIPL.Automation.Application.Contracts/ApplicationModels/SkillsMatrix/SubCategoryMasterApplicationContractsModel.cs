using System;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class SubCategoryMasterApplicationContractsModel
    {
        public int Id { get; set; }
        public int? CategoryId { get; set; }
        public string SubCategoryName { get; set; }
        public string SubCategoryDescription { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime ModifiedOn { get; set; }
    }
}
