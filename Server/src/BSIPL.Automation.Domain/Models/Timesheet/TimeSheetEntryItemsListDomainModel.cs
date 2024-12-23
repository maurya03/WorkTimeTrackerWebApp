using System;

namespace BSIPL.Automation.Models.Timesheet
{
    public class TimeSheetDetailListDomainModel
    {
        public int ProjectId { get; set; }
        public int DayOfWeek { get; set; }
        public decimal HoursWorked { get; set; }
        public string TimesheetUnit { get; set; }
        public DateTime Date { get; set; }
        public string TaskDescription { get; set; }
        public int TimeSheetCategoryId { get; set; }
        public int TimeSheetSubCategoryId { get; set; }
        public int StatusId { get; set; }
        public int TimesheetId { get; set; }
        public string CategoryName { get; set; }
        public string SubCategoryName { get; set; }
        public string ProjectName { get; set; }
        public int TimesheetDetailId { get; set; }
    }
    public class TimeSheetDetailWithCreatedTypeListDomainModel: TimeSheetDetailListDomainModel
    {       
        public string CreatedBy { get; set; }
        public int ClientId { get; set; }
    }
}
