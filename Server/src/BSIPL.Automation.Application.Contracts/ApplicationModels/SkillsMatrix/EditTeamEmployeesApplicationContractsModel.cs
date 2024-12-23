using System;
using System.Collections.Generic;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class EditTeamEmployeesApplicationContractsModel
    {
        public int Id { get; set; }
        public string? TeamName { get; set; }
        public string? TeamDescription { get; set; }
        public DateTime ModifiedOn = DateTime.Now;
        public List<EmployeeDetailsApplicationContractsModel> Employees { get; set; }
    }
    public class EditTeamEmployeesUpdateApplicationContractsModel
    {

        public DateTime ModifiedOn = DateTime.Now;
        public int EmployeeId { get; set; }
        public int? TeamId { get; set; }
        public string EmployeeName { get; set; }
        public string? BhavnaEmployeeId { get; set; }
        public string EmailId { get; set; }
        public bool IsEditEmployeeId { get; set; }

        public int? Type { get; set; }
        public int Role { get; set; }
        public int DesignationId { get; set; }
        public string UpdatedById { get; set; }
    }
}
