using System;

namespace BSIPL.Automation.Models.Timesheet
{
    public class UpdateTimeSheetDomainModel
    {
        public string Status { get; set; }
        public string EmailId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int TimesheetId { get; set; }
    }
}
