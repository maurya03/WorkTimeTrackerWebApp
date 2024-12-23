using System.Threading.Tasks;
using Volo.Abp.DependencyInjection;

namespace BSIPL.Automation.Data;

/* This is used if database provider does't define
 * IAutomationDbSchemaMigrator implementation.
 */
public class NullAutomationDbSchemaMigrator : IAutomationDbSchemaMigrator, ITransientDependency
{
    public Task MigrateAsync()
    {
        return Task.CompletedTask;
    }
}
