/****** Object:  StoredProcedure [dbo].[usp_getreport_withallcategories_allclients]    Script Date: 24-04-2024 11:16:06 ******/
DROP PROCEDURE [dbo].[usp_getTimesheetSubmissionReportByClientAndTeam]
GO

/****** Object:  StoredProcedure [dbo].[usp_getTimesheetSubmissionReportByClientAndTeam]    Script Date: 24-04-2024 11:16:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Murali Sainath Reddy>
-- Create date: <24-04-2024>
-- Description:	<CreTed to get Timesheet Submission Report>
-- =============================================

CREATE OR ALTER   PROCEDURE [dbo].[usp_getTimesheetSubmissionReportByClientAndTeam]
@EmailId VARCHAR(150),
@ClientId INT,
@TeamId INT,
@StausId INT,
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
				CONVERT(varchar, CAST(t.WeekStartDate AS DATE)) +' - '+ CONVERT(varchar, CAST(t.WeekEndDate AS DATE)) AS Period,
				t.TotalHours AS TotalHours,
				ts.StatusName AS Status,
				CONVERT(varchar, CAST(t.SubmissionDate AS DATE)) AS SubmissionDate,
				CASE WHEN t.StatusId = 2 THEN NULL ELSE CONVERT(varchar, CAST(t.ApprovedDate AS DATE)) END AS 'Approved/RejectedDate'
				from EmployeeDetails ed 
					INNER JOIN Timesheet t ON ed.BhavnaEmployeeId=t.EmployeeID
					INNER JOIN ClientMaster cm ON t.ClientId = cm.Id
					INNER JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
					WHERE (@ClientId =0 or t.ClientId = @ClientId)
							AND (@TeamId = 0 OR t.TeamId = @TeamId) AND
							(t.WeekStartDate >= @StartDate AND t.WeekEndDate <= @EndDate)
							AND (@StausId = 0 or t.StatusID = @StausId);			
		END
		Else IF (@Role = 'Reporting_Manager')
		BEGIN
			SELECT 
				ed.EmployeeName AS EmployeeName,
				cm.ClientName AS Project,
				CONVERT(varchar, CAST(t.WeekStartDate AS DATE)) +' - '+ CONVERT(varchar, CAST(t.WeekEndDate AS DATE)) AS Period,
				t.TotalHours AS TotalHours,
				ts.StatusName AS Status,
				CONVERT(varchar, CAST(t.SubmissionDate AS DATE)) AS SubmissionDate,
				CASE WHEN t.StatusId = 2 THEN NULL ELSE CONVERT(varchar, CAST(t.ApprovedDate AS DATE)) END AS 'Approved/RejectedDate'
				from EmployeeDetails ed 
					INNER JOIN Timesheet t ON ed.BhavnaEmployeeId=t.EmployeeID
					INNER JOIN ClientMaster cm ON t.ClientId = cm.Id
					INNER JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
					INNER JOIN EmployeeRoles er ON er.EmployeeId = ed.EmployeeId
					WHERE (t.ClientId = @Client) AND 
					(@TeamId = 0 OR t.TeamId = @TeamId) AND
					(er.RoleId != 1) AND
					(t.WeekStartDate >= @StartDate AND t.WeekEndDate <= @EndDate)
					AND (@StausId = 0 or t.StatusID = @StausId);
		END
END

GO


/****** Object:  StoredProcedure [dbo].[usp_getTimesheetDayWiseReport]   Script Date: 24-04-2024 11:16:06 ******/
DROP PROCEDURE [dbo].[usp_getTimesheetDayWiseReport]
GO

