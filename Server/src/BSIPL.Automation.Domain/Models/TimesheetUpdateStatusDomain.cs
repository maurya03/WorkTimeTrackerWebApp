using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Models
{
    public class TimesheetUpdateStatusDomain
    {
        public string? EmployeeIds { get; set; }
        public string? TimesheetIds { get; set; }
        public string? Remarks { get; set; }
        public string EmailId { get; set; }
    }
}
