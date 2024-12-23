-- =============================================
-- Author:	<Chetna Upadhyay>
-- Create date: <7/4/2024>
-- Description:	<Get Employee Detail List View>
-- =============================================

CREATE OR ALTER VIEW [dbo].[vw_Eb_GetEmployeesDetailList] AS
WITH LatestEmployeeDetails As (
SELECT
		EmployeeId,
		TeamId,
		ROW_NUMBER() OVER (PARTITION BY EmployeeId Order By EmployeeId DESC) As RowNum
		From EmployeeDetails
		)
SELECT 
EbDesignation.designation AS Designation, 
EbProjects.ProjectName AS Project,
TeamMaster.TeamName AS Team,
Em.FullName FullName,
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
LEFT JOIN (SELECT EmployeeId, TeamId FROM LatestEmployeeDetails Where RowNum = 1) AS Led ON Em.EmployeeId = Led.EmployeeId
LEFT JOIN EbProjects ON EbProjects.Id = Em.ProjectId
LEFT JOIN EbDesignation ON EbDesignation.Id = Em.DesignationId
LEFT JOIN TeamMaster ON TeamMaster.Id =Led.TeamId
GO

------------------------------------------------------------------
-- =============================================
-- Author:	<Chetna Upadhyay>
-- Create date: <7/4/2024>
-- Description:	<Search Employees>
-- =============================================
GO
ALTER PROCEDURE [dbo].[usp_Eb_SearchEmployees1] --0,'All','NameAsc','', 1,6,'akash.maurya@bhavnacorp.com'
    @ProjectId INT = 0,
    @Interests VARCHAR(100) = NULL,
    @SortBy VARCHAR(100) = 'NameAsc',
    @SearchText NVARCHAR(500) = NULL,
    @Page INT = 1,
    @PageSize INT = 6,
    @EmailId VARCHAR(200) = ''
