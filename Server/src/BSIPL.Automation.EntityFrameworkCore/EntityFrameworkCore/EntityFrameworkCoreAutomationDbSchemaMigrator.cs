using System;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using BSIPL.Automation.Data;
using Volo.Abp.DependencyInjection;

namespace BSIPL.Automation.EntityFrameworkCore;

public class EntityFrameworkCoreAutomationDbSchemaMigrator
    : IAutomationDbSchemaMigrator, ITransientDependency
{
    private readonly IServiceProvider _serviceProvider;

    public EntityFrameworkCoreAutomationDbSchemaMigrator(
        IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }

    public async Task MigrateAsync()
    {
        /* We intentionally resolving the AutomationDbContext
         * from IServiceProvider (instead of directly injecting it)
         * to properly get the connection string of the current tenant in the
         * current scope.
         */

        await _serviceProvider
            .GetRequiredService<AutomationDbContext>()
            .Database
            .MigrateAsync();
    }
}
