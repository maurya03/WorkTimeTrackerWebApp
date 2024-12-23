using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BSIPL.Automation.Models.Timesheet
{
    public class TimeSheetCategory
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int TimeSheetCategoryID { get; set; }

        [Required]
        [Column(TypeName = "varchar(50)")]
        public string TimeSheetCategoryName { get; set; }
    }
}
