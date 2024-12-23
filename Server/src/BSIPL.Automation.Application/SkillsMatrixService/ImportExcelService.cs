using AutoMapper.Internal.Mappers;
using BSIPL.Automation.EntityFrameworkCore;
using BSIPL.Automation.ImportExcel;
using BSIPL.Automation.ImportExcelRepoInterface;
using BSIPL.Automation.Model;
using BSIPL.Automation.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.ObjectMapping;

namespace BSIPL.Automation.SkillsMatrixService
{
    public class ImportExcelService : IImportExcelContract
    {
        public IImportExcelRepo importExcelRepo { get; set; }
        public IObjectMapper<AutomationEntityFrameworkCoreModule> objectMapper { get; }
        public ImportExcelService(IImportExcelRepo _importExcelRepo, IObjectMapper<AutomationEntityFrameworkCoreModule> _objectMapper)
        {
            importExcelRepo = _importExcelRepo;
            objectMapper = _objectMapper;
        }
        public async Task<IList<dynamic>> SaveOrgRecords(IList<OrgMasterRecord> orgMasterRecordDomainModels, DateTime startDate, DateTime endDate)
        {
            var orgDomainModel = objectMapper.Map<IList<OrgMasterRecord>, IList<OrgMasterRecordDomainModel>>(orgMasterRecordDomainModels);
            var records = await importExcelRepo.SaveOrgRecords(orgDomainModel, startDate, endDate);
            return records;
        } 
        public async Task<IList<dynamic>> SaveItHoursTable(IList<OrgMasterRecord> orgMasterRecordDomainModels)
        {
            var orgDomainModel = objectMapper.Map<IList<OrgMasterRecord>, IList<OrgMasterRecordDomainModel>>(orgMasterRecordDomainModels);
            var records = await importExcelRepo.SaveItHourRecords(orgDomainModel);
            return records;
        }     
        async Task<IList<OrgColumnNameModel>> IImportExcelContract.SaveExcelColumnName(List<string> columns)
        {
            var output = await importExcelRepo.SaveExcelColumnName(columns);
            var applicationStory = objectMapper.Map<IList<OrgColumnDomainModel>, IList<OrgColumnNameModel>>(output);
            return applicationStory;
        }       
    }
}
