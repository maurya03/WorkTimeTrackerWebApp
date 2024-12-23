using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Models.SkillsMatrix
{
    public class SkillSegementCategoryModel
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
