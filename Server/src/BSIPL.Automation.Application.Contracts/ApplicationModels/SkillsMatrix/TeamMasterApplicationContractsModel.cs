using System;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class TeamMasterApplicationContractsModel
    {
        public int Id { get; set; }
        public int ClientId { get; set; }
        public string TeamName { get; set; }
        public string TeamDescription { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime ModifiedOn { get; set; }
    }
}
