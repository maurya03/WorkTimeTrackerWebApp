using System.Collections.Generic;

namespace BSIPL.Automation.ApplicationModels
{
    public class EmployeeRoleDetailApplicationContractsModel
    {
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string Email { get; set; }
        public List<RoleDetailModel> Roles { get; set; }
    }

    public class RoleDetailModel
    {
        public int Id { get; set; }
        public string RoleName { get; set; }
        public bool value { get; set; }
    }
}
