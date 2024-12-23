using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Models
{
    public class ManagerAndApproverEmailsAndOtherFields
    {
        public string ManagerEmailId { get; set; }
        public string ApproverEmailId1 { get; set; }
        public string ApproverEmailId2 { get; set; }
        public string FullName { get; set; }
        public string EmailId { get; set; }
        public DateTime WeekStartDate { get; set; }
        public DateTime WeekEndDate { get; set; }
        public string Status { get; set; }
        public string Remarks { get; set; }
    }
}
