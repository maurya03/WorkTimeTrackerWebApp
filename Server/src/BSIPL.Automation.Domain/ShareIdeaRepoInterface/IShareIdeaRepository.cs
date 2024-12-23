using BSIPL.Automation.ApplicationModels.ShareIdeaModels;
using BSIPL.Automation.Models.ShareIdeaModels;
using System.Collections.Generic;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories;

namespace BSIPL.Automation.ShareIdeaRepoInterface
{
    public interface IShareIdeaRepository : IRepository 
    {
       Task AddIdeaAsync(ShareIdeaModel Idea, string EmailId);
       Task<IList<ShareIdeaCategoryModel>> GetIdeaCategoryAsync();
       Task<IList<ShareIdeaQuestionsModel>> GetQuestionsAsync();
       Task<IList<GetShareIdeaCountsWithCategoryModel>> GetShareIdeaCountsWithCategoryAsync();
       Task<IList<EmployeeShareIdeasModel>> GetEmployeeShareIdeasAsync();
    }
}