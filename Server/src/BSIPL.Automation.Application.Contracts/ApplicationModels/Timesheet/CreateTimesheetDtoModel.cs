using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class CreateTimesheetDtoModel
    {
        public List<ClientWiseHoursTotalDto> ClientWiseHoursTotal { get; set; }
        public List<TimesheetTaskDtoModel> TaskRows { get; set; }
        public DateTime WeekStartDate { get; set; }
        public DateTime WeekEndDate { get; set; }
        public int StatusId { get; set; }
    }
}
