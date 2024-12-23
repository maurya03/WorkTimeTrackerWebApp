using BSIPL.Automation.ApplicationModels.ShareIdeaModels.DtoModel;
using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.ShareIdeaModels
{
    public class ShareIdeaApplicationContractsModel
    {
        public int CategoryId { get;set; }
        public List<ShareIdeaDtoModel> ShareIdeas { get; set; }
    }
}
