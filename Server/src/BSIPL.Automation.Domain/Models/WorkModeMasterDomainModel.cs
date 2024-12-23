using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Models
{
    public class WorkModeMasterDomainModel
    {
        public string EmpId { get; set; }
        public string Month { get; set; }
        public string WorkMode { get; set; }
        public int WfhGranted { get; set; }
        public int WfhAvailed { get; set; }
        public int WfhCompensated { get; set; } = 0;
        public int TotalWorkingDays { get; set; } = 20;
        public int CompletedDays { get; set; }
        public int Leaves { get; set; } = 0;
        public int NonCompliance { get; set; }
        public DateTime UpdatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string CreatedBy { get; set; }
    }
}
