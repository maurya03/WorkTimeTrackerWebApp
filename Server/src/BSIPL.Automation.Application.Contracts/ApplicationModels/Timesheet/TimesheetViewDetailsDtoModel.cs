using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimesheetViewDetailsDtoModel
    {
        public IList<TimesheetViewListDtoModel> timesheetData { get; set; }
        public int StatusId { get; set; }
    }
}
