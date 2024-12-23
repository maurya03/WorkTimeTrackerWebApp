using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.ShareIdeaModels
{
    public class GetShareIdeaCountsWithCategoryApplicationContractsModel
    {
        public int CategoryId { get; set; }
        public int IdeaCounts { get; set; }
        public string Category { get; set; }
    }
}
