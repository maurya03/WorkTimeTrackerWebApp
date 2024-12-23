using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.ShareIdeaModels.DtoModel
{
    public class EmployeeQuestionAnswerDtoModel
    {
        public string EmployeeId { get; set; } 
        public Guid ShareIdeaId { get; set; }
        public string FullName { get; set; }
        public string EmailId { get; set; }
        public List<QuestionAnswerDtoModel> QuestionAnswer { get; set; }
    }

}
