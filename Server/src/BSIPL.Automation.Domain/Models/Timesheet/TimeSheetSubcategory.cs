using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BSIPL.Automation.Models.Timesheet
{
    public class TimeSheetSubcategory
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int TimeSheetSubcategoryID { get; set; }

        [Required]
        [Column(TypeName = "varchar(50)")]
        public string TimeSheetSubcategoryName { get; set; }

        public int TimeSheetCategoryID { get; set; }
        [ForeignKey(nameof(TimeSheetCategoryID))]
        public TimeSheetCategory? TimeSheetCategory { get; set; }
    }
}
