using System;

namespace BSIPL.Automation.Models.SkillsMatrix
{
    public class EditTeamEmployeesModelUpdate
    {
        public DateTime ModifiedOn = DateTime.Now;
        public int EmployeeId { get; set; }
        public int? TeamId { get; set; }
        public string EmployeeName { get; set; }
        public string? BhavnaEmployeeId { get; set; }
        public string EmailId { get; set; }
        public int? Type { get; set; }
        public int Role { get; set; }
        public int DesignationId { get; set; }
        public string UpdatedById { get; set; }
    }
}
