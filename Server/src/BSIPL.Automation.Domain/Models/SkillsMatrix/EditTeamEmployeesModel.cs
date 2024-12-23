using System;
using System.Collections.Generic;

namespace BSIPL.Automation.Models.SkillsMatrix
{
    public class EditTeamEmployeesModel
    {
        public int Id { get; set; }
        public string? TeamName { get; set; }
        public string? TeamDescription { get; set; }
        public DateTime ModifiedOn = DateTime.Now;
        public List<EmployeeDetailsModel> Employees { get; set; }
    }

}
