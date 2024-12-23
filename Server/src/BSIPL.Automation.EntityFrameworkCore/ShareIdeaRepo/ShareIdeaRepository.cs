
using BSIPL.Automation.Domain.Shared.Enum.EmployeesBookEnum;
using BSIPL.Automation.EntityFrameworkCore;
using BSIPL.Automation.Models.ShareIdeaModels;
using BSIPL.Automation.ShareIdeaRepoInterface;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories.Dapper;
using Volo.Abp.EntityFrameworkCore;


namespace BSIPL.Automation.ShareIdeaRepo
{
    public class ShareIdeaRepository : DapperRepository<AutomationDbContext>, IShareIdeaRepository
    {
        public ShareIdeaRepository(IDbContextProvider<AutomationDbContext> dbContextProvider) : base(dbContextProvider)
        {


        }

        public async Task AddIdeaAsync(ShareIdeaModel idea, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var dt = new DataTable();
            if (idea != null && idea.ShareIdeas.Count > 0)
            {
                dt.Columns.Add("QuestionId", typeof(int));
                dt.Columns.Add("Answere", typeof(string));
                foreach (var QuestionAnswer in idea.ShareIdeas)
                {
                    var row = dt.NewRow();
                    row["QuestionId"] = QuestionAnswer.QuestionId;
                    row["Answere"] = QuestionAnswer.Answer;
                    dt.Rows.Add(row);
                }
            }
            var parameters = new DynamicParameters();
            parameters.Add("@EmailId", emailId);
            parameters.Add("@Action", DbActionEnum.INSERT);
            parameters.Add("@QuestionAnswer", dt, DbType.Object);
            parameters.Add("@CategoryId", idea.CategoryId);
            await dbConnection.ExecuteAsync("usp_Crud_SharedIdea", parameters, commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync());
        }


        public async Task<IList<ShareIdeaCategoryModel>> GetIdeaCategoryAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            var result = (await dbConnection.QueryAsync<ShareIdeaCategoryModel>($"SELECT * FROM ShareIdeaCategory",
                transaction: await GetDbTransactionAsync())).ToList();
            return result;
        }

        public async Task<IList<ShareIdeaQuestionsModel>> GetQuestionsAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            var result = (await dbConnection.QueryAsync<ShareIdeaQuestionsModel>($"SELECT Id, Question FROM ShareIdeaQuestions",
                transaction: await GetDbTransactionAsync())).ToList();
            return result;
        }

        public async Task<IList<GetShareIdeaCountsWithCategoryModel>> GetShareIdeaCountsWithCategoryAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            var result = (await dbConnection.QueryAsync<GetShareIdeaCountsWithCategoryModel>($"SELECT * FROM vw_GetShareIdeaCategoryWithCounts",
                transaction: await GetDbTransactionAsync())).ToList();
            return result;
        }

        public async Task<IList<EmployeeShareIdeasModel>> GetEmployeeShareIdeasAsync()
        {
            try
            {
                var dbConnection = await GetDbConnectionAsync();
                var result = (await dbConnection.QueryAsync<EmployeeShareIdeasModel>($"SELECT * From vw_GetShareIdeaEmployeeRecords",
                    transaction: await GetDbTransactionAsync())).ToList();
                return result;

            }
            catch(Exception ex)
            {
                return [];

            }
        }

    }
}
