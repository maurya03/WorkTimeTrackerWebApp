using System;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class EmployeeDetailsApplicationContractsModel
    {
        public int EmployeeId { get; set; }
        public int? TeamId { get; set; }
        public string EmployeeName { get; set; }
        public int Type { get; set; }
        public string EmailId { get; set; }
        public string? BhavnaEmployeeId { get; set; }
        public string FunctionType { get; set; }
        public int ClientId { get; set; }
        public int Role { get; set; }
        public int DesignationId { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
        public string CreatedById { get; set; }
    }
}
