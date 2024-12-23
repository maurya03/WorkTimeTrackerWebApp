using BSIPL.Automation.Models;
using System.Collections.Generic;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories;

namespace BSIPL.Automation.LoggerRepoInterface
{
    public interface ILoggerRepository : IRepository
    {
        Task AddLog(LoggerModel postLog);

        Task<IList<LoggerModel>> GetLogs(string filter);
    }
}