using BSIPL.Automation.EntityFrameworkCore;
using Volo.Abp.Autofac;
using Volo.Abp.Modularity;

namespace BSIPL.Automation.DbMigrator;

[DependsOn(
    typeof(AbpAutofacModule),
    typeof(AutomationEntityFrameworkCoreModule),
    typeof(AutomationApplicationContractsModule)
    )]
public class AutomationDbMigratorModule : AbpModule
{

}
