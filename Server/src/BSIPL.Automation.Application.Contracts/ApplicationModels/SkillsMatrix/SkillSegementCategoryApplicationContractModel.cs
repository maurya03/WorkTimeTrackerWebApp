using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class SkillSegementCategoryApplicationContractModel
    {
        public string CategoryName { get; set; }
        public string SubCategoryName { get; set; }
        public int Expert { get; set; }
        public int Good { get; set; }
        public int Average { get; set; }
        public int NeedTraining { get; set; }
        public int GrandTotal { get; set; }
    }
}
