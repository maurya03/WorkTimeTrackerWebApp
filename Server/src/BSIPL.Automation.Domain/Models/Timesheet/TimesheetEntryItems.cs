using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BSIPL.Automation.Models.Timesheet
{
    public class TimesheetEntryItems
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int ItemID { get; set; }

        public int EntryID { get; set; }
        [ForeignKey(nameof(EntryID))]
        public Timesheet? TimesheetEntry { get; set; }

        public int TimeSheetCategoryID { get; set; }
        [ForeignKey(nameof(TimeSheetCategoryID))]
        public TimeSheetCategory? TimeSheetCategory { get; set; }

        public int TimeSheetSubcategoryID { get; set; }
        [ForeignKey(nameof(TimeSheetSubcategoryID))]
        public TimeSheetSubcategory? TimeSheetSubcategory { get; set; }


        public string TaskDescription { get; set; }

        [Column(TypeName = "int")]
        public int DayOfWeek { get; set; }

        [Column(TypeName = "decimal(5,2)")]
        public decimal HoursWorked { get; set; }

        [Column(TypeName = "int")]
        public int ProjectId { get; set; }
    }
}
