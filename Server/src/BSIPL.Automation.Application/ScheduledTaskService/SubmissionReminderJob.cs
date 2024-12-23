using BSIPL.Automation.Contracts.Interface;
using BSIPL.Automation.Domain.Interface;
using BSIPL.Automation.ScheduledTaskServiceInterface;
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
    public class SubmissionReminderJob : QuartzBackgroundWorkerBase
    {
        private readonly ITimeSheetService _timeSheetService;
        public string fireSubmitTimesheet { get; set; }
        public SubmissionReminderJob(IConfiguration configuration, ITimeSheetService timeSheetService)
        {
            _timeSheetService = timeSheetService;
            var submissionReminderJobSchedule = configuration["EmailSettings:SubmissionReminderJobSchedule"] ?? throw new InvalidOperationException();
            fireSubmitTimesheet = configuration["EmailSettings:isSubmitTimesheet"] ?? throw new InvalidOperationException();
            JobDetail = JobBuilder.Create<SubmissionReminderJob>().WithIdentity(nameof(SubmissionReminderJob)).Build();
            //Trigger = TriggerBuilder.Create().WithIdentity(nameof(SubmissionReminderJob)).StartNow().Build();
            Trigger = TriggerBuilder.Create().WithIdentity(nameof(SubmissionReminderJob)).WithCronSchedule(submissionReminderJobSchedule).Build();
        }
        public override Task Execute(IJobExecutionContext context)
        {
            if (Convert.ToBoolean(fireSubmitTimesheet))
            {
                _timeSheetService.SendEmailReminderForTimesheetAsync();
                Logger.LogInformation("Executed SubmitTimesheetJob..!");
            }

            return Task.CompletedTask;
        }
    }
}
