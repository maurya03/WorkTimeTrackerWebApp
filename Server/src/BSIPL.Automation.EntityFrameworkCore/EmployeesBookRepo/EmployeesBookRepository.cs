using Azure;
using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.EmployeesBookModels;
using BSIPL.Automation.Domain.Shared.Enum.EmployeesBookEnum;
using BSIPL.Automation.EmployeesBookRepoInterface;
using BSIPL.Automation.EntityFrameworkCore;
using BSIPL.Automation.Models;
using BSIPL.Automation.Models.EmployeesBookModels;
using BSIPL.Automation.Models.SkillsMatrix;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories.Dapper;
using Volo.Abp.EntityFrameworkCore;

namespace BSIPL.Automation.EmployeesBookRepo
{
    public class EmployeesBookRepository : DapperRepository<AutomationDbContext>, IEmployeesBookRepository
    {
        public EmployeesBookRepository(IDbContextProvider<AutomationDbContext> dbContextProvider) : base(dbContextProvider)
        {


        }

        public async Task<EmployeeMasterModel> GetEmployeeDetailByIdAsync(string employeeId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeMasterModel>($"EXEC usp_Eb_GetEmployeeDetailById {employeeId}",
                transaction: await GetDbTransactionAsync())).FirstOrDefault();
        }

