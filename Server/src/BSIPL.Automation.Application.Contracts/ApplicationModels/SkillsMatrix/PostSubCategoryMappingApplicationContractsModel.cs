using System;

namespace BSIPL.Automation.ApplicationModels.SkillsMatrix
{
    public class PostSubCategoryMappingApplicationContractsModel
    {
        public int Id { get; set; }
        public int TeamId { get; set; }
        public int SubCategoryId { get; set; }
        public int ClientExpectedScore { get; set; }
        public DateTime CreatedOn { get; set; }
        public DateTime ModifiedOn { get; set; }

    }
}
