using System;
using System.Collections.Generic;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimesheetDto
    {
        public List<ClientWiseHoursTotal> ClientWiseHoursTotal { get; set; }
        public List<TimesheetDetail> HourlyData { get; set; }
        public string Remarks { get; set; }
        public DateTime WeekStartDate { get; set; }
        public DateTime WeekEndDate { get; set; }
        public int StatusId { get; set; }
        public int OnBehalfTimesheetCreatedFor { get; set; }
        public string OnBehalfTimesheetCreatedByEmail { get; set; }
        public int TimesheetId { get; set; }       
        public static void IsValid(List<TimesheetDetail> HourlyData)
        {
            if (HourlyData is List<TimesheetDetail> hourlyData)
            {
                foreach (var key in hourlyData)
                {
                    if (key.DayOfWeek < 1 || key.DayOfWeek > 7)
                    {
                        throw new InvalidOperationException("HourlyData keys must represent valid days of the week.");
                    }
                }
            }
        }
    }
    public class TimesheetDetail
    {
        public int DayOfWeek { get; set; }
        public decimal HoursWorked { get; set; }
        public string TaskDescription { get; set; }
        public int TimeSheetCategoryID { get; set; }
        public int TimeSheetSubcategoryID { get; set; }
        public int ProjectId { get; set; }
    }
    public class ClientWiseHoursTotal
    {
        public decimal TotalHours { get; set; }
        public int ProjectId { get; set; }
    }
    public class TimesheetGetDto
    {
        public string Status { get; set; }
        public string EmailId { get; set; }
        public string? ClientId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public bool IsApproverPending { get; set; }
        public string? SearchedText { get; set; }
        public int? SkipRows { get; set; }
        public bool ShowSelfRecordsToggle { get; set; }
    }
}
