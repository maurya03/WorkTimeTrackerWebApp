using BSIPL.Automation.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories;

namespace BSIPL.Automation.ImportExcelRepoInterface
{
    public interface IImportExcelRepo : IRepository
    {
        public Task<IList<dynamic>> SaveOrgRecords(IList<OrgMasterRecordDomainModel> orgMasterRecordDomainModels, DateTime startDate, DateTime endDate);
        public Task<IList<dynamic>> SaveItHourRecords(IList<OrgMasterRecordDomainModel> orgMasterRecordDomainModels);
        public Task<IList<OrgColumnDomainModel>> SaveExcelColumnName(List<string> columns);

    }
}
