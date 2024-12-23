USE [Automation]
GO

IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'Logger')
BEGIN
CREATE TABLE [dbo].[Logger](
	[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[LoggerType] [varchar](50) NULL DEFAULT ('ERROR'),
	[Description] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL DEFAULT (getdate()),
	[Source] [varchar](200) NULL,
)
END

GO


IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'EmployeeMaster')
BEGIN
CREATE TABLE [dbo].[EmployeeMaster](
	[EmployeeId] INT NOT NULL PRIMARY KEY,
	[EmailId] VARCHAR(200) NOT NULL UNIQUE, 
	[CreatedDate] DATETIME NULL DEFAULT GETDATE(),
	[UpdatedDate] DATETIME NULL,
	[CreatedById] INT NULL,
	[UpdatedById] INT NULL,
	[IsActive] [bit] NULL,
	[IsSkillMatrixAllowed] [bit] NULL DEFAULT(0) -- By default skill matix not allowed to anyone
)
END
ELSE
BEGIN
--Check Id column exist
IF EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'Id'
          AND Object_ID = Object_ID(N'dbo.EmployeeMaster'))
BEGIN
    -- IF Id column exists remove first constraint Primary Key

	DECLARE @table NVARCHAR(512), @sql NVARCHAR(MAX);
    SELECT @table = N'dbo.EmployeeMaster';

    SELECT @sql = 'ALTER TABLE ' + @table 
    + ' DROP CONSTRAINT ' + name + ';'
    FROM sys.key_constraints
    WHERE [type] = 'PK'
    AND [parent_object_id] = OBJECT_ID(@table);
    
    EXEC sp_executeSQL @sql;

    --Now drop Id column

    ALTER TABLE EmployeeMasters
    DROP COLUMN Id;

    --now add primary key constraint in EmployeeId column

    ALTER TABLE EmployeeMaster 
    ADD CONSTRAINT PK_employeeId PRIMARY KEY (employeeId);

END
END

GO


--AS Employee Master is the only source of truth so we are updating the foreign key references


DECLARE @ForeignKey VARCHAR(100) = '';
SELECT
  @ForeignKey = name
FROM sys.foreign_keys
WHERE parent_object_id = object_id('EmployeeRoles') AND referenced_object_id = object_id('EmployeeDetails')
if @ForeignKey <> ''
BEGIN
EXEC ('ALTER TABLE EmployeeRoles DROP CONSTRAINT '+ @ForeignKey);
print('Foreign Key ' + @ForeignKey + ' removed successfully !!' );
END
ELSE
print('No foreign key found');
GO
-- ADD NEW FOREIGN KEY CONSTARINT
IF NOT EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'FK_Employee_EmployeeRoles')
   AND parent_object_id = OBJECT_ID(N'dbo.EmployeeRoles')
)
BEGIN
ALTER TABLE EmployeeRoles
ADD CONSTRAINT FK_Employee_EmployeeRoles
FOREIGN KEY (EmployeeId) REFERENCES EmployeeMaster(EmployeeId);

END





----------------------------------------------- UPDATED SP -------------------------------------------



IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_getClientMasterByEmployeeId'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_getClientMasterByEmployeeId

GO

CREATE PROCEDURE [dbo].[usp_getClientMasterByEmployeeId]
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @ClientId INT;

SELECT TOP(1) @ClientId=TeamMaster.ClientId, @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.EmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId

IF @Role = ''
BEGIN
SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId
END

--FILTER RECORD USING ROLE
IF (@Role = 'ADMIN')
BEGIN
SELECT * FROM ClientMaster
END
ELSE IF (@Role = 'Reporting_Manager')
BEGIN
SELECT * FROM ClientMaster where Id  = @ClientId
END
ELSE IF (@Role = 'EMPLOYEE')
BEGIN
SELECT * FROM ClientMaster where Id  = @ClientId
END

END
END


GO


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_getEmployeeDetailByEmailId'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_getEmployeeDetailByEmailId

GO

CREATE PROCEDURE [dbo].[usp_getEmployeeDetailByEmailId]
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100)= '';
 DECLARE @TeamId INT;
 DECLARE @EmployeeId Int;

SELECT TOP(1) @TeamId=EmployeeDetails.TeamId, @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId
FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.EmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId

IF @Role = ''
BEGIN
SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId
END


--FILTER RECORD USING ROLE
IF (@Role = 'ADMIN')
BEGIN
SELECT * FROM EmployeeDetails
END
ELSE IF (@Role = 'Reporting_Manager')
BEGIN
SELECT * FROM EmployeeDetails WHERE TeamId = @TeamId
END
ELSE IF (@Role = 'EMPLOYEE')
BEGIN
SELECT * FROM EmployeeDetails WHERE EmployeeId  = @EmployeeId
END

