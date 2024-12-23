USE [Automation]
GO
--------------------------------------------
IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'EbDesignation')
BEGIN
CREATE TABLE [dbo].[EbDesignation]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[designation] [varchar](100) NOT NULL UNIQUE,
	[description] [nvarchar](500) NULL,
	[CreateDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[UpdateDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL DEFAULT 1,
	CONSTRAINT PK_Designation PRIMARY KEY (Id)
)
END


IF NOT EXISTS (SELECT * FROM EbDesignation where id in (1,2))
BEGIN
SET IDENTITY_INSERT [dbo].[EbDesignation] ON 

INSERT [dbo].[EbDesignation] ([Id], [designation], [description], [CreateDate], [UpdateDate], [IsActive]) VALUES (1, N'Senior Software Engineer', NULL, CAST(N'2024-02-14T17:01:18.120' AS DateTime), NULL, 1)
INSERT [dbo].[EbDesignation] ([Id], [designation], [description], [CreateDate], [UpdateDate], [IsActive]) VALUES (2, N'Engineer', NULL, CAST(N'2024-02-14T17:06:04.260' AS DateTime), NULL, 1)
SET IDENTITY_INSERT [dbo].[EbDesignation] OFF

END

------------------------------------------------
IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'EbProjects')
BEGIN
CREATE TABLE [dbo].[EbProjects]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectName] [varchar](100) NULL,
	[IsActive] [bit] NOT NULL DEFAULT 1,
	CreatedDate Datetime not null default GETDATE(),
	CONSTRAINT PK_Projects PRIMARY KEY (Id)
)
END

GO

IF NOT EXISTS (SELECT * FROM EbProjects where id in (1,2,3))
BEGIN
SET IDENTITY_INSERT [dbo].[EbProjects] ON 

INSERT [dbo].[EbProjects] ([Id], [ProjectName], [IsActive], [CreatedDate]) VALUES (1, N'Common Pool', 1, CAST(N'2024-02-14T17:03:20.333' AS DateTime))
INSERT [dbo].[EbProjects] ([Id], [ProjectName], [IsActive], [CreatedDate]) VALUES (2, N'ML', 1, CAST(N'2024-02-14T17:03:36.090' AS DateTime))
INSERT [dbo].[EbProjects] ([Id], [ProjectName], [IsActive], [CreatedDate]) VALUES (3, N'Mercell', 1, CAST(N'2024-02-14T17:03:43.500' AS DateTime))
SET IDENTITY_INSERT [dbo].[EbProjects] OFF

END

----------------------- NEW CHANGES ON 28-02-2024-------------------------------------
--Now EmployeeMaster is source truth of employees 
USE [Automation]
GO

---------------------------------
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'FirstName'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[FirstName] [varchar](100) NOT NULL DEFAULT(' ')

GO
-----------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'MiddleName'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[MiddleName] [varchar](100) NULL

GO
-------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'LastName'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[LastName] [varchar](100) NULL

GO


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'ProjectId'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[ProjectId] [int] NOT NULL DEFAULT(1)

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'AboutYourSelf'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[AboutYourSelf] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------



---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'HobbiesAndInterests'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
		[HobbiesAndInterests] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------




---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'FutureAspirations'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[FutureAspirations] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'BiographyTitle'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[BiographyTitle] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'DefineMyself'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
				[DefineMyself] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'MyBiggestFlex'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
					[MyBiggestFlex] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'FavoriteBingsShow'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
					[FavoriteBingsShow] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'MyLifeMantra'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
				[MyLifeMantra] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'ProfilePictureUrl'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[ProfilePictureUrl] [varchar](500) NULL

GO

------------------------------------------------------------------------------

---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'JoiningDate'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[JoiningDate] [datetime] NOT NULL DEFAULT(GETDATE())

GO

------------------------------------------------------------------------------



---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'EmployeeLocation'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[EmployeeLocation] [varchar](100) NULL

GO

------------------------------------------------------------------------------


IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'TeamId'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[TeamId] INT NOT NULL
GO

DECLARE @ClientId INT;
DECLARE @TeamId INT;
IF NOT EXISTS(SELECT Id FROM ClientMaster WHERE ClientName = 'BSIPL')
BEGIN
INSERT INTO [dbo].[ClientMaster]
           ([ClientName]
           ,[ClientDescription]
           ,[CreatedOn]
           ,[ModifiedOn])
     VALUES
           ('BSIPL'
           ,'BSIPL'
           ,GETDATE()
           ,GETDATE())

SELECT @ClientId = SCOPE_IDENTITY();

INSERT INTO [dbo].[TeamMaster]
           ([ClientId]
           ,[TeamName]
           ,[TeamDescription]
           ,[CreatedOn]
           ,[ModifiedOn])
     VALUES
           (@ClientId
           ,'Common Pool'
          ,'Common Pool'
           ,GETDATE()
           ,GETDATE())
END
ELSE
BEGIN
SELECT TOP(1) @TeamId = Id from TeamMaster WHERE [TeamName] = 'Common Pool'
END

UPDATE EmployeeMaster SET TeamId = @TeamId;
GO


------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'OneThingICanNotLive'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
				[OneThingICanNotLive] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'WhoInspiresYou'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	[WhoInspiresYou] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'YourBucketList'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	[YourBucketList] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------



---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'FavoriteWorkProject'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	[FavoriteWorkProject] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'FavoriteMomentsAtBhavna'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
[FavoriteMomentsAtBhavna] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'NativePlace'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	[NativePlace] [varchar](100) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'ExperienceYear'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
		[ExperienceYear] [int] NOT NULL DEFAULT(0)

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'DesignationId'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
		[DesignationId] [int] NOT NULL DEFAULT(1)

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'IsDeleted'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	
	[IsDeleted] [bit] NOT NULL DEFAULT(0)

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'IsEmployeeBookAllowed'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	
	[IsEmployeeBookAllowed] [bit] NOT NULL DEFAULT(1)

GO

------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------


IF NOT EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'FK_EmployeeMaster_Designation')
   AND parent_object_id = OBJECT_ID(N'dbo.EmployeeMaster')
)
BEGIN
ALTER TABLE [dbo].[EmployeeMaster]  WITH CHECK ADD CONSTRAINT [FK_EmployeeMaster_Designation] FOREIGN KEY([DesignationId])
REFERENCES [dbo].[EbDesignation] ([Id])
END 

GO


