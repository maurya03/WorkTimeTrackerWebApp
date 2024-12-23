using BSIPL.Automation.Contracts.Interface;
using BSIPL.Automation.ServiceImplementation;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Quartz;
using System;
using System.Threading;
using System.Threading.Tasks;
using Volo.Abp.BackgroundWorkers.Quartz;

namespace BSIPL.Automation.ScheduledTaskService
{
    public class TimesheetMonthlyReportJob : QuartzBackgroundWorkerBase
    {
        private readonly ITimeSheetService _timeSheetService;
        public TimesheetMonthlyReportJob(IConfiguration configuration, ITimeSheetService timeSheetService)
        {
            _timeSheetService = timeSheetService;
            var monthlyReportJobSchedule = configuration["ReportSettings:MonthlyReportJobSchedule"] ?? throw new InvalidOperationException();
            JobDetail = JobBuilder.Create<TimesheetMonthlyReportJob>().WithIdentity(nameof(TimesheetMonthlyReportJob)).Build();
          //  Trigger = TriggerBuilder.Create().WithIdentity(nameof(TimesheetWeeklyReportJob)).StartNow().Build();
            Trigger = TriggerBuilder.Create().WithIdentity(nameof(TimesheetMonthlyReportJob)).WithCronSchedule(monthlyReportJobSchedule).Build();
        }
        public override Task Execute(IJobExecutionContext context)
        {
            _timeSheetService.GetTimesheetMonthlyReport();
            Logger.LogInformation("Executed Monthly Report..!");
            return Task.CompletedTask;
        }
    }
}
