using System.Collections.Generic;

namespace BSIPL.Automation.Models.Timesheet
{
    public class TimesheetApprovalDetail
    {
        public List<TimesheetApproverName> ReportingManagerList {  get; set; }
        public List<TimesheetApproverName> ApproverId1List { get; set; }
        public List<TimesheetApproverName> ApproverId2List { get; set; }
    }
}