IF NOT EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'FK_EmployeeMaster_Projects')
   AND parent_object_id = OBJECT_ID(N'dbo.EmployeeMaster')
)
BEGIN
ALTER TABLE [dbo].[EmployeeMaster]  WITH CHECK ADD CONSTRAINT [FK_EmployeeMaster_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[EbProjects] ([Id])
END 

GO


------------------------------------------STORED PROC-----------


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_SaveEmployeeRole'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_Eb_SaveEmployeeRole

GO
CREATE PROCEDURE [dbo].[usp_Eb_SaveEmployeeRole]
	@EmailId VARCHAR(200),
	@RoleId INT,
	@EmployeeId INT,
	@Response INT OUTPUT
AS         
BEGIN

-- CHECK ROLE USING EMAILID
IF @EmailId IS NOT NULL --1

BEGIN
DECLARE @Role VARCHAR(100) = '';


SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId

--FILTER RECORD USING ROLE
IF @Role <> '' AND @EmployeeId > 0
BEGIN
IF (@Role = 'ADMIN') -- ONLY ADMIN CAN SAVE EMPLOYEE ROLES
BEGIN
--Drop previous role.. We are considering one role per employee
DELETE FROM EmployeeRoles Where EmployeeId = @EmployeeId

-- Insert new role.. 
INSERT INTO EmployeeRoles (RoleId, EmployeeId) VALUES(@RoleId, @EmployeeId);

SELECT @Response = 1; --Success
				return;

END
ELSE
BEGIN
SELECT @Response = 0; --Access Denied Issue 
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured EMAIL ID NULL
				return;
END

END   --1 END

GO



--------------------------------------------------------------------------------------


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_GetEmployeeRole'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_Eb_GetEmployeeRole

GO

CREATE PROCEDURE [dbo].[usp_Eb_GetEmployeeRole]
	@EmailId VARCHAR(200)
AS  
BEGIN


-- CHECK ROLE USING EMAILID
 IF @EmailId IS NOT NULL
 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @EmployeeId INT = 0;


SELECT TOP(1) @Role=Roles.RoleName, @EmployeeId = EmployeeMaster.EmployeeId FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId


--FILTER RECORD USING ROLE
IF @Role <> '' AND @EmployeeId > 0
BEGIN

SELECT @Role AS RoleName, EmployeeRoles.RoleId AS RoleId, * FROM EmployeeRoles WHERE EmployeeId = @EmployeeId;
END

END
END
GO


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_EditDeleteEmployee'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_EditDeleteEmployee

GO

CREATE PROCEDURE [dbo].[usp_Eb_EditDeleteEmployee]
		@EmailId VARCHAR(200) = '',
		@EmployeeId INT = 0,
		@action INT = 0,
		@FName VARCHAR(100) = NULL,
		@MName VARCHAR(100) = NULL,
		@LName VARCHAR(100) = NULL,
		@ProjectId INT = NULL,
		@AboutYSelf NVARCHAR(2000) = NULL,
		@HobbiesAndInterest NVARCHAR(2000)= NULL,
		@FutureAspirations NVARCHAR(2000) = NULL,
		@BiographyTitle NVARCHAR(2000) = NULL,
		@DefineMyself NVARCHAR(2000) = NULL,
		@MyBiggestFlex NVARCHAR(2000) = NULL,
		@FavoriteBingsShow NVARCHAR(2000) = NULL,
		@MyLifeMantra NVARCHAR(2000) = NULL,
		@ProfilePictureUrl VARCHAR(200) = NULL,
		@TeamId INT = 0,
		@OneThingICanNotLive NVARCHAR(2000) = NULL,
		@WhoInspiresYou NVARCHAR(2000) = NULL,
		@YourBucketList NVARCHAR(2000) = NULL,
		@FavoriteWorkProject NVARCHAR(2000) = NULL,
		@FavoriteMomentsAtBhavna NVARCHAR(2000) = NULL,
		@NativePlace VARCHAR(100) = NULL,
		@ExperienceYear INT = NULL,
		@DesignationId INT = NULL,
		@UpdatedBy INT = NULL,
		@Response INT OUTPUT
		AS
			BEGIN
			if(@EmployeeId IS NULL OR @action <= 0 OR @EmailId = '')
			BEGIN
				SELECT @Response = 2; --ERROR 
				return;
			END

--ONLY ADMIN CAN EDIT OR DELETE A EMPLOYEE
 DECLARE @Role VARCHAR(100) = '';

SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId

IF @Role <> ''
BEGIN
IF (@Role = 'ADMIN') -- ONLY ADMIN CAN SAVE EMPLOYEE ROLES
BEGIN
IF (@action = 2) --UPDATE EMPLOYEE
BEGIN
UPDATE EmployeeMaster 
SET         
    FirstName = @FName,
	LastName = @LName,
    MiddleName =@MName,
	ProjectId = @ProjectId,
	AboutYourSelf = @AboutYSelf,
    HobbiesAndInterests = @HobbiesAndInterest,
	FutureAspirations = @FutureAspirations,
    BiographyTitle = @BiographyTitle,
	DefineMyself = @DefineMyself,
    MyBiggestFlex = @MyBiggestFlex,
	FavoriteBingsShow = @FavoriteBingsShow,
    MyLifeMantra = @MyLifeMantra,
	ProfilePictureUrl = isNull(@ProfilePictureUrl, ProfilePictureUrl),
	TeamId = @TeamId,
    OneThingICanNotLive = @OneThingICanNotLive,
	WhoInspiresYou = @WhoInspiresYou,
    YourBucketList = @YourBucketList,
	FavoriteWorkProject = @FavoriteWorkProject,
    FavoriteMomentsAtBhavna = @FavoriteMomentsAtBhavna,
	NativePlace = @NativePlace,
	ExperienceYear = isNull(@ExperienceYear, ExperienceYear),
	DesignationId = isNull(@DesignationId, DesignationId),
	UpdatedById = @UpdatedBy,
	UpdatedDate = GETDATE()
WHERE EmployeeId = @EmployeeId;

SELECT @Response = 1; --SuccessFul
				return;

END
ELSE IF (@action = 3) --DELETE EMPLOYEE
BEGIN
		UPDATE EmployeeMaster SET IsDeleted = 1, UpdatedById = @UpdatedBy where EmployeeId  = @EmployeeId;
		SELECT @Response = 1; --SUCCESSFUL
				return;
END 


END
END
ELSE
BEGIN
SELECT @Response = 0; --Access Denied Issue 
				return;
END

END

GO






------------------------------------------------------------------------------------------------------

IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_GetEmployeeDetailById'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_GetEmployeeDetailById

GO

CREATE PROCEDURE [dbo].[usp_Eb_GetEmployeeDetailById]
	@EmployeeId INT
AS  
BEGIN


-- CHECK ROLE USING EMAILID
 IF @EmployeeId IS NOT NULL AND @EmployeeId > 0
 BEGIN

 SELECT * from vw_Eb_GetEmployeesDetailList AS Em
WHERE Em.EmployeeId = @EmployeeId and Em.IsDeleted = 0 and Em.IsActive = 1;
END
END
GO


----------------------------------------------------------------------------------------------------

IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_SaveEmployeeExcel'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_SaveEmployeeExcel

GO

CREATE PROCEDURE [dbo].[usp_Eb_SaveEmployeeExcel]
    @EmployeeExcel EmployeeExcel READONLY,
	@EmailId varchar(200),
	@Response INT OUTPUT
AS
BEGIN

-- CHECK ROLE USING EMAILID
IF @EmailId IS NOT NULL --1

BEGIN
DECLARE @Role VARCHAR(100) = '';


SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId

--FILTER RECORD USING ROLE
IF @Role <> ''
BEGIN
IF (@Role = 'ADMIN') -- ONLY ADMIN CAN SAVE EMPLOYEE RECORDS
BEGIN
-- Insert new role.. 
INSERT INTO EmployeeMaster(EmployeeId,FirstName,MiddleName,LastName, EmailId, ProjectId, AboutYourSelf, 
HobbiesAndInterests, FutureAspirations, BiographyTitle, DefineMyself, MyBiggestFlex, FavoriteBingsShow, MyLifeMantra,
ProfilePictureUrl,EmployeeLocation, TeamId, OneThingICanNotLive,WhoInspiresYou, YourBucketList, FavoriteWorkProject,
FavoriteMomentsAtBhavna, NativePlace, ExperienceYear, DesignationId, IsActive, IsDeleted, JoiningDate
) SELECT EmployeeId,FirstName,MiddleName,LastName, EmailId, ProjectId, AboutYourSelf, 
HobbiesAndInterests, FutureAspirations, BiographyTitle, DefineMyself, MyBiggestFlex, FavoriteBingsShow, MyLifeMantra,
ProfilePictureUrl,EmployeeLocation, TeamId, OneThingICanNotLive,WhoInspiresYou, YourBucketList, FavoriteWorkProject,
FavoriteMomentsAtBhavna, NativePlace, ExperienceYear, DesignationId, 1, 0, JoiningDate FROM @EmployeeExcel;

SELECT @Response = 1; --Success
return;

END
ELSE
BEGIN
SELECT @Response = 0; --Access Denied Issue 
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured EMAIL ID NULL
				return;
END
END
GO

--------------------------------------------

IF type_id('[dbo].[EmployeeExcel]') IS NULL
/****** Object:  UserDefinedTableType [dbo].[EmployeeExcel]    Script Date: 3/11/2024 2:47:15 PM ******/
CREATE TYPE [dbo].[EmployeeExcel] AS TABLE(
	[EmployeeId] [int] NOT NULL,
	[FirstName] [varchar](100) NOT NULL,
	[MiddleName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[EmailId] [varchar](200) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[AboutYourSelf] [nvarchar](2000) NULL,
	[HobbiesAndInterests] [nvarchar](2000) NULL,
	[FavoriteMomentsAtBhavna] [nvarchar](2000) NULL,
	[FutureAspirations] [nvarchar](2000) NULL,
	[BiographyTitle] [nvarchar](2000) NULL,
	[DefineMyself] [nvarchar](2000) NULL,
	[MyBiggestFlex] [nvarchar](2000) NULL,
	[FavoriteBingsShow] [nvarchar](2000) NULL,
	[MyLifeMantra] [nvarchar](2000) NULL,
	[ProfilePictureUrl] [varchar](500) NULL,
	[TeamId] [int] NULL,
	[OneThingICanNotLive] [nvarchar](2000) NULL,
	[WhoInspiresYou] [nvarchar](2000) NULL,
	[YourBucketList] [nvarchar](2000) NULL,
	[FavoriteWorkProject] [nvarchar](2000) NULL,
	[NativePlace] [varchar](100) NULL,
	[ExperienceYear] [int] NOT NULL,
	[DesignationId] [int] NOT NULL,
	[EmployeeLocation] [varchar](100) NULL,
	[JoiningDate] [datetime] NULL
)
GO

USE [Automation]
GO

-------------------------------------------------------------------------------------------------

IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_SearchEmployees'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_SearchEmployees

GO

CREATE PROCEDURE [dbo].[usp_Eb_SearchEmployees]
	@ProjectId INT = 0,
	@Interests VARCHAR(100) = NULL,
	@SortBy VARCHAR(100) = 'NameAsc',
	@SearchText NVARCHAR(500) = NULL,  
	@Page INT = 1,  
	@PageSize INT = 12
AS         
BEGIN   
	DECLARE @EndIndex INT;
	DECLARE @StartIndex INT;
	DECLARE @TotalPages INT = 0;  
	DECLARE @TotalRecords INT = 0;  
	DECLARE @SQLQuery NVARCHAR(MAX) = '';
	DECLARE @OrderBy VARCHAR(100) = '';
	

	CREATE TABLE #ProjectDat(ProjectId int,ProjectName nvarchar(100));
  
	CREATE TABLE #tmpEmployees(RowNum INT, EmployeeId INT, EmployeeName VARCHAR(300), ProjectName VARCHAR(200), ProfilePictureUrl VARCHAR(200), Designation VARCHAR(100))
	

	IF @SortBy = 'RecentJoining'
	BEGIN
		SET @OrderBy = 'ORDER BY JoiningDate ASC, (FirstName) ASC';
	END
	ELSE IF @SortBy = 'NameDesc'
	BEGIN
		SET @OrderBy = 'ORDER BY (FirstName) DESC ';
	END
	ELSE
	BEGIN
		SET @OrderBy = 'ORDER BY (FirstName) ASC ';
	END
  
	SET @SearchText = CASE WHEN @SearchText IS NULL THEN '' ELSE @SearchText END  
	SET @Interests = CASE WHEN @Interests IS NULL OR @Interests = 'All' THEN '' ELSE @Interests END  
	SET @StartIndex = (@Page - 1) * @PageSize + 1  
	SET @EndIndex = @StartIndex + @PageSize - 1  
  
  
	SET @SQLQuery =   'INSERT INTO  #tmpEmployees  
						SELECT		ROW_NUMBER() OVER ('+@OrderBy+'), EmployeeId, FirstName, ProjectName, ProfilePictureUrl, dsgn.designation
						FROM		EmployeeMaster emp 
						INNER JOIN  EbProjects prj ON emp.ProjectId =  prj.Id
						INNER JOIN  EbDesignation dsgn ON emp.DesignationId =  dsgn.Id
						WHERE		emp.IsActive = 1 and emp.IsDeleted = 0'  
     
	IF @ProjectId > 0  
	BEGIN
		SET @SQLQuery += ' AND prj.Id = @ProjectId '  
	END

	IF @Interests <> ''
	BEGIN
		SET @SQLQuery += ' AND emp.HobbiesAndInterests LIKE ''%'' + @Interests + ''%'' '
	END

	IF @SearchText <> ''
	BEGIN
		SET @SQLQuery += 'AND (  
		emp.FirstName LIKE ''%'' + @SearchText + ''%'' OR  
		prj.ProjectName LIKE ''%'' + @SearchText + ''%''
		)  '
	END

	IF @SQLQuery <> ''  
	BEGIN  
		EXECUTE SP_EXECUTESQL @SQLQuery, N'@ProjectId INT, @SearchText NVARCHAR(500), @Interests VARCHAR(100)', 
		@ProjectId, @SearchText, @Interests
	END   
   
	SELECT  @TotalPages = CEILING(CAST(COUNT(*) AS FLOAT) / CAST(@PageSize AS FLOAT)), @TotalRecords = COUNT(*) FROM #tmpEmployees  
  
	SELECT EmployeeId, EmployeeName, ProfilePictureUrl, Designation FROM #tmpEmployees WHERE RowNum >= @StartIndex  AND  RowNum <= @EndIndex  
  
	SELECT @TotalPages [TotalPages], @TotalRecords [TotalRecords] 
END 
GO




-------------------------------------------------------------------------------------------------

------------------------------------------  VIEW -----------------------------------------
IF exists(select 1 from sys.views where name='vw_Eb_GetEmployeesDetailList' and type='v')
DROP VIEW [dbo].[vw_Eb_GetEmployeesDetailList]
GO

CREATE VIEW [dbo].[vw_Eb_GetEmployeesDetailList] AS
SELECT 
EbDesignation.designation AS Designation, 
EbProjects.ProjectName AS Project,
TeamMaster.TeamName AS Team,
RTRIM(LTRIM(
        CONCAT(
            COALESCE(FirstName + ' ', '')
            , COALESCE(MiddleName + ' ', '')
            , COALESCE(Lastname, '')
        )
    )) AS FullName,
	Em.FirstName,
	Em.LastName,
	em.MiddleName,
Em.EmployeeId,
Em.EmailId,
Em.ProjectId,
Em.AboutYourSelf,
Em.HobbiesAndInterests,
Em.FutureAspirations,
Em.BiographyTitle,
Em.DefineMyself,
Em.MyBiggestFlex,
Em.FavoriteBingsShow,
Em.MyLifeMantra,
Em.ProfilePictureUrl,
Em.IsActive,
Em.CreatedById,
Em.CreatedDate,
EM.UpdatedDate,
Em.UpdatedById,
Em.JoiningDate,
Em.EmployeeLocation,
Em.TeamId,
Em.OneThingICanNotLive,
Em.WhoInspiresYou,
Em.YourBucketList,
Em.FavoriteWorkProject,
Em.FavoriteMomentsAtBhavna,
Em.NativePlace,
Em.ExperienceYear,
Em.DesignationId,
Em.IsDeleted,
Em.isSkillMatrixAllowed,
Em.isEmployeeBookAllowed
from EmployeeMaster AS Em
INNER JOIN EbProjects ON EbProjects.Id = Em.ProjectId
INNER JOIN EbDesignation ON EbDesignation.Id = Em.DesignationId
INNER JOIN TeamMaster ON TeamMaster.Id = Em.TeamId
GO

---------------------------------------------------- VIEW END --------------------------------------------------------------------


IF NOT EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'FK_EmployeeMaster_Team')
   AND parent_object_id = OBJECT_ID(N'dbo.EmployeeMaster')
)
BEGIN
ALTER TABLE [dbo].[EmployeeMaster] ADD CONSTRAINT [FK_EmployeeMaster_Team] FOREIGN KEY([TeamId])
REFERENCES [dbo].[TeamMaster] ([Id])
END

