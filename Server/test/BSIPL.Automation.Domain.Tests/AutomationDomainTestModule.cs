using BSIPL.Automation.EntityFrameworkCore;
using Volo.Abp.Modularity;

namespace BSIPL.Automation;

[DependsOn(
    typeof(AutomationEntityFrameworkCoreTestModule)
    )]
public class AutomationDomainTestModule : AbpModule
{

}
