using System;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class ClientMasterApplicationContractsModel
    {
        public int Id { get; set; }
        public string ClientName { get; set; }
        public string ClientDescription { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime ModifiedOn { get; set; }

    }
}
