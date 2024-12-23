using Volo.Abp.Application.Services;

namespace BSIPL.Automation;

/* Inherit your application services from this class.
 */
public abstract class AutomationAppService : ApplicationService
{
    protected AutomationAppService()
    {
       // LocalizationResource = typeof(AutomationResource);
    }
}
