using System;
using System.Collections.Generic;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class EditCategorySubcategoryApplicationContractsModel
    {
        public int Id { get; set; }
        public string? CategoryName { get; set; }
        public string? CategoryDescription { get; set; }
        public DateTime ModifiedOn = DateTime.Now;
        public List<SubCategoryMasterApplicationContractsModel> SubCategories { get; set; }
    }
}