AS
BEGIN
    --set @PageSize=1200
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
    DECLARE @EmployeeId VARCHAR(100) = '';
    DECLARE @RoleBasedProjectList TABLE (Id INT);
    -- END ADDED FOR EMPLOYEE ROLE PROJECT BASED
 
    CREATE TABLE #ProjectDat(ProjectId INT, ProjectName NVARCHAR(100));
    CREATE TABLE #tmpEmployees(
        RowNum INT,
        EmployeeId VARCHAR(100),
        EmployeeName VARCHAR(300),
        ProjectName VARCHAR(200),
        ProfilePictureUrl VARCHAR(200),
        Designation VARCHAR(100),
        ProjectId INT,
        Interest VARCHAR(200)
    );
 
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
 
    SET @SearchText = CASE WHEN @SearchText IS NULL THEN '' ELSE @SearchText END;
    SET @Interests = CASE WHEN @Interests IS NULL OR @Interests = 'All' THEN '' ELSE @Interests END;
    SET @StartIndex = (@Page - 1) * @PageSize + 1;
    SET @EndIndex = @StartIndex + @PageSize - 1;
 
    SET @SQLQuery = 'INSERT INTO #tmpEmployees
                     SELECT ROW_NUMBER() OVER (' + @OrderBy + '), EmployeeId, FullName, ProjectName, ProfilePictureUrl, dsgn.designation, ProjectId, HobbiesAndInterests
                     FROM EmployeeMaster emp
                     LEFT OUTER JOIN EbProjects prj ON emp.ProjectId = prj.Id
                     LEFT OUTER JOIN EbDesignation dsgn ON emp.DesignationId = dsgn.Id
                     WHERE emp.IsActive = 1 AND emp.IsDeleted = 0';
 
    IF @ProjectId > 0
    BEGIN
        SET @SQLQuery += ' AND prj.Id = @ProjectId ';
    END
    ELSE
    BEGIN
        IF @EmailId <> ''
        BEGIN
            SELECT TOP(1)
                @Role = Roles.RoleName,
                @EmployeeId = EmployeeMaster.EmployeeId,
                @EmployeeRoleId = EmployeeRoles.EmployeeRoleId,
                @RoleId = EmployeeRoles.RoleId
            FROM EmployeeMaster
            INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
            INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
            WHERE EmployeeMaster.EmailId = @EmailId;
 
            IF @Role <> '' AND @EmployeeId <> ''
            BEGIN
                SELECT TOP(1)
                    @EmployeeRoleId = EmployeeRoleId,
                    @RoleId = RoleId
                FROM EmployeeRoles
                WHERE EmployeeId = @EmployeeId;
            END
 
            IF @EmployeeRoleId > 0
            BEGIN
                SELECT TOP(1) @ProjectId = ProjectId
                FROM EmployeeRoleProjects
                WHERE EmployeeRoleId = @EmployeeRoleId;
 
                IF @ProjectId > 0
                BEGIN
                    SET @SQLQuery += ' AND prj.Id = @ProjectId ';
                END
            END
        END
    END
 
    IF @Interests <> ''
    BEGIN
        SET @SQLQuery += ' AND emp.HobbiesAndInterests LIKE ''%'' + @Interests + ''%'' ';
    END
 
    IF @SearchText <> ''
    BEGIN
        SET @SQLQuery += ' AND (
                           emp.FullName LIKE ''%'' + @SearchText + ''%'' OR
                           prj.ProjectName LIKE ''%'' + @SearchText + ''%''
                          ) ';
    END
 
    IF @SQLQuery <> ''
    BEGIN
        EXECUTE SP_EXECUTESQL @SQLQuery,
                              N'@ProjectId INT, @SearchText NVARCHAR(500), @Interests VARCHAR(100)',
                              @ProjectId, @SearchText, @Interests;
    END
 
    SELECT
        @TotalPages = CEILING(CAST(COUNT(*) AS FLOAT) / CAST(@PageSize AS FLOAT)),
        @TotalRecords = COUNT(*)
    FROM #tmpEmployees;
 
    SELECT
        RowNum,
        FullName AS EmployeeName,
        Interest,
        vwEmp.*
    FROM #tmpEmployees tmp
    JOIN vw_Eb_GetEmployeesDetailList vwEmp ON tmp.EmployeeId = vwEmp.EmployeeId
    WHERE vwEmp.IsDeleted = 0 AND vwEmp.IsActive = 1;
 
    SELECT
        @TotalPages [TotalPages],
        @TotalRecords [TotalRecords];
END