/****** Object:  StoredProcedure [dbo].[usp_getTimesheetDayWiseReport]    Script Date: 17-05-2024 17:00:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Suramit Pramanik>
-- Create date: <17-05-2024>
-- Description:	<CreTed to get Timesheet DayWIse Report>
-- =============================================


CREATE OR ALTER   PROCEDURE [dbo].[usp_getTimesheetDayWiseReport]
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
				CONVERT(varchar, CAST(td.Date AS DATE)) AS Date,
				CONVERT(varchar, CAST(t.WeekStartDate AS DATE)) AS WeekStartDate ,
				CONVERT(varchar, CAST(t.WeekEndDate AS DATE)) AS WeekEndDate,
				ts.StatusName AS Status,
				tc.TimeSheetCategoryName AS Category,
				tsc.TimeSheetSubcategoryName AS Subcategory,
				(case WHEN datename(WEEKDAY, td.Date) = 'Sunday' then td.Value ELSE 0 END) AS SUN,
				(case datename(WEEKDAY, td.Date) when 'Monday' then td.Value ELSE 0 END) AS MON,
				(case datename(WEEKDAY, td.Date) when 'Tuesday' then td.Value ELSE 0 END) AS TUE,
				(case datename(WEEKDAY, td.Date) when 'Wednesday' then td.Value ELSE 0 END) AS WED,
				(case datename(WEEKDAY, td.Date) when 'Thursday' then td.Value ELSE 0 END) AS THU,
				(case datename(WEEKDAY, td.Date) when 'Friday' then td.Value ELSE 0 END) AS FRI,
				(case datename(WEEKDAY, td.Date) when 'Saturday' then td.Value ELSE 0 END) AS SAT
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
							AND (@StatusId = 0 or t.StatusID = @StatusId);
		END
		Else IF (@Role = 'Reporting_Manager')
		BEGIN
			SELECT 
				ed.EmployeeName AS EmployeeName,
				cm.ClientName AS Project,
				CONVERT(varchar, CAST(t.SubmissionDate AS DATE)) AS SubmissionDate,
				CONVERT(varchar, CAST(t.Created AS DATE)) AS CreatedDate,
				CONVERT(varchar, CAST(td.Date AS DATE)) AS Date,
				CONVERT(varchar, CAST(t.WeekStartDate AS DATE)) AS WeekStartDate ,
				CONVERT(varchar, CAST(t.WeekEndDate AS DATE)) AS WeekEndDate,
				ts.StatusName AS Status,
				tc.TimeSheetCategoryName AS Category,
				tsc.TimeSheetSubcategoryName AS Subcategory,
				(case WHEN datename(WEEKDAY, td.Date) = 'Sunday' then td.Value ELSE 0 END) AS DAY1,
				(case datename(WEEKDAY, td.Date) when 'Monday' then td.Value ELSE 0 END) AS DAY2,
				(case datename(WEEKDAY, td.Date) when 'Tuesday' then td.Value ELSE 0 END) AS DAY3,
				(case datename(WEEKDAY, td.Date) when 'Wednesday' then td.Value ELSE 0 END) AS DAY4,
				(case datename(WEEKDAY, td.Date) when 'Thursday' then td.Value ELSE 0 END) AS DAY5,
				(case datename(WEEKDAY, td.Date) when 'Friday' then td.Value ELSE 0 END) AS DAY6,
				(case datename(WEEKDAY, td.Date) when 'Saturday' then td.Value ELSE 0 END) AS DAY7 
				from EmployeeDetails ed 
					INNER JOIN Timesheet t ON ed.BhavnaEmployeeId=t.EmployeeID
					INNER JOIN TimesheetDetail td ON t.TimesheetId=td.TimesheetId
					INNER JOIN ClientMaster cm ON t.ClientId = cm.Id
					INNER JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
					INNER JOIN TimeSheetCategory tc ON td.TimeSheetCategoryID = tc.TimeSheetCategoryID
					INNER JOIN TimeSheetSubcategory tsc ON td.TimeSheetSubcategoryID = tsc.TimeSheetSubcategoryID
					WHERE (t.ClientId = @Client) AND 
					(@TeamId = 0 OR t.TeamId = @TeamId) AND
					(td.Date >= @StartDate AND td.Date <= @EndDate)
					AND (@StatusId = 0 or t.StatusID = @StatusId);
		END
END
GO


/****** Object:  StoredProcedure [dbo].[usp_getTimesheetSubmissionReport]   Script Date: 21-05-2024 17:12:51 ******/
DROP PROCEDURE [dbo].[usp_getTimesheetSubmissionReport]
GO

