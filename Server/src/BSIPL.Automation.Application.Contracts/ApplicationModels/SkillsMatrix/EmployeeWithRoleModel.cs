namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class EmployeeWithRoleModel
    {
        public string EmployeeId { get; set; }
        public int? TeamId { get; set; }
        public int? ClientId { get; set; }
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public string EmployeeName { get; set; }
    }
}
