using BSIPL.Automation.ApplicationModels.ShareIdeaModels.DtoModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Models.ShareIdeaModels
{
    public class ShareIdeaModel
    {
        public int CategoryId { get; set; }
        public List<ShareIdeaDtoModel> ShareIdeas { get; set; }
    }
}
