using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.Models.Timesheet
{
    public class EmailAndWeekDomainModel
    {
        public string EmailId { get; set; }
        public DateTime WeekStartDate { get; set; }
        public DateTime WeekEndDate { get; set; }
        public string Status { get; set; }
        public string Remarks { get; set; }
    }
}
