using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BSIPL.Automation.Models.SkillsMatrix
{
    public class SubCategoryMappingModel
    {
        //[Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        public int? TeamId { get; set; }
        [ForeignKey(nameof(TeamId))]
        public virtual TeamMasterModel? TeamMasterModel { get; set; }

        public int? SubCategoryId { get; set; }
        [ForeignKey(nameof(SubCategoryId))]
        public virtual SubCategoryMasterModel? SubCategoryMasterModel { get; set; }

        [Required]
        public int ClientExpectedScore { get; set; }

        [Column(TypeName = "datetime")]
        public DateTime CreatedOn { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime ModifiedOn { get; set; }
    }
}
