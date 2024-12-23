using System.ComponentModel.DataAnnotations.Schema;

namespace BSIPL.Automation.Models.Timesheet
{
    public class TimesheetSubCategoryDomainModel
    {
        [Column(TypeName = "int")]
        public int TimeSheetSubCategoryId { get; set; }
        [Column(TypeName = "varchar(255)")]
        public string TimeSheetSubCategoryName { get; set; }
        [Column(TypeName = "int")]
        public int? TimeSheetCategoryId { get; set; }
    }
}