END
END


GO


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_getEmployeeRoleDetailByEmailId'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_getEmployeeRoleDetailByEmailId

GO

CREATE PROCEDURE [dbo].[usp_getEmployeeRoleDetailByEmailId]
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @ClientId INT;
 DECLARE @TeamId INT;
 DECLARE @EmployeeId Int;
 DECLARE @RoleId Int;

 SELECT TOP(1) @TeamId=EmployeeDetails.TeamId, @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId,
 @RoleId = Roles.RoleId,@ClientId = TeamMaster.ClientId
FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.EmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId;

IF @Role = ''
BEGIN
 SELECT TOP(1) @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId,
 @RoleId = Roles.RoleId
FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId  = @EmailId;
SELECT @RoleId AS RoleId, @TeamId AS TeamId, @Role AS RoleName, @EmployeeId AS EmployeeId, @ClientId AS ClientId
END
ELSE
BEGIN
SELECT @RoleId AS RoleId, @TeamId AS TeamId, @Role AS RoleName, @EmployeeId AS EmployeeId, @ClientId AS ClientId
END

END
END


GO


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_getSkillsMatrixTablesByEmailId'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_getSkillsMatrixTablesByEmailId

GO


CREATE PROCEDURE [dbo].[usp_getSkillsMatrixTablesByEmailId]
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @ClientId INT;
 DECLARE @Query VARCHAR(max);
 DECLARE @Condition VARCHAR(max);

SELECT TOP(1) @ClientId=TeamMaster.ClientId, @Role=Roles.RoleName
FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.EmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId

SET @Query = 'SELECT ClientMaster.ClientName, 
TeamMaster.TeamName, 
SkillsMatrix.EmployeeId, 
EmployeeDetails.EmployeeName, 
CategoryMaster.CategoryName, 
SubCategoryMaster.SubCategoryName, 
SubCategoryMapping.ClientExpectedScore, 
SkillsMatrix.EmployeeScore FROM SkillsMatrix
inner JOIN EmployeeDetails ON EmployeeDetails.EmployeeId = SkillsMatrix.EmployeeId
inner JOIN SubCategoryMapping ON SkillsMatrix.SubCategoryId = SubCategoryMapping.SubCategoryId AND SubCategoryMapping.TeamId=EmployeeDetails.TeamId 
inner JOIN TeamMaster ON EmployeeDetails.TeamId=TeamMaster.Id 
inner JOIN ClientMaster ON TeamMaster.ClientId=ClientMaster.Id 
inner JOIN SubCategoryMaster ON SubCategoryMapping.SubCategoryId = SubCategoryMaster.Id  
JOIN CategoryMaster ON SubCategoryMaster.CategoryId = CategoryMaster.Id'

IF @Role = ''
BEGIN
SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId
END


--FILTER RECORD USING ROLE
IF (@Role = 'ADMIN')
BEGIN
EXEC(@Query)
END
ELSE IF (@Role = 'Reporting_Manager')
BEGIN
SET @Condition = ' WHERE ClientId = @Param';
SET @Query = @Query + @Condition;
EXECUTE sp_executesql @Query, N'@Param INT',@Param=@ClientId
END
--For now we are not working on employee

END
END


GO


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_getTeamListByEmailId'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_getTeamListByEmailId

GO

CREATE PROCEDURE [dbo].[usp_getTeamListByEmailId]
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @ClientId INT;

SELECT TOP(1) @ClientId=TeamMaster.ClientId, @Role=Roles.RoleName
FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.EmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId


IF @Role = ''
BEGIN
SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId
END


--FILTER RECORD USING ROLE
IF (@Role = 'ADMIN')
BEGIN
SELECT * FROM TeamMaster
END
ELSE IF (@Role = 'Reporting_Manager')
BEGIN
SELECT * FROM TeamMaster where ClientId = @ClientId;
END
--For now we are not working on employee

END
END
GO



IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_getClientMasterByEmployeeId'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_getClientMasterByEmployeeId

GO

CREATE PROCEDURE [dbo].[usp_getClientMasterByEmployeeId]
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @ClientId INT;

SELECT TOP(1) @ClientId=TeamMaster.ClientId, @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.EmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId

IF @Role = ''
BEGIN
SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId
END

--FILTER RECORD USING ROLE
IF (@Role = 'ADMIN')
BEGIN
SELECT * FROM ClientMaster
END
ELSE IF (@Role = 'Reporting_Manager')
BEGIN
SELECT * FROM ClientMaster where Id  = @ClientId
END
ELSE IF (@Role = 'EMPLOYEE')
BEGIN
SELECT * FROM ClientMaster where Id  = @ClientId
END

