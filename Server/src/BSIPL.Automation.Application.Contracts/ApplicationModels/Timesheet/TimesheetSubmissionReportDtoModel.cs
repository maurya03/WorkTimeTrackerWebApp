using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimesheetSubmissionReportDtoModel
    {
        public string EmployeeName { get; set; }
        public string Project { get; set; }
        public string Period { get; set; }
        public decimal TotalHours { get; set; }
        public string Status { get; set; }
    }
}
