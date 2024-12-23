namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimesheetEmployeeDetailsDtoModel
    {
        public string EmployeeId { get; set; }
        public string? EmployeeName { get; set; }
        public int TeamId { get; set; }
        public string TimesheetManagerId { get; set; }
        public string TimesheetApproverId1 { get; set; }
        public string TimesheetApproverId2 { get; set; }
    }
}
