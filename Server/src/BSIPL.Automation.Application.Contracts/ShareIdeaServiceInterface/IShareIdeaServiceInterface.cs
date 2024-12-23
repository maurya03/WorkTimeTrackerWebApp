
using BSIPL.Automation.ApplicationModels.ShareIdeaModels;
using System.Collections.Generic;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;
using BSIPL.Automation.ApplicationModels;

namespace BSIPL.Automation.ShareIdeaServiceInterface
{
    public interface IShareIdeaService : IApplicationService
    {
        Task AddIdeaAsync(ShareIdeaApplicationContractsModel idea, string emailId);
        Task<IList<ShareIdeaCategoryApplicationContractsModel>> GetIdeaCategoryAsync();
        Task<IList<ShareIdeaQuestionsApplicationContractsModel>> GetQuestionsAsync();
        Task<IList<GetShareIdeaCountsWithCategoryApplicationContractsModel>> GetShareIdeaCountsWithCategoryAsync();
        Task<IList<EmployeeShareIdeasApplicationContractsModel>> GetEmployeeShareIdeasAsync();
    }
}