/****** Object:  StoredProcedure [dbo].[usp_getTimesheetSubmissionReport]    Script Date: 21-05-2024 17:12:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Suramit Pramanik>
-- Create date: <21-05-2024>
-- Description:	<CreTed to get Timesheet Employee Submission Report>
-- =============================================

CREATE OR ALTER  PROCEDURE [dbo].[usp_getTimesheetSubmissionReport]
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
				CASE
				WHEN t.Created IS NOT NULL THEN 'YES'
				ELSE 'NO'
				END AS TimesheetCreated,
				CASE 
				WHEN t.SubmissionDate IS NOT NULL THEN 'YES'
				ELSE 'NO'
				END AS SubmittedDate,
				ISNULL(CONVERT(varchar, CAST(t.Created AS DATE),120),'') AS CreatedDate,
				ISNULL(CONVERT(varchar, CAST(t.WeekStartDate AS DATE),120),'') AS WeekStartDate ,
				ISNULL(CONVERT(varchar, CAST(t.WeekEndDate AS DATE),120),'') AS WeekEndDate,
				ISNULL(ts.StatusName, '') AS Status,
				ISNULL(CONVERT(VARCHAR,t.TotalHours), '') AS TotalHours
				FROM EmployeeDetails ed 
				LEFT JOIN Timesheet t ON ed.EmployeeId = t.EmployeeID
				LEFT JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
					WHERE (@ClientId = 0 OR t.ClientId = @ClientId)
							AND (@TeamId = 0 OR t.TeamId = @TeamId) AND
							(t.Created >= @StartDate AND t.Created <= @EndDate)
							AND (@StatusId = 0 or t.StatusID = @StatusId)
							ORDER BY
				ed.EmployeeName desc;
		END
		Else IF (@Role = 'Reporting_Manager')
		BEGIN
			SELECT 
				ed.EmployeeName AS EmployeeName,
				CASE
				WHEN t.Created IS NOT NULL THEN 'YES'
				ELSE 'NO'
				END AS TimesheetCreated,
				CASE 
				WHEN t.SubmissionDate IS NOT NULL THEN 'YES'
				ELSE 'NO'
				END AS SubmittedDate,
				ISNULL(CONVERT(varchar, CAST(t.Created AS DATE),120),'') AS CreatedDate,
				ISNULL(CONVERT(varchar, CAST(t.WeekStartDate AS DATE),120),'') AS WeekStartDate ,
				ISNULL(CONVERT(varchar, CAST(t.WeekEndDate AS DATE),120),'') AS WeekEndDate,
				ISNULL(ts.StatusName, '') AS Status,
				ISNULL(CONVERT(VARCHAR,t.TotalHours), '') AS TotalHours
				FROM EmployeeDetails ed 
				LEFT JOIN Timesheet t ON ed.EmployeeId = t.EmployeeID
				LEFT JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
				INNER JOIN EmployeeRoles er ON ed.EmployeeId  = er.EmployeeId
					WHERE (t.ClientId = @Client) AND 
					(@TeamId = 0 OR t.TeamId = @TeamId) AND
							(t.Created >= @StartDate AND t.Created <= @EndDate)
							AND ( er.RoleId != 1 ) AND (@StatusId = 0 or t.StatusID = @StatusId)
					ORDER BY
				ed.EmployeeName desc;
		END
END
GO


/****** Object:  StoredProcedure  [dbo].[usp_getTimesheetPdfReport]    Script Date: 22-05-2024 17:16:06 ******/
DROP PROCEDURE [dbo].[usp_getTimesheetPdfReport]
GO

