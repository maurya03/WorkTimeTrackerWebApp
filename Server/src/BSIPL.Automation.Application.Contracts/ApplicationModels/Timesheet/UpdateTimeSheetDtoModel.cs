using System;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class UpdateTimeSheetDtoModel
    {
        public string Status { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int TimesheetId { get; set; }
    }
}
