using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimesheetApproval
    {
        public List<TimesheetApprovalAsignee> ReportingManagerList { get; set; }

        public List<TimesheetApprovalAsignee> ApproverId1List { get; set; }

        public List<TimesheetApprovalAsignee> ApproverId2List { get; set; }

    }
}
