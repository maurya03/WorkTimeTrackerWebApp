using BSIPL.Automation.EntityFrameworkCore;
using System.Collections.Generic;

using System.Threading.Tasks;
using Volo.Abp.ObjectMapping;
using BSIPL.Automation.ShareIdeaServiceInterface;
using BSIPL.Automation.ShareIdeaRepoInterface;
using BSIPL.Automation.ApplicationModels.ShareIdeaModels;
using BSIPL.Automation.Models.ShareIdeaModels;
using System.Linq;
using BSIPL.Automation.ApplicationModels.ShareIdeaModels.DtoModel;

namespace BSIPL.Automation.ShareIdeaService
{
    public class ShareIdeaService : IShareIdeaService
    {
        private readonly IShareIdeaRepository shareIdeaRepository;
        public IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper { get; }

        public ShareIdeaService(IShareIdeaRepository _shareIdeaRepository, IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper)
        { 
            shareIdeaRepository = _shareIdeaRepository;
            this.objectMapper = objectMapper;
        }

       

        public async Task AddIdeaAsync(ShareIdeaApplicationContractsModel idea, string emailId)
        {
            var mappingShareIdeaObj = objectMapper.Map<ShareIdeaApplicationContractsModel, ShareIdeaModel>(idea);
            await shareIdeaRepository.AddIdeaAsync(mappingShareIdeaObj, emailId);
        }

        public async Task<IList<ShareIdeaCategoryApplicationContractsModel>> GetIdeaCategoryAsync()
        {
            var result = await shareIdeaRepository.GetIdeaCategoryAsync();
            var response = objectMapper.Map< IList<ShareIdeaCategoryModel>, IList<ShareIdeaCategoryApplicationContractsModel>>(result);
            return response;
        }

        public async Task<IList<ShareIdeaQuestionsApplicationContractsModel>> GetQuestionsAsync()
        {
            var result = await shareIdeaRepository.GetQuestionsAsync();
            var response = objectMapper.Map<IList<ShareIdeaQuestionsModel>, IList<ShareIdeaQuestionsApplicationContractsModel>>(result);
            return response;
        }

        public async Task<IList<GetShareIdeaCountsWithCategoryApplicationContractsModel>> GetShareIdeaCountsWithCategoryAsync()
        {
            var result = await shareIdeaRepository.GetShareIdeaCountsWithCategoryAsync();
            var response = objectMapper.Map<IList<GetShareIdeaCountsWithCategoryModel>, IList<GetShareIdeaCountsWithCategoryApplicationContractsModel>>(result);
            return response;
        }

        public async Task<IList<EmployeeShareIdeasApplicationContractsModel>> GetEmployeeShareIdeasAsync()
        {
            var result = await shareIdeaRepository.GetEmployeeShareIdeasAsync();

            var groupByCategory = result.GroupBy(x => x.CategoryId).ToList();
            var employeeShareIdeasApplication = new List<EmployeeShareIdeasApplicationContractsModel>();
            foreach(var groupBy in groupByCategory)
            {
                var record = new EmployeeShareIdeasApplicationContractsModel();
                record.CategoryId = groupBy.Key;
                record.Category = result.FirstOrDefault(x => x.CategoryId == groupBy.Key).Category;


                var categoryResult = result.Where(x => x.CategoryId == groupBy.Key).ToList();
                var groupByShareIdeaId = categoryResult.GroupBy(x => x.ShareIdeaId).ToList();
                var employeeDataList = new List<EmployeeQuestionAnswerDtoModel>();
                foreach (var item in groupByShareIdeaId)
                {
                    var filterRecord = result.Where(x => x.ShareIdeaId == item.Key).FirstOrDefault();
                    var employeeQuestionModel = new EmployeeQuestionAnswerDtoModel();
                    employeeQuestionModel.EmployeeId = filterRecord.EmployeeId.ToString();
                    employeeQuestionModel.FullName = filterRecord.FullName;
                    employeeQuestionModel.EmailId = filterRecord.Email;
                    employeeQuestionModel.ShareIdeaId = item.Key;

                    var questionsAnswer = result.Where(x => x.ShareIdeaId == item.Key).Select(d => new
                    QuestionAnswerDtoModel
                    {
                        Question = d.Question,
                        Answer = d.Answer
                    }).ToList();

                    employeeQuestionModel.QuestionAnswer = questionsAnswer;
                    employeeDataList.Add(employeeQuestionModel);
                }
                record.Model = employeeDataList;
                employeeShareIdeasApplication.Add(record);
            }
           
            return employeeShareIdeasApplication;
        }
    }
}