using BSIPL.Automation.EntityFrameworkCore;
using BSIPL.Automation.SkillsMatrixRepoInterface;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Threading.Tasks;
using Volo.Abp.Domain.Repositories.Dapper;
using Volo.Abp.EntityFrameworkCore;
using BSIPL.Automation.Models.SkillsMatrix;
using BSIPL.Automation.Models;
using BSIPL.Automation.ApplicationModels;
using BSIPL.Automation.ApplicationModels.SkillsMatrix;
using System.Data.Common;
using BSIPL.Automation.Models.Timesheet;

namespace BSIPL.Automation.SkillsMatrixRepo
{
    public class SkillsMatrixRepository : DapperRepository<AutomationDbContext>, ISkillsMatrixRepository
    {
        public SkillsMatrixRepository(IDbContextProvider<AutomationDbContext> dbContextProvider) : base(dbContextProvider)
        {

        }

        public async Task<IList<CategoryMasterModel>> GetCategoryListAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<CategoryMasterModel>("SELECT * FROM CategoryMaster",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<CategoryMasterModel>> GetCategoryWithTeamScoreListAsync(int teamId, int isWithScore = 0)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<CategoryMasterModel>($"usp_getCategoryMasterByClientScore '{teamId}', {isWithScore}",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<ClientMasterModel>> GetClientListAsync(string EmailId, int isWithTeam = 0)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<ClientMasterModel>($"EXEC usp_getClientMasterByEmployeeId '{EmailId}'",
        transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<TeamMasterModel>> GetClientTeamListAsync(int clientId, string functionType)
        {
            var query = $"SELECT * FROM TeamMaster WHERE ClientId={clientId} ORDER BY TeamName";
            if (functionType != "All")
            {
                query = $"SELECT distinct team.Id, team.ClientId, team.TeamName,team.CreatedOn, team.ModifiedOn, team.TeamDescription\r\nFROM TeamMaster team join EmployeeDetails emp on team.Id = emp.TeamId \r\njoin EmployeeType empType on empType.Id= emp.Type\r\nWHERE ClientId={clientId} and empType.Function_Type ='{functionType}'";
            }
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TeamMasterModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<IList<TeamMasterModel>> GetClientManagerTeamListAsync(int clientId, string employeeId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var query = $"exec usp_getClientManagerTeamList {clientId},'{employeeId}'";
            return (await dbConnection.QueryAsync<TeamMasterModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }


        public async Task<IList<SkillsMatrixModel>> GetAllSkillsMatrixOrListByEmployeeIdAsync(string employeeId)
        {
            string? query = $"SELECT * FROM SkillsMatrix";
            query = employeeId != "0" ? $"{query} where EmployeeId = '{employeeId}'" : query;

            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<SkillsMatrixModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<GetSkillsMatrixJoinTablesModel>> GetSkillsMatrixJoinTablesListAsync(string EmailId)
        {

            var dbConnection = await GetDbConnectionAsync();
            var query = $"exec usp_getSkillsMatrixTablesByEmailId '{EmailId}'";
            return (await dbConnection.QueryAsync<GetSkillsMatrixJoinTablesModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();

        }

        public async Task<IList<EmployeeSkillMatrixModel>> SkillMatrixEmployeeList(int? teamId, int? subCategoryId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var GetSkillsMatrixJoinTablesQuery = "select distinct emp.BhavnaEmployeeId, emp.EmployeeName, isnull(matrix.EmployeeScore,0) as EmployeeScore, matrix.Id as MappingId  from EmployeeDetails emp left join SkillsMatrix matrix on emp.BhavnaEmployeeId=matrix.EmployeeId and matrix.SubCategoryId=" + subCategoryId + " left JOIN SubCategoryMapping SCM ON matrix.SubCategoryId = SCM.SubCategoryId  and scm.TeamId= emp.TeamId where emp.TeamId=" + teamId + "";

            return (await dbConnection.QueryAsync<EmployeeSkillMatrixModel>(GetSkillsMatrixJoinTablesQuery,
                transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<IList<GetSkillsMatrixJoinTablesCheckModel>> GetSkillsMatrixJoinTablesListCheckAsync(PostSkillMatrixTableModel postSkillMatrix)
        {
            var dbConnection = await GetDbConnectionAsync();
            var query = $"exec usp_getClientSubCategoryExpectedScore {postSkillMatrix.categoryId},{postSkillMatrix.teamId}";
            return (await dbConnection.QueryAsync<GetSkillsMatrixJoinTablesCheckModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<SubCategoryMasterModel>> GetSubCategoryListAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<SubCategoryMasterModel>("SELECT * FROM SubCategoryMaster",
                transaction: await GetDbTransactionAsync())).ToList();
        }


        public async Task<IList<EmployeeDetailsModel>> GetEmployeeDetailsListAsync(string EmailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeDetailsModel>($"EXEC usp_getEmployeeDetailByEmailId '{EmailId}'",
            transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<EmployeeDetailsModel?> GetEmployeeDetailsAsync(string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var sql = $"SELECT * FROM EmployeeMaster WHERE EmailId= '{emailId}'";
            return (await dbConnection.QueryAsync<EmployeeDetailsModel>(sql,
                transaction: await GetDbTransactionAsync())).FirstOrDefault();
        }

        public async Task<IList<TeamMasterModel>> GetTeamListAsync(string EmailId)
        {

            var dbConnection = await GetDbConnectionAsync();
            var query = $"exec usp_getTeamListByEmailId '{EmailId}'";
            return (await dbConnection.QueryAsync<TeamMasterModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<TeamMasterModel?> GetTeamByIdAsync(int? teamId = 0)
        {
            string? query;
            if (teamId == 0)
            {
                query = "SELECT * FROM TeamMaster";
            }
            else
            {
                query = $"SELECT * FROM TeamMaster where Id = {teamId}";
            }
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<TeamMasterModel>(query,
                transaction: await GetDbTransactionAsync())).FirstOrDefault();
        }

        public async Task<IList<SubCategoryMappingModel>> GetSubCategoryMappingListAsync()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<SubCategoryMappingModel>("SELECT * FROM SubCategoryMapping",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<EmployeeMasterModel> GetEmployeeMasterByEmailIdAsync(string EmailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeMasterModel>($"SELECT * FROM EmployeeMaster where EmailId = {EmailId}",
                transaction: await GetDbTransactionAsync())).FirstOrDefault();
        }

        public async Task<IList<SubCategoryMappingModel>> GetTeamSubCategoryMappingListAsync(int teamId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<SubCategoryMappingModel>($"SELECT  mapping.TeamId, category.Id as SubCategoryId, isnull(mapping.ClientExpectedScore,0) ClientExpectedScore, mapping.CreatedOn, mapping.ModifiedOn FROM SubCategoryMaster category left join SubCategoryMapping mapping\r\non category.Id= mapping.SubCategoryId and mapping.TeamId={teamId}",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<SubCategoryMasterModel>> GetSubCategoryAndCategoryListAsync(int categoryId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<SubCategoryMasterModel>($"SELECT subCategory.* FROM SubCategoryMaster subCategory join CategoryMaster category on subCategory.CategoryId= category.Id WHERE subCategory.CategoryId={categoryId} and subCategory.SubCategoryName <> category.CategoryName ORDER BY subCategory.SubCategoryName",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<EmployeeDetailsModel>> GetEmployeeDetailsTeamWiseListAsync(int teamId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeDetailsModel>($"SELECT emp.*, master.EmailId, master.DesignationId, empType.function_type as FunctionType, empRoles.RoleId as Role FROM EmployeeDetails emp inner join EmployeeType empType on emp.Type= empType.id left join EmployeeMaster master on emp.BhavnaEmployeeId= master.EmployeeId left join EmployeeRoles empRoles on emp.BhavnaEmployeeId = empRoles.EmployeeId where emp.TeamId={teamId} ORDER BY emp.EmployeeName",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task AddClientAsync(ClientMasterModel postClient, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var insertQuery = $"INSERT INTO dbo.ClientMaster(ClientName,ClientDescription,CreatedOn,ModifiedOn,CreatedBy,ModifiedBy) VALUES ('{postClient.ClientName.Trim()}', '{postClient.ClientDescription.Trim()}', '{DateTime.Now}', '{DateTime.Now}', '{emailId}', '{null}')";
            _ = (await dbConnection.QueryAsync<ClientMasterModel>(insertQuery,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task AddTeamAsync(TeamMasterModel postTeam, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var insertQuery = $"INSERT INTO dbo.TeamMaster(ClientId,TeamName,TeamDescription,CreatedOn,ModifiedOn,CreatedBy,ModifiedBy) VALUES ('{postTeam.ClientId}', '{postTeam.TeamName.Trim()}', '{postTeam.TeamDescription.Trim()}' , '{DateTime.Now}', '{DateTime.Now}', '{emailId}', '{null}')";
            _ = (await dbConnection.QueryAsync<TeamMasterModel>(insertQuery,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task UpdateTeamDetailAsync(TeamMasterModel teamDetail, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            teamDetail.ModifiedOn = DateTime.Now;
            var updateQuery = $"UPDATE dbo.TeamMaster SET TeamName = '{teamDetail.TeamName.Trim()}', TeamDescription = '{teamDetail.TeamDescription.Trim()}', ModifiedOn = '{teamDetail.ModifiedOn}', ModifiedBy = '{emailId}' WHERE Id= {teamDetail.Id} ";
            _ = (await dbConnection.QueryAsync<TeamMasterModel>(updateQuery,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task AddCategoryAsync(CategoryMasterModel postCategory, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var insertQuery = $"INSERT INTO dbo.CategoryMaster(CategoryFunction,CategoryName,CategoryDescription,CreatedOn,ModifiedOn,CreatedBy,ModifiedBy) VALUES ('{postCategory.CategoryFunction.Trim()}', '{postCategory.CategoryName.Trim()}', '{postCategory.CategoryDescription}' , '{DateTime.Now}', '{DateTime.Now}', '{emailId}', '{null}')";
            _ = (await dbConnection.QueryAsync<CategoryMasterModel>(insertQuery,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task EditCategoryAsync(CategoryMasterModel postCategory, int? Id, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            postCategory.ModifiedOn = DateTime.Now;
            var updateQuery = $"UPDATE dbo.CategoryMaster SET CategoryFunction = '{postCategory.CategoryFunction}', CategoryName = '{postCategory.CategoryName.Trim()}', CategoryDescription = '{postCategory.CategoryDescription.Trim()}', ModifiedOn = '{postCategory.ModifiedOn}', ModifiedBy = '{emailId}' WHERE Id = {Id}";
            await dbConnection.QueryAsync<CategoryMasterModel>(updateQuery,
                transaction: await GetDbTransactionAsync());
        }

        public async Task EditSubCategoryAsync(SubCategoryMasterModel subCategory, int? Id, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            subCategory.ModifiedOn = DateTime.Now;
            var updateQuery = $"UPDATE dbo.SubCategoryMaster SET SubCategoryName = '{subCategory.SubCategoryName.Trim()}', SubCategoryDescription = '{subCategory.SubCategoryDescription.Trim()}', ModifiedOn = '{subCategory.ModifiedOn}', ModifiedBy = '{emailId}' WHERE Id = {Id}";
            await dbConnection.QueryAsync<CategoryMasterModel>(updateQuery,
                transaction: await GetDbTransactionAsync());
        }

        public async Task AddEmployeeAsync(EmployeeDetailsModel postEmployee)
        {
            var dbConnection = await GetDbConnectionAsync();
            var insertQuery = $"INSERT INTO dbo.EmployeeDetails(EmployeeId,TeamId,EmployeeName,Type,BhavnaEmployeeId,CreatedBy,CreatedDate) VALUES ((select isnull(max(EmployeeId),0) + 1 from EmployeeDetails), '{postEmployee.TeamId}', '{postEmployee.EmployeeName.Trim()}','{postEmployee.Type}','{postEmployee.BhavnaEmployeeId}','{postEmployee.CreatedById}','{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")}')";
            _ = (await dbConnection.QueryAsync<EmployeeDetailsModel>(insertQuery,
                transaction: await GetDbTransactionAsync())).ToList();
            var query = $"Exec usp_AddModifyEmployeeData '{postEmployee.BhavnaEmployeeId}','{postEmployee.EmployeeName}','{postEmployee.EmailId}',{postEmployee.Role},'{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")}','{null}',{postEmployee.DesignationId},'{postEmployee.CreatedById}','{null}'";
            _ = (await dbConnection.QueryAsync<dynamic>(query, transaction: await GetDbTransactionAsync()));
        }

        public async Task updateEmployees(EditTeamEmployeesModelUpdate updateEmployeesObj)
        {
            var dbConnection = await GetDbConnectionAsync();

            var updateQuery = $"UPDATE dbo.EmployeeDetails SET TeamId={updateEmployeesObj.TeamId}, EmployeeName='{updateEmployeesObj.EmployeeName.Trim()}',Type={updateEmployeesObj.Type},ModifiedBy= '{updateEmployeesObj.UpdatedById}',UpdatedDate='{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")}' WHERE BhavnaEmployeeId='{updateEmployeesObj.BhavnaEmployeeId}'";
            await dbConnection.QueryAsync(updateQuery, transaction: await GetDbTransactionAsync());

            var query = $"exec usp_AddModifyEmployeeData '{updateEmployeesObj.BhavnaEmployeeId}','{updateEmployeesObj.EmployeeName}','{updateEmployeesObj.EmailId}',{updateEmployeesObj.Role},'{null}','{DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")}',{updateEmployeesObj.DesignationId},'{null}','{updateEmployeesObj.UpdatedById}'";
            await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());
        }

        public async Task<EmployeeWithRoleModel> GetEmployeeRoleDetailByEmailIdAsync(string EmailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeWithRoleModel>($"EXEC usp_getEmployeeRoleDetailByEmailId '{EmailId}'",
                        transaction: await GetDbTransactionAsync())).FirstOrDefault();
        }

        public async Task AddSkillMatrixAsync(SkillsMatrixModel postSkillMatrix, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var query = $"SELECT * FROM dbo.SkillsMatrix WHERE EmployeeId= '{ postSkillMatrix.BhavnaEmployeeId }' AND SubCategoryId= { postSkillMatrix.SubCategoryId }";
            var result = (await dbConnection.QueryAsync<SkillsMatrixModel>(query,
            transaction: await GetDbTransactionAsync())).ToList();

            try
            {
                if (result.Count() > 0)
                {
                    query = $"UPDATE dbo.SkillsMatrix SET EmployeeScore ={postSkillMatrix.EmployeeScore}, ModifiedOn='{DateTime.Now}', ModifiedBy='{emailId}' WHERE EmployeeId='{postSkillMatrix.BhavnaEmployeeId}' AND SubCategoryId={postSkillMatrix.SubCategoryId}";
                    result = (await dbConnection.QueryAsync<SkillsMatrixModel>(query,
                        transaction: await GetDbTransactionAsync())).ToList();
                    _ = result;
                }
                else
                {
                    query = $"INSERT INTO dbo.SkillsMatrix (EmployeeId,SubCategoryId,EmployeeScore,CreatedOn,ModifiedOn,MatrixDate,CreatedBy,ModifiedBy) VALUES ('{postSkillMatrix.BhavnaEmployeeId}', {postSkillMatrix.SubCategoryId}, {postSkillMatrix.EmployeeScore} , '{DateTime.Now}', '{DateTime.Now}','{DateTime.Now}','{emailId}','{null}')";
                    result = (await dbConnection.QueryAsync<SkillsMatrixModel>(query,
                    transaction: await GetDbTransactionAsync())).ToList();
                    _ = result;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Invalid", ex);
            }
        }

        public async Task AddSubCategoryMappingAsync(SubCategoryMappingModel postSubCategoryMapping, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var query = $"SELECT * FROM dbo. SubCategoryMapping WHERE TeamId='{postSubCategoryMapping.TeamId}' AND SubCategoryId='{postSubCategoryMapping.SubCategoryId}'";
            var result = (await dbConnection.QueryAsync<SubCategoryMappingModel>(query,
            transaction: await GetDbTransactionAsync())).ToList();

            if (result.Count() == 0)
            {
                query = $"INSERT INTO dbo.SubCategoryMapping(TeamId,SubCategoryId,ClientExpectedScore,CreatedOn,ModifiedOn,CreatedBy,ModifiedBy) VALUES ('{postSubCategoryMapping.TeamId}', '{postSubCategoryMapping.SubCategoryId}', '{postSubCategoryMapping.ClientExpectedScore}', '{DateTime.Now}', '{DateTime.Now}', '{emailId}', '{null}')";
                _ = (await dbConnection.QueryAsync<SubCategoryMappingModel>(query,
                    transaction: await GetDbTransactionAsync())).ToList();
            }
            else

            {
                postSubCategoryMapping.ModifiedOn = DateTime.Now;
                if (postSubCategoryMapping.ClientExpectedScore == 0 && result[0].ClientExpectedScore > 0)
                {
                    query = $"DELETE FROM dbo.SubCategoryMapping WHERE TeamId= '{postSubCategoryMapping.TeamId}' AND SubCategoryId= '{postSubCategoryMapping.SubCategoryId}'";
                }
                else
                {
                    query = $"UPDATE dbo.SubCategoryMapping SET ClientExpectedScore = '{postSubCategoryMapping.ClientExpectedScore}' , ModifiedOn = '{postSubCategoryMapping.ModifiedOn}', ModifiedBy = '{emailId}' WHERE TeamId= '{postSubCategoryMapping.TeamId}' AND SubCategoryId= '{postSubCategoryMapping.SubCategoryId}'";
                }
                _ = (await dbConnection.QueryAsync<SubCategoryMappingModel>(query,
                    transaction: await GetDbTransactionAsync())).ToList();
            }
        }

        public async Task AddSubCategoryMasterAsync(SubCategoryMasterModel postSubCategoryMaster, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var insertQuery = $"INSERT INTO dbo.SubCategoryMaster(CategoryId,SubCategoryName,SubCategoryDescription,CreatedOn,ModifiedOn,CreatedBy,ModifiedBy) VALUES ('{postSubCategoryMaster.CategoryId}', '{postSubCategoryMaster.SubCategoryName}', '{postSubCategoryMaster.SubCategoryDescription}' , '{DateTime.Now}', '{DateTime.Now}', '{emailId}', '{null}')";
            _ = (await dbConnection.QueryAsync<SubCategoryMasterModel>(insertQuery,
            transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<SubCategoryMappingModel>> UpdateSubCategoryMappingAsync(SubCategoryMappingModel putSubCategoryMapping)
        {
            var dbConnection = await GetDbConnectionAsync();
            var updateQuery = "UPDATE dbo.SubCategoryMapping SET ClientExpectedScore = " + putSubCategoryMapping.ClientExpectedScore + " WHERE Id=2";
            return (await dbConnection.QueryAsync<SubCategoryMappingModel>(updateQuery,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<SkillsMatrixModel>> GetEmployeeScores(int teamId, string employeeId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var selectQuery = $@"SELECT sm.* FROM dbo.SkillsMatrix sm
                           INNER JOIN dbo.SubCategoryMapping scm ON
                           sm.SubCategoryId=scm.SubCategoryId
                           WHERE scm.ClientExpectedScore > 0 AND sm.EmployeeId= ANY
                           (SELECT EmployeeId FROM dbo.EmployeeDetails
                           WHERE TeamId={teamId});";
            selectQuery = employeeId != "0" ? $"{selectQuery} and EmployeeId = '{employeeId}'" : selectQuery;
            return (await dbConnection.QueryAsync<SkillsMatrixModel>(selectQuery,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task DeleteEmployee(string employeeId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var deleteQuery = $"exec usp_softDeleteEmployee '{employeeId}'";
            await dbConnection.QueryAsync<string>(deleteQuery, transaction: await GetDbTransactionAsync());
        }

        public async Task DeleteTeam(int teamId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var query = $"SELECT EmployeeId FROM dbo.EmployeeDetails WHERE TeamId={teamId}";
            var result = (await dbConnection.QueryAsync<int>(query,
                transaction: await GetDbTransactionAsync())).ToList();

            foreach (var employeeId in result)
            {
                query = $"DELETE FROM dbo.SkillsMatrix WHERE EmployeeId='{employeeId}'";
                await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());
            }

            query = $"DELETE FROM dbo.SubCategoryMapping WHERE TeamId={teamId}";
            await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());

            query = $"DELETE FROM dbo.EmployeeDetails WHERE TeamId={teamId}";
            await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());

            query = $"DELETE FROM dbo.TeamMaster WHERE id={teamId}";
            await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());
        }
        public async Task DeleteClient(int Id)
        {
            var dbConnection = await GetDbConnectionAsync();
            var deleteQuery = $"DELETE FROM dbo.ClientMaster WHERE Id={Id}";
            await dbConnection.QueryAsync(deleteQuery, transaction: await GetDbTransactionAsync());
        }

        public async Task DeleteCategory(int Id)
        {
            var dbConnection = await GetDbConnectionAsync();
            var deleteQuery = $"SELECT * FROM dbo.SubCategoryMaster WHERE CategoryId={Id}";
            var subCategoryList = (await dbConnection.QueryAsync<SubCategoryMasterModel>(deleteQuery,
            transaction: await GetDbTransactionAsync())).ToList();
            foreach (var subCategory in subCategoryList)
            {
                deleteQuery = $"DELETE FROM dbo.SubCategoryMapping WHERE SubCategoryId={subCategory.Id}";
                await dbConnection.QueryAsync(deleteQuery, transaction: await GetDbTransactionAsync());
                deleteQuery = $"DELETE FROM dbo.SkillsMatrix WHERE SubCategoryId={subCategory.Id}";
                await dbConnection.QueryAsync(deleteQuery, transaction: await GetDbTransactionAsync());
            }
            deleteQuery = $"DELETE FROM dbo.SubCategoryMaster WHERE CategoryId={Id}";
            await dbConnection.QueryAsync(deleteQuery, transaction: await GetDbTransactionAsync());
            deleteQuery = $"DELETE FROM dbo.CategoryMaster WHERE Id={Id}";
            await dbConnection.QueryAsync(deleteQuery, transaction: await GetDbTransactionAsync());

        }
        public async Task DeleteSubCategory(int subCategoryId)
        {
            var dbConnection = await GetDbConnectionAsync();

            var query = $"DELETE FROM dbo.SkillsMatrix WHERE SubCategoryId={subCategoryId}";
            await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());

            query = $"DELETE FROM dbo.SubCategoryMapping WHERE SubCategoryId={subCategoryId}";
            await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());

            query = $"DELETE FROM dbo.SubCategoryMaster WHERE id={subCategoryId}";
            await dbConnection.QueryAsync(query, transaction: await GetDbTransactionAsync());
        }
        public async Task EditClient(Models.SkillsMatrix.EditClientTeamsModel editClient, string emailId)
        {
            var dbConnection = await GetDbConnectionAsync();

            var updateQuery = $"UPDATE dbo.ClientMaster " +
                $"SET ClientName='{editClient.ClientName.Trim()}', " +
                $"ClientDescription='{editClient.ClientDescription.Trim()}', " +
                $"ModifiedOn='{editClient.ModifiedOn}', " +
                $"ModifiedBy='{emailId}' " +
                $"WHERE Id={editClient.Id}";
            await dbConnection.QueryAsync(updateQuery, transaction: await GetDbTransactionAsync());
        }

        public async Task EditCategorySubcategory(EditCategorySubcategoryModel editCategorySubcategoryObj)
        {
            var dbConnection = await GetDbConnectionAsync();

            var updateQuery = $"UPDATE dbo.CategoryMaster " +
                $"SET CategoryName='{editCategorySubcategoryObj.CategoryName.Trim()}', " +
                $"CategoryDescription='{editCategorySubcategoryObj.CategoryDescription.Trim()}', " +
                $"ModifiedOn='{editCategorySubcategoryObj.ModifiedOn}' " +
                $"WHERE Id={editCategorySubcategoryObj.Id}";
            await dbConnection.QueryAsync(updateQuery, transaction: await GetDbTransactionAsync());


            foreach (var subCategory in editCategorySubcategoryObj.SubCategories)
            {
                updateQuery = $"UPDATE dbo.SubCategoryMaster " +
                $"SET SubCategoryName='{subCategory.SubCategoryName.Trim()}', " +
                $"SubCategoryDescription='{subCategory.SubCategoryDescription.Trim()}', " +
                $"ModifiedOn='{editCategorySubcategoryObj.ModifiedOn}' " +
                $"WHERE Id={subCategory.Id}";
                await dbConnection.QueryAsync(updateQuery, transaction: await GetDbTransactionAsync());
            }
        }

        public async Task EditTeamEmployees(EditTeamEmployeesModel updateEmployeesObj)
        {
            var dbConnection = await GetDbConnectionAsync();

            var updateQuery = $"UPDATE dbo.TeamMaster " +
                $"SET TeamName='{updateEmployeesObj.TeamName.Trim()}', " +
                $"TeamDescription='{updateEmployeesObj.TeamDescription.Trim()}', " +
                $"ModifiedOn='{updateEmployeesObj.ModifiedOn}' " +
                $"WHERE Id={updateEmployeesObj.Id}";
            await dbConnection.QueryAsync(updateQuery, transaction: await GetDbTransactionAsync());


            foreach (var employee in updateEmployeesObj.Employees)
            {
                updateQuery = $"UPDATE dbo.EmployeeDetails " +
                $"SET EmployeeName='{employee.EmployeeName.Trim()}' " +
                $"WHERE EmployeeId={employee.EmployeeId}";
                await dbConnection.QueryAsync(updateQuery, transaction: await GetDbTransactionAsync());


            }
        }


        public async Task<IList<EmployeeTypeModel>> GetEmployeeTypes()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeTypeModel>($"SELECT * FROM EmployeeType",
                transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<IList<DesignationsModel>> GetEmployeeDesignations()
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<DesignationsModel>($"SELECT * FROM EbDesignation",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        #region Roles Related service repository
        public async Task<IList<RolesModel>> GetRoleListAsync()
        {
            var query = $"SELECT * FROM Roles";
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<RolesModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<RolesModel?> GetRoleByIdAsync(int RoleId)
        {
            var query = $"SELECT * FROM Roles where RoleId = '{RoleId}'";
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<RolesModel>(query,
                transaction: await GetDbTransactionAsync())).FirstOrDefault();
        }

        public async Task<IList<EmployeeRolesModel>> GetEmployeeRolesListAsync()
        {
            var query = $"SELECT * FROM EmployeeRoles";
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeRolesModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<EmployeeRolesModel>> GetEmployeeRolesListByEmployeeIdAsync(string EmployeeId)
        {
            var query = $"SELECT * FROM EmployeeRoles where employeeId = '{EmployeeId}'";
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeRolesModel>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public Task AddEmployeeRole(int employeeId, int RoleId)
        {
            throw new NotImplementedException();
        }

        public Task EditEmployeeRole(int EmployeeRoleID, int RoleId)
        {
            throw new NotImplementedException();
        }

        public Task DeleteEmployeeRole(int EmployeeRoleID)
        {
            throw new NotImplementedException();
        }

        public async Task PostEmployeeWithRoleAsync(EmployeeRoleDetailApplicationContractsModel postEmployeeWithRole, string emailId)
        {
            if (postEmployeeWithRole != null && postEmployeeWithRole.Roles.Count > 0)
            {
                var dbConnection = await GetDbConnectionAsync();
                var employeeSelectedRole = postEmployeeWithRole.Roles.Where(x => x.value == true).FirstOrDefault(); // we are only updating role with value check true at frontend
                if (employeeSelectedRole != null)
                {
                    // Needs to check which role admin has updated as true for posted user, needs to update only if exist
                    var selectQuery = $"SELECT * FROM dbo.EmployeeRoles WHERE EmployeeId = '{postEmployeeWithRole.EmployeeId}'";
                    var result = (await dbConnection.QueryAsync<EmployeeRolesModel>(selectQuery,
                                transaction: await GetDbTransactionAsync())).FirstOrDefault();

                    if (result == null) // this means role mapping not exist insert the mapping
                    {
                        var insertQuery = $"INSERT INTO dbo.EmployeeRoles (RoleId, EmployeeId, CreatedDate, CreatedBy, ModifiedBy) VALUES ({employeeSelectedRole.Id},'{postEmployeeWithRole.EmployeeId}', '{DateTime.Now}', '{emailId}', '{null}')";
                        (await dbConnection.QueryAsync<SubCategoryMasterModel>(insertQuery,
                        transaction: await GetDbTransactionAsync())).FirstOrDefault();

                    }
                    else // this means role mapping exist in DB then update role
                    {
                        var updateQuery = $"UPDATE dbo.EmployeeRoles SET RoleId='{employeeSelectedRole.Id}', UpdatedDate='{DateTime.Now}', ModifiedBy='{emailId}'  WHERE EmployeeRoleId={result.EmployeeRoleId}";
                        await dbConnection.QueryAsync(updateQuery, transaction: await GetDbTransactionAsync());
                    }
                }

            }
        }
        public async Task<IList<ApplicationAccessContractModel?>> GetApplicationAccessListAsync(string EmailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<ApplicationAccessContractModel>($"EXEC usp_getApplicationAccessByEmailId '{EmailId}'",
                        transaction: await GetDbTransactionAsync())).ToList();
        }


        #endregion

        #region Report Service Repository starts here
        public async Task<IList<dynamic>> GetReportByCategoryAndClientAsync(string emailId, int categoryId, int clientId)
        {
            var dbconnection = await GetDbConnectionAsync();
            return (await dbconnection.QueryAsync<dynamic>($"exec usp_getReportByCategoryAndClient '{emailId}', {categoryId},'{clientId}'",
                transaction: await GetDbTransactionAsync())).ToList();
        }
        public async Task<IList<SkillSegementCategoryModel>> SkillsSegmentByCategoryAsync(string emailId, int? categoryId, int? clientId, int? teamId, int year, int month)
        {
            var categoryIdValue = categoryId == null || categoryId == 0 ? "NULL" : categoryId.ToString();
            var clientIdValue = clientId == null || clientId == 0 ? "NULL" : clientId.ToString();
            var teamIdValue = teamId == null || teamId == 0 ? "NULL" : teamId.ToString();
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<SkillSegementCategoryModel>($"EXEC usp_getskillsegmentscorereport_withcategories '{emailId}', {categoryIdValue}, {clientIdValue}, {teamIdValue}, {year}, {month}",
                transaction: await GetDbTransactionAsync())).ToList();
        }

        public async Task<IList<dynamic>> GetEmployeeScoreReportByCategoryClientAsync(PostSkillMatrixReportModel postSkillMatrix, string EmailId)
        {
            var dbConnection = await GetDbConnectionAsync();
            var query = $"exec usp_getEmployeeScoreReportByCategoryClient '{EmailId}', {postSkillMatrix.categoryId}, {postSkillMatrix.clientId}, {postSkillMatrix.teamId}, {postSkillMatrix.reportType}, '{postSkillMatrix.functionType}', {postSkillMatrix.year}, {postSkillMatrix.month}";
            return (await dbConnection.QueryAsync<dynamic>(query,
                transaction: await GetDbTransactionAsync())).ToList();
        }

        #endregion

        public async Task ExecuteArchiveProcess()
        {
            var dbConnection = await GetDbConnectionAsync();
            _ = (await dbConnection.QueryAsync("usp_archive_process", commandType: CommandType.StoredProcedure,
                transaction: await GetDbTransactionAsync()));
        }

        public async Task SaveOrUpdateArchiveProcessLog(DateTime month, string status)
        {
            var dbConnection = await GetDbConnectionAsync();
            _ = (await dbConnection.QueryAsync("SaveOrUpdateArchiveProcessLog", new { @month = month, @status = status },
                commandType: CommandType.StoredProcedure, transaction: await GetDbTransactionAsync()));
        }
        public async Task<IList<EmployeeDetailsModel>> GetAllEmployeeListSm(int teamId = 0)
        {
            var dbConnection = await GetDbConnectionAsync();
            return (await dbConnection.QueryAsync<EmployeeDetailsModel>($"exec usp_getEmployeeDetailsByTeamId {teamId}",
            transaction: await GetDbTransactionAsync())).ToList();
        }

    }
}