/****** Object:  StoredProcedure [dbo].[usp_getTimesheetDayWiseReport]    Script Date: 18-06-2024 21:16:07 ******/
DROP PROCEDURE [dbo].[usp_getTimesheetDayWiseReport]
GO

/****** Object:  StoredProcedure [dbo].[usp_getTimesheetDayWiseReport]    Script Date: 18-06-2024 21:16:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Suramit Pramanik>
-- Create date: <18-06-2024>
-- Description:	<Created to get Timesheet DayWIse Report>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[usp_getTimesheetDayWiseReport]
@EmailId VARCHAR(150),
@ClientId INT,
@TeamId INT,
@StatusId INT,
@StartDate DATETIME,
@EndDate DATETIME
AS
	BEGIN
		SET NOCOUNT ON
			IF @EmailId IS NOT NULL
			BEGIN
				DECLARE @Role VARCHAR(100) = '';
				DECLARE @Client INT;
				SELECT TOP(1) @Role=Roles.RoleName, @Client= team.ClientId FROM EmployeeMaster 
				INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.BhavnaEmployeeId
				INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
				INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
				INNER JOIN TeamMaster team on team.Id= EmployeeDetails.TeamId
				WHERE EmployeeMaster.EmailId  = @EmailId
			END
			IF @Role = ''
			BEGIN
				SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
				INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
				INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
				WHERE EmployeeMaster.EmailId =  @EmailId
			END
		IF (@Role = 'ADMIN')
		BEGIN
			SELECT 
				ed.EmployeeName AS EmployeeName,
				cm.ClientName AS Project,
				CONVERT(varchar, CAST(t.SubmissionDate AS DATE)) AS SubmissionDate,
				CONVERT(varchar, CAST(t.Created AS DATE)) AS CreatedDate,
				CONVERT(varchar, CAST(t.WeekStartDate AS DATE)) AS WeekStartDate ,
				CONVERT(varchar, CAST(t.WeekEndDate AS DATE)) AS WeekEndDate,
				ts.StatusName AS Status,
				tc.TimeSheetCategoryName AS Category,
				tsc.TimeSheetSubcategoryName AS Subcategory,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Sunday' THEN td.Value ELSE 0 END) AS SUN,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Monday' THEN td.Value ELSE 0 END) AS MON,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Tuesday' THEN td.Value ELSE 0 END) AS TUE,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Wednesday' THEN td.Value ELSE 0 END) AS WED,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Thursday' THEN td.Value ELSE 0 END) AS THU,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Friday' THEN td.Value ELSE 0 END) AS FRI,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Saturday' THEN td.Value ELSE 0 END) AS SAT,
				SUM(td.Value) as Total
				from EmployeeDetails ed 
					INNER JOIN Timesheet t ON ed.BhavnaEmployeeId=t.EmployeeID
					INNER JOIN TimesheetDetail td ON t.TimesheetId=td.TimesheetId
					INNER JOIN ClientMaster cm ON t.ClientId = cm.Id
					INNER JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
					INNER JOIN TimeSheetCategory tc ON td.TimeSheetCategoryID = tc.TimeSheetCategoryID
					INNER JOIN TimeSheetSubcategory tsc ON td.TimeSheetSubcategoryID = tsc.TimeSheetSubcategoryID
					WHERE (@ClientId = 0 OR t.ClientId = @ClientId)
							AND (@TeamId = 0 OR t.TeamId = @TeamId) AND
							(td.Date >= @StartDate AND td.Date <= @EndDate)
							AND (@StatusId = 0 or t.StatusID = @StatusId)
					GROUP BY
							ed.EmployeeName,
							cm.ClientName,
							CONVERT(varchar, CAST(t.SubmissionDate AS DATE)),
							CONVERT(varchar, CAST(t.Created AS DATE)),
							CONVERT(varchar, CAST(t.WeekStartDate AS DATE)),
							CONVERT(varchar, CAST(t.WeekEndDate AS DATE)),
							ts.StatusName,
							tc.TimeSheetCategoryName,
							tsc.TimeSheetSubcategoryName;
		END
		Else IF (@Role = 'Reporting_Manager')
		BEGIN
			SELECT 
				ed.EmployeeName AS EmployeeName,
				cm.ClientName AS Project,
				CONVERT(varchar, CAST(t.SubmissionDate AS DATE)) AS SubmissionDate,
				CONVERT(varchar, CAST(t.Created AS DATE)) AS CreatedDate,
				CONVERT(varchar, CAST(t.WeekStartDate AS DATE)) AS WeekStartDate ,
				CONVERT(varchar, CAST(t.WeekEndDate AS DATE)) AS WeekEndDate,
				ts.StatusName AS Status,
				tc.TimeSheetCategoryName AS Category,
				tsc.TimeSheetSubcategoryName AS Subcategory,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Sunday' THEN td.Value ELSE 0 END) AS SUN,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Monday' THEN td.Value ELSE 0 END) AS MON,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Tuesday' THEN td.Value ELSE 0 END) AS TUE,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Wednesday' THEN td.Value ELSE 0 END) AS WED,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Thursday' THEN td.Value ELSE 0 END) AS THU,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Friday' THEN td.Value ELSE 0 END) AS FRI,
				SUM(CASE WHEN DATENAME(WEEKDAY, td.Date) = 'Saturday' THEN td.Value ELSE 0 END) AS SAT,
				SUM(td.Value) as Total
				from EmployeeDetails ed 
					INNER JOIN Timesheet t ON ed.BhavnaEmployeeId=t.EmployeeID
					INNER JOIN TimesheetDetail td ON t.TimesheetId=td.TimesheetId
					INNER JOIN ClientMaster cm ON t.ClientId = cm.Id
					INNER JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
					INNER JOIN TimeSheetCategory tc ON td.TimeSheetCategoryID = tc.TimeSheetCategoryID
					INNER JOIN TimeSheetSubcategory tsc ON td.TimeSheetSubcategoryID = tsc.TimeSheetSubcategoryID
					INNER JOIN EmployeeRoles er ON ed.BhavnaEmployeeId  = er.EmployeeId
					WHERE (t.ClientId = @Client) AND 
					(@TeamId = 0 OR t.TeamId = @TeamId) AND
					( er.RoleId != 1 )AND
					(td.Date >= @StartDate AND td.Date <= @EndDate)
					AND (@StatusId = 0 or t.StatusID = @StatusId)
					GROUP BY
							ed.EmployeeName,
							cm.ClientName,
							CONVERT(varchar, CAST(t.SubmissionDate AS DATE)),
							CONVERT(varchar, CAST(t.Created AS DATE)),
							CONVERT(varchar, CAST(t.WeekStartDate AS DATE)),
							CONVERT(varchar, CAST(t.WeekEndDate AS DATE)),
							ts.StatusName,
							tc.TimeSheetCategoryName,
							tsc.TimeSheetSubcategoryName;
		END
END

GO

/****** Object:  StoredProcedure [dbo].[usp_getTimesheetSubmissionReport]    Script Date: 25-06-2024 12:03:00 ******/
DROP PROCEDURE [dbo].[usp_getTimesheetSubmissionReport]
GO

