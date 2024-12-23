using BSIPL.Automation.ApplicationModels.ShareIdeaModels.DtoModel;
using System;
using System.Collections.Generic;

namespace BSIPL.Automation.Models.ShareIdeaModels
{
    public class EmployeeShareIdeasModel
    {
        public int QuestionId { get; set; }
        public string Question { get; set; }
        public string EmployeeId { get; set; }
        public string Answer { get; set; }
        public int CategoryId { get; set; }
        public Guid ShareIdeaId { get; set; }
        public string FullName { get;set; }
        public string Email { get; set; }
        public string Category { get; set; }
    }
}
