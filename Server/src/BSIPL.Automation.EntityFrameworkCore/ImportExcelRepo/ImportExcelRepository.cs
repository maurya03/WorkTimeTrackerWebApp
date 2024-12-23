using BSIPL.Automation.EntityFrameworkCore;
using BSIPL.Automation.ImportExcelRepoInterface;
using BSIPL.Automation.Models;
using Dapper;
using JetBrains.Annotations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories.Dapper;
using Volo.Abp.EntityFrameworkCore;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace BSIPL.Automation.ImportExcelRepo
{
    public class ImportExcelRepository : DapperRepository<AutomationDbContext>, IImportExcelRepo
    {
        public ImportExcelRepository(IDbContextProvider<AutomationDbContext> dbContextProvider) : base(dbContextProvider)
        {
        }
        public async Task<IList<dynamic>> SaveOrgRecords(IList<OrgMasterRecordDomainModel> orgMasterRecordDomainModels, DateTime startDate, DateTime endDate)
        {
            var dbConnection = await GetDbConnectionAsync();
            try
            {
                var query = $"delete from OrgMasterRecord";
                var data = await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());
                foreach (var item in orgMasterRecordDomainModels)
                {                     
                    if (data != null && data.Count() <= 0)
                    {
                        query = item.OrgColumnId == 12 ? $"insert into OrgMasterRecord(RowId,ColumnId,ColumnValue) values ({item.RowId},{item.OrgColumnId},{Convert.ToDouble(item.ColumnValue)})" :
                       $"insert into OrgMasterRecord(RowId,ColumnId,ColumnValue) values ({item.RowId},{item.OrgColumnId},'{item.ColumnValue}')";
                        data = await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            var orgQuery = "exec usp_getorgDetails @startDate, @endDate";
            var param = new { startDate = startDate, endDate = endDate };
            var records = (await dbConnection.QueryAsync(orgQuery, param, transaction: await GetDbTransactionAsync())).ToList();
            return records;
        }
        public async Task<IList<dynamic>> SaveItHourRecords(IList<OrgMasterRecordDomainModel> orgMasterRecordDomainModels)
        {
            var dbConnection = await GetDbConnectionAsync();
            try
            {
                var query = $"delete from OrgMasterRecord";
                var data = await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());
                foreach (var item in orgMasterRecordDomainModels)
                {
                    if (data != null && data.Count() <= 0)
                    {
                        query = $"insert into OrgMasterRecord(RowId,ColumnId,ColumnValue) values ({item.RowId},{item.OrgColumnId},'{item.ColumnValue}')";
                        data = await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());
                    }                   
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            var orgQuery = "exec [usp_getITHoursDetail]"; //@startDate, @endDate";
            //var param = new { startDate = "2024-06-16 00:00:00.000", endDate = "2024-06-22 00:00:00.000" };
            var records = (await dbConnection.QueryAsync(orgQuery, transaction: await GetDbTransactionAsync())).ToList();
            return records;
        }
     
        async Task<IList<OrgColumnDomainModel>> IImportExcelRepo.SaveExcelColumnName(List<string> Columns)
        {
            try
            {
                var dbConnection = await GetDbConnectionAsync();
                var data = (await dbConnection.QueryAsync("SELECT * FROM OrgColumns", transaction: await GetDbTransactionAsync()));
                if(data!=null)
                { 
                    await dbConnection.QueryAsync("delete FROM OrgColumns", transaction: await GetDbTransactionAsync());                   
                }
                int i = 0;
                foreach (var column in Columns)
                {
                    var query = $"insert into OrgColumns(ColumnName,ColumnNumber) values('{column}',{i})";
                    await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());
                    i++;
                }

                var records = (await dbConnection.QueryAsync<OrgColumnDomainModel>("SELECT * FROM OrgColumns", transaction: await GetDbTransactionAsync())).ToList();

                return records;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

  
    }
}
