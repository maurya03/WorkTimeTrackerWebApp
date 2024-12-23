using Volo.Abp.Settings;

namespace BSIPL.Automation.Settings;

public class AutomationSettingDefinitionProvider : SettingDefinitionProvider
{
    public override void Define(ISettingDefinitionContext context)
    {
        //Define your own settings here. Example:
        //context.Add(new SettingDefinition(AutomationSettings.MySetting1));
    }
}
