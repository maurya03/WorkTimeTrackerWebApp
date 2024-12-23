using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using BSIPL.Automation.Data;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging.Abstractions;
using BSIPL.Automation.Models;

namespace BSIPL.Automation.ScheduledTaskService
{
    public class ScheduledTaskDomainService: IScheduledTaskDomainService
    {
        public ILogger<AutomationDbMigrationService> Logger { get; set; }
        public string BhavnaEmailId { get; set; }
        public string BhavnaPassword { get; set; }

        public ScheduledTaskDomainService(IConfiguration configuration)
        { 
            Logger = NullLogger<AutomationDbMigrationService>.Instance;
            BhavnaEmailId = configuration["BhavnaCredentials:EmailId"] ?? "";
            BhavnaPassword = configuration["BhavnaCredentials:Password"] ?? "";

        }
            public async Task SendMail(MailServiceModel mailServiceModel)
        {
            SmtpClient client = new SmtpClient("smtp.office365.com");
            client.Port = 587;
            client.EnableSsl = true;
            client.Credentials = new NetworkCredential(BhavnaEmailId, BhavnaPassword);
            MailMessage message = new MailMessage(BhavnaEmailId, mailServiceModel.RecipientEmail);            
            message.Subject = mailServiceModel.Subject;           
            try
            {
                var emailBody = string.Format(mailServiceModel.EmailBodyFormat, mailServiceModel.StatusMessage, mailServiceModel.Remarks, mailServiceModel.FooterMessage);
                message.Body = emailBody;
                await client.SendMailAsync(message);
                Logger.LogInformation("Email sent successfully.");
            }
            catch (Exception ex)
            {
                Logger.LogError($"Failed to send email: {ex.Message}");
            }
        }
    }
}
