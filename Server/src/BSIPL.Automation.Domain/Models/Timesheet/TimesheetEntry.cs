using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BSIPL.Automation.Models.Timesheet
{
    public class Timesheet
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int EntryID { get; set; }

        public string EmailId { get; set; }

        [Column(TypeName = "int")]
        public int StatusID { get; set; }       

        [Required]
        [Column(TypeName = "varchar(50)")]
        public string Remarks { get; set; }


        public DateTime WeekStartDate { get; set; }

       
        public DateTime WeekEndDate { get; set; }

        [Column(TypeName = "datetime")]
        public DateTime Created { get; set; }

        [Column(TypeName = "datetime")]
        public DateTime Modified { get; set; }

        public int OnBehalfTimesheetCreatedFor { get; set; }
        public string OnBehalfTimesheetCreatedByEmail { get; set; }
        public int TimesheetId { get; set; }
    }
}
