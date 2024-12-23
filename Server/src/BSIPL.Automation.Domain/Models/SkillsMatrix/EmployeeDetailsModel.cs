using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System;

namespace BSIPL.Automation.Models.SkillsMatrix
{
    public class EmployeeDetailsModel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public string EmployeeId { get; set; }
        public int Id { get; set; }

        public int? Type { get; set; }
        public int Role { get; set; }
        public int DesignationId { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
        public string CreatedById { get; set; }

        public int? TeamId { get; set; }
        [ForeignKey(nameof(TeamId))]
        public TeamMasterModel? TeamMasterModel { get; set; }

        [Required]
        [Column(TypeName = "varchar(50)")]
        public string EmployeeName { get; set; }

        [Column(TypeName = "varchar(150)")]
        public string EmailId { get; set; }
        public string FunctionType { get; set; }

        public string? BhavnaEmployeeId { get; set; }
    }
    public class EmployeeSkillMatrixModel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public string BhavnaEmployeeId { get; set; }

        [Required]
        [Column(TypeName = "varchar(50)")]
        public string EmployeeName { get; set; }
        public int EmployeeScore { get; set; }
        public int? SubCategoryId { get; set; }
        public int? MappingId { get; set; }
    }

}
