using System;

namespace BSIPL.Automation.Models.SkillsMatrix
{
    public class EditClientTeamsModel
    {
        public int Id { get; set; }
        public string? ClientName { get; set; }
        public string? ClientDescription { get; set; }
        public DateTime ModifiedOn { get; set; }

    }
}
