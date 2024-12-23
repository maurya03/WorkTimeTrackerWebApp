using Volo.Abp.Modularity;

namespace BSIPL.Automation;

[DependsOn(
    typeof(AutomationApplicationModule),
    typeof(AutomationDomainTestModule)
    )]
public class AutomationApplicationTestModule : AbpModule
{

}
