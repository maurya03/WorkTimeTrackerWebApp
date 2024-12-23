using System;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class EditClientTeamsApplicationContractsModel
    {
        public int Id { get; set; }
        public string? ClientName { get; set; }
        public string? ClientDescription { get; set; }

        public DateTime ModifiedOn = DateTime.Now;
    }
}
