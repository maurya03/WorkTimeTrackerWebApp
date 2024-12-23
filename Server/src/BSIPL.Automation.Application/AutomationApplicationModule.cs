using BSIPL.Automation.SkillsMatrixRepo;
using BSIPL.Automation.SkillsMatrixRepoInterface;
using BSIPL.Automation.ImportExcel;
using BSIPL.Automation.ImportExcelRepo;
using BSIPL.Automation.ImportExcelRepoInterface;
using BSIPL.Automation.SkillsMatrixService;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.Extensions.DependencyInjection;
using Volo.Abp.Account;
using Volo.Abp.AutoMapper;
using Volo.Abp.BackgroundWorkers.Quartz;
using Volo.Abp.Identity;
using Volo.Abp.Modularity;
using Volo.Abp.TenantManagement;
using Volo.Abp.Caching;

namespace BSIPL.Automation;

[DependsOn(
    typeof(AutomationDomainModule),
    typeof(AbpAccountApplicationModule),
    typeof(AutomationApplicationContractsModule),
    typeof(AbpIdentityApplicationModule),
    typeof(AbpTenantManagementApplicationModule),
    typeof(AbpBackgroundWorkersQuartzModule)
    )]
[DependsOn(typeof(AbpCachingModule))]
public class AutomationApplicationModule : AbpModule
{
    public override void ConfigureServices(ServiceConfigurationContext context)
    {
        Configure<AbpAutoMapperOptions>(options =>
        {
            options.AddMaps<AutomationApplicationModule>();
        });

        context.Services.AddScoped<IDashboardService, DashboardService>();
        context.Services.AddScoped<IDashboardRepository, DashboardRepository>();
        context.Services.AddScoped<IValidationService, ValidationService>();
        context.Services.AddScoped<IImportExcelContract, ImportExcelService>();
        context.Services.AddScoped<IImportExcelRepo, ImportExcelRepository>();
    }
}
