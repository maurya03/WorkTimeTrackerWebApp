using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BSIPL.Automation.Models.SkillsMatrix
{
    public class SkillsMatrixModel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }


        public string BhavnaEmployeeId { get; set; }
        [ForeignKey(nameof(BhavnaEmployeeId))]
        public EmployeeDetailsModel? EmployeeDetailsModel { get; set; }


        //public int? TeamId { get; set; }
        //[ForeignKey(nameof(TeamId))]
        //public TeamMasterModel? TeamMasterModel { get; set; }

        public int? SubCategoryId { get; set; }
        [ForeignKey(nameof(SubCategoryId))]
        public SubCategoryMasterModel? SubCategoryMasterModel { get; set; }

        [Required]
        public int EmployeeScore { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime CreatedOn { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime ModifiedOn { get; set; }
    }
}
