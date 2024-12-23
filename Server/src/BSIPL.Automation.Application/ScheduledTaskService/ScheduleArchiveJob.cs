using BSIPL.Automation.ScheduledTaskServiceInterface;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Quartz;
using System;
using System.Threading.Tasks;
using Volo.Abp.BackgroundWorkers.Quartz;

namespace BSIPL.Automation.ScheduledTaskService
{
    public class ScheduleArchiveJob : QuartzBackgroundWorkerBase
    {
        private readonly ISkillsMatrixService _skillsMatrixService;
        private readonly IScheduledTaskService _scheduledTaskService;
        public ScheduleArchiveJob(IConfiguration configuration, ISkillsMatrixService skillsMatrixService, IScheduledTaskService scheduledTaskService)
        {
            _skillsMatrixService = skillsMatrixService;
            _scheduledTaskService = scheduledTaskService;
            var archiveJobSchedule = configuration["SkillMatrix:ArchiveJobSchedule"] ?? throw new InvalidOperationException();
            JobDetail = JobBuilder.Create<ScheduleArchiveJob>().WithIdentity(nameof(ScheduleArchiveJob)).Build();
            Trigger = TriggerBuilder.Create().WithIdentity(nameof(ScheduleArchiveJob)).WithCronSchedule(archiveJobSchedule).Build();
        }

        public override Task Execute(IJobExecutionContext context)
        {
            _scheduledTaskService.ExecuteArchive(_skillsMatrixService);
            Logger.LogInformation("Executed ScheduleArchiveJob..!");
            return Task.CompletedTask;

        }
    }
}
