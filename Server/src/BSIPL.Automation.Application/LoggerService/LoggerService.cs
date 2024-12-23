using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.EntityFrameworkCore;

using BSIPL.Automation.LoggerRepoInterface;
using BSIPL.Automation.LoggerServiceInterface;
using BSIPL.Automation.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Volo.Abp.ObjectMapping;

namespace BSIPL.Automation.LoggerService
{
    public class LoggerService : ILoggerService
    {
        private readonly ILoggerRepository loggerRepository;
        public IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper { get; }
        public LoggerService(ILoggerRepository loggersRepository, IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper)
        {
            loggerRepository = loggersRepository;
            this.objectMapper = objectMapper;
        }

        public async Task AddLog(LoggerApplicationContractsModel postLog)
        {
            try
            {
                var postLogData = objectMapper.Map<LoggerApplicationContractsModel, LoggerModel>(postLog);
                await loggerRepository.AddLog(postLogData);
            }
            catch (Exception ex)
            {
                return;
            }
        }

        public async Task<IList<LoggerApplicationContractsModel>> GetLogs(string filter)
        {
            var result = await loggerRepository.GetLogs(filter);
            var logs = objectMapper.Map<IList<LoggerModel>, IList<LoggerApplicationContractsModel>> (result);
            return logs;
        }
    }
}