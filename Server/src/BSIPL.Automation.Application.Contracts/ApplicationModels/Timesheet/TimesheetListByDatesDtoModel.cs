using System;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimesheetListByDatesDtoModel
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool Isbehalf { get; set; }
        public int EmpId { get; set; }
        public int ClientId { get; set; }
    }
}