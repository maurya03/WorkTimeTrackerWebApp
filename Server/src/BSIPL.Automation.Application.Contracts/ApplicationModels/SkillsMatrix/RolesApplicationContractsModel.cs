using System;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class RolesApplicationContractsModel
    {
        public int RoleId { get; set; }
        public string? RoleName { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
        public int IsActive { get; set; }
    }
}
