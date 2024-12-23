using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels
{
    public class EmailAndWeekDto
    {
        public string EmailId { get; set; }
        public DateTime WeekStartDate { get; set; }
        public DateTime WeekEndDate { get; set; }
        public string Status { get; set; }
        public string Remarks { get; set; }
    }
}