----------------------------------------------------------------------- 11-03-2024 script ends here





USE [Automation]
GO
--------------------------------------------
IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'EbDesignation')
BEGIN
CREATE TABLE [dbo].[EbDesignation]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[designation] [varchar](100) NOT NULL UNIQUE,
	[description] [nvarchar](500) NULL,
	[CreateDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[UpdateDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL DEFAULT 1,
	CONSTRAINT PK_Designation PRIMARY KEY (Id)
)
END


IF NOT EXISTS (SELECT * FROM EbDesignation where id in (1,2))
BEGIN
SET IDENTITY_INSERT [dbo].[EbDesignation] ON 

INSERT [dbo].[EbDesignation] ([Id], [designation], [description], [CreateDate], [UpdateDate], [IsActive]) VALUES (1, N'Senior Software Engineer', NULL, CAST(N'2024-02-14T17:01:18.120' AS DateTime), NULL, 1)
INSERT [dbo].[EbDesignation] ([Id], [designation], [description], [CreateDate], [UpdateDate], [IsActive]) VALUES (2, N'Engineer', NULL, CAST(N'2024-02-14T17:06:04.260' AS DateTime), NULL, 1)
SET IDENTITY_INSERT [dbo].[EbDesignation] OFF

END

------------------------------------------------
IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'EbProjects')
BEGIN
CREATE TABLE [dbo].[EbProjects]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectName] [varchar](100) NULL,
	[IsActive] [bit] NOT NULL DEFAULT 1,
	CreatedDate Datetime not null default GETDATE(),
	CONSTRAINT PK_Projects PRIMARY KEY (Id)
)
END

GO

IF NOT EXISTS (SELECT * FROM EbProjects where id in (1,2,3))
BEGIN
SET IDENTITY_INSERT [dbo].[EbProjects] ON 

INSERT [dbo].[EbProjects] ([Id], [ProjectName], [IsActive], [CreatedDate]) VALUES (1, N'Common Pool', 1, CAST(N'2024-02-14T17:03:20.333' AS DateTime))
INSERT [dbo].[EbProjects] ([Id], [ProjectName], [IsActive], [CreatedDate]) VALUES (2, N'ML', 1, CAST(N'2024-02-14T17:03:36.090' AS DateTime))
INSERT [dbo].[EbProjects] ([Id], [ProjectName], [IsActive], [CreatedDate]) VALUES (3, N'Mercell', 1, CAST(N'2024-02-14T17:03:43.500' AS DateTime))
SET IDENTITY_INSERT [dbo].[EbProjects] OFF

END

----------------------- NEW CHANGES ON 28-02-2024-------------------------------------
--Now EmployeeMaster is source truth of employees 
USE [Automation]
GO

---------------------------------
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'FirstName'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[FirstName] [varchar](100) NOT NULL DEFAULT(' ')

GO
-----------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'MiddleName'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[MiddleName] [varchar](100) NULL

GO
-------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'LastName'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[LastName] [varchar](100) NULL

GO


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'ProjectId'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[ProjectId] [int] NOT NULL DEFAULT(1)

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'AboutYourSelf'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[AboutYourSelf] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------



---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'HobbiesAndInterests'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
		[HobbiesAndInterests] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------




---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'FutureAspirations'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[FutureAspirations] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'BiographyTitle'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[BiographyTitle] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'DefineMyself'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
				[DefineMyself] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'MyBiggestFlex'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
					[MyBiggestFlex] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'FavoriteBingsShow'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
					[FavoriteBingsShow] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'MyLifeMantra'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
				[MyLifeMantra] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'ProfilePictureUrl'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[ProfilePictureUrl] [varchar](500) NULL

GO

------------------------------------------------------------------------------

---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'JoiningDate'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[JoiningDate] [datetime] NOT NULL DEFAULT(GETDATE())

GO

------------------------------------------------------------------------------



---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'EmployeeLocation'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[EmployeeLocation] [varchar](100) NULL

GO

------------------------------------------------------------------------------


IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'TeamId'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			[TeamId] INT NOT NULL
GO

