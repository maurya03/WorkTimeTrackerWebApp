using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Volo.Abp;

namespace BSIPL.Automation;

public class AutomationWebTestStartup
{
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddApplication<AutomationWebTestModule>();
    }

    public void Configure(IApplicationBuilder app, ILoggerFactory loggerFactory)
    {
        app.InitializeApplication();
    }
}