/****** Object:  StoredProcedure [dbo].[usp_getTimesheetSubmissionReport]   Script Date: 25-06-2024 12:03:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Suramit Pramanik>
-- Create date: <25-06-2024>
-- Description:	<CreTed to get Timesheet Employee Submission Report>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[usp_getTimesheetSubmissionReport]
@EmailId VARCHAR(150),
@ClientId INT,
@TeamId INT,
@StatusId INT,
@StartDate DATETIME,
@EndDate DATETIME
AS
	BEGIN
		SET NOCOUNT ON
			IF @EmailId IS NOT NULL
			BEGIN
				DECLARE @Role VARCHAR(100) = '';
				DECLARE @Client INT;
				SELECT TOP(1) @Role=Roles.RoleName, @Client= team.ClientId FROM EmployeeMaster 
				INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.BhavnaEmployeeId
				INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
				INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
				INNER JOIN TeamMaster team on team.Id= EmployeeDetails.TeamId
				WHERE EmployeeMaster.EmailId  = @EmailId
			END
			IF @Role = ''
			BEGIN
				SELECT TOP(1) @Role=Roles.RoleName FROM EmployeeMaster 
				INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
				INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
				WHERE EmployeeMaster.EmailId =  @EmailId
			END
		IF (@Role = 'ADMIN')
		BEGIN
			SELECT 
				ed.EmployeeName AS EmployeeName,
				cm.ClientName AS Project,
				CASE
				WHEN t.Created IS NOT NULL THEN 'YES'
				ELSE 'NO'
				END AS TimesheetCreated,
				CASE 
				WHEN t.SubmissionDate IS NOT NULL THEN 'YES'
				ELSE 'NO'
				END AS TimesheetSubmitted,
				ISNULL(CONVERT(varchar, CAST(t.Created AS DATE),120),'') AS CreatedDate,
				ISNULL(CONVERT(varchar, CAST(t.SubmissionDate AS DATE),120),'') AS SubmittedDate,
				ISNULL(CONVERT(varchar, CAST(t.WeekStartDate AS DATE),120),'') AS WeekStartDate ,
				ISNULL(CONVERT(varchar, CAST(t.WeekEndDate AS DATE),120),'') AS WeekEndDate,
				ISNULL(ts.StatusName, '') AS Status,
				CASE WHEN t.StatusId = 2 THEN NULL ELSE CONVERT(varchar, CAST(t.ApprovedDate AS DATE)) END AS 'Approved/RejectedDate',
				ISNULL(CONVERT(VARCHAR,t.TotalHours), '') AS TotalHours
				FROM EmployeeDetails ed 
				INNER JOIN TeamMaster tm ON tm.Id = ed.TeamId
				INNER JOIN ClientMaster cm ON tm.ClientId = cm.Id
				LEFT JOIN EmployeeMaster empM on ed.BhavnaEmployeeId=empM.EmployeeId
				LEFT JOIN Timesheet t ON ed.BhavnaEmployeeId = t.EmployeeID AND (t.WeekStartDate >= @StartDate AND t.WeekEndDate <= @EndDate)
				LEFT JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID 
					WHERE (@ClientId = 0 OR tm.ClientId = @ClientId)
						  AND (@TeamId = 0 OR tm.Id = @TeamId) 	
						  AND (@StatusId = 0 or t.StatusID = @StatusId)
						  AND(empM.IsDeleted = 0)
							 
					ORDER BY
						ed.EmployeeName desc;
		END
		Else IF (@Role = 'Reporting_Manager')
		BEGIN
			SELECT 
				ed.EmployeeName AS EmployeeName,
				cm.ClientName AS Project,
				CASE
				WHEN t.Created IS NOT NULL THEN 'YES'
				ELSE 'NO'
				END AS TimesheetCreated,
				CASE 
				WHEN t.SubmissionDate IS NOT NULL THEN 'YES'
				ELSE 'NO'
				END AS TimesheetSubmitted,
				ISNULL(CONVERT(varchar, CAST(t.Created AS DATE),120),'') AS CreatedDate,
				ISNULL(CONVERT(varchar, CAST(t.SubmissionDate AS DATE),120),'') AS SubmittedDate,
				ISNULL(CONVERT(varchar, CAST(t.WeekStartDate AS DATE),120),'') AS WeekStartDate ,
				ISNULL(CONVERT(varchar, CAST(t.WeekEndDate AS DATE),120),'') AS WeekEndDate,
				ISNULL(ts.StatusName, '') AS Status,
				CASE WHEN t.StatusId = 2 THEN NULL ELSE CONVERT(varchar, CAST(t.ApprovedDate AS DATE)) END AS 'Approved/RejectedDate',
				ISNULL(CONVERT(VARCHAR,t.TotalHours), '') AS TotalHours
				FROM EmployeeDetails ed 
				INNER JOIN TeamMaster tm ON tm.Id = ed.TeamId
				INNER JOIN ClientMaster cm ON tm.ClientId = cm.Id
				LEFT JOIN EmployeeMaster empM on ed.BhavnaEmployeeId=empM.EmployeeId
				LEFT JOIN Timesheet t ON ed.BhavnaEmployeeId = t.EmployeeID AND (t.WeekStartDate >= @StartDate AND t.WeekEndDate <= @EndDate)
				LEFT JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
				LEFT JOIN EmployeeRoles er ON ed.BhavnaEmployeeId  = er.EmployeeId
					WHERE (tm.ClientId = @Client) 
					AND (@TeamId = 0 OR tm.Id = @TeamId)
					AND ( er.RoleId != 1 ) 
					AND (@StatusId = 0 or t.StatusID = @StatusId) 
					AND (empM.IsDeleted = 0)
					ORDER BY
				ed.EmployeeName desc;
		END
END
GO

DROP PROCEDURE IF EXISTS [dbo].[usp_AddModifyEmployeeData]

/****** Object:  StoredProcedure [dbo].[usp_AddModifyEmployeeData]    Script Date: 19-06-2024 15:01:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Suramit Pramanik>
-- Create date: <19-06-2024>
-- Description:	<Create for Add and Modify Employee Data in EmployeeRoles Table and EmployeeMaster Table>
-- =============================================

CREATE OR ALTER procedure [dbo].[usp_AddModifyEmployeeData]
(
@EmployeeId VARCHAR(50),
@FullName varchar(200),
@emailId varchar(200),
@RoleId int,
@CreatedDate DateTime,
@UpdatedDate DateTime,
@DesignationId int,
@CreatedById VARCHAR(50),
@UpdatedById VARCHAR (50)
)
AS
BEGIN
	BEGIN
	IF NOT EXISTS (select 1 from EmployeeRoles where EmployeeId=@EmployeeId)
	BEGIN
	INSERT INTO EmployeeRoles(EmployeeId,RoleId,CreatedDate,CreatedBy) VALUES (@EmployeeId,@RoleId,@CreatedDate,@CreatedById)
	END
	ELSE
	BEGIN
		UPDATE EmployeeRoles SET RoleId=@RoleId,UpdatedDate=@UpdatedDate,ModifiedBy=@UpdatedById WHERE EmployeeId=@EmployeeId
	END
	END
	BEGIN
	IF NOT EXISTS (select 1 from EmployeeMaster where EmployeeId=@EmployeeId)
	BEGIN
		INSERT INTO EmployeeMaster(EmployeeId,FullName,EmailId,CreatedDate,DesignationId,CreatedById) VALUES (@EmployeeId,@FullName,@emailId,@CreatedDate,@DesignationId,@CreatedById)
	END
	ELSE
	BEGIN
		UPDATE EmployeeMaster SET FullName =@FullName, EmailId=@emailId, UpdatedDate=@UpdatedDate, DesignationId=@DesignationId, UpdatedById=@UpdatedById WHERE EmployeeId=@EmployeeId
	END
	END
END


-- =============================================
-- Author:<Suramit Pramanik>
-- Create date: <19-06-2024>
-- Description:	<For CreatedById and UpdatedById alter that columns in EmployeeMaster from Int To Varchar datatype change. After that Open Script View as CREATE for the vw_Eb_GetEmployeesDetailList View Then DROP the VIEW and CREATE the VIEW. So that the datatype also changes in the View>
-- =============================================

ALTER TABLE dbo.EmployeeMaster ALTER COLUMN CreatedById VARCHAR(50) NULL;

ALTER TABLE dbo.EmployeeMaster ALTER COLUMN UpdatedById VARCHAR(50) NULL;

DROP VIEW vw_Eb_GetEmployeesDetailList;


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
LEFT OUTER JOIN EbProjects ON EbProjects.Id = Em.ProjectId
LEFT OUTER JOIN EbDesignation ON EbDesignation.Id = Em.DesignationId

GO

DROP PROCEDURE IF EXISTS [dbo].[usp_getManagerEmails]


/****** Object:  StoredProcedure [dbo].[usp_getManagerEmails]    Script Date: 25-06-2024 12:03:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Suramit Pramanik>
-- Create date: <25-06-2024>
-- Description:	<Created to get Manager and approver email based on the employee>

CREATE OR ALTER   PROCEDURE [dbo].[usp_getManagerEmails]
@EmailAndWeekList dbo.EmailAndWeekList READONLY
AS
BEGIN
 Select (Select EmailId from EmployeeMaster where EmployeeId= empD.TimesheetManagerId) ManagerEmailId,
 (Select EmailId from EmployeeMaster where EmployeeId= empD.TimesheetApproverId1) ApproverEmailId1,
 (Select EmailId from EmployeeMaster where EmployeeId= empD.TimesheetApproverId2) ApproverEmailId2,

	empM.FullName,tm.WeekStartDate,tm.WeekEndDate 
 from @EmailAndWeekList emailList 
	Inner join EmployeeMaster empM on emailList.EmailId=empM.EmailId
	Inner join EmployeeDetails empD on empD.BhavnaEmployeeId=empM.EmployeeId
	Inner join Timesheet tm on empM.EmployeeId=tm.EmployeeID And emailList.WeekStartDate=tm.WeekStartDate And emailList.WeekEndDate=tm.WeekEndDate
	Inner join TeamMaster teamM on teamM.Id=tm.TeamId  And teamM.Id=empD.TeamId
End
-- =============================================






