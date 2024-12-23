using System;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class EmployeeRolesApplicationContractsModel
    {
        public int EmployeeRoleId { get; set; }
        public int RoleId { get; set; }
        public string EmployeeId { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
        public int IsActive { get; set; }
    }
}
