using BSIPL.Automation.SkillsMatrixServiceInterface;
using System.Threading.Tasks;

namespace BSIPL.Automation.ScheduledTaskServiceInterface
{
    public interface IScheduledTaskService
    {
        Task SendStatusEmail(string recipientEmail, string status, string startDate, string endDate, string remarks, string fullName, bool isManagerEmail);
        Task SendReminderEmail(string recipientEmail, string startDate, string endDate);
        Task ExecuteArchive(ISkillsMatrixService _skillsMatrixService);
    }
}