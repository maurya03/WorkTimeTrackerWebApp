using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Models.Timesheet
{
    public class TimesheetDeleteEmployeeListModel
    {
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string FunctionType { get; set; }
        public string ClientName { get; set; }
        public string TeamName { get; set; }
        public string EmailId { get; set; }
        public int ExperienceYear { get; set; }
    }
}
