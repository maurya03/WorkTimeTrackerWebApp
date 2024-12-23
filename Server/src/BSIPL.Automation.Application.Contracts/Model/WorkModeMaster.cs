using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.Model
{
    public class WorkModeMaster
    {
        public string EmpId { get; set; }
        public string Month { get; set; }
        public string WorkMode { get; set; }
        public int WfhGranted { get; set; }
        public int WfhAvailed { get; set; }
        public int WfhCompensated { get; set; }
        public int TotalWorkingDays { get; set; }
        public int CompletedDays { get; set; }
        public int Leaves { get; set; }
        public int NonCompliance { get; set; }
        public DateTime UpdatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string CreatedBy { get; set; }
    }
}
