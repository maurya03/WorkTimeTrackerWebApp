using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace BSIPL.Automation.Models.SkillsMatrix
{
    public class EmployeeRolesModel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int EmployeeRoleId { get; set; }
        public int RoleId { get; set; }
        [ForeignKey(nameof(RoleId))]
        public RolesModel? RoleModel { get; set; }
        public string EmployeeId { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime CreatedDate { get; set; }
        [Column(TypeName = "datetime")]
        public DateTime UpdatedDate { get; set; }
        [Column(TypeName = "bit")]
        public int IsActive { get; set; }
    }
}
