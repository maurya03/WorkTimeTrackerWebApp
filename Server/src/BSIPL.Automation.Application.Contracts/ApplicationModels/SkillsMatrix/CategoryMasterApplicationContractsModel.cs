using System;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class CategoryMasterApplicationContractsModel
    {
        public int Id { get; set; }
        public string CategoryFunction { get; set; }
        public string CategoryName { get; set; }
        public string CategoryDescription { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime ModifiedOn { get; set; }
    }
}
