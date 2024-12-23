using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BSIPL.Automation.Models.SkillsMatrix
{
    public class SubCategoryMasterModel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        //public int? ClientId { get; set; }
        //[ForeignKey(nameof(ClientId))]
        //public ClientMasterModel? ClientMasterModel { get; set; }

        public int? CategoryId { get; set; }
        [ForeignKey(nameof(CategoryId))]
        public CategoryMasterModel? CategoryMasterModel { get; set; }

        [Required]
        [Column(TypeName = "varchar(50)")]
        public string SubCategoryName { get; set; }
        [Required]
        [Column(TypeName = "varchar(250)")]
        public string SubCategoryDescription { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime CreatedOn { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime ModifiedOn { get; set; }
    }
}
