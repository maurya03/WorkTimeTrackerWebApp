using BSIPL.Automation.ApplicationModels;
using System.Collections.Generic;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;

namespace BSIPL.Automation.LoggerServiceInterface
{
    public interface ILoggerService : IApplicationService
    {
        Task AddLog(LoggerApplicationContractsModel postLog);
        Task<IList<LoggerApplicationContractsModel>> GetLogs(string filter);
    }
}