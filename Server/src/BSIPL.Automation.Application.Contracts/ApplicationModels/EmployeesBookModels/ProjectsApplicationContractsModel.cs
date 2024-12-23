using System;

namespace BSIPL.Automation.ApplicationModels.EmployeesBookModels
{
    public class ProjectsApplicationContractsModel
    {
        public int Id { get; set; }
        public string ProjectName { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}