using System;
using System.Threading.Tasks;
using BSIPL.Automation.Web.Middleware;
using BSIPL.Automation.Web.Policy;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Serilog;
using Serilog.Events;
using BSIPL.Automation.EmployeesBookRepoInterface;
using BSIPL.Automation.EmployeesBookRepo;
using BSIPL.Automation.EmployeesBookServiceInterface;
using Microsoft.Extensions.Configuration;
using BSIPL.Automation.TimesheetService.Validation;
using BSIPL.Automation.SkillsMatrixRepo;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using BSIPL.Automation.SkillsMatrixRepoInterface;
using BSIPL.Automation.LoggerServiceInterface;
using BSIPL.Automation.LoggerRepoInterface;
using BSIPL.Automation.LoggerRepo;
using BSIPL.Automation.Contracts.Interface;
using BSIPL.Automation.ServiceImplementation;
using BSIPL.Automation.ServiceInterface.Validation;
using BSIPL.Automation.Domain.Interface;
using BSIPL.Automation.RepositoryImplementation;
using BSIPL.Automation.ShareIdeaServiceInterface;
using BSIPL.Automation.ShareIdeaRepoInterface;
using BSIPL.Automation.ShareIdeaRepo;


namespace BSIPL.Automation.Web;

public class Program
{
    public async static Task<int> Main(string[] args)
    {
        Log.Logger = new LoggerConfiguration()
#if DEBUG
            .MinimumLevel.Debug()
#else
            .MinimumLevel.Information()
#endif
            .MinimumLevel.Override("Microsoft", LogEventLevel.Information)
            .MinimumLevel.Override("Microsoft.EntityFrameworkCore", LogEventLevel.Warning)
            .Enrich.FromLogContext()
            .WriteTo.Async(c => c.File("Logs/logs.txt"))
            .WriteTo.Async(c => c.Console())
            .CreateLogger();

        try
        {
            Log.Information("Starting web host.");
            var builder = WebApplication.CreateBuilder(args);

            var path = $"{builder.Environment.ContentRootPath}{builder.Configuration.GetValue<string>("EnvironmentPath:GoogleAnalyticsJsonPath")}";
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", path);

            builder.Host.AddAppSettingsSecretsJson()
                 .UseAutofac()
                 .UseSerilog();
            await builder.AddApplicationAsync<AutomationWebModule>();
            builder.Services.AddScoped<ISkillsMatrixService, SkillsMatrixService.SkillsMatrixService>();
            builder.Services.AddScoped<ITimeSheetService, TimeSheetService>();
            builder.Services.AddScoped<ISkillsMatrixRepository, SkillsMatrixRepository>();

            builder.Services.AddScoped<ILoggerService, LoggerService.LoggerService>();
            builder.Services.AddScoped<ITimeSheetValidation, TimeSheetValidation>();
            builder.Services.AddScoped<ILoggerRepository, LoggerRepository>();


            // EmployeeBook START

            builder.Services.AddScoped<IEmployeesBookService, EmployeesBookService.EmployeesBookService>();
            builder.Services.AddScoped<IEmployeesBookRepository, EmployeesBookRepository>();

            builder.Services.AddScoped<IShareIdeaService, ShareIdeaService.ShareIdeaService>();
            builder.Services.AddScoped<IShareIdeaRepository, ShareIdeaRepository>();

            //EmployeeBook END

            // User Start
            builder.Services.AddScoped<IUserCredentialRepository, UserCredentialRepository>();
            builder.Services.AddScoped<IUserCredentialService, UserCredentialService>();
            // User END

            builder.Services.AddScoped<IUserCredentialService, UserCredentialService>();
            


            builder.Services.AddAuthorization(o =>
            {
                o.AddPolicy("ADMIN", p => p.AddRequirements(new AdminRoleRequirement("ADMIN")));
            });
            builder.Services.AddSingleton<IAuthorizationHandler, AdminRoleRequirementHandler>();
            builder.Services.AddScoped<ITimeSheetRepository, TimeSheetRepository>();
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddCors();

            // Adding CORS Policy
            var allowedOrigin = builder.Configuration.GetSection("AllowedOrigin").Get<string[]>();
            builder.Services.AddCors(options =>
            {
                options.AddPolicy("SkillMatrixPolicy",
                    builder => builder.WithOrigins(allowedOrigin!));
            });

            builder.Services.AddSwaggerGen();

            var app = builder.Build();
            app.UseMiddleware<ExceptionMiddleware>();
          
            app.UseMiddleware<AuthMiddleware>();
            app.UseCors(builder =>
            {
                builder
                .WithOrigins(allowedOrigin!)
                .AllowAnyMethod()
                .AllowAnyHeader()
                .AllowCredentials();
            });
            // Shows UseCors with named policy.
            app.UseCors("SkillMatrixPolicy");
            app.ConfigureEndpoints();
            await app.InitializeApplicationAsync();
            await app.RunAsync();
            return 0;
        }
        catch (Exception ex)
        {
            if (ex is HostAbortedException)
            {
                throw;
            }

            Log.Fatal(ex, "Host terminated unexpectedly!");
            return 1;
        }
        finally
        {
            Log.CloseAndFlush();
        }
    }
}