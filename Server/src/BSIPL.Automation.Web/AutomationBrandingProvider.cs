using Volo.Abp.Ui.Branding;
using Volo.Abp.DependencyInjection;

namespace BSIPL.Automation.Web;

[Dependency(ReplaceServices = true)]
public class AutomationBrandingProvider : DefaultBrandingProvider
{
    public override string AppName => "Automation";
}
