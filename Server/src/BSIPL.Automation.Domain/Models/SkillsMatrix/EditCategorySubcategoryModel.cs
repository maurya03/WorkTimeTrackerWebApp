using System;
using System.Collections.Generic;

namespace BSIPL.Automation.Models.SkillsMatrix
{
    public class EditCategorySubcategoryModel
    {
        public int Id { get; set; }
        public string? CategoryName { get; set; }
        public string? CategoryDescription { get; set; }
        public DateTime ModifiedOn = DateTime.Now;
        public List<SubCategoryMasterModel> SubCategories { get; set; }
    }
}
