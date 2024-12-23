using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BSIPL.Automation.Models
{
    public class LoggerModel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        [Column(TypeName = "varchar(50)")]
        public string LoggerType { get; set; }

        [Column(TypeName = "varchar(200)")]
        public string Source { get; set; }

        [Column(TypeName = "varchar(max)")]
        public string Description { get; set; }

        [Column(TypeName = "datetime")]
        public DateTime CreatedDate { get; set; }

        [Column(TypeName = "varchar(50)")]
        public string LogFrom { get; set; }
    }
}
