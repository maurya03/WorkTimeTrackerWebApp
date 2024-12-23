using BSIPL.Automation.Localization;
using Volo.Abp.AspNetCore.Mvc.UI.RazorPages;

namespace BSIPL.Automation.Web.Pages;

/* Inherit your PageModel classes from this class.
 */
public abstract class AutomationPageModel : AbpPageModel
{
    protected AutomationPageModel()
    {
        LocalizationResourceType = typeof(AutomationResource);
    }
}
