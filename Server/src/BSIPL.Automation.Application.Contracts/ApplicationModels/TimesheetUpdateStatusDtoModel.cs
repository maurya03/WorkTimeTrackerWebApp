using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels
{
    public class TimesheetUpdateStatusDtoModel
    {
        public string Status { get; set; }
        public string? EmployeeIds { get; set; }
        public string? TimesheetIds { get; set; }
        public string? Remarks { get; set; }


    }
}
