using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.EmployeesBookModels;
using BSIPL.Automation.EmployeesBookServiceInterface;
using BSIPL.Automation.LoggerServiceInterface;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Hosting.Server;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http.Headers;
using Volo.Abp.Modularity;
using static Volo.Abp.Identity.Settings.IdentitySettingNames;


namespace BSIPL.Automation.Endpoints.EmployeesBook
{
    public static class EmployeesBookEndpoint
    {
        public static WebApplication MapEmployeesBookEndpoints(this WebApplication app)
        {
            var EmployeesBookTag = "EmployeesBook";


            _ = app.MapGet("/GetProjects", async ([FromServices] IEmployeesBookService emloyeesBookService,  IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.GetProjectListAsync();
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapGet("/getRoleBasedProjects", async ([FromServices] IEmployeesBookService emloyeesBookService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.GetProjectListByEmailAsync(contextAccessor.HttpContext.Request.Headers["emailId"].ToString());
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapGet("/GetDesignations", async ([FromServices] IEmployeesBookService emloyeesBookService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.GetDesignationsAsync();
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapGet("/GetProjectById", async ([FromServices] IEmployeesBookService emloyeesBookService, int id, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.GetProjectByIdAsync(id);
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapGet("/GetEmployeesWithSearch", async ([FromServices] IEmployeesBookService emloyeesBookService, int projectId, string interests, string sortBy, string searchText, int page, int pageSize, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.GetEmployeesWithSearchListAsync(projectId, interests, sortBy, searchText, page, pageSize, contextAccessor.HttpContext.Request.Headers["emailId"].ToString());
                return (result);
            }).WithTags(EmployeesBookTag);


            _ = app.MapGet("/GetEmployeeDetailById", async ([FromServices] IEmployeesBookService emloyeesBookService, string employeeId, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.GetEmployeeDetailByIdAsync(employeeId);
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapGet("/GetUpdatedEmployeeDetailById", async ([FromServices] IEmployeesBookService emloyeesBookService, string employeeId, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.GetUpdatedEmployeeDetailByIdAsync(employeeId);
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapPost("/UpdateEmployeeDetailByEmployee", async ([FromServices] IEmployeesBookService emloyeesBookService, [FromBody] EmployeeMasterApplicationContractsModel updateEmployee, IHttpContextAccessor contextAccessor) =>
            {
                return await emloyeesBookService.AddEmployeeMasterUpdateAsync(updateEmployee);
            }).WithTags(EmployeesBookTag);

            _ = app.MapPut("/UpdateEmployeeDetailById", async ([FromServices] IEmployeesBookService emloyeesBookService, [FromBody] EmployeeMasterApplicationContractsModel updatedEmployee, string employeeId, IHttpContextAccessor contextAccessor) =>
            {
                return await emloyeesBookService.UpdateEmployeeDetailByIdAsync(employeeId, updatedEmployee);
            }).WithTags(EmployeesBookTag);

            _ = app.MapGet("/GetUpdateEmployeeDetails", async ([FromServices] IEmployeesBookService emloyeesBookService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.GetUpdatedEmployeeDetailsAsync();
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapPut("/UpdateEmployeeDetail", async ([FromServices] IEmployeesBookService emloyeesBookService, string employeeId, [FromBody] EmployeeMasterApplicationContractsModel updateEmployee, IHttpContextAccessor contextAccessor) =>
            {
                 return await emloyeesBookService.UpdateEmployeeDetailAsync(employeeId, updateEmployee);
               
            }).WithTags(EmployeesBookTag);

            _ = app.MapDelete("/EmployeeDetail", async ([FromServices] IEmployeesBookService emloyeesBookService, string employeeId, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.DeleteEmployeeByIdAsync(employeeId, contextAccessor.HttpContext.Request.Headers["emailId"].ToString());
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapDelete("/UpdatedEmployeeDetailById", async ([FromServices] IEmployeesBookService emloyeesBookService, string employeeId, IHttpContextAccessor contextAccessor) =>
            {
                await emloyeesBookService.DeleteUpdatedEmployeeDetailByIdAsync(employeeId);
                return Results.Ok();
            }).WithTags(EmployeesBookTag);

            _ = app.MapGet("/GetEmployeeBookRoles", async ([FromServices] IEmployeesBookService emloyeesBookService, [FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await skillsMatrixService.GetRoleListAsync();
                return (result);
            }).WithTags(EmployeesBookTag);


            _ = app.MapGet("/GetAssignedRole", async ([FromServices] IEmployeesBookService emloyeesBookService, [FromServices] ISkillsMatrixService skillsMatrixService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.GetAssignedRoleAsync(contextAccessor.HttpContext.Request.Headers["emailId"].ToString());
                return (result);
            }).WithTags(EmployeesBookTag);


            _ = app.MapPost("/AddEmployeeRole", async ([FromServices] IEmployeesBookService emloyeesBookService, [FromBody] EmployeeRoleMapApplicationContractsModel postEmployeeRoleMapping, IHttpContextAccessor contextAccessor) =>
            {
               var result =  await emloyeesBookService.AddEmployeeRoleMapAsync(contextAccessor.HttpContext.Request.Headers["emailId"].ToString(), postEmployeeRoleMapping);
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapPost("/AddExcelEmployeeData", async ([FromServices] IEmployeesBookService emloyeesBookService, [FromBody] IList<EmployeeMasterApplicationContractsModel> postEmployeeExcelData, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.AddEmployeeExcelAsync(contextAccessor.HttpContext.Request.Headers["emailId"].ToString(), postEmployeeExcelData);
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapGet("/GetEmployees", async ([FromServices] IEmployeesBookService emloyeesBookService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.GetEmployeesAsync();
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapPost("/UpdateEmployeeImage", async (IWebHostEnvironment hostingEnvironment, IConfiguration configuration,[FromServices] IEmployeesBookService emloyeesBookService, [FromForm] IFormFile employeeImgFile, IHttpContextAccessor contextAccessor) =>
            {
                var employeeId = contextAccessor.HttpContext.Request.Form["employeeId"];

                if (employeeImgFile != null && !string.IsNullOrEmpty(employeeId))
                {
                    try
                    {
                        // Define the path where you want to save the image
                        //var savePath = Path.Combine(hostingEnvironment.WebRootPath, "EmployeeImages");
                        var savePath = configuration.GetValue<string>("EnvironmentPath:EmpImagePath");

                        // Ensure the directory exists
                        if (!Directory.Exists(savePath))
                        {
                            Directory.CreateDirectory(savePath);
                        }

                        // Create a unique file name
                        var fileName = $"{employeeId}_{employeeImgFile.FileName}";
                        var filePath = Path.Combine(savePath, fileName);

                        // Save the file to the server
                        using (var stream = new FileStream(savePath, FileMode.Create))
                        {
                            await employeeImgFile.CopyToAsync(stream);
                        }

                        // Now update the image URL in the respective employee record
                        var imageUrl = $"https://bhavnawks132.bhavnacorp.net/empImage/{fileName}";
                        await emloyeesBookService.UpdateEmployeeImageUrlAsync(employeeId, imageUrl);
                    }
                    catch (Exception ex)
                    {
                        // Log the exception (you can add logging here)
                        return Results.StatusCode(500);
                    }
                    /*try
                    {
                        var domainPath = configuration.GetValue<string>("EnvironmentPath:EmpImagePath");
                        string url = $"ftp://{domainPath}/'{employeeId}'_{employeeImgFile.FileName}";
                        
                        FtpWebRequest request = (FtpWebRequest)WebRequest.Create(url);
                        request.Credentials = new NetworkCredential(configuration.GetValue<string>("EnvironmentPath:FtpUserName"), configuration.GetValue<string>("EnvironmentPath:FtpPassword"));
                        request.Method = WebRequestMethods.Ftp.UploadFile;
                        request.Proxy = null;
                        request.KeepAlive = true;
                        request.UseBinary = true;
                        using (Stream ftpStream = request.GetRequestStream())
                        {
                            employeeImgFile.CopyTo(ftpStream);
                        }

                        // Now Update Image to respective Employee UpdateEmployeeImageUrl
                        await emloyeesBookService.UpdateEmployeeImageUrlAsync(employeeId, employeeImgFile.FileName);
                    }
                    catch (Exception ex)
                    {
                        return 0;
                    }*/
                }

                return Results.Ok(1);
            }).WithTags(EmployeesBookTag);

            _ = app.MapPost("/WindowLogin", async (IConfiguration config, [FromServices] IEmployeesBookService emloyeesBookService, [FromBody] LoginModelApplicationContractsModel postLoginCred, IHttpContextAccessor contextAccessor) =>
            {
                var result = await emloyeesBookService.LoginWindowAuth(postLoginCred, config["Domain:BhavnaDomain"], config["AzureAdWindow:Instance"], config["AzureAdWindow:TenantId"], config["AzureAdWindow:ClientId"], config["AzureAdWindow:Resource"], config["AzureAdWindow:Scope"], config["AzureAdWindow:Grant_Type"], config["AzureAdWindow:Client_Secret"]);
                return (result);
            }).WithTags(EmployeesBookTag);

             _ = app.MapGet("/GetAnalyticsReport", async ([FromServices] IEmployeesBookService emloyeesBookService, [FromQuery] string filter, [FromQuery] DateTime startDate, [FromQuery] DateTime endDate, IHttpContextAccessor contextAccessor) =>
             {
                 var result = await emloyeesBookService.GetAnalyticsReportAsync(filter, startDate, endDate);
                 return (result);
             }).WithTags(EmployeesBookTag);

            _ = app.MapGet("/GetEmployeebookLogs", async (string filter, [FromServices]  ILoggerService loggerService, IHttpContextAccessor contextAccessor) =>
            {
                var result = await loggerService.GetLogs(filter);
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapGet("/GetGoogleAnalyticalReports", async ([FromServices] IEmployeesBookService emloyeesBookService, [FromQuery] DateTime startDate, [FromQuery] DateTime endDate) =>
            {
                
                var result = await emloyeesBookService.GetGoogleAnalyticalReport(startDate, endDate);
                return (result);
            }).WithTags(EmployeesBookTag);

            _ = app.MapPost("/AddLog", async (IConfiguration config, [FromServices] IEmployeesBookService emloyeesBookService, [FromBody] LoggerApplicationContractsModel postLoggerModel, IHttpContextAccessor contextAccessor) =>
            {
                await emloyeesBookService.AddLogAsync(postLoggerModel);
            }).WithTags(EmployeesBookTag);

            _ = app.MapGet("/health", async ([FromServices] IEmployeesBookService emloyeesBookService, IHttpContextAccessor contextAccessor) =>
            {
                return Results.Ok();
            }).WithTags(EmployeesBookTag);

            return app;
        }
    }
}