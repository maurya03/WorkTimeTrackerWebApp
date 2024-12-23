using BSIPL.Automation.Domain.Shared.Enum;
using System;

namespace BSIPL.Automation.ApplicationModels
{
    public class LoggerApplicationContractsModel
    {
        public int Id { get; set; }
        public LogEnum LoggerType { get; set; }
        public LogFromEnum LogFrom { get; set; }
        public string Description { get; set; }
        public string Source { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
