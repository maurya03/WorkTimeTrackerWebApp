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
    public class SubmitTimesheetJob : QuartzBackgroundWorkerBase
    {
        private readonly ITimeSheetService _timeSheetService;
        public string autoSubmitTimesheet { get; set; }
        public SubmitTimesheetJob(IConfiguration configuration, ITimeSheetService timeSheetService)
        {
            _timeSheetService = timeSheetService;
            var submitTimesheetJobSchedule = configuration["EmailSettings:SubmitTimesheetJobSchedule"] ?? throw new InvalidOperationException();
            autoSubmitTimesheet = configuration["EmailSettings:isAutoSubmitTimesheet"] ?? "false";
            JobDetail = JobBuilder.Create<SubmitTimesheetJob>().WithIdentity(nameof(SubmitTimesheetJob)).Build();
            //Trigger = TriggerBuilder.Create().WithIdentity(nameof(SubmissionReminderJob)).StartNow().Build();
            Trigger = TriggerBuilder.Create().WithIdentity(nameof(SubmitTimesheetJob)).WithCronSchedule(submitTimesheetJobSchedule).Build();            
        }          
        public override Task Execute(IJobExecutionContext context)
        {
            if (Convert.ToBoolean(autoSubmitTimesheet))
            {
                _timeSheetService.SubmitTimeSheeetAndFetchEmailSAsync();
                Logger.LogInformation("Executed SubmitTimesheetJob..!");
            }
            return Task.CompletedTask;

        }
    }
}
