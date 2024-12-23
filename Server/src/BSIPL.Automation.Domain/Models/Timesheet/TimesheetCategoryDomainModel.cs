using System.ComponentModel.DataAnnotations.Schema;

namespace BSIPL.Automation.Models.Timesheet
{
    public class TimesheetCategoryDomainModel
    {
        [Column(TypeName = "int")]
        public int TimeSheetCategoryId { get; set; }
        [Column(TypeName = "varchar(255)")]
        public string TimeSheetCategoryName { get; set; }
        [Column(TypeName = "varchar(100)")]
        public string Function { get; set; }
    }
}
