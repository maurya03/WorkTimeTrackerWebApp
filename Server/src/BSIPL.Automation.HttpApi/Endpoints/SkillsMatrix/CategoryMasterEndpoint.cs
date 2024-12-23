using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using BSIPL.Automation.Domain.Shared.Enum;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;

namespace BSIPL.Automation.Endpoints.SkillsMatrix
{
    public static class CategoryMasterEndpoint
    {
        public static WebApplication MapCategoryMasterEndpoints(this WebApplication app)
        {
            var categoryRoute = app.MapGroup("api/v1").WithTags("Category");

            _ = categoryRoute.MapGet("/categories", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetCategoryListAsync();
                return result;
            });

            _ = categoryRoute.MapGet("/categoriesWithTeamScore", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor, [FromQuery] int teamId, [FromQuery] int isWithScore) =>
            {
                var result = await skillsMatrixService.GetCategoryWithTeamScoreListAsync(isWithScore, teamId);
                return result;
            });

            _ = categoryRoute.MapPost("/category", async ([FromServices] IValidationService validationService, [FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] CategoryMasterApplicationContractsModel postCategory, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if (role != null && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.Reporting_Manager.ToString()))
                {
                    var errorMessageList = await validationService.ValidateAddCategory(postCategory, emailId);
                    if (errorMessageList.Count > 0)
                    {
                        return Results.BadRequest(errorMessageList);
                    }

                    await skillsMatrixService.AddCategoryAsync(postCategory, emailId);
                    return Results.Ok();
                }

                return Results.Unauthorized();

            });

            _ = categoryRoute.MapPut("/category/{Id}", async (int? Id, [FromServices] IValidationService validationService, [FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] CategoryMasterApplicationContractsModel Category, IHttpContextAccessor contextAccessor) =>
            {
                if (Id.HasValue)
                {
                    if (Category.CategoryName.IsNullOrWhiteSpace() || Category.CategoryDescription.IsNullOrWhiteSpace())
                    {
                        throw new Exception("Name or Description is empty");
                    }
                    else
                    {
                        var emailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
                        var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                        if (role != null && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.Reporting_Manager.ToString()))
                        {
                            var errorMessageList = await validationService.ValidateUpdateCategory(Category, Id);
                            if (errorMessageList.Count > 0)
                            {
                                return Results.BadRequest(errorMessageList);
                            }

                            await skillsMatrixService.EditCategoryAsync(Category, Id, emailId);
                            return Results.Ok();
                        }

                        return Results.Unauthorized();
                    }

                }
                else
                {
                    throw new Exception("Id is empty");
                }
            });

            _ = categoryRoute.MapDelete("/category", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromQuery] int Id, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if (role != null && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.Reporting_Manager.ToString()))
                {
                    await skillsMatrixService.DeleteCategory(Id);
                }
            });
            _ = categoryRoute.MapGet("/subCategoriesByCategoryId", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromQuery] int CategoryId, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetSubCategoryByCategoryIdAsync(CategoryId);
                return result;
            });

            _ = categoryRoute.MapPut("/subCategory", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] EditCategorySubcategoryApplicationContractsModel editCategorySubcategoryObj, IHttpContextAccessor contextAccessor) =>
            {

                await skillsMatrixService.EditCategorySubcategory(editCategorySubcategoryObj);

            }).RequireAuthorization(RoleEnum.Admin.ToString());

            _ = categoryRoute.MapGet("/subCategories", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetSubCategoryListAsync();
                return result;
            });

            _ = categoryRoute.MapPost("/subCategory", async ([FromServices] IValidationService validationService, [FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] SubCategoryMasterApplicationContractsModel postSubCategory, IHttpContextAccessor contextAccessor) =>
            {
            var emailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
            var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if (role != null && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.Reporting_Manager.ToString()))
                {
                    var errorMessageList = await validationService.ValidateAddSubCategory(postSubCategory);
                    if (errorMessageList.Count > 0)
                    {
                        return Results.BadRequest(errorMessageList);
                    }
                    await skillsMatrixService.AddSubCategoryAsync(postSubCategory, emailId);
                    return Results.Ok();
                }

                return Results.Unauthorized();

            });

            _ = categoryRoute.MapPut("/subCategory/{Id}", async (int? Id, [FromServices] IValidationService validationService, [FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] SubCategoryMasterApplicationContractsModel SubCategory, IHttpContextAccessor contextAccessor) =>
            {

                if (Id.HasValue)
                {
                    var emailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
                    var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                    if (role != null && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.Reporting_Manager.ToString()))
                    {
                        var errorMessageList = await validationService.ValidateUpdateSubCategory(SubCategory, Id);
                        if (errorMessageList.Count > 0)
                        {
                            return Results.BadRequest(errorMessageList);
                        }

                        await skillsMatrixService.EditSubCategoryAsync(SubCategory, Id, emailId);
                        return Results.Ok();
                    }

                    return Results.Unauthorized();

                }
                else
                {
                    return Results.BadRequest(new ValidationErrorMessage() { ErrorMessage = "subcategoryId not passed" });
                }
            });

            _ = categoryRoute.MapDelete("/subCategory", async ([FromServices] ISkillsMatrixService skillsMatrixService, int subCategoryId, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if (role != null && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.Reporting_Manager.ToString()))
                {
                    await skillsMatrixService.DeleteSubCategoryById(subCategoryId);
                }

            });

            _ = categoryRoute.MapGet("/SubCategoryMapping", async ([FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = new List<SubCategoryMappingApplicationContractsModel>();

                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if (role == null)
                    return null;

                if (role.RoleName == RoleEnum.Admin.ToString())
                {
                    result = (await skillsMatrixService.GetSubCategoryMappingAsync()).ToList();
                }
                else if (role.RoleName == RoleEnum.Reporting_Manager.ToString())
                {
                    result = (await skillsMatrixService.GetSubCategoryMappingAsync()).ToList();
                }
                return result;
            });

            _ = categoryRoute.MapPost("/subCategoryMapping", async ([FromServices] IValidationService validationService, [FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] IList<PostSubCategoryMappingApplicationContractsModel> postSubCategoryMapping, IHttpContextAccessor contextAccessor) =>
            {
                var emailId = contextAccessor.HttpContext.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if (role != null && (role.RoleName == RoleEnum.Admin.ToString() || role.RoleName == RoleEnum.Reporting_Manager.ToString()))
                {
                    var errorList = await validationService.ValidateClientExpectedScore(postSubCategoryMapping);
                    if (errorList.Count > 0)
                    {
                        return Results.BadRequest(errorList);
                    }
                    await skillsMatrixService.AddSubCategoryMappingAsync(postSubCategoryMapping, emailId);

                    return Results.Ok();
                }

                return Results.Unauthorized();

            });

            _ = categoryRoute.MapPut("/subCategoryMapping", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromBody] SubCategoryMappingApplicationContractsModel putSubCategoryMapping) =>
            {
                await skillsMatrixService.UpdateSubCategoryMappingAsync(putSubCategoryMapping);
            });

            _ = categoryRoute.MapGet("/TeamSubCategoryMapping", async ([FromServices] ISkillsMatrixService skillsMatrixService, [FromQuery] int teamId, IHttpContextAccessor contextAccessor) =>
            {

                var result = new List<SubCategoryClientMappingScoreModel>();
                var emailId = contextAccessor?.HttpContext?.Request.Headers["emailId"].ToString();
                var role = await skillsMatrixService.GetRoleByEmailIdAsync(emailId);
                if (role == null)
                    return null;

                if (role.RoleName == RoleEnum.Admin.ToString())
                {
                    result = (await skillsMatrixService.GetTeamSubCategoryByIdAsync(teamId)).ToList();
                }
                else if (role.RoleName == RoleEnum.Reporting_Manager.ToString())
                {
                    result = (await skillsMatrixService.GetTeamSubCategoryByIdAsync(teamId)).ToList();
                }
                return result;
            });
            return app;
        }
    }
}
