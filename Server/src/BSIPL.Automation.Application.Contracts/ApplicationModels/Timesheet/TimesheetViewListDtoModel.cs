using System;
using System.Collections.Generic;
using System.Text;

namespace BSIPL.Automation.ApplicationModels.Timesheet
{
    public class TimesheetViewListDtoModel
    {
        public string Sun { get; set; }
        public string Mon { get; set; }
        public string Tue { get; set; }
        public string Wed { get; set; }
        public string Thu { get; set; }
        public string Fri { get; set; }
        public string Sat { get; set; }
        public string TaskDescription { get; set; }
        public string CategoryName { get; set; }
        public int TimeSheetCategoryId { get; set; }
        public string SubCategoryName { get; set; }
        public int TimeSheetSubCategoryId { get; set; }
        public string ProjectName { get; set; }
        public int ProjectId { get; set; }
        public List<int> TimesheetDetailId { get; set; }
        public int StatusId { get; set; }
    }
}
