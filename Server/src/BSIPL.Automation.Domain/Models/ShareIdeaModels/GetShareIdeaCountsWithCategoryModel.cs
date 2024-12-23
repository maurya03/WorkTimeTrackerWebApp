using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Models.ShareIdeaModels
{
    public class GetShareIdeaCountsWithCategoryModel
    {
        public int CategoryId { get; set; }
        public int IdeaCounts { get; set; }
        public string Category { get; set; }
    }
}
