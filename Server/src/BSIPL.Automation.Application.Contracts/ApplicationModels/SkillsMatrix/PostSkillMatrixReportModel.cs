using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class PostSkillMatrixReportModel
    {
        public int? categoryId { get; set; }
        public int? clientId { get; set; }
        public int? teamId { get; set; }
        public int? reportType { get; set; }
        public int? functionType { get; set; }
        public int year {  get; set; }
        public int month { get; set; }
    }
}
