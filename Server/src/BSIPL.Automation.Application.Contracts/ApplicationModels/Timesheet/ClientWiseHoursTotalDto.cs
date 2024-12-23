using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class ClientWiseHoursTotalDto
    {
        public decimal TotalHours { get; set; }
        public int ProjectId { get; set; }
    }
}
