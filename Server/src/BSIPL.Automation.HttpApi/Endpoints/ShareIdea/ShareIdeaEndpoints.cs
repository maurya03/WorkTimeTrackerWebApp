using BSIPL.Automation.ApplicationModels.ShareIdeaModels;
using BSIPL.Automation.CommonServiceInterface;
using BSIPL.Automation.ShareIdeaServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace BSIPL.Automation.Endpoints.ShareIdea
{
    public static class ShareIdeaEndpoints
    {
        public static WebApplication MapShareIdeaEndpoints(this WebApplication app)
        {
            var ShareIdeaTag = "ShareIdea";

             _= app.MapPost("/AddIdea", async (IConfiguration config, [FromServices] IUserService userService, [FromServices] IShareIdeaService shareIdeaService, [FromBody] ShareIdeaApplicationContractsModel addIdeaModel, IHttpContextAccessor contextAccessor) =>
             {
                 var result = await userService.UserInfo();
                 await shareIdeaService.AddIdeaAsync(addIdeaModel, result.EmailId);
             }).WithTags(ShareIdeaTag);

            _ = app.MapGet("/GetIdeaCategory", async ([FromServices] IShareIdeaService shareIdeaService) =>
            {
                return await shareIdeaService.GetIdeaCategoryAsync();
            }).WithTags(ShareIdeaTag);

            _ = app.MapGet("/GetQuestions", async ([FromServices] IShareIdeaService shareIdeaService) =>
            {
                return await shareIdeaService.GetQuestionsAsync();
            }).WithTags(ShareIdeaTag);

            _ = app.MapGet("/GetShareIdeaCountsWithCategory", async ([FromServices] IShareIdeaService shareIdeaService) =>
            {
                return await shareIdeaService.GetShareIdeaCountsWithCategoryAsync();
            }).WithTags(ShareIdeaTag);

            _ = app.MapGet("/GetEmployeeShareIdeas", async ([FromServices] IShareIdeaService shareIdeaService) =>
            {
                return await shareIdeaService.GetEmployeeShareIdeasAsync();
            }).WithTags(ShareIdeaTag);

            return app;
        }
    }
}
