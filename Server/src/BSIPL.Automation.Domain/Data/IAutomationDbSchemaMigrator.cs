using System.Threading.Tasks;

namespace BSIPL.Automation.Data;

public interface IAutomationDbSchemaMigrator
{
    Task MigrateAsync();
}