------------------------------------------------------------------
-- =============================================
-- Author:	<Chetna Upadhyay>
-- Create date: <7/4/2024>
-- Description:	<Edit Delete Employees>
-- =============================================
/****** Object:  StoredProcedure [dbo].[usp_Eb_EditDeleteEmployee]    Script Date: 7/4/2024 1:02:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_Eb_EditDeleteEmployee]
		@EmailId VARCHAR(200) = '',
		@EmployeeId VARCHAR(200) = '',
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
			if(@EmployeeId='' OR @action <= 0 OR @EmailId = '')
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
IF (@Role = 'ADMIN' OR @Role = 'HR') -- ONLY ADMIN CAN SAVE EMPLOYEE ROLES
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
	Team = @TeamId,
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
	--update employeemaster and set deleted
		UPDATE EmployeeMaster SET IsDeleted = 1, UpdatedById = @UpdatedBy where EmployeeId  = @EmployeeId;

		-- Removed all roles assigned to it
		DELETE FROM EmployeeRoles where EmployeeId =  @EmployeeId;

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
------------------------------------------------------------------
-- =============================================
-- Author:	<Chetna Upadhyay>
-- Create date: <7/4/2024>
-- Description:	<Alter Logger Table>
-- =============================================
ALTER TABLE Logger 
ADD LogFrom VARCHAR(50)

------------------------------------------------------------------
-- =============================================
-- Author:	<Chetna Upadhyay>
-- Create date: <7/4/2024>
-- Description:	<Save Employee Role>
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_Eb_SaveEmployeeRole]
	@EmailId VARCHAR(200),
	@RoleId INT,
	@EmployeeId VARCHAR(200),
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
IF @Role <> '' AND @EmployeeId <> ''
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

------------------------------------------------------------------
-- =============================================
-- Author:	<Chetna Upadhyay>
-- Create date: <7/4/2024>
-- Description:	<Inserting HR Role>
-- =============================================
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'HR')
BEGIN
INSERT INTO [dbo].[Roles]
           ([RoleName]
           ,[CreatedDate]
           ,[UpdatedDate]
           ,[IsActive])
     VALUES
           ('HR',GETDATE(),GETDATE(),1)
END
GO

------------------------------------------------------------------
-- =============================================
-- Author:	<Chetna Upadhyay>
-- Create date: <7/4/2024>
-- Description:	<Get Daily Employee Login Chart SP>
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[usp_Eb_GetChartRecord]
@FilterBy VARCHAR(200),
@StartDate DATETIME NULL,
@EndDate DATETIME NULL
AS  
BEGIN

IF @StartDate IS NULL
SET @StartDate = CONVERT(DATETIME, DATEADD(MONTH, -1, CONVERT(DATE, GETDATE())))

IF @EndDate IS NULL
SET @EndDate = GETDATE();

IF @FilterBy = 'MONTHLY'
BEGIN
SELECT COUNT(*) AS LoginCount, DATENAME(MONTH, DATEADD(MONTH, 0, CreatedDate))  AS Label from Logger
WHERE LogFrom = 'EmployeeBook' AND Description Like '%logged in to the Employeebook.%' AND CAST(CreatedDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
GROUP BY DATENAME(MONTH, DATEADD(MONTH, 0, CreatedDate));
END
ELSE IF  @FilterBy = 'WEEKLY'
BEGIN
SELECT COUNT(*) AS LoginCount, DATEPART(WEEK, CAST(CreatedDate AS DATE)) AS Label from Logger
WHERE LogFrom = 'EmployeeBook' AND Description Like '%logged in to the Employeebook.%' AND CAST(CreatedDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
GROUP BY DATEPART(WEEK, CAST(CreatedDate AS DATE));
END
ELSE
BEGIN
SELECT COUNT(*) AS LoginCount, CAST(CreatedDate AS DATE) AS Label from Logger
WHERE LogFrom = 'EmployeeBook' AND Description Like '%logged in to the Employeebook.%' AND CAST(CreatedDate AS DATE) BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
GROUP BY CAST(CreatedDate AS DATE);
END

SELECT COUNT(*) AS ActiveEmployeeCount FROM EmployeeMaster WHERE IsActive =1 and IsDeleted = 0 and IsEmployeeBookAllowed = 1;
SELECT COUNT(*) AS DailyEmployeeLoginCount FROM Logger where LogFrom = 'EmployeeBook' AND Description Like '%logged in to the Employeebook.%' AND CAST(CreatedDate as Date) = CAST(GETDATE() as Date);

END


------------------------------------------------------------------
-- =============================================
-- Author:	<Chetna Upadhyay>
-- Create date: <7/4/2024>
-- Description:	<Share Idea Table, SP and View>
-- =============================================
/****** Object:  Table [dbo].[ShareIdeaCategory]    Script Date: 7/4/2024 4:58:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'ShareIdeaCategory')
BEGIN
CREATE TABLE dbo.ShareIdeaCategory
(
Id INT NOT NULL Identity(1,1) CONSTRAINT pk_ShareIdeaCategory_Id PRIMARY KEY,
Category VARCHAR(100) NOT NULL,
CreatedDate DATETIME NOT NULL CONSTRAINT default_ShareIdeaCategory_CreatedDate DEFAULT GETDATE(),
UpdatedDate DATETIME NULL,
CreatedById VARCHAR(100) NULL,
UpdatedById VARCHAR(100) NULL,
IsActive INT NOT NULL CONSTRAINT default_ShareIdeaCategory_IsActive DEFAULT 1,
)
END
GO

/****** Object:  Table [dbo].[ShareIdeaQuestions]    Script Date: 7/4/2024 4:58:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'ShareIdeaQuestions')
BEGIN
CREATE TABLE [dbo].[ShareIdeaQuestions]
(
Id INT NOT NULL Identity(1,1) CONSTRAINT pk_ShareIdeaQuestions_Id PRIMARY KEY,
Question VARCHAR(500) NOT NULL,
CreatedDate datetime NOT NULL CONSTRAINT default_ShareIdeaQuestions_CreatedDate DEFAULT GETDATE(),
UpdatedDate datetime NULL,
IsActive int NOT NULL CONSTRAINT default_ShareIdeaQuestions_IsActive DEFAULT 1
)
END
GO

/****** Object:  Table [dbo].[ShareIdeaAnswer]    Script Date: 7/4/2024 4:58:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'ShareIdeaAnswer')
BEGIN
CREATE TABLE [dbo].[ShareIdeaAnswer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[QuestionId] [int] NOT NULL,
	[EmployeeId] [varchar](100) NOT NULL,
	[Answer] [varchar](5000) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[IsActive] [int] NOT NULL,
	[CategoryId] [int] NULL,
	[ShareIdeaId] [uniqueidentifier] NULL,
CONSTRAINT [pk_ShareIdeaAnswer_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
 
ALTER TABLE [dbo].[ShareIdeaAnswer] ADD  CONSTRAINT [default_ShareIdeaAnswer_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
 
ALTER TABLE [dbo].[ShareIdeaAnswer] ADD  CONSTRAINT [default_ShareIdeaAnswer_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
 
ALTER TABLE [dbo].[ShareIdeaAnswer]  WITH CHECK ADD  CONSTRAINT [fk_ShareIdeaAnswer_ShareIdeaQuestions_QuestionId] FOREIGN KEY([QuestionId])
REFERENCES [dbo].[ShareIdeaQuestions] ([Id])
GO
 
ALTER TABLE [dbo].[ShareIdeaAnswer] CHECK CONSTRAINT [fk_ShareIdeaAnswer_ShareIdeaQuestions_QuestionId]
GO

/****** Object:  View [dbo].[vw_GetEmployeeShareIdea]    Script Date: 7/4/2024 4:58:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF exists(select 1 from sys.views where name='vw_GetEmployeeShareIdea' and type='v')
DROP VIEW [dbo].[vw_GetEmployeeShareIdea]
GO
CREATE OR ALTER  VIEW [dbo].[vw_GetEmployeeShareIdea] AS
SELECT shareQ.Id AS QuestionId, 
shareA.Id AS ShareIdeaAnswerId,
shareA.Answer,
Em.EmployeeId,
Em.EmailId,
Em.FullName,
category.Id AS CategoryId,
category.Category,
Question FROM ShareIdeaQuestions AS shareQ
INNER JOIN ShareIdeaAnswer AS shareA ON shareQ.Id = shareA.QuestionId
INNER JOIN ShareIdeaCategory AS category ON shareA.CategoryId = category.Id
INNER JOIN EmployeeMaster AS Em ON shareA.EmployeeId = Em.EmployeeId
GO
/****** Object:  View [dbo].[vw_GetShareIdeaCategoryWithCounts]    Script Date: 7/4/2024 4:58:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER  VIEW [dbo].[vw_GetShareIdeaCategoryWithCounts] AS
with cte as  
   (  
     SELECT CategoryId, ShareIdeaId AS QuestionsCount
  FROM [dbo].[ShareIdeaAnswer] GROUP BY CategoryId, ShareIdeaId
    )  
 
SELECT CategoryId, (SELECT Category FROM ShareIdeaCategory WHERE Id = CategoryId) AS Category, COUNT(CategoryId) AS IdeaCounts FROM cte GROUP BY CategoryId;

GO
/****** Object:  View [dbo].[vw_GetShareIdeaEmployeeRecords]    Script Date: 7/4/2024 4:58:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER  VIEW [dbo].[vw_GetShareIdeaEmployeeRecords]
AS
SELECT shidea.*,siq.Question, em.FullName, em.EmailId, sic.Category from [dbo].[ShareIdeaAnswer] shidea
JOIN EmployeeMaster em on em.EmployeeId = shidea.EmployeeId
JOIN ShareIdeaCategory sic on sic.Id = shidea.CategoryId
JOIN ShareIdeaQuestions siq on siq.Id = shidea.QuestionId
GO
SET IDENTITY_INSERT [dbo].[ShareIdeaAnswer] OFF
SET IDENTITY_INSERT [dbo].[ShareIdeaCategory] ON
IF NOT EXISTS (SELECT 1 FROM [dbo].[ShareIdeaCategory] WHERE [Id] = 1)
INSERT [dbo].[ShareIdeaCategory] ([Id], [Category], [CreatedDate], [UpdatedDate], [IsActive]) VALUES (1, N'Engineering', CAST(N'2024-04-30T13:45:06.257' AS DateTime), NULL, 1)
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[ShareIdeaCategory] WHERE [Id] = 2)
INSERT [dbo].[ShareIdeaCategory] ([Id], [Category], [CreatedDate], [UpdatedDate], [IsActive]) VALUES (2, N'Product', CAST(N'2024-04-30T13:45:12.943' AS DateTime), NULL, 1)
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[ShareIdeaCategory] WHERE [Id] = 3)
INSERT [dbo].[ShareIdeaCategory] ([Id], [Category], [CreatedDate], [UpdatedDate], [IsActive]) VALUES (3, N'Sales', CAST(N'2024-04-30T13:45:21.450' AS DateTime), NULL, 1)
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[ShareIdeaCategory] WHERE [Id] = 4)
INSERT [dbo].[ShareIdeaCategory] ([Id], [Category], [CreatedDate], [UpdatedDate], [IsActive]) VALUES (4, N'Marketing', CAST(N'2024-04-30T13:45:29.307' AS DateTime), NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[ShareIdeaCategory] OFF
SET IDENTITY_INSERT [dbo].[ShareIdeaQuestions] ON
IF NOT EXISTS (SELECT 1 FROM [dbo].[ShareIdeaQuestions] WHERE [Id] = 1)
INSERT [dbo].[ShareIdeaQuestions] ([Id], [Question], [CreatedDate], [UpdatedDate], [IsActive]) VALUES (1, N'What innovative idea do you have to help the organization?', CAST(N'2024-05-07T12:58:58.943' AS DateTime), NULL, 1)
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[ShareIdeaQuestions] WHERE [Id] = 2)
INSERT [dbo].[ShareIdeaQuestions] ([Id], [Question], [CreatedDate], [UpdatedDate], [IsActive]) VALUES (2, N'Can you explain how this idea would benefit our organization?', CAST(N'2024-05-07T13:02:31.747' AS DateTime), NULL, 1)
GO
IF NOT EXISTS (SELECT 1 FROM [dbo].[ShareIdeaQuestions] WHERE [Id] = 3)
INSERT [dbo].[ShareIdeaQuestions] ([Id], [Question], [CreatedDate], [UpdatedDate], [IsActive]) VALUES (5, N'How your idea create value to the company?', CAST(N'2024-05-08T10:23:53.010' AS DateTime), NULL, 1)
GO


/****** Object:  UserDefinedTableType [dbo].[QuestionsAnswer]    Script Date: 7/4/2024 5:16:06 PM ******/
CREATE TYPE [dbo].[QuestionsAnswer] AS TABLE(
	[QuestionId] [int] NOT NULL,
	[Answer] [varchar](500) NOT NULL
)
GO

