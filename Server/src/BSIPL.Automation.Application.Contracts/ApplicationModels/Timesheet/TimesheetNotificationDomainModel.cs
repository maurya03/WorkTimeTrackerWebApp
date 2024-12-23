using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimesheetNotificationDomainModel
    {
        public string? EmployeeName { get; set; }
        public string? EmailId { get; set; }
        public string Project { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime SubmittedDate { get; set; }
        public DateTime WeekStartDate { get; set; }
        public DateTime WeekEndDate { get; set; }
        public string ApprovedRejectedDate {get; set;}
        public string TotalHours { get; set; }

    }
}
