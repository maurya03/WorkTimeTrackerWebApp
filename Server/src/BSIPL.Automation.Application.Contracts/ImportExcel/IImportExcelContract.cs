using BSIPL.Automation.Model;
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices.ComTypes;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Application.Services;

namespace BSIPL.Automation.ImportExcel
{
    public interface IImportExcelContract : IApplicationService
    {
        public Task<IList<dynamic>> SaveOrgRecords(IList<OrgMasterRecord> orgMasterRecordDomainModels, DateTime startDate, DateTime endDate);
        public Task<IList<dynamic>> SaveItHoursTable(IList<OrgMasterRecord> orgMasterRecordDomainModels);
        public Task<IList<OrgColumnNameModel>> SaveExcelColumnName(List<string> columns);
       
    }
}