END
END


GO


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_getEmployeeDetailByEmailId'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_getEmployeeDetailByEmailId

GO

CREATE PROCEDURE [dbo].[usp_getEmployeeDetailByEmailId]
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100)= '';
 DECLARE @TeamId INT;
 DECLARE @EmployeeId Int;

SELECT TOP(1) @TeamId=EmployeeDetails.TeamId, @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId
FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.EmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId

IF @Role = ''
BEGIN
SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId
END


--FILTER RECORD USING ROLE
IF (@Role = 'ADMIN')
BEGIN
SELECT * FROM EmployeeDetails
END
ELSE IF (@Role = 'Reporting_Manager')
BEGIN
SELECT * FROM EmployeeDetails WHERE TeamId = @TeamId
END
ELSE IF (@Role = 'EMPLOYEE')
BEGIN
SELECT * FROM EmployeeDetails WHERE EmployeeId  = @EmployeeId
END

END
END


GO


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_getEmployeeRoleDetailByEmailId'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_getEmployeeRoleDetailByEmailId

GO

CREATE PROCEDURE [dbo].[usp_getEmployeeRoleDetailByEmailId]
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @ClientId INT;
 DECLARE @TeamId INT;
 DECLARE @EmployeeId Int;
 DECLARE @RoleId Int;

 SELECT TOP(1) @TeamId=EmployeeDetails.TeamId, @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId,
 @RoleId = Roles.RoleId,@ClientId = TeamMaster.ClientId
FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.EmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId;

IF @Role = ''
BEGIN
 SELECT TOP(1) @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId,
 @RoleId = Roles.RoleId
FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId  = @EmailId;
END

SELECT @RoleId AS RoleId, @TeamId AS TeamId, @Role AS RoleName, @EmployeeId AS EmployeeId, @ClientId AS ClientId

END
END


GO


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_getSkillsMatrixTablesByEmailId'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_getSkillsMatrixTablesByEmailId

GO


CREATE PROCEDURE [dbo].[usp_getSkillsMatrixTablesByEmailId]
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @ClientId INT;
 DECLARE @Query VARCHAR(max);
 DECLARE @Condition VARCHAR(max);

SELECT TOP(1) @ClientId=TeamMaster.ClientId, @Role=Roles.RoleName
FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.EmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId

SET @Query = 'SELECT ClientMaster.ClientName, 
TeamMaster.TeamName, 
SkillsMatrix.EmployeeId, 
EmployeeDetails.EmployeeName, 
CategoryMaster.CategoryName, 
SubCategoryMaster.SubCategoryName, 
SubCategoryMapping.ClientExpectedScore, 
SkillsMatrix.EmployeeScore FROM SkillsMatrix
inner JOIN EmployeeDetails ON EmployeeDetails.EmployeeId = SkillsMatrix.EmployeeId
inner JOIN SubCategoryMapping ON SkillsMatrix.SubCategoryId = SubCategoryMapping.SubCategoryId AND SubCategoryMapping.TeamId=EmployeeDetails.TeamId 
inner JOIN TeamMaster ON EmployeeDetails.TeamId=TeamMaster.Id 
inner JOIN ClientMaster ON TeamMaster.ClientId=ClientMaster.Id 
inner JOIN SubCategoryMaster ON SubCategoryMapping.SubCategoryId = SubCategoryMaster.Id  
JOIN CategoryMaster ON SubCategoryMaster.CategoryId = CategoryMaster.Id'

IF @Role = ''
BEGIN
SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId
END


--FILTER RECORD USING ROLE
IF (@Role = 'ADMIN')
BEGIN
EXEC(@Query)
END
ELSE IF (@Role = 'Reporting_Manager')
BEGIN
SET @Condition = ' WHERE ClientId = @Param';
SET @Query = @Query + @Condition;
EXECUTE sp_executesql @Query, N'@Param INT',@Param=@ClientId
END
--For now we are not working on employee

END
END


GO


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_getTeamListByEmailId'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_getTeamListByEmailId

GO

CREATE PROCEDURE [dbo].[usp_getTeamListByEmailId]
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @ClientId INT;

SELECT TOP(1) @ClientId=TeamMaster.ClientId, @Role=Roles.RoleName
FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.EmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId


IF @Role = ''
BEGIN
SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId
END


--FILTER RECORD USING ROLE
IF (@Role = 'ADMIN')
BEGIN
SELECT * FROM TeamMaster
END
ELSE IF (@Role = 'Reporting_Manager')
BEGIN
SELECT * FROM TeamMaster where ClientId = @ClientId;
END
--For now we are not working on employee

END
END
GO

