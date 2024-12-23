using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimesheetNotificationModel
    {
        public int ClientId { get; set; }
        public int TeamId { get; set; }
        public string IsTimesheetCreated { get; set; }
        public string IsTimesheetSubmitted { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
    }
}