DECLARE @ClientId INT;
DECLARE @TeamId INT;
IF NOT EXISTS(SELECT Id FROM ClientMaster WHERE ClientName = 'BSIPL')
BEGIN
INSERT INTO [dbo].[ClientMaster]
           ([ClientName]
           ,[ClientDescription]
           ,[CreatedOn]
           ,[ModifiedOn])
     VALUES
           ('BSIPL'
           ,'BSIPL'
           ,GETDATE()
           ,GETDATE())

SELECT @ClientId = SCOPE_IDENTITY();

INSERT INTO [dbo].[TeamMaster]
           ([ClientId]
           ,[TeamName]
           ,[TeamDescription]
           ,[CreatedOn]
           ,[ModifiedOn])
     VALUES
           (@ClientId
           ,'Common Pool'
          ,'Common Pool'
           ,GETDATE()
           ,GETDATE())
END
SELECT TOP(1) @TeamId = Id from TeamMaster WHERE [TeamName] = 'Common Pool'

UPDATE EmployeeMaster SET TeamId = @TeamId;
GO


------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'OneThingICanNotLive'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
				[OneThingICanNotLive] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'WhoInspiresYou'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	[WhoInspiresYou] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'YourBucketList'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	[YourBucketList] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------



---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'FavoriteWorkProject'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	[FavoriteWorkProject] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'FavoriteMomentsAtBhavna'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
[FavoriteMomentsAtBhavna] [nvarchar](2000) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'NativePlace'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	[NativePlace] [varchar](100) NULL

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'ExperienceYear'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
		[ExperienceYear] [int] NOT NULL DEFAULT(0)

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'DesignationId'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
		[DesignationId] [int] NOT NULL DEFAULT(1)

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'IsDeleted'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	
	[IsDeleted] [bit] NOT NULL DEFAULT(0)

GO

------------------------------------------------------------------------------


---------------------------------------------------------------------

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'IsEmployeeBookAllowed'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
			
	
	[IsEmployeeBookAllowed] [bit] NOT NULL DEFAULT(1)

GO

------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------


IF NOT EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'FK_EmployeeMaster_Designation')
   AND parent_object_id = OBJECT_ID(N'dbo.EmployeeMaster')
)
BEGIN
ALTER TABLE [dbo].[EmployeeMaster]  WITH CHECK ADD CONSTRAINT [FK_EmployeeMaster_Designation] FOREIGN KEY([DesignationId])
REFERENCES [dbo].[EbDesignation] ([Id])
END 

GO


