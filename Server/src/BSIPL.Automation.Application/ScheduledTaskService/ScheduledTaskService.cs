using System.Net.Mail;
using System.Net;
using System;
using Microsoft.Extensions.Logging;
using BSIPL.Automation.Data;
using BSIPL.Automation.ScheduledTaskServiceInterface;
using Microsoft.Extensions.Logging.Abstractions;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;
using BSIPL.Automation.Domain.Interface;
using BSIPL.Automation.Models;
using BSIPL.Automation.SkillsMatrixServiceInterface;
using Microsoft.AspNetCore.Mvc;

namespace BSIPL.Automation.ScheduledTaskService
{
    public class ScheduledTaskService : IScheduledTaskService
    {
        public ILogger<AutomationDbMigrationService> _logger { get; set; }
        private readonly IScheduledTaskDomainService _scheduledTaskDomainService;
        public string subject { get; set; }
        public string detailsLink { get; set; }
        public string footerMessage { get; set; }
        public string emailBodyFormat { get; set; }
        public string statusMessage { get; set; }
        public string emailremarks { get; set; }
        public string reminderMessage { get; set; }
        public string reminderMessageSubject { get; set; }

        public ScheduledTaskService(IConfiguration configuration, IScheduledTaskDomainService scheduledTaskDomainService, ILogger<AutomationDbMigrationService> logger)
        {
            subject = configuration["EmailSettings:Subject"] ?? throw new InvalidOperationException();
            detailsLink = configuration["EmailSettings:DetailsLink"] ?? throw new InvalidOperationException();
            footerMessage = configuration["EmailSettings:FooterMessage"] ?? throw new InvalidOperationException();
            emailBodyFormat = configuration["EmailSettings:EmailBody"] ?? throw new InvalidOperationException();
            statusMessage = configuration["EmailSettings:MessageBody"] ?? throw new InvalidOperationException();
            reminderMessage = configuration["EmailSettings:ReminderMessage"] ?? throw new InvalidOperationException();
            reminderMessageSubject = configuration["EmailSettings:ReminderMessageSubject"] ?? throw new InvalidOperationException();
            emailremarks = configuration["EmailSettings:Remarks"] ?? throw new InvalidOperationException();
            _scheduledTaskDomainService = scheduledTaskDomainService;
            _logger = logger;
        }
        public async Task SendStatusEmail(string recipientEmail,string status,string startDate, string endDate,string remarks,string fullName,bool isManagerEmail)
        {
            var mailServiceModel = new MailServiceModel();
            mailServiceModel.FooterMessage = footerMessage;
            mailServiceModel.DetailsLink = string.Format(detailsLink, "www.google.com");
            mailServiceModel.EmailBodyFormat = emailBodyFormat;
            
            mailServiceModel.RecipientEmail = recipientEmail;
            mailServiceModel.Status = isManagerEmail ? status + " Timesheet" : status;
            mailServiceModel.StartDate = startDate;
            mailServiceModel.EndDate = endDate;
            mailServiceModel.Subject = string.Format(subject, isManagerEmail ? fullName : "Timesheet", mailServiceModel.Status, mailServiceModel.StartDate, mailServiceModel.EndDate);
            mailServiceModel.StatusMessage = isManagerEmail ? mailServiceModel.Subject:string.Format(statusMessage, isManagerEmail ? status + " Timesheet" : status, startDate, endDate);            
            mailServiceModel.Remarks = String.IsNullOrEmpty(remarks) ? "" : string.Format(emailremarks, remarks);
            await _scheduledTaskDomainService.SendMail(mailServiceModel);
        }
        public async Task SendReminderEmail(string recipientEmail,string startDate, string endDate)
        {
            var mailServiceModel = new MailServiceModel();
            mailServiceModel.FooterMessage = footerMessage;
            mailServiceModel.EmailBodyFormat = emailBodyFormat;
            mailServiceModel.RecipientEmail = recipientEmail;
            mailServiceModel.Subject = string.Format(reminderMessageSubject, startDate, endDate);
            mailServiceModel.StatusMessage = string.Format(reminderMessage,startDate, endDate);
            mailServiceModel.Remarks = string.Empty;
            await _scheduledTaskDomainService.SendMail(mailServiceModel);
        }

        public async Task ExecuteArchive([FromServices] ISkillsMatrixService _skillsMatrixService)
        {
            try
            {
                _logger.LogInformation("Started ScheduledArchiveJob..!");
                await _skillsMatrixService.ExecuteAndLogArchiveProcess("Started");
                _logger.LogInformation("Executed ScheduledArchiveJob..!");
            }
            catch (Exception ex)
            {
                string message = $"Archive process failed: {ex.Message}";
                _logger.LogError(message);
                await _skillsMatrixService.ExecuteAndLogArchiveProcess(ex.Message);
            }

        }
    }
}
