using System;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimeSheetEntryListDtoModel
    {
        public int EntryId { get; set; }
        public DateTime Created { get; set; }
        public string Period { get; set; }
        public DateTime PeriodStart { get; set; }
        public decimal TotalHours { get; set; }
        public string StatusName { get; set; }
    }
    public class TimeSheetListDtoModel
    {
        public string? ClientName { get; set; }
        public int TimesheetId { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime WeekStartDate { get; set; }
        public DateTime WeekEndDate { get; set; }
        public DateTime SubmissionDate { get; set; }
        public DateTime ApprovedDate { get; set; }
        public string StatusName { get; set; }
        public decimal TotalHours { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeId { get; set; }
        public int? TotalCount { get; set; }
         public string? Remarks { get; set; }
        public string? EmailId { get; set; }
    }
}