IF NOT EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'FK_EmployeeMaster_Projects')
   AND parent_object_id = OBJECT_ID(N'dbo.EmployeeMaster')
)
BEGIN
ALTER TABLE [dbo].[EmployeeMaster]  WITH CHECK ADD CONSTRAINT [FK_EmployeeMaster_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[EbProjects] ([Id])
END 

GO


------------------------------------------STORED PROC-----------


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_SaveEmployeeRole'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_Eb_SaveEmployeeRole

GO
CREATE PROCEDURE [dbo].[usp_Eb_SaveEmployeeRole]
	@EmailId VARCHAR(200),
	@RoleId INT,
	@EmployeeId INT,
	@Response INT OUTPUT
AS         
BEGIN

-- CHECK ROLE USING EMAILID
IF @EmailId IS NOT NULL --1

BEGIN
DECLARE @Role VARCHAR(100) = '';


SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId

--FILTER RECORD USING ROLE
IF @Role <> '' AND @EmployeeId > 0
BEGIN
IF (@Role = 'ADMIN') -- ONLY ADMIN CAN SAVE EMPLOYEE ROLES
BEGIN
--Drop previous role.. We are considering one role per employee
DELETE FROM EmployeeRoles Where EmployeeId = @EmployeeId

-- Insert new role.. 
INSERT INTO EmployeeRoles (RoleId, EmployeeId) VALUES(@RoleId, @EmployeeId);

SELECT @Response = 1; --Success
				return;

END
ELSE
BEGIN
SELECT @Response = 0; --Access Denied Issue 
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured EMAIL ID NULL
				return;
END

END   --1 END

GO



--------------------------------------------------------------------------------------


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_GetEmployeeRole'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_Eb_GetEmployeeRole

GO

CREATE PROCEDURE [dbo].[usp_Eb_GetEmployeeRole]
	@EmailId VARCHAR(200)
AS  
BEGIN


-- CHECK ROLE USING EMAILID
 IF @EmailId IS NOT NULL
 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @EmployeeId INT = 0;


SELECT TOP(1) @Role=Roles.RoleName, @EmployeeId = EmployeeMaster.EmployeeId FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId


--FILTER RECORD USING ROLE
IF @Role <> '' AND @EmployeeId > 0
BEGIN

SELECT @Role AS RoleName, EmployeeRoles.RoleId AS RoleId, * FROM EmployeeRoles WHERE EmployeeId = @EmployeeId;
END

END
END
GO


IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_EditDeleteEmployee'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_EditDeleteEmployee

GO

CREATE PROCEDURE [dbo].[usp_Eb_EditDeleteEmployee]
		@EmailId VARCHAR(200) = '',
		@EmployeeId INT = 0,
		@action INT = 0,
		@FName VARCHAR(100) = NULL,
		@MName VARCHAR(100) = NULL,
		@LName VARCHAR(100) = NULL,
		@ProjectId INT = NULL,
		@AboutYSelf NVARCHAR(2000) = NULL,
		@HobbiesAndInterest NVARCHAR(2000)= NULL,
		@FutureAspirations NVARCHAR(2000) = NULL,
		@BiographyTitle NVARCHAR(2000) = NULL,
		@DefineMyself NVARCHAR(2000) = NULL,
		@MyBiggestFlex NVARCHAR(2000) = NULL,
		@FavoriteBingsShow NVARCHAR(2000) = NULL,
		@MyLifeMantra NVARCHAR(2000) = NULL,
		@ProfilePictureUrl VARCHAR(200) = NULL,
		@TeamId INT = 0,
		@OneThingICanNotLive NVARCHAR(2000) = NULL,
		@WhoInspiresYou NVARCHAR(2000) = NULL,
		@YourBucketList NVARCHAR(2000) = NULL,
		@FavoriteWorkProject NVARCHAR(2000) = NULL,
		@FavoriteMomentsAtBhavna NVARCHAR(2000) = NULL,
		@NativePlace VARCHAR(100) = NULL,
		@ExperienceYear INT = NULL,
		@DesignationId INT = NULL,
		@UpdatedBy INT = NULL,
		@Response INT OUTPUT
		AS
			BEGIN
			if(@EmployeeId IS NULL OR @action <= 0 OR @EmailId = '')
			BEGIN
				SELECT @Response = 2; --ERROR 
				return;
			END

--ONLY ADMIN CAN EDIT OR DELETE A EMPLOYEE
 DECLARE @Role VARCHAR(100) = '';

SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId

IF @Role <> ''
BEGIN
IF (@Role = 'ADMIN') -- ONLY ADMIN CAN SAVE EMPLOYEE ROLES
BEGIN
IF (@action = 2) --UPDATE EMPLOYEE
BEGIN
UPDATE EmployeeMaster 
SET         
    FirstName = @FName,
	LastName = @LName,
    MiddleName =@MName,
	ProjectId = @ProjectId,
	AboutYourSelf = @AboutYSelf,
    HobbiesAndInterests = @HobbiesAndInterest,
	FutureAspirations = @FutureAspirations,
    BiographyTitle = @BiographyTitle,
	DefineMyself = @DefineMyself,
    MyBiggestFlex = @MyBiggestFlex,
	FavoriteBingsShow = @FavoriteBingsShow,
    MyLifeMantra = @MyLifeMantra,
	ProfilePictureUrl = isNull(@ProfilePictureUrl, ProfilePictureUrl),
	TeamId = @TeamId,
    OneThingICanNotLive = @OneThingICanNotLive,
	WhoInspiresYou = @WhoInspiresYou,
    YourBucketList = @YourBucketList,
	FavoriteWorkProject = @FavoriteWorkProject,
    FavoriteMomentsAtBhavna = @FavoriteMomentsAtBhavna,
	NativePlace = @NativePlace,
	ExperienceYear = isNull(@ExperienceYear, ExperienceYear),
	DesignationId = isNull(@DesignationId, DesignationId),
	UpdatedById = @UpdatedBy,
	UpdatedDate = GETDATE()
WHERE EmployeeId = @EmployeeId;

SELECT @Response = 1; --SuccessFul
				return;

END
ELSE IF (@action = 3) --DELETE EMPLOYEE
BEGIN
		UPDATE EmployeeMaster SET IsDeleted = 1, UpdatedById = @UpdatedBy where EmployeeId  = @EmployeeId;
		SELECT @Response = 1; --SUCCESSFUL
				return;
END 


END
END
ELSE
BEGIN
SELECT @Response = 0; --Access Denied Issue 
				return;
END

END

GO






------------------------------------------------------------------------------------------------------

IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_GetEmployeeDetailById'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_GetEmployeeDetailById

GO

CREATE PROCEDURE [dbo].[usp_Eb_GetEmployeeDetailById]
	@EmployeeId INT
AS  
BEGIN


-- CHECK ROLE USING EMAILID
 IF @EmployeeId IS NOT NULL AND @EmployeeId > 0
 BEGIN

 SELECT * from vw_Eb_GetEmployeesDetailList AS Em
WHERE Em.EmployeeId = @EmployeeId and Em.IsDeleted = 0 and Em.IsActive = 1;
END
END
GO


----------------------------------------------------------------------------------------------------

IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_SaveEmployeeExcel'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_SaveEmployeeExcel

GO

CREATE PROCEDURE [dbo].[usp_Eb_SaveEmployeeExcel]
    @EmployeeExcel EmployeeExcel READONLY,
	@EmailId varchar(200),
	@Response INT OUTPUT
AS
BEGIN

-- CHECK ROLE USING EMAILID
IF @EmailId IS NOT NULL --1

BEGIN
DECLARE @Role VARCHAR(100) = '';


SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId

--FILTER RECORD USING ROLE
IF @Role <> ''
BEGIN
IF (@Role = 'ADMIN') -- ONLY ADMIN CAN SAVE EMPLOYEE RECORDS
BEGIN
-- Insert new role.. 
INSERT INTO EmployeeMaster(EmployeeId,FirstName,MiddleName,LastName, EmailId, ProjectId, AboutYourSelf, 
HobbiesAndInterests, FutureAspirations, BiographyTitle, DefineMyself, MyBiggestFlex, FavoriteBingsShow, MyLifeMantra,
ProfilePictureUrl,EmployeeLocation, TeamId, OneThingICanNotLive,WhoInspiresYou, YourBucketList, FavoriteWorkProject,
FavoriteMomentsAtBhavna, NativePlace, ExperienceYear, DesignationId, IsActive, IsDeleted, JoiningDate
) SELECT EmployeeId,FirstName,MiddleName,LastName, EmailId, ProjectId, AboutYourSelf, 
HobbiesAndInterests, FutureAspirations, BiographyTitle, DefineMyself, MyBiggestFlex, FavoriteBingsShow, MyLifeMantra,
ProfilePictureUrl,EmployeeLocation, TeamId, OneThingICanNotLive,WhoInspiresYou, YourBucketList, FavoriteWorkProject,
FavoriteMomentsAtBhavna, NativePlace, ExperienceYear, DesignationId, 1, 0, JoiningDate FROM @EmployeeExcel;

SELECT @Response = 1; --Success
return;

END
ELSE
BEGIN
SELECT @Response = 0; --Access Denied Issue 
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured EMAIL ID NULL
				return;
END
END
GO

--------------------------------------------

IF type_id('[dbo].[EmployeeExcel]') IS NULL
/****** Object:  UserDefinedTableType [dbo].[EmployeeExcel]    Script Date: 3/11/2024 2:47:15 PM ******/
CREATE TYPE [dbo].[EmployeeExcel] AS TABLE(
	[EmployeeId] [int] NOT NULL,
	[FirstName] [varchar](100) NOT NULL,
	[MiddleName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[EmailId] [varchar](200) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[AboutYourSelf] [nvarchar](2000) NULL,
	[HobbiesAndInterests] [nvarchar](2000) NULL,
	[FavoriteMomentsAtBhavna] [nvarchar](2000) NULL,
	[FutureAspirations] [nvarchar](2000) NULL,
	[BiographyTitle] [nvarchar](2000) NULL,
	[DefineMyself] [nvarchar](2000) NULL,
	[MyBiggestFlex] [nvarchar](2000) NULL,
	[FavoriteBingsShow] [nvarchar](2000) NULL,
	[MyLifeMantra] [nvarchar](2000) NULL,
	[ProfilePictureUrl] [varchar](500) NULL,
	[TeamId] [int] NULL,
	[OneThingICanNotLive] [nvarchar](2000) NULL,
	[WhoInspiresYou] [nvarchar](2000) NULL,
	[YourBucketList] [nvarchar](2000) NULL,
	[FavoriteWorkProject] [nvarchar](2000) NULL,
	[NativePlace] [varchar](100) NULL,
	[ExperienceYear] [int] NOT NULL,
	[DesignationId] [int] NOT NULL,
	[EmployeeLocation] [varchar](100) NULL,
	[JoiningDate] [datetime] NULL
)
GO

USE [Automation]
GO

-------------------------------------------------------------------------------------------------

IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_SearchEmployees'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_SearchEmployees

GO

CREATE PROCEDURE [dbo].[usp_Eb_SearchEmployees]
	@ProjectId INT = 0,
	@Interests VARCHAR(100) = NULL,
	@SortBy VARCHAR(100) = 'NameAsc',
	@SearchText NVARCHAR(500) = NULL,  
	@Page INT = 1,  
	@PageSize INT = 12
AS         
BEGIN   
	DECLARE @EndIndex INT;
	DECLARE @StartIndex INT;
	DECLARE @TotalPages INT = 0;  
	DECLARE @TotalRecords INT = 0;  
	DECLARE @SQLQuery NVARCHAR(MAX) = '';
	DECLARE @OrderBy VARCHAR(100) = '';
	

	CREATE TABLE #ProjectDat(ProjectId int,ProjectName nvarchar(100));
  
	CREATE TABLE #tmpEmployees(RowNum INT, EmployeeId INT, EmployeeName VARCHAR(300), ProjectName VARCHAR(200), ProfilePictureUrl VARCHAR(200), Designation VARCHAR(100))
	

	IF @SortBy = 'RecentJoining'
	BEGIN
		SET @OrderBy = 'ORDER BY JoiningDate ASC, (FirstName) ASC';
	END
	ELSE IF @SortBy = 'NameDesc'
	BEGIN
		SET @OrderBy = 'ORDER BY (FirstName) DESC ';
	END
	ELSE
	BEGIN
		SET @OrderBy = 'ORDER BY (FirstName) ASC ';
	END
  
	SET @SearchText = CASE WHEN @SearchText IS NULL THEN '' ELSE @SearchText END  
	SET @Interests = CASE WHEN @Interests IS NULL OR @Interests = 'All' THEN '' ELSE @Interests END  
	SET @StartIndex = (@Page - 1) * @PageSize + 1  
	SET @EndIndex = @StartIndex + @PageSize - 1  
  
  
	SET @SQLQuery =   'INSERT INTO  #tmpEmployees  
						SELECT		ROW_NUMBER() OVER ('+@OrderBy+'), EmployeeId, FirstName, ProjectName, ProfilePictureUrl, dsgn.designation
						FROM		EmployeeMaster emp 
						INNER JOIN  EbProjects prj ON emp.ProjectId =  prj.Id
						INNER JOIN  EbDesignation dsgn ON emp.DesignationId =  dsgn.Id
						WHERE		emp.IsActive = 1 and emp.IsDeleted = 0'  
     
	IF @ProjectId > 0  
	BEGIN
		SET @SQLQuery += ' AND prj.Id = @ProjectId '  
	END

	IF @Interests <> ''
	BEGIN
		SET @SQLQuery += ' AND emp.HobbiesAndInterests LIKE ''%'' + @Interests + ''%'' '
	END

	IF @SearchText <> ''
	BEGIN
		SET @SQLQuery += 'AND (  
		emp.FirstName LIKE ''%'' + @SearchText + ''%'' OR  
		prj.ProjectName LIKE ''%'' + @SearchText + ''%''
		)  '
	END

	IF @SQLQuery <> ''  
	BEGIN  
		EXECUTE SP_EXECUTESQL @SQLQuery, N'@ProjectId INT, @SearchText NVARCHAR(500), @Interests VARCHAR(100)', 
		@ProjectId, @SearchText, @Interests
	END   
   
	SELECT  @TotalPages = CEILING(CAST(COUNT(*) AS FLOAT) / CAST(@PageSize AS FLOAT)), @TotalRecords = COUNT(*) FROM #tmpEmployees  
  
	SELECT EmployeeId, EmployeeName, ProfilePictureUrl, Designation FROM #tmpEmployees WHERE RowNum >= @StartIndex  AND  RowNum <= @EndIndex  
  
	SELECT @TotalPages [TotalPages], @TotalRecords [TotalRecords] 
END 
GO




-------------------------------------------------------------------------------------------------

------------------------------------------  VIEW -----------------------------------------
IF exists(select 1 from sys.views where name='vw_Eb_GetEmployeesDetailList' and type='v')
DROP VIEW [dbo].[vw_Eb_GetEmployeesDetailList]
GO

CREATE VIEW [dbo].[vw_Eb_GetEmployeesDetailList] AS
SELECT 
EbDesignation.designation AS Designation, 
EbProjects.ProjectName AS Project,
TeamMaster.TeamName AS Team,
RTRIM(LTRIM(
        CONCAT(
            COALESCE(FirstName + ' ', '')
            , COALESCE(MiddleName + ' ', '')
            , COALESCE(Lastname, '')
        )
    )) AS FullName,
	Em.FirstName,
	Em.LastName,
	em.MiddleName,
Em.EmployeeId,
Em.EmailId,
Em.ProjectId,
Em.AboutYourSelf,
Em.HobbiesAndInterests,
Em.FutureAspirations,
Em.BiographyTitle,
Em.DefineMyself,
Em.MyBiggestFlex,
Em.FavoriteBingsShow,
Em.MyLifeMantra,
Em.ProfilePictureUrl,
Em.IsActive,
Em.CreatedById,
Em.CreatedDate,
EM.UpdatedDate,
Em.UpdatedById,
Em.JoiningDate,
Em.EmployeeLocation,
Em.TeamId,
Em.OneThingICanNotLive,
Em.WhoInspiresYou,
Em.YourBucketList,
Em.FavoriteWorkProject,
Em.FavoriteMomentsAtBhavna,
Em.NativePlace,
Em.ExperienceYear,
Em.DesignationId,
Em.IsDeleted,
Em.isSkillMatrixAllowed,
Em.isEmployeeBookAllowed
from EmployeeMaster AS Em
INNER JOIN EbProjects ON EbProjects.Id = Em.ProjectId
INNER JOIN EbDesignation ON EbDesignation.Id = Em.DesignationId
INNER JOIN TeamMaster ON TeamMaster.Id = Em.TeamId
GO

---------------------------------------------------- VIEW END --------------------------------------------------------------------


IF NOT EXISTS (SELECT * 
  FROM sys.foreign_keys 
   WHERE object_id = OBJECT_ID(N'FK_EmployeeMaster_Team')
   AND parent_object_id = OBJECT_ID(N'dbo.EmployeeMaster')
)
BEGIN
ALTER TABLE [dbo].[EmployeeMaster] ADD CONSTRAINT [FK_EmployeeMaster_Team] FOREIGN KEY([TeamId])
REFERENCES [dbo].[TeamMaster] ([Id])
END





-------------------------------------------------------------------------------------------- 13-03-2024 script ends here



USE [Automation]
GO

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'Team'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[Team] [varchar](100) NULL

GO
-----------------------------------------



IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_SaveEmployeeExcel'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_SaveEmployeeExcel

GO

IF type_id('[dbo].[EmployeeExcel]') IS NOT NULL
BEGIN
/****** Object:  UserDefinedTableType [dbo].[EmployeeExcel]    Script Date: 3/18/2024 8:26:57 PM ******/
DROP TYPE [dbo].[EmployeeExcel]
END
GO

/****** Object:  UserDefinedTableType [dbo].[EmployeeExcel]    Script Date: 3/18/2024 8:26:57 PM ******/
CREATE TYPE [dbo].[EmployeeExcel] AS TABLE(
	[EmployeeId] [int] NOT NULL,
	[FirstName] [varchar](100) NOT NULL,
	[MiddleName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[EmailId] [varchar](200) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[AboutYourSelf] [nvarchar](2000) NULL,
	[HobbiesAndInterests] [nvarchar](2000) NULL,
	[FavoriteMomentsAtBhavna] [nvarchar](2000) NULL,
	[FutureAspirations] [nvarchar](2000) NULL,
	[BiographyTitle] [nvarchar](2000) NULL,
	[DefineMyself] [nvarchar](2000) NULL,
	[MyBiggestFlex] [nvarchar](2000) NULL,
	[FavoriteBingsShow] [nvarchar](2000) NULL,
	[MyLifeMantra] [nvarchar](2000) NULL,
	[ProfilePictureUrl] [varchar](500) NULL,
	[Team] [varchar](100) NULL,
	[OneThingICanNotLive] [nvarchar](2000) NULL,
	[WhoInspiresYou] [nvarchar](2000) NULL,
	[YourBucketList] [nvarchar](2000) NULL,
	[FavoriteWorkProject] [nvarchar](2000) NULL,
	[NativePlace] [varchar](100) NULL,
	[ExperienceYear] [int] NOT NULL,
	[DesignationId] [int] NOT NULL,
	[EmployeeLocation] [varchar](100) NULL,
	[JoiningDate] [datetime] NULL
)
GO

/****** Object:  StoredProcedure [dbo].[usp_Eb_SaveEmployeeExcel]    Script Date: 3/18/2024 8:38:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_Eb_SaveEmployeeExcel]
    @EmployeeExcel EmployeeExcel READONLY,
	@EmailId varchar(200),
	@Response INT OUTPUT
AS
BEGIN

-- CHECK ROLE USING EMAILID
IF @EmailId IS NOT NULL --1

BEGIN
DECLARE @Role VARCHAR(100) = '';


SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId

--FILTER RECORD USING ROLE
IF @Role <> ''
BEGIN
IF (@Role = 'ADMIN') -- ONLY ADMIN CAN SAVE EMPLOYEE RECORDS
BEGIN
-- Insert new role.. 
INSERT INTO EmployeeMaster(EmployeeId,FirstName,MiddleName,LastName, EmailId, ProjectId, AboutYourSelf, 
HobbiesAndInterests, FutureAspirations, BiographyTitle, DefineMyself, MyBiggestFlex, FavoriteBingsShow, MyLifeMantra,
ProfilePictureUrl,EmployeeLocation, Team, OneThingICanNotLive,WhoInspiresYou, YourBucketList, FavoriteWorkProject,
FavoriteMomentsAtBhavna, NativePlace, ExperienceYear, DesignationId, IsActive, IsDeleted, JoiningDate
) SELECT EmployeeId,FirstName,MiddleName,LastName, EmailId, ProjectId, AboutYourSelf, 
HobbiesAndInterests, FutureAspirations, BiographyTitle, DefineMyself, MyBiggestFlex, FavoriteBingsShow, MyLifeMantra,
ProfilePictureUrl,EmployeeLocation, Team, OneThingICanNotLive,WhoInspiresYou, YourBucketList, FavoriteWorkProject,
FavoriteMomentsAtBhavna, NativePlace, ExperienceYear, DesignationId, 1, 0, JoiningDate FROM @EmployeeExcel;

SELECT @Response = 1; --Success
return;

END
ELSE
BEGIN
SELECT @Response = 0; --Access Denied Issue 
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured EMAIL ID NULL
				return;
END
END
GO



-------------------------------------------------------------------------------------- 18-03-2024 scripts ends here






USE [Automation]
GO


IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeMaster]') 
         AND name = 'FullName'
)
ALTER TABLE [dbo].[EmployeeMaster]
ADD 
	[FullName] [varchar](100) NULL

GO

IF exists(select 1 from sys.views where name='vw_Eb_GetEmployeesDetailList' and type='v')
DROP VIEW [dbo].[vw_Eb_GetEmployeesDetailList]
GO

USE [Automation]
GO

/****** Object:  View [dbo].[vw_Eb_GetEmployeesDetailList]    Script Date: 3/19/2024 9:43:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_Eb_GetEmployeesDetailList] AS
SELECT 
EbDesignation.designation AS Designation, 
EbProjects.ProjectName AS Project,
Em.Team AS Team,
Em.FullName,
	Em.FirstName,
	Em.LastName,
	em.MiddleName,
Em.EmployeeId,
Em.EmailId,
Em.ProjectId,
Em.AboutYourSelf,
Em.HobbiesAndInterests,
Em.FutureAspirations,
Em.BiographyTitle,
Em.DefineMyself,
Em.MyBiggestFlex,
Em.FavoriteBingsShow,
Em.MyLifeMantra,
Em.ProfilePictureUrl,
Em.IsActive,
Em.CreatedById,
Em.CreatedDate,
EM.UpdatedDate,
Em.UpdatedById,
Em.JoiningDate,
Em.EmployeeLocation,
Em.TeamId,
Em.OneThingICanNotLive,
Em.WhoInspiresYou,
Em.YourBucketList,
Em.FavoriteWorkProject,
Em.FavoriteMomentsAtBhavna,
Em.NativePlace,
Em.ExperienceYear,
Em.DesignationId,
Em.IsDeleted,
Em.isSkillMatrixAllowed,
Em.isEmployeeBookAllowed
from EmployeeMaster AS Em
INNER JOIN EbProjects ON EbProjects.Id = Em.ProjectId
INNER JOIN EbDesignation ON EbDesignation.Id = Em.DesignationId
GO





IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_EditDeleteEmployee'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_Eb_EditDeleteEmployee

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_Eb_EditDeleteEmployee]
		@EmailId VARCHAR(200) = '',
		@EmployeeId INT = 0,
		@action INT = 0,
		@FullName VARCHAR(100) = NULL,
		@FName VARCHAR(100) = NULL,
		@MName VARCHAR(100) = NULL,
		@LName VARCHAR(100) = NULL,
		@ProjectId INT = NULL,
		@AboutYSelf NVARCHAR(2000) = NULL,
		@HobbiesAndInterest NVARCHAR(2000)= NULL,
		@FutureAspirations NVARCHAR(2000) = NULL,
		@BiographyTitle NVARCHAR(2000) = NULL,
		@DefineMyself NVARCHAR(2000) = NULL,
		@MyBiggestFlex NVARCHAR(2000) = NULL,
		@FavoriteBingsShow NVARCHAR(2000) = NULL,
		@MyLifeMantra NVARCHAR(2000) = NULL,
		@ProfilePictureUrl VARCHAR(200) = NULL,
		@TeamId INT = 0,
		@OneThingICanNotLive NVARCHAR(2000) = NULL,
		@WhoInspiresYou NVARCHAR(2000) = NULL,
		@YourBucketList NVARCHAR(2000) = NULL,
		@FavoriteWorkProject NVARCHAR(2000) = NULL,
		@FavoriteMomentsAtBhavna NVARCHAR(2000) = NULL,
		@NativePlace VARCHAR(100) = NULL,
		@ExperienceYear INT = NULL,
		@DesignationId INT = NULL,
		@UpdatedBy INT = NULL,
		@Response INT OUTPUT
		AS
			BEGIN
			if(@EmployeeId IS NULL OR @action <= 0 OR @EmailId = '')
			BEGIN
				SELECT @Response = 2; --ERROR 
				return;
			END

--ONLY ADMIN CAN EDIT OR DELETE A EMPLOYEE
 DECLARE @Role VARCHAR(100) = '';

SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId

IF @Role <> ''
BEGIN
IF (@Role = 'ADMIN') -- ONLY ADMIN CAN SAVE EMPLOYEE ROLES
BEGIN
IF (@action = 2) --UPDATE EMPLOYEE
BEGIN
UPDATE EmployeeMaster 
SET FullName = @FullName,      
    FirstName = @FName,
	LastName = @LName,
    MiddleName =@MName,
	ProjectId = @ProjectId,
	AboutYourSelf = @AboutYSelf,
    HobbiesAndInterests = @HobbiesAndInterest,
	FutureAspirations = @FutureAspirations,
    BiographyTitle = @BiographyTitle,
	DefineMyself = @DefineMyself,
    MyBiggestFlex = @MyBiggestFlex,
	FavoriteBingsShow = @FavoriteBingsShow,
    MyLifeMantra = @MyLifeMantra,
	ProfilePictureUrl = isNull(@ProfilePictureUrl, ProfilePictureUrl),
	TeamId = @TeamId,
    OneThingICanNotLive = @OneThingICanNotLive,
	WhoInspiresYou = @WhoInspiresYou,
    YourBucketList = @YourBucketList,
	FavoriteWorkProject = @FavoriteWorkProject,
    FavoriteMomentsAtBhavna = @FavoriteMomentsAtBhavna,
	NativePlace = @NativePlace,
	ExperienceYear = isNull(@ExperienceYear, ExperienceYear),
	DesignationId = isNull(@DesignationId, DesignationId),
	UpdatedById = @UpdatedBy,
	UpdatedDate = GETDATE()
WHERE EmployeeId = @EmployeeId;

SELECT @Response = 1; --SuccessFul
				return;

END
ELSE IF (@action = 3) --DELETE EMPLOYEE
BEGIN
		UPDATE EmployeeMaster SET IsDeleted = 1, UpdatedById = @UpdatedBy where EmployeeId  = @EmployeeId;
		SELECT @Response = 1; --SUCCESSFUL
				return;
END 


END
END
ELSE
BEGIN
SELECT @Response = 0; --Access Denied Issue 
				return;
END

END

GO
-------------------------------------------------------------------------------------------------

IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_SearchEmployees'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_Eb_SearchEmployees

GO

/****** Object:  StoredProcedure [dbo].[usp_Eb_SearchEmployees]    Script Date: 3/19/2024 9:59:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_Eb_SearchEmployees]
	@ProjectId INT = 0,
	@Interests VARCHAR(100) = NULL,
	@SortBy VARCHAR(100) = 'NameAsc',
	@SearchText NVARCHAR(500) = NULL,  
	@Page INT = 1,  
	@PageSize INT = 12
AS         
BEGIN   
	DECLARE @EndIndex INT;
	DECLARE @StartIndex INT;
	DECLARE @TotalPages INT = 0;  
	DECLARE @TotalRecords INT = 0;  
	DECLARE @SQLQuery NVARCHAR(MAX) = '';
	DECLARE @OrderBy VARCHAR(100) = '';
	

	CREATE TABLE #ProjectDat(ProjectId int,ProjectName nvarchar(100));
  
	CREATE TABLE #tmpEmployees(RowNum INT, EmployeeId INT, EmployeeName VARCHAR(300), ProjectName VARCHAR(200), ProfilePictureUrl VARCHAR(200), Designation VARCHAR(100))
	

	IF @SortBy = 'RecentJoining'
	BEGIN
		SET @OrderBy = 'ORDER BY JoiningDate ASC, (FullName) ASC';
	END
	ELSE IF @SortBy = 'NameDesc'
	BEGIN
		SET @OrderBy = 'ORDER BY (FullName) DESC ';
	END
	ELSE
	BEGIN
		SET @OrderBy = 'ORDER BY (FullName) ASC ';
	END
  
	SET @SearchText = CASE WHEN @SearchText IS NULL THEN '' ELSE @SearchText END  
	SET @Interests = CASE WHEN @Interests IS NULL OR @Interests = 'All' THEN '' ELSE @Interests END  
	SET @StartIndex = (@Page - 1) * @PageSize + 1  
	SET @EndIndex = @StartIndex + @PageSize - 1  
  
  
	SET @SQLQuery =   'INSERT INTO  #tmpEmployees  
						SELECT		ROW_NUMBER() OVER ('+@OrderBy+'), EmployeeId, FullName, ProjectName, ProfilePictureUrl, dsgn.designation
						FROM		EmployeeMaster emp 
						INNER JOIN  EbProjects prj ON emp.ProjectId =  prj.Id
						INNER JOIN  EbDesignation dsgn ON emp.DesignationId =  dsgn.Id
						WHERE		emp.IsActive = 1 and emp.IsDeleted = 0'  
     
	IF @ProjectId > 0  
	BEGIN
		SET @SQLQuery += ' AND prj.Id = @ProjectId '  
	END

	IF @Interests <> ''
	BEGIN
		SET @SQLQuery += ' AND emp.HobbiesAndInterests LIKE ''%'' + @Interests + ''%'' '
	END

	IF @SearchText <> ''
	BEGIN
		SET @SQLQuery += 'AND (  
		emp.FullName LIKE ''%'' + @SearchText + ''%'' OR  
		prj.ProjectName LIKE ''%'' + @SearchText + ''%''
		)  '
	END

	IF @SQLQuery <> ''  
	BEGIN  
		EXECUTE SP_EXECUTESQL @SQLQuery, N'@ProjectId INT, @SearchText NVARCHAR(500), @Interests VARCHAR(100)', 
		@ProjectId, @SearchText, @Interests
	END   
   
	SELECT  @TotalPages = CEILING(CAST(COUNT(*) AS FLOAT) / CAST(@PageSize AS FLOAT)), @TotalRecords = COUNT(*) FROM #tmpEmployees  
  
	SELECT EmployeeId, EmployeeName, ProfilePictureUrl, Designation FROM #tmpEmployees WHERE RowNum >= @StartIndex  AND  RowNum <= @EndIndex  
  
	SELECT @TotalPages [TotalPages], @TotalRecords [TotalRecords] 
END 
GO


----------------------------------------------------------------------------------------







IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_SaveEmployeeExcel'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_SaveEmployeeExcel

GO

IF type_id('[dbo].[EmployeeExcel]') IS NOT NULL
BEGIN
/****** Object:  UserDefinedTableType [dbo].[EmployeeExcel]    Script Date: 3/18/2024 8:26:57 PM ******/
DROP TYPE [dbo].[EmployeeExcel]
END
GO

/****** Object:  UserDefinedTableType [dbo].[EmployeeExcel]    Script Date: 3/18/2024 8:26:57 PM ******/
CREATE TYPE [dbo].[EmployeeExcel] AS TABLE(
	[EmployeeId] [int] NOT NULL,
	[FullName] [varchar](100) NOT NULL,
	[EmailId] [varchar](200) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[AboutYourSelf] [nvarchar](2000) NULL,
	[HobbiesAndInterests] [nvarchar](2000) NULL,
	[FavoriteMomentsAtBhavna] [nvarchar](2000) NULL,
	[FutureAspirations] [nvarchar](2000) NULL,
	[BiographyTitle] [nvarchar](2000) NULL,
	[DefineMyself] [nvarchar](2000) NULL,
	[MyBiggestFlex] [nvarchar](2000) NULL,
	[FavoriteBingsShow] [nvarchar](2000) NULL,
	[MyLifeMantra] [nvarchar](2000) NULL,
	[ProfilePictureUrl] [varchar](500) NULL,
	[Team] [varchar](100) NULL,
	[OneThingICanNotLive] [nvarchar](2000) NULL,
	[WhoInspiresYou] [nvarchar](2000) NULL,
	[YourBucketList] [nvarchar](2000) NULL,
	[FavoriteWorkProject] [nvarchar](2000) NULL,
	[NativePlace] [varchar](100) NULL,
	[ExperienceYear] [int] NOT NULL,
	[DesignationId] [int] NOT NULL,
	[EmployeeLocation] [varchar](100) NULL,
	[JoiningDate] [datetime] NULL
)
GO

/****** Object:  StoredProcedure [dbo].[usp_Eb_SaveEmployeeExcel]    Script Date: 3/18/2024 8:38:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_Eb_SaveEmployeeExcel]
    @EmployeeExcel EmployeeExcel READONLY,
	@EmailId varchar(200),
	@Response INT OUTPUT
AS
BEGIN

-- CHECK ROLE USING EMAILID
IF @EmailId IS NOT NULL --1

BEGIN
DECLARE @Role VARCHAR(100) = '';


SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId

--FILTER RECORD USING ROLE
IF @Role <> ''
BEGIN
IF (@Role = 'ADMIN') -- ONLY ADMIN CAN SAVE EMPLOYEE RECORDS
BEGIN
-- Insert new role.. 
INSERT INTO EmployeeMaster(EmployeeId,FullName, EmailId, ProjectId, AboutYourSelf, 
HobbiesAndInterests, FutureAspirations, BiographyTitle, DefineMyself, MyBiggestFlex, FavoriteBingsShow, MyLifeMantra,
ProfilePictureUrl,EmployeeLocation, Team, OneThingICanNotLive,WhoInspiresYou, YourBucketList, FavoriteWorkProject,
FavoriteMomentsAtBhavna, NativePlace, ExperienceYear, DesignationId, IsActive, IsDeleted, JoiningDate
) SELECT EmployeeId,FullName, EmailId, ProjectId, AboutYourSelf, 
HobbiesAndInterests, FutureAspirations, BiographyTitle, DefineMyself, MyBiggestFlex, FavoriteBingsShow, MyLifeMantra,
ProfilePictureUrl,EmployeeLocation, Team, OneThingICanNotLive,WhoInspiresYou, YourBucketList, FavoriteWorkProject,
FavoriteMomentsAtBhavna, NativePlace, ExperienceYear, DesignationId, 1, 0, JoiningDate FROM @EmployeeExcel;

SELECT @Response = 1; --Success
return;

END
ELSE
BEGIN
SELECT @Response = 0; --Access Denied Issue 
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured
				return;
END

END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured EMAIL ID NULL
				return;
END
END
GO


------------------------------------------------------------------- 19-03-2024 scripts end here ------------------------














































IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'EmployeeRoleProjects')
BEGIN
CREATE TABLE [dbo].[EmployeeRoleProjects](
	Id INT IDENTITY(1,1) NOT NULL, 
	EmployeeRoleId INT NOT NULL,
	ProjectId INT NOT NULL,
	CreateDate DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT UC_EmployeeRoleId UNIQUE (EmployeeRoleId),
	CONSTRAINT PK_EmployeeRoleProjects PRIMARY KEY (Id)
)
END

GO

IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_GetProjectsByRole'
            AND type = 'P'
      )
DROP PROCEDURE dbo.usp_Eb_GetProjectsByRole

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_Eb_GetProjectsByRole]
	@EmailId VARCHAR(200)
AS  
BEGIN


-- CHECK ROLE USING EMAILID
 IF @EmailId IS NOT NULL
 BEGIN
  DECLARE @Role VARCHAR(100) = '';
  DECLARE @RoleId INT = 0;
  DECLARE @EmployeeRoleId INT = 0;
  DECLARE @EmployeeId INT = 0;
  DECLARE @RoleBasedProjectList TABLE (Id int);

SELECT TOP(1) @Role=Roles.RoleName,@EmployeeId = EmployeeMaster.EmployeeId, @EmployeeRoleId = EmployeeRoles.EmployeeRoleId, @RoleId = EmployeeRoles.RoleId FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId


--FILTER RECORD USING ROLE
IF @Role <> '' AND @EmployeeId > 0
BEGIN
SELECT @EmployeeRoleId = EmployeeRoleId,@RoleId = RoleId FROM EmployeeRoles WHERE EmployeeId = @EmployeeId;
END

IF @RoleId > 0 AND @EmployeeRoleId > 0 AND (SELECT COUNT(*) FROM EmployeeRoleProjects where EmployeeRoleId = @EmployeeRoleId) > 0
BEGIN

INSERT INTO @RoleBasedProjectList SELECT ProjectId FROM EmployeeRoleProjects where EmployeeRoleId = @EmployeeRoleId;
SELECT DISTINCT rbp.Id AS Id, ProjectName FROM @RoleBasedProjectList rbp INNER JOIN EbProjects pr on rbp.Id=pr.Id;
END
ELSE
BEGIN
SELECT Id, ProjectName from EbProjects;
END
END
END
GO

IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_SearchEmployees'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_SearchEmployees

GO

CREATE PROCEDURE [dbo].[usp_Eb_SearchEmployees]
	@ProjectId INT = 0,
	@Interests VARCHAR(100) = NULL,
	@SortBy VARCHAR(100) = 'NameAsc',
	@SearchText NVARCHAR(500) = NULL,  
	@Page INT = 1,  
	@PageSize INT = 6,
	@EmailId VARCHAR(200) = ''
AS         
BEGIN   
	DECLARE @EndIndex INT;
	DECLARE @StartIndex INT;
	DECLARE @TotalPages INT = 0;  
	DECLARE @TotalRecords INT = 0;  
	DECLARE @SQLQuery NVARCHAR(MAX) = '';
	DECLARE @OrderBy VARCHAR(100) = '';
	
	
		-- ADDED FOR EMPLOYEE ROLE PROJECT BASED
	DECLARE @Role VARCHAR(100) = '';
	DECLARE @RoleId INT = 0;
	DECLARE @EmployeeRoleId INT = 0;
	DECLARE @EmployeeId INT = 0;
	DECLARE @RoleBasedProjectList TABLE (Id int);
	-- END ADDED FOR EMPLOYEE ROLE PROJECT BASED
	

	CREATE TABLE #ProjectDat(ProjectId int,ProjectName nvarchar(100));
  
	CREATE TABLE #tmpEmployees(RowNum INT, EmployeeId INT, EmployeeName VARCHAR(300), ProjectName VARCHAR(200), ProfilePictureUrl VARCHAR(200), Designation VARCHAR(100))
	

	IF @SortBy = 'RecentJoining'
	BEGIN
		SET @OrderBy = 'ORDER BY JoiningDate ASC, (FullName) ASC';
	END
	ELSE IF @SortBy = 'NameDesc'
	BEGIN
		SET @OrderBy = 'ORDER BY (FullName) DESC ';
	END
	ELSE
	BEGIN
		SET @OrderBy = 'ORDER BY (FullName) ASC ';
	END
  
	SET @SearchText = CASE WHEN @SearchText IS NULL THEN '' ELSE @SearchText END  
	SET @Interests = CASE WHEN @Interests IS NULL OR @Interests = 'All' THEN '' ELSE @Interests END  
	SET @StartIndex = (@Page - 1) * @PageSize + 1  
	SET @EndIndex = @StartIndex + @PageSize - 1  
  
  
	SET @SQLQuery =   'INSERT INTO  #tmpEmployees  
						SELECT		ROW_NUMBER() OVER ('+@OrderBy+'), EmployeeId, FullName, ProjectName, ProfilePictureUrl, dsgn.designation
						FROM		EmployeeMaster emp 
						LEFT OUTER JOIN  EbProjects prj ON emp.ProjectId =  prj.Id
						LEFT OUTER JOIN  EbDesignation dsgn ON emp.DesignationId =  dsgn.Id
						WHERE		emp.IsActive = 1 and emp.IsDeleted = 0'  
     
	IF @ProjectId > 0  
	BEGIN
		SET @SQLQuery += ' AND prj.Id = @ProjectId '  
	END
	ELSE
	BEGIN
	IF @EmailId <> ''
	BEGIN
	SELECT TOP(1) @Role=Roles.RoleName,@EmployeeId = EmployeeMaster.EmployeeId, @EmployeeRoleId = EmployeeRoles.EmployeeRoleId, @RoleId = EmployeeRoles.RoleId FROM EmployeeMaster 
	INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
	INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
	WHERE EmployeeMaster.EmailId =  @EmailId

	IF @Role <> '' AND @EmployeeId > 0
	BEGIN
		SELECT TOP(1) @EmployeeRoleId = EmployeeRoleId,@RoleId = RoleId FROM EmployeeRoles WHERE EmployeeId = @EmployeeId;
	END
	IF @EmployeeRoleId > 0 
	BEGIN
		SELECT TOP(1) @ProjectId = ProjectId FROM EmployeeRoleProjects WHERE EmployeeRoleId = @EmployeeRoleId;

		IF @ProjectId > 0 
		BEGIN
		SET @SQLQuery += ' AND prj.Id = @ProjectId '  
		END
	END
	END
	END

	IF @Interests <> ''
	BEGIN
		SET @SQLQuery += ' AND emp.HobbiesAndInterests LIKE ''%'' + @Interests + ''%'' '
	END

	IF @SearchText <> ''
	BEGIN
		SET @SQLQuery += 'AND (  
		emp.FullName LIKE ''%'' + @SearchText + ''%'' OR  
		prj.ProjectName LIKE ''%'' + @SearchText + ''%''
		)  '
	END

	IF @SQLQuery <> ''  
	BEGIN  
		EXECUTE SP_EXECUTESQL @SQLQuery, N'@ProjectId INT, @SearchText NVARCHAR(500), @Interests VARCHAR(100)', 
		@ProjectId, @SearchText, @Interests
	END   
   
	SELECT  @TotalPages = CEILING(CAST(COUNT(*) AS FLOAT) / CAST(@PageSize AS FLOAT)), @TotalRecords = COUNT(*) FROM #tmpEmployees  
  
	SELECT EmployeeId, EmployeeName, ProfilePictureUrl, Designation FROM #tmpEmployees WHERE RowNum >= @StartIndex  AND  RowNum <= @EndIndex  
  
	SELECT @TotalPages [TotalPages], @TotalRecords [TotalRecords] 
END 
GO

