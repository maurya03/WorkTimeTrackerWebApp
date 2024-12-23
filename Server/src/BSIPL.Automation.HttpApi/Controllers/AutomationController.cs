using Volo.Abp.AspNetCore.Mvc;

namespace BSIPL.Automation.Controllers;

/* Inherit your controllers from this class.
 */
public abstract class AutomationController : AbpControllerBase
{
    protected AutomationController()
    {
        //LocalizationResource = typeof(AutomationResource);
    }
}
