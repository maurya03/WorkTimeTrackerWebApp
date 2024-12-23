using BSIPL.Automation.Contracts.Interface;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Quartz;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.BackgroundWorkers.Quartz;

namespace BSIPL.Automation.ScheduledTaskService
{

    public class TimesheetWeeklyReportJob : QuartzBackgroundWorkerBase
    {
        private readonly ITimeSheetService _timeSheetService;
        public TimesheetWeeklyReportJob(IConfiguration configuration, ITimeSheetService timeSheetService)
        {
            _timeSheetService = timeSheetService;
            var weeklyReportJobSchedule = configuration["ReportSettings:WeeklyReportJobSchedule"] ?? throw new InvalidOperationException();
            JobDetail = JobBuilder.Create<TimesheetWeeklyReportJob>().WithIdentity(nameof(TimesheetWeeklyReportJob)).Build();
           // Trigger = TriggerBuilder.Create().WithIdentity(nameof(TimesheetWeeklyReportJob)).StartNow().Build();
             Trigger = TriggerBuilder.Create().WithIdentity(nameof(TimesheetWeeklyReportJob)).WithCronSchedule(weeklyReportJobSchedule).Build();


        }
        public override Task Execute(IJobExecutionContext context)
        {
            _timeSheetService.GetTimesheetWeeklyReport();
            Logger.LogInformation("Executed Weekly Report..!");
            return Task.CompletedTask;
        }
    }
}