/****** Object:  StoredProcedure  [dbo].[usp_getTimesheetPdfReport]    Script Date: 22-05-2024 17:16:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER   PROCEDURE [dbo].[usp_getTimesheetPdfReport]
@startDate datetime,
@endDate datetime,
@ClientId int
AS
BEGIN

WITH AggregatedTimesheets AS (    
SELECT EmployeeID,SUM (TotalHours) AS TotalHours FROM Timesheet WHERE StatusId = 2 
AND WeekStartDate >=@startDate AND WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ClientId = @ClientId)
GROUP BY EmployeeID
), 
EmployeeDetailsRanked AS (    
SELECT *, ROW_NUMBER() OVER (PARTITION BY BhavnaEmployeeId ORDER BY TeamId) AS RowNum FROM EmployeeDetails 
),
TimesheetTotalHours AS (
SELECT t.EmployeeID, SUM(tsd.Value) As TotalTimesheetHours
FROM Timesheet t 
Left Join TimesheetDetail tsd on t.TimesheetId=tsd.TimesheetId
where t.StatusId=2
AND t.WeekStartDate >=@startDate AND t.WeekEndDate<=@endDate
AND (ISNULL(@ClientId, 0) = 0 OR t.ClientId = @ClientId)
AND tsd.TimeSheetCategoryID = (select TimeSheetCategoryID from TimeSheetCategory where TimeSheetCategoryName='COMMON')
AND tsd.TimeSheetSubcategoryID in (select TimeSheetSubcategoryID from TimeSheetSubcategory where TimeSheetSubcategoryName IN ('LEAVE-PL', 'LEAVE-LOP', 'LEAVE-PTL'))
GROUP BY t.EmployeeID
),
TSProdNonProdHours AS (
select t.EmployeeId,
SUM(Case when sub.TimeSheetSubcategoryName= 'Non Technical Meetings' THEN tsd.Value 
     when sub.TimeSheetSubcategoryName= 'Training Imparted' THEN tsd.Value
	 when sub.TimeSheetSubcategoryName= 'Self Learning' THEN tsd.Value
	 when sub.TimeSheetSubcategoryName= 'Training Attended - Non Technical' THEN tsd.Value
	 ELSE 0 END) As TsNonProdHours,
SUM(Case when sub.TimeSheetSubcategoryName NOT IN ('Non Technical Meetings','Training Imparted',
'Self Learning', 'Training Attended - Non Technical','LEAVE-PL', 'LEAVE-LOP', 'LEAVE-PTL') THEN tsd.Value
ELSE 0 END) As TSProdHours
from Timesheet t 
Left join TimesheetDetail tsd on t.TimesheetId=tsd.TimesheetId
Left Join TimeSheetCategory cat on tsd.TimeSheetCategoryID=cat.TimeSheetCategoryID
Left join TimeSheetSubcategory sub on tsd.TimeSheetSubcategoryID=sub.TimeSheetSubcategoryID
where t.StatusId=2
AND t.WeekStartDate >=@startDate AND t.WeekEndDate<=@endDate
AND (ISNULL(@ClientId, 0) = 0 OR t.ClientId = @ClientId)
Group By t.EmployeeID
)

SELECT et.Function_Type as FunctionType,    
COUNT(DISTINCT em.EmployeeId) AS EmployeeCount,   
COALESCE(SUM(ats.TotalHours),0) AS TSActualHours,
 CASE
           WHEN @ClientId IS NOT NULL THEN (SELECT expectedHours FROM ClientExpectedHours WHERE clientId = @ClientId)
           ELSE 0 
       END AS ExpectedHours,
       CASE
           WHEN @ClientId IS NOT NULL THEN (SELECT expectedHours FROM ClientExpectedHours WHERE clientId = @ClientId) * 5 * COUNT(DISTINCT em.EmployeeId)
           ELSE 0 
       END AS TSExpectedHours,
ROUND((COUNT(DISTINCT ats.EmployeeID) * 100.0 / COUNT(DISTINCT em.EmployeeId)),2) AS TSCompliance,
COUNT (DISTINCT ats.EmployeeId) AS TimesheetSubmitted,
COALESCE(SUM(tth.TotalTimesheetHours),0) AS LeaveHours,
COALESCE(SUM(tnh.TSProdHours),0) AS TSProdHours,
COALESCE(SUM(tnh.TsNonProdHours),0) AS TSNonProdHours,
CASE WHEN SUM(ats.TotalHours) <> 0 AND SUM(tnh.TSProdHours) <> 0
THEN COALESCE(SUM(tnh.TSProdHours),0) *100/ COALESCE(SUM(ats.TotalHours),0)
ELSE
0
END as ProdPercent
FROM EmployeeType et    
INNER JOIN EmployeeDetailsRanked edr ON et.Id =CONVERT(int, edr.Type) AND edr.RowNum = 1
INNER JOIN EmployeeMaster em ON edr.BhavnaEmployeeId = em.EmployeeId    
INNER JOIN TeamMaster tm ON edr.TeamId = tm.Id  
LEFT JOIN AggregatedTimesheets ats ON em.EmployeeId = ats.EmployeeID    
LEFT JOIN TimesheetTotalHours tth ON em.EmployeeId=tth.EmployeeID
LEFT JOIN TSProdNonProdHours tnh ON em.EmployeeId=tnh.EmployeeId
WHERE (ISNULL(@ClientId, 0) = 0 OR tm.ClientId = @ClientId)  
GROUP BY et.Function_Type

SELECT sub.TimeSheetSubcategoryName as SubCategory,
COUNT(DISTINCT ts.EmployeeID) AS EmployeeCount,
SUM(tsd.Value) as TSHours
FROM Timesheet ts
inner join TimesheetDetail tsd on ts.TimesheetId=tsd.TimesheetId
inner join TimeSheetCategory cat on tsd.TimeSheetCategoryID= cat.TimeSheetCategoryID
inner join TimeSheetSubcategory sub on tsd.TimeSheetSubcategoryID= sub.TimeSheetSubcategoryID
where ts.StatusId=2 
AND ts.WeekStartDate >=@startDate AND ts.WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ts.ClientId = @ClientId)
and tsd.TimeSheetCategoryID= (select TimeSheetCategoryID from TimeSheetCategory where TimeSheetCategoryName = 'COMMON')
and sub.TimeSheetSubcategoryName IN ('Self Learning', 'Non Technical Meetings', 'Training Imparted', 'Training Attended - Non Technical')
GROUP BY sub.TimeSheetSubcategoryName;

WITH EmployeeDetailsRows AS (    
SELECT *, ROW_NUMBER() OVER (PARTITION BY BhavnaEmployeeId ORDER BY TeamId) AS RowNum FROM EmployeeDetails 
)
select ET.Function_Type as EmployeeType,
tc.TimeSheetCategoryName as CategoryName,
SUM(td.value) as Hours from  Timesheet ts 
inner join EmployeeDetailsRows edr ON ts.EmployeeID =CONVERT(int, edr.BhavnaEmployeeId) AND edr.RowNum = 1
inner join EmployeeType et on edr.Type = et.Id
inner join TimesheetDetail td on ts.TimesheetId=td.TimesheetId
inner join TimeSheetCategory tc on Td.TimeSheetCategoryID= tc.TimeSheetCategoryID
where ts.StatusId=2 AND ts.WeekStartDate >=@startDate AND ts.WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ts.ClientId = @ClientId)
Group by et.Function_Type, tc.TimeSheetCategoryName
END
GO

/****** Object:  StoredProcedure  [dbo].[usp_getTimesheetReport_excel]   Script Date: 22-05-2024 17:18:06 ******/
DROP PROCEDURE [dbo].[usp_getTimesheetReport_excel]
GO

/****** Object:  StoredProcedure  [dbo].[usp_getTimesheetReport_excel]   Script Date: 22-05-2024 17:18:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER   PROCEDURE [dbo].[usp_getTimesheetReport_excel] -- '2024-03-31', '2024-04-27'
@StartDate datetime,
@EndDate datetime
AS
	BEGIN
		BEGIN
			SELECT 
				ed.EmployeeName AS EmployeeName,
				cm.ClientName AS Project,
				CONVERT(varchar, CAST(t.WeekStartDate AS DATE)) + '-' + CONVERT(varchar, CAST(t.WeekEndDate AS DATE)) AS Period,
				t.TotalHours,
				ts.StatusName AS Status
				from EmployeeDetails ed 
					INNER JOIN Timesheet t ON ed.BhavnaEmployeeId=t.EmployeeID
					INNER JOIN ClientMaster cm ON t.ClientId = cm.Id
					INNER JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
					WHERE t.WeekStartDate >= @StartDate AND t.WeekEndDate <= @EndDate;
					END
END
GO







