using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimesheetTaskDtoModel
    {
        
        public string TaskDescription { get; set; }
        [JsonPropertyName("TimeSheetCategoryID")]
        public int CategoryID { get; set; }
        [JsonPropertyName("TimeSheetSubCategoryID")]
        public int SubCategoryID { get; set; }        
        public int ProjectId { get; set; }
        public string HoursWorked { get; set; }
    }
}
