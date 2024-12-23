using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Models.Timesheet
{
    public class TimesheetReportDetails
    {
        public int clientId { get; set; }
        public string clientName { get; set; }
        public double AdrenalineLeaves { get; set; }

        public List<NonProdTimesheetDetail> NonProdTimesheetDetails { get; set; }
        public List<TimesheetEffortSummary> TimesheetEffortSummary { get; set; }
        public List<TimesheetCategoryWiseEfforts> TimesheetCategoryWiseEfforts { get; set; }
        public List<List<TimesheetSubCategoryWiseEfforts>> timesheetFunctionWiseEfforts { get; set; }
        public List<TimesheetSubCategoryWiseEfforts> TimesheetSubCategoryWiseEfforts { get; set; }
    }
    public class NonProdTimesheetDetail
    {
        public string? SubCategory { get; set; }
        public int EmployeeCount { get; set; }
        public decimal TSHours { get; set; }
    }
    public class TimesheetEffortSummary
    {
        public string? FunctionType { get; set; }
        public int EmployeeCount { get; set; }
        public decimal TSActualHours { get; set; }
        public decimal TSExpectedHours { get; set; }
        public double TSCompliance { get; set; }
        public decimal LeaveHours { get; set; }
        public decimal TSProdHours { get; set; }
        public decimal TSNonProdHours { get; set; }
        public double ProdPercent { get; set; }
        public double ITHours { get; set; }
        public double UtilisationPer { get; set; }
        public double TimesheetSubmitted { get; set; }
        public decimal WeekEndHour { get; set; }
        public decimal IdleTime { get; set; }

    }
    public class TimesheetCategoryWiseEfforts
    {
        public string CategoryName { get; set; }
        public string EmployeeType { get; set; }
        public decimal Hours { get; set; }
    }
    public class TimesheetSubCategoryWiseEfforts
    {
        public string SubCategoryName { get; set; }
        public string EmployeeName { get; set; }
        public decimal Hours { get; set; }
    }
}
