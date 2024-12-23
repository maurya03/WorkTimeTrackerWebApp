using BSIPL.Automation.ApplicationModels.ShareIdeaModels.DtoModel;
using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.ShareIdeaModels
{
    public class EmployeeShareIdeasApplicationContractsModel
    {
        public int CategoryId { get; set; }
        public string Category { get; set; }
        public List<EmployeeQuestionAnswerDtoModel> Model { get; set; }
    }
}