        public async Task<EmployeeMasterModel> GetUpdatedEmployeeDetailByIdAsync(string employeeId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeMasterModel>($"EXEC usp_Eb_GetUpdatedEmployeeDetailById {employeeId}",
                transaction: await GetDbTransactionAsync())).FirstOrDefault();
        }

        public async Task DeleteUpdatedEmployeeDetailByIdAsync(string employeeId)
        {
            var dbConnection = await GetDbConnectionAsync();
            await dbConnection.QueryAsync<EmployeeMasterModel>($"DELETE FROM EmployeeMasterUpdate WHERE EmployeeId = {employeeId}",
                transaction: await GetDbTransactionAsync());
        }

        public async Task<IList<EmployeeMasterModel>> GetUpdatedEmployeeDetailsAsync()
            {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeMasterModel>($"EXEC usp_Eb_GetUpdatedEmployeeDetails",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<int> AddEmployeeMasterUpdateAsync(EmployeeMasterModel employee)
        {
            try
            {
                var parameters = new DynamicParameters();
                parameters.Add("@EmailId", employee.EmailId);
                parameters.Add("@EmployeeId", employee.EmployeeId);
                parameters.Add("@FullName", employee.FullName);
                parameters.Add("@FirstName", employee.FirstName);
                parameters.Add("@MiddleName", employee.MiddleName);
                parameters.Add("@LastName", employee.LastName);
                parameters.Add("@ProjectId", employee.ProjectId);
                parameters.Add("@AboutYourSelf", employee.AboutYourSelf);
                parameters.Add("@HobbiesAndInterests", employee.HobbiesAndInterests);
                parameters.Add("@FutureAspirations", employee.FutureAspirations);
                parameters.Add("@BiographyTitle", employee.BiographyTitle);
                parameters.Add("@DefineMyself", employee.DefineMyself);
                parameters.Add("@MyBiggestFlex", employee.MyBiggestFlex);
                parameters.Add("@FavoriteBingsShow", employee.FavoriteBingsShow);
                parameters.Add("@MyLifeMantra", employee.MyLifeMantra);
                parameters.Add("@ProfilePictureUrl", $"{employee.EmployeeId}.jpg");
                parameters.Add("@Team", employee.Team);
                parameters.Add("@OneThingICanNotLive", employee.OneThingICanNotLive);
                parameters.Add("@EmployeeLocation", employee.EmployeeLocation);
                parameters.Add("@WhoInspiresYou", employee.WhoInspiresYou);
                parameters.Add("@YourBucketList", employee.YourBucketList);
                parameters.Add("@FavoriteWorkProject", employee.FavoriteWorkProject);
                parameters.Add("@FavoriteMomentsAtBhavna", employee.FavoriteMomentsAtBhavna);
                parameters.Add("@NativePlace", employee.NativePlace);
                parameters.Add("@ExperienceYear", employee.ExperienceYear);
                parameters.Add("@DesignationId", employee.DesignationId);

                var dbConnection = await GetDbConnectionAsync();
                await dbConnection.ExecuteAsync("usp_Eb_AddEmployeeMasterUpdate", parameters, commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync());
                return (int)ResponseEnum.SUCCESSFUL;
            }
            catch (Exception ex)
            {
                return (int)ResponseEnum.ERROR;
            }
        }
        public async Task<EmployeeSearchContractsModel> GetEmployeesWithSearchListAsync(int projectId, string interests, string sortBy, string searchText, int page, int pageSize, string emailId)
        {
            var empObj = new EmployeeSearchContractsModel();
            var dbConnection = await GetDbConnectionAsync();
            var result = await dbConnection.QueryMultipleAsync($"EXEC usp_Eb_SearchEmployees1 {projectId}, '{interests}', '{sortBy}' , '{searchText}', {page}, {pageSize}, '{emailId}'", transaction: await GetDbTransactionAsync());
            empObj.EmployeeList = (await result.ReadAsync<EmployeeMasterApplicationContractsModel>()).ToList();
            var pageRecord = (await result.ReadAsync<EmployeeCountApplicationContractsModel>()).FirstOrDefault();
            if (pageRecord != null)
            {
                empObj.EmployeeCount.TotalRecords = pageRecord.TotalRecords;
                empObj.EmployeeCount.TotalPages = pageRecord.TotalPages;
            }

            return empObj;
        }

        public async Task<ProjectsModel> GetProjectByIdAsync(int id)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<ProjectsModel>($"SELECT * FROM EbProjects where Id = {id}",
                transaction: await GetDbTransactionAsync())).FirstOrDefault();
        }


        public async Task<string> GetUserDetailByEmailIdAsync(string emailId)
        {
            try
            {
                var dbConnection = await GetDbConnectionAsync();
                var result = (await dbConnection.QueryAsync<EmployeeMasterModel>($"SELECT EmployeeId FROM EmployeeMaster where EmailId = '{emailId}'",
                    transaction: await GetDbTransactionAsync())).FirstOrDefault();
                return result==null ? "" : result.EmployeeId;
            }
            catch(Exception ex) {

                return "";
                    }   
        }

        public async Task<IList<ProjectsModel>> GetProjectListAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<ProjectsModel>("SELECT * FROM EbProjects",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<ProjectsModel>> GetProjectListByEmailAsync(string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<ProjectsModel>($"EXEC usp_Eb_GetProjectsByRole '{emailId}'",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<int> UpdateEmployeeDetailAsync(string employeeId, EmployeeMasterModel putEmployee)
        {
            try
            {
                var parameters = new DynamicParameters();
                parameters.Add("@EmailId", putEmployee.EmailId);
                parameters.Add("@EmployeeId", employeeId);
                parameters.Add("@action", DbActionEnum.UPDATE);
                parameters.Add("@FullName", putEmployee.FullName);
                parameters.Add("@FName", putEmployee.FirstName);
                parameters.Add("@MName", putEmployee.MiddleName);
                parameters.Add("@LName", putEmployee.LastName);
                parameters.Add("@ProjectId", putEmployee.ProjectId);
                parameters.Add("@AboutYSelf", putEmployee.AboutYourSelf);
                parameters.Add("@HobbiesAndInterest", putEmployee.HobbiesAndInterests);
                parameters.Add("@FutureAspirations", putEmployee.FutureAspirations);
                parameters.Add("@BiographyTitle", putEmployee.BiographyTitle);
                parameters.Add("@DefineMyself", putEmployee.DefineMyself);
                parameters.Add("@MyBiggestFlex", putEmployee.MyBiggestFlex);
                parameters.Add("@FavoriteBingsShow", putEmployee.FavoriteBingsShow);
                parameters.Add("@MyLifeMantra", putEmployee.MyLifeMantra);
                parameters.Add("@ProfilePictureUrl", $"{employeeId}.jpg");
                parameters.Add("@TeamId", putEmployee.TeamId);
                parameters.Add("@OneThingICanNotLive", putEmployee.OneThingICanNotLive);
                parameters.Add("@WhoInspiresYou", putEmployee.WhoInspiresYou);
                parameters.Add("@YourBucketList", putEmployee.YourBucketList);
                parameters.Add("@FavoriteWorkProject", putEmployee.FavoriteWorkProject);
                parameters.Add("@FavoriteMomentsAtBhavna", putEmployee.FavoriteMomentsAtBhavna);
                parameters.Add("@NativePlace", putEmployee.NativePlace);
                parameters.Add("@ExperienceYear", putEmployee.ExperienceYear);
                parameters.Add("@DesignationId", putEmployee.DesignationId);
                parameters.Add("@Response", dbType: DbType.Int32, direction: ParameterDirection.Output);
                var dbConnection = await GetDbConnectionAsync();
                await dbConnection.ExecuteAsync("usp_Eb_EditDeleteEmployee", parameters, commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync());
                var response = parameters.Get<dynamic>("Response");
                return response;

            }
            catch (Exception ex)
            {
                return (int)ResponseEnum.ERROR;
            }
        }

        public async Task<int> DeleteEmployeeByIdAsync(string employeeId, string emailId)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@EmailId", emailId);
            parameters.Add("@EmployeeId", employeeId);
            parameters.Add("@action", DbActionEnum.DELETE);
            parameters.Add("@Response", dbType: DbType.Int32, direction: ParameterDirection.Output);
            var dbConnection = await GetDbConnectionAsync();
            await dbConnection.ExecuteAsync("usp_Eb_EditDeleteEmployee", parameters, commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync());
            return parameters.Get<dynamic>("Response");
            
        }

        public async Task<IList<UserRoleModel>> GetRoleListAsync()
        {
            //Role List we are getting from Common Role TABLE used FOR Skillmatrix and Other projects
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<UserRoleModel>($"SELECT * FROM EmployeeRoles",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<AssignedRolesModel> GetAssignedRoleAsync(string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<AssignedRolesModel>($"EXEC usp_Eb_GetEmployeeRole '{emailId}'",
                transaction: await GetDbTransactionAsync())).FirstOrDefault();
        }

        public async Task<int> AddEmployeeRoleMapAsync(string emailId, EmployeeRoleMapModel postEmployeeRoleMap)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@EmailId", emailId);
            parameters.Add("@RoleId", postEmployeeRoleMap.RoleId);
            parameters.Add("@EmployeeId", postEmployeeRoleMap.EmployeeId);
            parameters.Add("@Response", dbType: DbType.Int32, direction: ParameterDirection.Output);
            var dbConnection = await GetDbConnectionAsync();
            await dbConnection.ExecuteAsync("usp_Eb_SaveEmployeeRole", parameters, commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync());
            var response = parameters.Get<dynamic>("Response");
            return response;
        }


        public async Task<int> AddEmployeeExcelAsync(string emailId, IList<EmployeeMasterApplicationContractsModel> employeeExcel)
        {
            try
            {
                var response = 0;
                var dbConnection = await GetDbConnectionAsync();
                var employeeIdList = (await dbConnection.QueryAsync<EmployeeIdEmailApplicationContractsModel>("SELECT EmployeeId, EmailId FROM EmployeeMaster",
                    transaction: await GetDbTransactionAsync())).ToList();

                //Needs to filter record already exist in DB
                var postEmployeeExcel = employeeExcel
                   .Where(x => !employeeIdList.Any(y => (y.EmployeeId == x.EmployeeId || y.EmailId.Trim().ToLower() == x.EmailId.Trim().ToLower()))).ToList();
                // get all designation name from backend
                var designations = (await dbConnection.QueryAsync<DesignationApplicationContractsModel>($"SELECT Id, designation FROM EbDesignation",
                transaction: await GetDbTransactionAsync())).ToList();

                // get all project name from backend
                var projects = (await dbConnection.QueryAsync<ProjectsApplicationContractsModel>($"SELECT Id, ProjectName FROM EbProjects",
                transaction: await GetDbTransactionAsync())).ToList();


                if (postEmployeeExcel.Count > 0)
                {
                    var dt = new DataTable();
                    dt.Columns.Add("EmployeeId", typeof(string));
                    dt.Columns.Add("FullName", typeof(string));
                    dt.Columns.Add("EmailId", typeof(string));
                    dt.Columns.Add("ProjectId", typeof(int));
                    dt.Columns.Add("AboutYourSelf", typeof(string));
                    dt.Columns.Add("HobbiesAndInterests", typeof(string));
                    dt.Columns.Add("FavoriteMomentsAtBhavna", typeof(string));
                    dt.Columns.Add("FutureAspirations", typeof(string));
                    dt.Columns.Add("BiographyTitle", typeof(string));
                    dt.Columns.Add("DefineMyself", typeof(string));
                    dt.Columns.Add("MyBiggestFlex", typeof(string));
                    dt.Columns.Add("FavoriteBingsShow", typeof(string));
                    dt.Columns.Add("MyLifeMantra", typeof(string));
                    dt.Columns.Add("ProfilePictureUrl", typeof(string));
                    dt.Columns.Add("Team", typeof(string));
                    dt.Columns.Add("OneThingICanNotLive", typeof(string));
                    dt.Columns.Add("WhoInspiresYou", typeof(string));
                    dt.Columns.Add("YourBucketList", typeof(string));
                    dt.Columns.Add("FavoriteWorkProject", typeof(string));
                    dt.Columns.Add("NativePlace", typeof(string));
                    dt.Columns.Add("ExperienceYear", typeof(decimal));
                    dt.Columns.Add("DesignationId", typeof(int));
                    dt.Columns.Add("EmployeeLocation", typeof(string));
                    dt.Columns.Add("JoiningDate", typeof(DateTime));

                    foreach (var employee in postEmployeeExcel)
                    {
                        // check the designation name is correct or not
                        if (employee.Designation != null && !designations.Any(x => x.Designation == employee.Designation))
                        {
                            var insertQuery = $"INSERT INTO dbo.EbDesignation (designation) OUTPUT INSERTED.Id VALUES ('{employee.Designation}')";
                            employee.DesignationId = (await dbConnection.QueryAsync<int>(insertQuery, transaction: await GetDbTransactionAsync())).FirstOrDefault();
                            designations.Add(new DesignationApplicationContractsModel { Designation = employee.Designation, Id = employee.DesignationId });
                        }
                        else
                        {
                            employee.DesignationId = designations.Where(x => x.Designation == employee.Designation).Select(x => x.Id).FirstOrDefault();

                        };
                        // check the Project name is correct or not 
                        if (employee.Project != null && !projects.Any(x => x.ProjectName == employee.Project))
                        {
                            var insertQuery = $"INSERT INTO dbo.EbProjects (projectname) OUTPUT INSERTED.Id VALUES ('{employee.Project}')";
                            employee.ProjectId = (await dbConnection.QueryAsync<int>(insertQuery, transaction: await GetDbTransactionAsync())).FirstOrDefault();
                            projects.Add(new ProjectsApplicationContractsModel { ProjectName = employee.Project, Id = employee.ProjectId });
                        }
                        else
                        {
                            employee.ProjectId = projects.Where(x => x.ProjectName == employee.Project).Select(x => x.Id).FirstOrDefault();
                        };

                        var row = dt.NewRow();
                        row["EmployeeId"] = employee.EmployeeId;
                        row["FullName"] = employee.FullName;
                        row["EmailId"] = employee.EmailId;
                        row["ProjectId"] = employee.ProjectId;
                        row["AboutYourSelf"] = employee.AboutYourSelf;
                        row["HobbiesAndInterests"] = employee.HobbiesAndInterests;
                        row["FavoriteMomentsAtBhavna"] = employee.FavoriteMomentsAtBhavna;
                        row["FutureAspirations"] = employee.FutureAspirations;
                        row["BiographyTitle"] = employee.BiographyTitle;
                        row["DefineMyself"] = employee.DefineMyself;
                        row["MyBiggestFlex"] = employee.MyBiggestFlex;
                        row["FavoriteBingsShow"] = employee.FavoriteBingsShow;
                        row["MyLifeMantra"] = employee.MyLifeMantra;
                        row["ProfilePictureUrl"] = employee.ProfilePictureUrl;
                        row["Team"] = employee.Team;
                        row["OneThingICanNotLive"] = employee.OneThingICanNotLive;
                        row["WhoInspiresYou"] = employee.WhoInspiresYou;
                        row["YourBucketList"] = employee.YourBucketList;
                        row["FavoriteWorkProject"] = employee.FavoriteWorkProject;
                        row["NativePlace"] = employee.NativePlace;
                        row["ExperienceYear"] = (employee.ExperienceYear is null) ? DBNull.Value : employee.ExperienceYear;
                        row["EmployeeLocation"] = employee.EmployeeLocation;
                        row["DesignationId"] = employee.DesignationId;
                        row["JoiningDate"] = string.IsNullOrEmpty(employee.DateJoining) ? DateTime.Now : DateTime.ParseExact(employee.DateJoining, "dd/MM/yyyy", null);
                        dt.Rows.Add(row);
                    }

                    var parameters = new DynamicParameters();
                    parameters.Add("@EmailId", emailId);
                    parameters.Add("@EmployeeExcel", dt, DbType.Object);
                    parameters.Add("@Response", dbType: DbType.Int32, direction: ParameterDirection.Output);
                    await dbConnection.ExecuteAsync("usp_Eb_SaveEmployeeExcel", parameters, commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync());
                    response = parameters.Get<dynamic>("Response");
                }
                return response;
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        public async Task<int> AddEmployeeRoleAsync(EmployeeRoleMapApplicationContractsModel postEmployeeRole)
        {
            try
            {
                if (postEmployeeRole != null)
                {
                    var dbConnection = await GetDbConnectionAsync();

                    // Needs to check which role admin has updated as true for posted user, needs to update only if exist
                    var selectQuery = $"SELECT * FROM dbo.EmployeeRoles WHERE EmployeeId = {postEmployeeRole.EmployeeId}";
                    var result = (await dbConnection.QueryAsync<EmployeeRolesModel>(selectQuery,
                                transaction: await GetDbTransactionAsync())).FirstOrDefault();

                    if (result == null) // this means role mapping not exist insert the mapping
                    {
                        var insertQuery = $"INSERT INTO dbo.EmployeeRoles (RoleId, EmployeeId, CreatedDate) VALUES ({postEmployeeRole.RoleId},'{postEmployeeRole.EmployeeId}', '{DateTime.Now}')";
                        (await dbConnection.QueryAsync<SubCategoryMasterModel>(insertQuery,
                        transaction: await GetDbTransactionAsync())).FirstOrDefault();

                    }
                    else // this means role mapping exist in DB then update role
                    {
                        var updateQuery = $"UPDATE dbo.EmployeeRoles SET RoleId='{postEmployeeRole.RoleId}', UpdatedDate='{DateTime.Now}' WHERE EmployeeRoleId={result.EmployeeRoleId}";
                        await dbConnection.QueryAsync(updateQuery, transaction: await GetDbTransactionAsync());
                    }

                }
                return (int)ResponseEnum.SUCCESSFUL;
            }
            catch (Exception ex)
            {
                return (int)ResponseEnum.ERROR;

            }

        }
        public async Task<IList<EmployeeForRoleApplicationContractsModel>> GetEmployeesAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            var result = (await dbConnection.QueryAsync<EmployeeForRoleApplicationContractsModel>($"SELECT EmployeeRoles.RoleId, v.FullName, v.EmployeeId, v.EmailId from vw_Eb_GetEmployeesDetailList AS v LEFT JOIN EmployeeRoles on v.EmployeeId = EmployeeRoles.EmployeeId",
                transaction: await GetDbTransactionAsync())).ToList();
            return result;
        }

        public async Task<IList<DesignationApplicationContractsModel>> GetDesignationsAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            var result = (await dbConnection.QueryAsync<DesignationApplicationContractsModel>($"SELECT Id, designation from EbDesignation",
                transaction: await GetDbTransactionAsync())).ToList();
            return result;
        }

        public async Task UpdateEmployeeImageUrlAsync(string employeeId, string imagePath)
        {
            var dbConnection = await GetDbConnectionAsync();
            await dbConnection.QueryAsync<bool>($"Update EmployeeMaster SET ProfilePictureUrl = '{imagePath}' where EmployeeId = '{employeeId}'",
                transaction: await GetDbTransactionAsync());
        }

        public async Task<AnalyticsReportApplicationContractsModel> GetAnalyticsReportAsync(string filter, DateTime startDate, DateTime endDate)
        {
            var analyticsObj = new AnalyticsReportApplicationContractsModel();
            var dbConnection = await GetDbConnectionAsync();
            var result = await dbConnection.QueryMultipleAsync($"EXEC usp_Eb_GetChartRecord '{filter}', '{startDate}', '{endDate}' ");
            analyticsObj.LoginCountModel = (await result.ReadAsync<LoginCountApplicationContractsModel>()).ToList();
            analyticsObj.ActiveEmployeeCount = (await result.ReadAsync<int>()).FirstOrDefault();
            analyticsObj.DailyEmployeeLoginCount = (await result.ReadAsync<int>()).FirstOrDefault();
            return analyticsObj;
        }
        
    }
}