/****** Object:  UserDefinedTableType [dbo].[QuestionsAnswerCategory]    Script Date: 7/4/2024 5:17:40 PM ******/
CREATE TYPE [dbo].[QuestionsAnswerCategory] AS TABLE(
	[CategoryId] [int] NOT NULL
)
GO

/****** Object:  StoredProcedure [dbo].[usp_Crud_SharedIdea]    Script Date: 7/4/2024 5:14:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_Crud_SharedIdea]
@EmailId VARCHAR(200) = '',
@Action INT = 0,
@QuestionAnswer QuestionsAnswer READONLY,
@CategoryId INT = 0
AS
BEGIN
IF @EmailId IS NOT NULL --1
BEGIN
DECLARE @EmployeeId VARCHAR(200) = '';
DECLARE @ShareIdeaId uniqueidentifier = NULL;
SELECT @EmployeeId = EmployeeId from EmployeeMaster where EmailId = @EmailId;
IF (@Action = 1 AND @EmployeeId <> '' AND @CategoryId > 0 ) -- INSERT RECORD
BEGIN
SET @ShareIdeaId = NEWID();
INSERT INTO ShareIdeaAnswer(QuestionId, EmployeeId, Answer, CategoryId, ShareIdeaId)
SELECT QuestionId, @EmployeeId, Answer, @CategoryId, @ShareIdeaId FROM @QuestionAnswer;
END
ELSE IF (@Action = 2) -- GET RECORDS
BEGIN
SELECT * FROM vw_GetEmployeeShareIdea;
END
END
END
GO


------------------------------------------------------------------
-- =============================================
-- Author:	<Chetna Upadhyay>
-- Create date: <7/4/2024>
-- Description:	<Create Employee Master Update Table>
-- =============================================
CREATE TABLE [dbo].[EmployeeMasterUpdate](
	[EmployeeId] [varchar](100) NOT NULL,
	[EmailId] [varchar](200) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[IsApproved] [bit] NULL,
	[FirstName] [varchar](100) NOT NULL,
	[MiddleName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[ProjectId] [int] NULL,
	[AboutYourSelf] [nvarchar](2000) NULL,
	[HobbiesAndInterests] [nvarchar](2000) NULL,
	[FutureAspirations] [nvarchar](2000) NULL,
	[BiographyTitle] [nvarchar](2000) NULL,
	[DefineMyself] [nvarchar](2000) NULL,
	[MyBiggestFlex] [nvarchar](2000) NULL,
	[FavoriteBingsShow] [nvarchar](2000) NULL,
	[MyLifeMantra] [nvarchar](2000) NULL,
	[ProfilePictureUrl] [varchar](500) NULL,
	[JoiningDate] [datetime] NULL,
	[EmployeeLocation] [varchar](100) NULL,
	[OneThingICanNotLive] [nvarchar](2000) NULL,
	[WhoInspiresYou] [nvarchar](2000) NULL,
	[YourBucketList] [nvarchar](2000) NULL,
	[FavoriteWorkProject] [nvarchar](2000) NULL,
	[FavoriteMomentsAtBhavna] [nvarchar](2000) NULL,
	[NativePlace] [varchar](100) NULL,
	[ExperienceYear] [decimal](3, 1) NULL,
	[DesignationId] [int] NULL,
	[Team] [varchar](100) NULL,
	[FullName] [varchar](100) NULL,
CONSTRAINT [PK__EmployeeMasterUpdate__EmployeeId] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[EmailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
 
ALTER TABLE [dbo].[EmployeeMasterUpdate] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
 
ALTER TABLE [dbo].[EmployeeMasterUpdate] ADD  DEFAULT (' ') FOR [FirstName]
GO
 
ALTER TABLE [dbo].[EmployeeMasterUpdate] ADD  DEFAULT ((1)) FOR [ProjectId]
GO
 
ALTER TABLE [dbo].[EmployeeMasterUpdate] ADD  DEFAULT (getdate()) FOR [JoiningDate]
GO
 
ALTER TABLE [dbo].[EmployeeMasterUpdate] ADD  DEFAULT ((1)) FOR [TeamId]
GO
 
ALTER TABLE [dbo].[EmployeeMasterUpdate] ADD  DEFAULT ((1)) FOR [DesignationId]
GO


------------------------------------------------------------------
-- =============================================
-- Author:	<Chetna Upadhyay>
-- Create date: <7/4/2024>
-- Description:	<Update Employee Sps>
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[usp_Eb_AddEmployeeMasterUpdate] (
  @EmailId nvarchar(max),
  @EmployeeId nvarchar(max),
  @FullName nvarchar(max),
  @FirstName nvarchar(max),
  @MiddleName nvarchar(max),
  @LastName nvarchar(max),
  @ProjectId int,
  @AboutYourSelf nvarchar(max),
  @HobbiesAndInterests nvarchar(max),
  @FutureAspirations nvarchar(max),
  @BiographyTitle nvarchar(max),
  @DefineMyself nvarchar(max),
  @MyBiggestFlex nvarchar(max),
  @FavoriteBingsShow nvarchar(max),
  @MyLifeMantra nvarchar(max),
  @OneThingICanNotLive nvarchar(max),
  @WhoInspiresYou nvarchar(max),
  @YourBucketList nvarchar(max),
  @FavoriteWorkProject nvarchar(max),
  @FavoriteMomentsAtBhavna nvarchar(max),
  @NativePlace nvarchar(max),
  @ExperienceYear int,
  @DesignationId int,
  @Team nvarchar(max),
  @ProfilePictureUrl nvarchar(max),
  @EmployeeLocation nvarchar(max)
)
AS
BEGIN
  -- Check if employee with the same EmailId exists (assuming EmailId is unique)
  DECLARE @EmployeeExists bit;

  -- Check if employee exists
  SELECT @EmployeeExists = CASE WHEN EXISTS (
    SELECT 1
    FROM EmployeeMasterUpdate
    WHERE EmployeeId = @EmployeeId
  ) THEN 1 ELSE 0
  END
IF @EmployeeExists = 0
  BEGIN
    -- Insert new employee record
    INSERT INTO EmployeeMasterUpdate (
      EmailId,
	  EmployeeId,
      FullName,
      FirstName,
      MiddleName,
      LastName,
      ProjectId,
      AboutYourSelf,
      HobbiesAndInterests,
      FutureAspirations,
      BiographyTitle,
      DefineMyself,
      MyBiggestFlex,
      FavoriteBingsShow,
      MyLifeMantra,
      OneThingICanNotLive,
      WhoInspiresYou,
      YourBucketList,
      FavoriteWorkProject,
      FavoriteMomentsAtBhavna,
      NativePlace,
      ExperienceYear,
      DesignationId,
	  UpdatedDate,
	  Team,
	  ProfilePictureUrl,
	  EmployeeLocation
    )
    VALUES (
      @EmailId,
	  @EmployeeId,
      @FullName,
      @FirstName,
      @MiddleName,
      @LastName,
      @ProjectId,
      @AboutYourSelf,
      @HobbiesAndInterests,
      @FutureAspirations,
      @BiographyTitle,
      @DefineMyself,
      @MyBiggestFlex,
      @FavoriteBingsShow,
      @MyLifeMantra,
      @OneThingICanNotLive,
      @WhoInspiresYou,
      @YourBucketList,
      @FavoriteWorkProject,
      @FavoriteMomentsAtBhavna,
      @NativePlace,
      @ExperienceYear,
      @DesignationId,
	  GETDATE(),
	  @Team,
	  @ProfilePictureUrl,
	  @EmployeeLocation
    );
  END
  ELSE
  BEGIN
    -- Update existing employee record
    UPDATE EmployeeMasterUpdate
    SET
	EmailId=@EmailId,
      FullName = @FullName,
      FirstName = @FirstName,
      MiddleName = @MiddleName,
      LastName = @LastName,
      ProjectId = @ProjectId,
      AboutYourSelf = @AboutYourself,
      HobbiesAndInterests = @HobbiesAndInterests,
      FutureAspirations = @FutureAspirations,
      BiographyTitle = @BiographyTitle,
      DefineMyself = @DefineMyself,
      MyBiggestFlex = @MyBiggestFlex,
      FavoriteBingsShow = @FavoriteBingsShow,
      MyLifeMantra = @MyLifeMantra,
      TeamId = @TeamId,
      OneThingICanNotLive = @OneThingICanNotLive,
      WhoInspiresYou = @WhoInspiresYou,
      YourBucketList = @YourBucketList,
      FavoriteMomentsAtBhavna=@FavoriteMomentsAtBhavna,
      NativePlace=@NativePlace,
      ExperienceYear=@ExperienceYear,
      DesignationId=@DesignationId,
	  UpdatedDate=GETDATE(),
	  Team=@Team,
	  ProfilePictureUrl=@ProfilePictureUrl,
	  EmployeeLocation=@EmployeeLocation
	  WHERE EmployeeId = @EmployeeId;
	  END
	  END
GO


CREATE OR ALTER PROCEDURE [dbo].[usp_Eb_GetUpdatedEmployeeDetailById]
    @EmployeeId VARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        EbDesignation.designation AS Designation,
        EbProjects.ProjectName AS Project,
        TeamMaster.TeamName AS Team,
        Em.FullName,
        Em.FirstName,
        Em.LastName,
        Em.MiddleName,
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
        Em.CreatedDate,
        Em.UpdatedDate,
        Em.JoiningDate,
        Em.EmployeeLocation,
        Em.OneThingICanNotLive,
        Em.WhoInspiresYou,
        Em.YourBucketList,
        Em.FavoriteWorkProject,
        Em.FavoriteMomentsAtBhavna,
        Em.NativePlace,
        Em.ExperienceYear,
        Em.DesignationId
    FROM 
        EmployeeMasterUpdate AS Em
    INNER JOIN 
        EbProjects ON EbProjects.Id = Em.ProjectId
 INNER JOIN 
     EbDesignation ON EbDesignation.Id = Em.DesignationId
 INNER JOIN 
	EmployeeDetails ON EmployeeDetails.BhavnaEmployeeId = Em.EmployeeId
 INNER JOIN
     TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
    WHERE 
        Em.EmployeeId = @EmployeeId;
END
GO


CREATE OR ALTER PROCEDURE [dbo].[usp_Eb_GetUpdatedEmployeeDetails]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
	 EbDesignation.designation AS Designation,
 EbProjects.ProjectName AS Project,
 TeamMaster.TeamName AS Team,
       Em.FullName AS EmployeeName,
        Em.FirstName,
        Em.LastName,
        Em.MiddleName,
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
        Em.CreatedDate,
        Em.UpdatedDate,
        Em.JoiningDate,
        Em.EmployeeLocation,
        Em.OneThingICanNotLive,
        Em.WhoInspiresYou,
        Em.YourBucketList,
        Em.FavoriteWorkProject,
        Em.FavoriteMomentsAtBhavna,
        Em.NativePlace,
        Em.ExperienceYear,
        Em.DesignationId
    FROM 
        EmployeeMasterUpdate AS Em
		 INNER JOIN 
     EbProjects ON EbProjects.Id = Em.ProjectId
 INNER JOIN 
     EbDesignation ON EbDesignation.Id = Em.DesignationId
 INNER JOIN 
	EmployeeDetails ON EmployeeDetails.BhavnaEmployeeId = Em.EmployeeId
 INNER JOIN
     TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
   
END
GO

------------------------------------------------------------------
-- =============================================
-- Author:	<Akash Maurya>
-- Create date: <7/29/2024>
-- Description:	<Update ShareIdeaAnswer>
-- =============================================
ALTER TABLE ShareIdeaAnswer
ALTER COLUMN EmployeeId varchar(100) NOT NULL;
