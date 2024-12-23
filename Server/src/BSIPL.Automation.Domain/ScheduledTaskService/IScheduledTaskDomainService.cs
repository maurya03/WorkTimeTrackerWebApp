using BSIPL.Automation.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BSIPL.Automation.ScheduledTaskService
{
    public interface IScheduledTaskDomainService
    {
        Task SendMail(MailServiceModel mailServiceModel);
    }
}
