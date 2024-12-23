namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class ApplicationAccessModel
    {
        public string EmployeeId { get; set; }
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public string ApplicationName { get; set; }
        public bool CanView { get; set; }
        public bool CanEdit { get; set; }
        public bool CanDelete { get; set; }
        public int ApplicationId { get; set; }
        public string ApplicationPath { get; set; }


    }
}
