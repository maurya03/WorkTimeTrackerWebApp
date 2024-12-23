-- =============================================
-- Author:	<Akash Maurya>
-- Create date: <6/17/2024>
-- Description:	<Add the Leave, And Holiday for all categories timesheet>
-- =============================================

CREATE OR ALTER  procedure [dbo].[usp_getTimesheetCategoryByEmployeeId] --'test01@bhavnacorp.com', 0
@emailId varchar(200),
@employeeIdParam varchar(50)
as
begin
declare @roleId int
declare @employeeId varchar(50)
If @employeeIdParam = '0'
	set @employeeId = (Select em.EmployeeId  from EmployeeMaster em where em.EmailId = @emailId)

else
	set @employeeId = @employeeIdParam

set @roleId = (Select er.roleId From EmployeeMaster em
		Inner Join EmployeeRoles er ON em.EmployeeId = er.EmployeeId
		Where em.EmployeeId=@employeeId)
If @roleId=1
BEGIN
select * from TimeSheetCategory where TimeSheetCategoryID IN (select Distinct TimeSheetCategoryID from TimeSheetSubcategory)
END
ELSE
BEGIN
   declare @function varchar(500)
   set @function= (select top 1 empType.Function_Type from EmployeeDetails detail join EmployeeType empType on detail.Type=empType.Id  where BhavnaEmployeeId=@employeeId)
		SELECT  200 + ROW_NUMBER() over(order by TimeSheetCategoryID), * FROM TimeSheetCategory where  [Function]=@function and
		TimeSheetCategoryID IN (select Distinct TimeSheetCategoryID from TimeSheetSubcategory)
		union
		SELECT 1000000 + ROW_NUMBER() over(order by TimeSheetCategoryID),* FROM TimeSheetCategory where [Function] IN ('Common', 'Leave','Holiday') and
		TimeSheetCategoryID IN (select Distinct TimeSheetCategoryID from TimeSheetSubcategory)
END;
end
GO

------------------------------------------------------------------
-- =============================================
-- Author:	<Akash Maurya>
-- Create date: <6/17/2024>
-- Description:	<SET the client for Approver>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[usp_getClientMasterByEmployeeId] --'sthakur@bhavnacorp.com'
@EmailId VARCHAR(150),
@IsWithTeam bit=0
AS
BEGIN
SET NOCOUNT ON
IF @EmailId IS NOT NULL

BEGIN
DECLARE @Role VARCHAR(100) = '';
DECLARE @ClientId INT;

SELECT TOP(1) @ClientId=TeamMaster.ClientId, @Role=Roles.RoleName FROM EmployeeMaster
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.BhavnaEmployeeId
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

declare @sql Nvarchar(max)
--FILTER RECORD USING ROLE
IF (@Role = 'ADMIN')
BEGIN
	IF (@IsWithTeam =0)
		BEGIN
		 set @sql='SELECT * FROM ClientMaster'
		END
		ELSE
		BEGIN
			 set @sql=	'SELECT distinct client.* FROM ClientMaster client
						INNER join TeamMaster team on client.Id= team.ClientId
						WHERE  team.Id is not null'
		END

END
ELSE IF (@Role = 'Reporting_Manager' OR @Role='Approver')
BEGIN
			set @sql='SELECT * FROM ClientMaster where Id  = '+  cast( @ClientId as varchar)



END
ELSE IF (@Role = 'EMPLOYEE')
	BEGIN
		    set @sql='SELECT distinct client.* FROM ClientMaster client
						INNER join TeamMaster team on client.Id= team.ClientId
						WHERE  team.Id is not null and client.Id  = '+ cast( @ClientId as varchar)


END
 print @sql
EXECUTE 	sp_executesql @sql
END
END

-- =============================================
-- Author:	<Akash Maurya>
-- Create date: <6/17/2024>
-- Description:	<Insert Approver Roles into Roles table>
-- =============================================
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'Approver')
BEGIN
    INSERT INTO [dbo].[Roles] ([RoleName], [CreatedDate], [UpdatedDate], [IsActive])
    VALUES ('Approver', GETDATE(), GETDATE(), 1)
END
GO

-- =============================================
-- Author:	<Suramit Pramanik>
-- Create date: <6/17/2024>
-- Description:	<Added Two new columns in EmployeeDetails table>
-- =============================================

IF NOT EXISTS (SELECT *
               FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_NAME = 'EmployeeDetails'
                 AND COLUMN_NAME = 'CreatedDate')
BEGIN
    ALTER TABLE EmployeeDetails ADD CreatedDate DATETIME;
END

IF NOT EXISTS (SELECT *
               FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_NAME = 'EmployeeDetails'
                 AND COLUMN_NAME = 'UpdatedDate')
BEGIN
    ALTER TABLE EmployeeDetails ADD UpdatedDate DATETIME;
END
GO


USE [Automation]
GO
/****** Object:  StoredProcedure [dbo].[[usp_getTimesheetConsultantReport]]    Script Date: 7/8/2024 4:14:19 PM ******/--Arpit verma
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create or
ALTER PROCEDURE [dbo].[usp_getTimesheetConsultantReport]-- '2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000',0
@startDate datetime,
@endDate datetime,
@ClientId int
AS
BEGIN

WITH AggregatedTimesheets AS (
SELECT EmployeeID,SUM (TotalHours) AS TotalHours FROM Timesheet WHERE StatusId = 4
AND WeekStartDate >=@startDate AND WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ClientId = @ClientId)
GROUP BY EmployeeID
),
WeekEndHour as  (select  t.EmployeeId , Sum(td.Value) As WeekendHour from TimesheetDetail td inner join Timesheet t ON t.TimesheetId= td.TimesheetId where td.Date=t.WeekStartDate OR td.Date=t.WeekEndDate GROUP BY t.EmployeeID),
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
AND tsd.TimeSheetCategoryID = (select TimeSheetCategoryID from TimeSheetCategory where TimeSheetCategoryName='Leave')
AND tsd.TimeSheetSubcategoryID in (select TimeSheetSubcategoryID from TimeSheetSubcategory where TimeSheetSubcategoryName IN ('PL','SL','BL', 'LOP', 'PAT'))
GROUP BY t.EmployeeID
),
ITActiveHours As (
SELECT EmpID, SUM(ITActiveHours) As ITHours
FROM EmployeeITProductivity
where startDate >=@startDate AND weekenddate<=@endDate
GROUP BY EmpID
),
TSProdNonProdHours AS (
select t.EmployeeId,
SUM(Case when sub.TimeSheetSubcategoryName= 'Non Technical Meetings' THEN tsd.Value
     when sub.TimeSheetSubcategoryName= 'Training Imparted' THEN tsd.Value
	 when sub.TimeSheetSubcategoryName= 'Self Learning' THEN tsd.Value
	 when sub.TimeSheetSubcategoryName= 'Training Attended - Non Technical' THEN tsd.Value
	 ELSE 0 END) As TsNonProdHours,
SUM(Case when sub.TimeSheetSubcategoryName NOT IN ('Non Technical Meetings','Training Imparted',
'Self Learning', 'Training Attended - Non Technical') THEN tsd.Value
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
COUNT(DISTINCT em.EmployeeId) *40 as TSExpectedHours,
ROUND((COUNT(DISTINCT ats.EmployeeID) * 100.0 / COUNT(DISTINCT em.EmployeeId)),2) AS TSCompliance
,COALESCE(SUM(tth.TotalTimesheetHours),0) AS LeaveHours,
COALESCE(SUM(tnh.TSProdHours),0) AS TSProdHours,
COALESCE(SUM(tnh.TsNonProdHours),0) AS TSNonProdHours,
COALESCE(SUM(ita.ITHours),0) AS ITHours,
COALESCE(SUM(wkh.WeekendHour),0) AS WeekEndHour,
ROUND(CASE WHEN SUM(ats.TotalHours) <> 0
THEN COALESCE(SUM(ats.TotalHours),0) *100/ COALESCE((COUNT(DISTINCT em.EmployeeId) *40),0)
ELSE
0
END,2) as UtilisationPer,
CASE WHEN SUM(ats.TotalHours) <> 0 AND SUM(tnh.TSProdHours) <> 0
THEN COALESCE(SUM(tnh.TSProdHours),0) *100/ COALESCE(SUM(ats.TotalHours),0)
ELSE
0
END as ProdPercent
FROM EmployeeType et
INNER JOIN EmployeeDetailsRanked edr ON et.Id =CONVERT(int, edr.Type) AND edr.RowNum = 1
INNER JOIN EmployeeMaster em ON edr.BhavnaEmployeeId = em.EmployeeId
INNER JOIN TeamMaster tm ON edr.TeamId = tm.Id  LEFT JOIN ITActiveHours ita ON em.EmployeeId=ita.EmpId
LEFT JOIN WeekEndHour wkh ON em.EmployeeId=wkh.EmployeeID
LEFT JOIN AggregatedTimesheets ats ON em.EmployeeId = ats.EmployeeID
LEFT JOIN TimesheetTotalHours tth ON em.EmployeeId=tth.EmployeeID
LEFT JOIN TSProdNonProdHours tnh ON em.EmployeeId=tnh.EmployeeId
WHERE (ISNULL(@ClientId, 0) = 0 OR tm.ClientId = @ClientId) AND em.EmployeeId IN (SELECT EmployeeId FROM EmployeeMaster WHERE DesignationId = 50)
GROUP BY et.Function_Type

SELECT sub.TimeSheetSubcategoryName as SubCategory,
COUNT(DISTINCT ts.EmployeeID) AS EmployeeCount,
SUM(tsd.Value) as TSHours
FROM Timesheet ts
inner join TimesheetDetail tsd on ts.TimesheetId=tsd.TimesheetId
inner join TimeSheetCategory cat on tsd.TimeSheetCategoryID= cat.TimeSheetCategoryID
inner join TimeSheetSubcategory sub on tsd.TimeSheetSubcategoryID= sub.TimeSheetSubcategoryID
where ts.StatusId=2
AND ts.WeekStartDate >=@startDate AND ts.WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ts.ClientId = @ClientId AND ts.EmployeeId IN (SELECT EmployeeId FROM EmployeeMaster WHERE DesignationId = 50))
and tsd.TimeSheetCategoryID= (select TimeSheetCategoryID from TimeSheetCategory where TimeSheetCategoryName = 'Common')
and sub.TimeSheetSubcategoryName IN ('Self Learning', 'Non Technical Meetings', 'Training Imparted', 'Training Attended - Non Technical')
GROUP BY sub.TimeSheetSubcategoryName;

END

/****** Object:  Table [dbo].[EmployeeITProductivity]    Script Date: 7/8/2024 8:54:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EmployeeITProductivity](
	[EmpId] [varchar](20) NOT NULL,
	[Leave] [int] NULL,
	[ITProductiveHours] [int] NULL,
	[ITActiveHours] [int] NULL,
	[startDate] [datetime] NULL,
	[weekenddate] [datetime] NULL
) ON [PRIMARY]
GO
------------------------
--Dummy data
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(1,1,60,62,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(1011,0,40,62,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(1012,2,50,60,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(1013,0,30,48,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(912,1,60,58,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(910,2,60,62,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(101,0,60,59,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(600,0,60,62,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(601,0,60,48,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(614,0,50,62,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(585,1,50,55,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
insert into EmployeeITProductivity(EmpId,Leave,	ITProductiveHours,ITActiveHours,startDate,weekenddate) values(670,0,55,62,'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000')
--

-- =============================================
-- Author:	<Arpit Verma>
-- Create date: < 7/10/2024 11:35:56 PM>
-- Description:	<Get Timesheet Report to get pdf, Expected hour changes done columns added and Adrenaline data>
-- =============================================
/****** Object:  StoredProcedure [dbo].[usp_getTimesheetPdfReport]    Script Date: 7/10/2024 11:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER     PROCEDURE [dbo].[usp_getTimesheetPdfReport]--'2024-06-1 00:00:00.000', '2024-06-30 00:00:00.000',0
@startDate datetime,
@endDate datetime,
@ClientId int
AS
BEGIN

WITH AggregatedTimesheets AS (
SELECT EmployeeID,SUM (TotalHours) AS TotalHours FROM Timesheet WHERE StatusId = 4
AND WeekStartDate >=@startDate AND WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ClientId = @ClientId)
GROUP BY EmployeeID
),
DateRange AS (
    SELECT @startDate AS Date
    UNION ALL
    SELECT DATEADD(DAY, 1, Date)
    FROM DateRange
    WHERE DATEADD(DAY, 1, Date) <= @endDate
),
WeekEndHour as  (select  t.EmployeeId , Sum(td.Value) As WeekendHour from TimesheetDetail td
inner join Timesheet t ON t.TimesheetId= td.TimesheetId where td.Date=t.WeekStartDate OR td.Date=t.WeekEndDate GROUP BY t.EmployeeID),
EmployeeDetailsRanked AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY BhavnaEmployeeId ORDER BY TeamId) AS RowNum FROM EmployeeDetails
),
TimesheetTotalHours AS (
SELECT t.EmployeeID, SUM(tsd.Value) As TotalTimesheetHours
FROM Timesheet t
Left Join TimesheetDetail tsd on t.TimesheetId=tsd.TimesheetId
where t.StatusId=4
AND t.WeekStartDate >=@startDate AND t.WeekEndDate<=@endDate
AND (ISNULL(@ClientId, 0) = 0 OR t.ClientId = @ClientId)
AND tsd.TimeSheetCategoryID = (select TimeSheetCategoryID from TimeSheetCategory where TimeSheetCategoryName='Leave')
AND tsd.TimeSheetSubcategoryID in (select TimeSheetSubcategoryID from TimeSheetSubcategory
where TimeSheetSubcategoryName IN ('PL','SL','BL', 'LOP', 'PAT'))
GROUP BY t.EmployeeID
),
HolidayHours AS (
SELECT t.EmployeeID, SUM(tsd.Value) As Holiday
FROM Timesheet t
Left Join TimesheetDetail tsd on t.TimesheetId=tsd.TimesheetId
where t.StatusId=4
AND t.WeekStartDate >=@startDate AND t.WeekEndDate<=@endDate
AND (ISNULL(@ClientId, 0) = 0 OR t.ClientId = @ClientId)
AND tsd.TimeSheetCategoryID = (select TimeSheetCategoryID from TimeSheetCategory where TimeSheetCategoryName='Holiday')
AND tsd.TimeSheetSubcategoryID in (select TimeSheetSubcategoryID from TimeSheetSubcategory
where TimeSheetSubcategoryName IN ('Regional Holiday','Floater Holiday','National Holiday'))
GROUP BY t.EmployeeID
),
ITActiveHours As (
SELECT EmpID, SUM(ITActiveHours) As ITHours
FROM EmployeeITProductivity
where startDate >=@startDate AND weekenddate<=@endDate
GROUP BY EmpID
),
TSProdNonProdHours AS (
select t.EmployeeId,
SUM(Case when sub.TimeSheetSubcategoryName= 'Non Technical Meetings' THEN tsd.Value
     when sub.TimeSheetSubcategoryName= 'Training Imparted' THEN tsd.Value
	 when sub.TimeSheetSubcategoryName= 'Self Learning' THEN tsd.Value
	 when sub.TimeSheetSubcategoryName= 'Training Attended - Non Technical' THEN tsd.Value
	 ELSE 0 END) As TsNonProdHours,
SUM(Case when sub.TimeSheetSubcategoryName NOT IN ('Non Technical Meetings','Training Imparted',
'Self Learning', 'Training Attended - Non Technical') THEN tsd.Value
ELSE 0 END) As TSProdHours
from Timesheet t
Left join TimesheetDetail tsd on t.TimesheetId=tsd.TimesheetId
Left Join TimeSheetCategory cat on tsd.TimeSheetCategoryID=cat.TimeSheetCategoryID
Left join TimeSheetSubcategory sub on tsd.TimeSheetSubcategoryID=sub.TimeSheetSubcategoryID
where t.StatusId=4
AND t.WeekStartDate >=@startDate AND t.WeekEndDate<=@endDate
AND (ISNULL(@ClientId, 0) = 0 OR t.ClientId = @ClientId)
Group By t.EmployeeID
)

SELECT et.Function_Type as FunctionType,
COUNT(DISTINCT em.EmployeeId) AS EmployeeCount,
COUNT(DISTINCT ats.EmployeeId) AS TimesheetSubmitted,
COALESCE(SUM(hh.Holiday),0) AS HolidayHours,
(COALESCE(SUM(ats.TotalHours),0)-COALESCE(SUM(hh.Holiday),0)- COALESCE(SUM(tth.TotalTimesheetHours),0)) AS TSActualHours,
((COUNT(DISTINCT em.EmployeeId)*(SELECT COUNT(*) AS Weekdays
FROM DateRange
WHERE DATEPART(WEEKDAY, Date) NOT IN (1, 7)) *8)-COALESCE(SUM(hh.Holiday),0)) AS TSExpectedHours,
ROUND((COUNT(DISTINCT ats.EmployeeID) * 100.0 / COUNT(DISTINCT em.EmployeeId)),2) AS TSCompliance
,COALESCE(SUM(tth.TotalTimesheetHours),0) AS LeaveHours,
COALESCE(SUM(tnh.TSProdHours),0) AS TSProdHours,
COALESCE(SUM(tnh.TsNonProdHours),0) AS TSNonProdHours,
COALESCE(SUM(ita.ITHours),0) AS ITHours,
COALESCE(SUM(wkh.WeekendHour),0) AS WeekEndHour,
ROUND(CASE WHEN SUM(ats.TotalHours) <> 0
THEN COALESCE(SUM(ats.TotalHours),0) *100/ COALESCE((COUNT(DISTINCT em.EmployeeId) *40),0)
ELSE
0
END,2) as UtilisationPer,
CASE WHEN SUM(ats.TotalHours) <> 0 AND SUM(tnh.TSProdHours) <> 0
THEN COALESCE(SUM(tnh.TSProdHours),0) *100/ COALESCE(SUM(ats.TotalHours),0)
ELSE
0
END as ProdPercent
FROM EmployeeType et
INNER JOIN EmployeeDetailsRanked edr ON et.Id =CONVERT(int, edr.Type) AND edr.RowNum = 1
INNER JOIN EmployeeMaster em ON edr.BhavnaEmployeeId = em.EmployeeId
INNER JOIN TeamMaster tm ON edr.TeamId = tm.Id  LEFT JOIN ITActiveHours ita ON em.EmployeeId=ita.EmpId
LEFT JOIN WeekEndHour wkh ON em.EmployeeId=wkh.EmployeeID
LEFT JOIN AggregatedTimesheets ats ON em.EmployeeId = ats.EmployeeID
LEFT JOIN TimesheetTotalHours tth ON em.EmployeeId=tth.EmployeeID
LEFT JOIN HolidayHours hh ON em.EmployeeId=hh.EmployeeID
LEFT JOIN TSProdNonProdHours tnh ON em.EmployeeId=tnh.EmployeeId
WHERE (ISNULL(@ClientId, 0) = 0 OR tm.ClientId = @ClientId)
AND (ET.Function_Type='Dev'
OR ET.Function_Type='QA'
OR ET.Function_Type='SM'
OR ET.Function_Type='PMO'
OR ET.Function_Type='BA'
OR ET.Function_Type='Analyst')
AND ((em.IsDeleted <> 1 AND em.isTimesheetRequired <> 0) OR ats.EmployeeID IS NOT NULL)
GROUP BY et.Function_Type

SELECT sub.TimeSheetSubcategoryName as SubCategory,
COUNT(DISTINCT ts.EmployeeID) AS EmployeeCount,
SUM(tsd.Value) as TSHours
FROM Timesheet ts
inner join TimesheetDetail tsd on ts.TimesheetId=tsd.TimesheetId
inner join TimeSheetCategory cat on tsd.TimeSheetCategoryID= cat.TimeSheetCategoryID
inner join TimeSheetSubcategory sub on tsd.TimeSheetSubcategoryID= sub.TimeSheetSubcategoryID
where ts.StatusId=4
AND ts.WeekStartDate >=@startDate AND ts.WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ts.ClientId = @ClientId)
and tsd.TimeSheetCategoryID= (select TimeSheetCategoryID from TimeSheetCategory where TimeSheetCategoryName = 'Common')
and sub.TimeSheetSubcategoryName IN ('Self Learning', 'Non Technical Meetings', 'Training Imparted', 'Training Attended - Non Technical')
GROUP BY sub.TimeSheetSubcategoryName;

WITH EmployeeDetailsRows AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY BhavnaEmployeeId ORDER BY TeamId) AS RowNum FROM EmployeeDetails
)
select ET.Function_Type as EmployeeType,
tc.TimeSheetCategoryName as CategoryName,
SUM(td.value) as Hours from  Timesheet ts
inner join EmployeeDetailsRows edr ON ts.EmployeeID =edr.BhavnaEmployeeId AND edr.RowNum = 1
inner join EmployeeType et on edr.Type = et.Id
inner join TimesheetDetail td on ts.TimesheetId=td.TimesheetId
inner join TimeSheetCategory tc on Td.TimeSheetCategoryID= tc.TimeSheetCategoryID
where ts.StatusId=4 AND ts.WeekStartDate >=@startDate AND ts.WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ts.ClientId = @ClientId)
AND (ET.Function_Type='Dev'
OR ET.Function_Type='QA'
OR ET.Function_Type='SM'
OR ET.Function_Type='PMO'
OR ET.Function_Type='BA'
OR ET.Function_Type='Analyst')
Group by et.Function_Type, tc.TimeSheetCategoryName
END

-- =============================================
-- Author:  <Akash Maurya>
-- Create date: <6/21/2024>
-- Description: <Added Approver Section to get Self Timesheet for getTimesheetDataStatusWise>

-- =============================================
GO
CREATE OR ALTER  PROCEDURE [dbo].[usp_getTimesheetDataStatusWise]   --3,'akash.maurya@bhavnacorp.com',12,'2024-06-09','2024-06-22',0,'',0,true
 @StatusID int,
  @EmailId varchar(200),
  @ClientId NVARCHAR(MAX) = '',
  @StartDate Datetime,
  @EndDate Datetime,
  @IsApproverPending bit,
  @SearchedText varchar(50),
  @SkipRows int,
  @ShowSelfRecordsToggle bit
AS
BEGIN
    DECLARE @EmpId varchar(50)
    Select @EmpId=EmployeeId from EmployeeMaster Where EmailId=@EmailId
    DECLARE @EmployeeRole varchar(200)
    DECLARE @TakeRows int= 10
    Select @EmployeeRole=r.RoleName from EmployeeRoles er  inner join Roles r on er.RoleId=r.RoleId where er.EmployeeId = @EmpId

    create table #tempEmployeeData(TimesheetId int,CreatedDate datetime, ApprovedDate datetime, WeekStartDate datetime, WeekEndDate datetime,
    SubmissionDate datetime,TotalCount int, StatusName varchar(30), Remarks nvarchar(max), EmployeeId varchar(50),
    ClientName varchar(400),TotalHours decimal, EmployeeName varchar(200),
     EmailId varchar(200))

  IF @StatusID=1 OR @IsApproverPending=1
  OR @EmployeeRole = 'Employee'
  OR (@EmployeeRole='Admin' AND (@StatusID = 3 OR @StatusID = 4 OR @StatusID = 2) AND @ShowSelfRecordsToggle=1)
  OR (@EmployeeRole='Reporting_Manager' AND (@StatusID = 3 OR @StatusID = 4) AND @ShowSelfRecordsToggle=1)
  OR (@EmployeeRole='Approver' AND (@StatusID = 3 OR @StatusID = 4) AND @ShowSelfRecordsToggle=1)
  begin
  insert into #tempEmployeeData
  exec usp_getTimesheetDataStatusWise_Employee @StatusID, @SkipRows, @EmpId, @TakeRows, @SearchedText
  end
  else
  begin
    IF @EmployeeRole='Admin'
    begin
    insert into #tempEmployeeData
    exec usp_getTimesheetDataStatusWise_Admin @StatusID, @StartDate, @EndDate,  @SkipRows, @EmpId, @TakeRows, @SearchedText, @ClientId
    end
    else if EXISTS(SELECT * FROM EmployeeDetails WHERE (timesheetManagerId=@EmpId Or timesheetApproverId1=@EmpId Or timesheetApproverId2=@empId))
    begin
    insert into #tempEmployeeData
    exec usp_getTimesheetDataStatusWise_Manager @StatusID, @StartDate, @EndDate,  @SkipRows, @EmpId, @TakeRows, @SearchedText, @ClientId
end
end
select * from #tempEmployeeData
  DROP table #tempEmployeeData
END
GO

GO


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

-- =============================================
-- Author:		<Akash Maurya>
-- Create date: <26-06-2024>
-- Description:	<Now Manager will be able to see day wise report of its own employee only>
/****** Object:  StoredProcedure [dbo].[usp_getTimesheetDayWiseReport]    Script Date: 6/26/2024 2:37:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
				DECLARE @EmployeeId VARCHAR(50)='';
				DECLARE @Client INT;
				SELECT TOP(1) @Role=Roles.RoleName, @Client= team.ClientId, @EmployeeId=EmployeeMaster.EmployeeId FROM EmployeeMaster
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
					INNER JOIN Timesheet t ON ed.BhavnaEmployeeId=t.EmployeeID And ed.TimesheetManagerId=@EmployeeId
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
					AND (@StatusId = 0 or t.StatusID = @StatusId);
		END
END

GO

-- =============================================
-- Author:	<Suramit Pramanik>
-- Create date: <7/04/2024>
-- Description:	<Added Submission date for the AutoSubmit>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[usp_submitTimesheetAndGetEmails]
@WeekStartDate datetime,
@WeekEndDate datetime
AS
BEGIN
 Select EmailId from Timesheet tm Inner Join EmployeeMaster empM on tm.EmployeeID=empM.EmployeeId Where  WeekStartDate =@WeekStartDate And WeekEndDate=@WeekEndDate And StatusId=1
 Update Timesheet set StatusId=2 , SubmissionDate = CURRENT_TIMESTAMP where WeekStartDate =@WeekStartDate And WeekEndDate=@WeekEndDate And StatusId=1
End

GO
-- =============================================
-- Author:	<Akash Maurya>
-- Create date: <07/08/2024>
-- Description:	<Timesheet Submission report based omn WeekStartDate and WeekEndDate>
-- =============================================

Create or ALTER PROCEDURE [dbo].[usp_getTimesheetSubmissionReport] --'akash.maurya@bhavnacorp.com',0,0,0,'2024-06-16 00:00:00.000', '2024-07-06 00:00:00.000'
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
				ISNULL(CONVERT(varchar, CAST(t.WeekStartDate AS DATE),120),'') AS WeekStartDate,
				ISNULL(CONVERT(varchar, CAST(t.WeekEndDate AS DATE),120),'') AS WeekEndDate,
				ISNULL(ts.StatusName, '') AS Status,
				ISNULL(CONVERT(VARCHAR,t.TotalHours), '') AS TotalHours
				FROM EmployeeDetails ed
				LEFT JOIN Timesheet t ON ed.BhavnaEmployeeId = t.EmployeeID
				LEFT JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
					WHERE (@ClientId = 0 OR t.ClientId = @ClientId)
							AND (@TeamId = 0 OR t.TeamId = @TeamId) AND
							(t.WeekStartDate >= @StartDate AND t.WeekEndDate <= @EndDate)
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
				LEFT JOIN Timesheet t ON ed.BhavnaEmployeeId = t.EmployeeID
				LEFT JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
				INNER JOIN EmployeeRoles er ON ed.BhavnaEmployeeId  = er.EmployeeId
					WHERE (t.ClientId = @Client) AND
					(@TeamId = 0 OR t.TeamId = @TeamId) AND
							(t.WeekStartDate >= @StartDate AND t.WeekEndDate <= @EndDate)
							AND ( er.RoleId != 1 ) AND (@StatusId = 0 or t.StatusID = @StatusId)
					ORDER BY
				ed.EmployeeName desc;
		END
END
-- =============================================
-- Author:  <Chetna Upadhyay>
-- Create date: <7/9/2024>
-- Description: <Get list of soft delete employees>
-- =============================================
GO
CREATE OR ALTER PROCEDURE GetSoftDeleteEmployeeList
AS
BEGIN
  SELECT EM.EmployeeId, EM.FullName AS EmployeeName,  ET.Function_Type AS FunctionType,
CM.ClientName, TM.TeamName, EM.EmailId, EM.ExperienceYear
  FROM EmployeeMaster EM
  LEFT JOIN EmployeeDetails ED ON ED.BhavnaEmployeeId = EM.EmployeeId
  LEFT JOIN EmployeeType ET ON ET.Id = ED.Type
  LEFT JOIN TeamMaster TM ON TM.Id = ED.TeamId
  LEFT JOIN ClientMaster CM ON CM.Id = TM.ClientId
   WHERE EM.IsDeleted=1 AND ED.IsDeleted=1
END;
GO

-- =============================================
-- Author:  <Chetna Upadhyay>
-- Create date: <7/9/2024>
-- Description: <Hard delete Employee By Id>
-- =============================================
CREATE OR ALTER PROCEDURE HardDeleteEmployeeByIds (@EmployeeIds NVARCHAR(MAX))
AS
BEGIN
  DECLARE @EmployeeId NVARCHAR(50);
  WHILE CHARINDEX(',', @EmployeeIds) > 0
  BEGIN
    SELECT @EmployeeId = SUBSTRING(@EmployeeIds, 1, CHARINDEX(',', @EmployeeIds) - 1);
    SET @EmployeeIds = SUBSTRING(@EmployeeIds, CHARINDEX(',', @EmployeeIds) + 1, LEN(@EmployeeIds));
    DELETE FROM EmployeeMaster WHERE EmployeeId = @EmployeeId;
	DELETE FROM EmployeeDetails WHERE BhavnaEmployeeId = @EmployeeId
	DELETE FROM EmployeeRoles WHERE EmployeeId = @EmployeeId
  END;

  IF LEN(@EmployeeIds) > 0
  BEGIN
    SET @EmployeeId = @EmployeeIds;
    DELETE FROM EmployeeMaster WHERE EmployeeId = @EmployeeId;
	DELETE FROM EmployeeDetails WHERE BhavnaEmployeeId = @EmployeeId
	DELETE FROM EmployeeRoles WHERE EmployeeId = @EmployeeId
  END;
END;
GO

-- =============================================
-- Author:  <Chetna Upadhyay>
-- Create date: <7/9/2024>
-- Description: <Recover Delete Employee By Id>
-- =============================================
CREATE OR ALTER PROCEDURE RecoverDeleteEmployeeByIds (@EmployeeIds NVARCHAR(MAX))
AS
BEGIN
  DECLARE @EmployeeId NVARCHAR(50);
  WHILE CHARINDEX(',', @EmployeeIds) > 0
  BEGIN
    SELECT @EmployeeId = SUBSTRING(@EmployeeIds, 1, CHARINDEX(',', @EmployeeIds) - 1);
    SET @EmployeeIds = SUBSTRING(@EmployeeIds, CHARINDEX(',', @EmployeeIds) + 1, LEN(@EmployeeIds));
    UPDATE EmployeeMaster SET IsDeleted=0
	WHERE EmployeeId = @EmployeeId;
	UPDATE EmployeeDetails SET IsDeleted =0
	WHERE BhavnaEmployeeId = @EmployeeId
  END;

  IF LEN(@EmployeeIds) > 0
  BEGIN
    SET @EmployeeId = @EmployeeIds;
    UPDATE EmployeeMaster SET IsDeleted=0
	WHERE EmployeeId = @EmployeeId;
	UPDATE EmployeeDetails SET IsDeleted =0
	WHERE BhavnaEmployeeId = @EmployeeId
  END;
END;
GO

GO

 ---------------------------
ALTER TABLE EmployeeDetails
ADD IsDeleted int


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,Arpit verma>
-- Create date: <27/06/2024>
-- Description:	<to soft delete the employee from master and detail table>
-- =============================================
CREATE PROCEDURE usp_softDeleteEmployee
	@EmpId int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE EmployeeMaster SET IsDeleted = 1 WHERE EmployeeId=@EmpId;
	Update EmployeeDetails Set IsDeleted = 1 WHERE BhavnaEmployeeId=@EmpId
END
GO


-----------------------
-- if is deleted column values are null  then run this first else don't
-----------------------
UPDATE EmployeeDetails
SET IsDeleted = 0;
-------------------------

USE [Automation]
GO
/****** Object:  StoredProcedure [dbo].[usp_getEmployeeDetailByEmailId]    Script Date: 7/3/2024 2:52:18 PM updated by -Arpit verma ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_getEmployeeDetailByEmailId]-- 'arpit.verma@bhavnacorp.com'
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100)= '';
 DECLARE @TeamId INT;
 DECLARE @EmployeeId VARCHAR(50);

SELECT TOP(1) @TeamId=EmployeeDetails.TeamId, @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId
FROM EmployeeMaster
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.BhavnaEmployeeId
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
SELECT * FROM EmployeeDetails where IsDeleted=0;
END
ELSE IF (@Role = 'Reporting_Manager')
BEGIN
SELECT * FROM EmployeeDetails WHERE TeamId = @TeamId And IsDeleted=0;
END
ELSE IF (@Role = 'EMPLOYEE')
BEGIN
SELECT * FROM EmployeeDetails WHERE BhavnaEmployeeId  = @EmployeeId
END

END
END

-- =============================================
-- Author:	<Suramit Pramanik>
-- Create date: <10/07/2024>
-- Description:	<Validating Null, Empty And Domain Emails >
-- =============================================
GO
CREATE OR ALTER PROCEDURE [dbo].[usp_getEmployeeDetailsByTeamId]

@TeamId INT = 0

AS

BEGIN

    IF @TeamId > 0

        BEGIN

            select EmployeeDetails.TeamId, EmployeeDetails.Type,EmployeeMaster.EmployeeId, EmployeeMaster.DesignationId, EmployeeRoles.RoleId, EmployeeDetails.EmployeeName  from EmployeeDetails

            full join EmployeeMaster on EmployeeMaster.EmployeeId = EmployeeDetails.BhavnaEmployeeId

            full join EmployeeRoles on EmployeeRoles.EmployeeId = EmployeeDetails.BhavnaEmployeeId

            where EmployeeDetails.TeamId = @TeamId

        END

    Else

	    BEGIN

	        select * from EmployeeMaster where EmailId is NOT NULL AND EmailId != '' AND EmailId Like '%@bhavnacorp.com%'

	    END

End
GO

-- =============================================
-- Author:	<Suramit Pramanik>
-- Create date: <10/07/2024>
-- Description:	<Get Manager And Approver for Employee>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[usp_GetManagerAndApprover]
@EmployeeId VARCHAR(150)
As
BEGIN
SELECT
    em1.FullName AS TimesheetManagerName,
    em2.FullName AS TimesheetApproverName
FROM EmployeeDetails ed
INNER JOIN EmployeeMaster em1 ON ed.TimesheetManagerId = em1.EmployeeId
INNER JOIN EmployeeMaster em2 ON ed.TimesheetApproverId1 = em2.EmployeeId
where ed.BhavnaEmployeeId= @EmployeeId
END;

GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Arpit Verma>
-- Create date: <7/11/24>
-- Description:	<to get the Adrenaline Leave hours>
-- =============================================
--select * from ClientMaster
CREATE Or ALTER PROCEDURE [dbo].[usp_AdrenalineLeave]-- '2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000',37
 @startDate datetime,
 @endDate datetime,
 @clientId int
AS
BEGIN
	SET NOCOUNT ON;

SELECT SUM(et.Leave) As TotalLeaves
FROM EmployeeITProductivity et
inner Join EmployeeDetails t on t.BhavnaEmployeeId=et.EmpId inner join TeamMaster tm on t.TeamId=tm.Id
inner join ClientMaster cm on cm.Id=tm.ClientId
where  et.startDate >=@startDate AND et.weekenddate<=@endDate
AND (ISNULL(@ClientId, 0) = 0 OR tm.ClientId = @ClientId)
group by cm.ClientName
END
GO

-- =============================================
-- Author:  <Akash Maurya>
-- Create date: <7/10/2024>
-- Description: <Get Pdf report>
-- =============================================
ALTER PROCEDURE [dbo].[usp_getTimesheetPdfReport] --'2024-06-16 00:00:00.000', '2024-06-22 00:00:00.000',1
@startDate datetime,
@endDate datetime,
@ClientId int
AS
BEGIN

WITH AggregatedTimesheets AS (
SELECT EmployeeID,SUM (TotalHours) AS TotalHours FROM Timesheet WHERE StatusId=4
AND WeekStartDate >=@startDate AND WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ClientId = @ClientId)
GROUP BY EmployeeID
),
WeekEndHour as  (select  t.EmployeeId , Sum(td.Value) As WeekendHour from TimesheetDetail td inner join Timesheet t ON t.TimesheetId= td.TimesheetId where td.Date=t.WeekStartDate OR td.Date=t.WeekEndDate GROUP BY t.EmployeeID),
EmployeeDetailsRanked AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY BhavnaEmployeeId ORDER BY TeamId) AS RowNum FROM EmployeeDetails
),
TimesheetTotalHours AS (
SELECT t.EmployeeID, SUM(tsd.Value) As TotalTimesheetHours
FROM Timesheet t
Left Join TimesheetDetail tsd on t.TimesheetId=tsd.TimesheetId
where t.StatusId=4
AND t.WeekStartDate >=@startDate AND t.WeekEndDate<=@endDate
AND (ISNULL(@ClientId, 0) = 0 OR t.ClientId = @ClientId)
AND tsd.TimeSheetCategoryID = (select TimeSheetCategoryID from TimeSheetCategory where TimeSheetCategoryName='Leave')
AND tsd.TimeSheetSubcategoryID in (select TimeSheetSubcategoryID from TimeSheetSubcategory where TimeSheetSubcategoryName IN ('PL','SL','BL', 'LOP', 'PAT'))
GROUP BY t.EmployeeID
),
ITActiveHours As (
SELECT EmpID, SUM(ITActiveHours) As ITHours
FROM EmployeeITProductivity
where startDate >=@startDate AND weekenddate<=@endDate
GROUP BY EmpID
),
TSProdNonProdHours AS (
select t.EmployeeId,
SUM(Case when sub.TimeSheetSubcategoryName= 'Non Technical Meetings' THEN tsd.Value
     when sub.TimeSheetSubcategoryName= 'Training Imparted' THEN tsd.Value
	 when sub.TimeSheetSubcategoryName= 'Self Learning' THEN tsd.Value
	 when sub.TimeSheetSubcategoryName= 'Training Attended - Non Technical' THEN tsd.Value
	 ELSE 0 END) As TsNonProdHours,
SUM(Case when sub.TimeSheetSubcategoryName NOT IN ('Non Technical Meetings','Training Imparted',
'Self Learning', 'Training Attended - Non Technical') THEN tsd.Value
ELSE 0 END) As TSProdHours
from Timesheet t
Left join TimesheetDetail tsd on t.TimesheetId=tsd.TimesheetId
Left Join TimeSheetCategory cat on tsd.TimeSheetCategoryID=cat.TimeSheetCategoryID
Left join TimeSheetSubcategory sub on tsd.TimeSheetSubcategoryID=sub.TimeSheetSubcategoryID
where t.StatusId=4
AND t.WeekStartDate >=@startDate AND t.WeekEndDate<=@endDate
AND (ISNULL(@ClientId, 0) = 0 OR t.ClientId = @ClientId)
Group By t.EmployeeID
)

SELECT et.Function_Type as FunctionType,
COUNT(DISTINCT em.EmployeeId) AS EmployeeCount,
COALESCE(SUM(ats.TotalHours),0) AS TSActualHours,
COUNT(DISTINCT em.EmployeeId) *40 as TSExpectedHours,
ROUND((COUNT(DISTINCT ats.EmployeeID) * 100.0 / COUNT(DISTINCT em.EmployeeId)),2) AS TSCompliance,
COUNT (DISTINCT ats.EmployeeId) AS TimesheetSubmitted,
COALESCE(SUM(tth.TotalTimesheetHours),0) AS LeaveHours,
COALESCE(SUM(tnh.TSProdHours),0) AS TSProdHours,
COALESCE(SUM(tnh.TsNonProdHours),0) AS TSNonProdHours,
COALESCE(SUM(ita.ITHours),0) AS ITHours,
COALESCE(SUM(wkh.WeekendHour),0) AS WeekEndHour,
ROUND(CASE WHEN SUM(ats.TotalHours) <> 0
THEN COALESCE(SUM(ats.TotalHours),0) *100/ COALESCE((COUNT(DISTINCT em.EmployeeId) *40),0)
ELSE
0
END,2) as UtilisationPer,
CASE WHEN SUM(ats.TotalHours) <> 0 AND SUM(tnh.TSProdHours) <> 0
THEN COALESCE(SUM(tnh.TSProdHours),0) *100/ COALESCE(SUM(ats.TotalHours),0)
ELSE
0
END as ProdPercent
FROM EmployeeType et
INNER JOIN EmployeeDetailsRanked edr ON et.Id =CONVERT(int, edr.Type) AND edr.RowNum = 1
INNER JOIN EmployeeMaster em ON edr.BhavnaEmployeeId = em.EmployeeId
INNER JOIN TeamMaster tm ON edr.TeamId = tm.Id  LEFT JOIN ITActiveHours ita ON em.EmployeeId=ita.EmpId
LEFT JOIN WeekEndHour wkh ON em.EmployeeId=wkh.EmployeeID
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
where ts.StatusId=4
AND ts.WeekStartDate >=@startDate AND ts.WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ts.ClientId = @ClientId)
and tsd.TimeSheetCategoryID= (select TimeSheetCategoryID from TimeSheetCategory where TimeSheetCategoryName = 'Common')
and sub.TimeSheetSubcategoryName IN ('Self Learning', 'Non Technical Meetings', 'Training Imparted', 'Training Attended - Non Technical')
GROUP BY sub.TimeSheetSubcategoryName;

WITH EmployeeDetailsRows AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY BhavnaEmployeeId ORDER BY TeamId) AS RowNum FROM EmployeeDetails
)
select ET.Function_Type as EmployeeType,
tc.TimeSheetCategoryName as CategoryName,
SUM(td.value) as Hours from  Timesheet ts
inner join EmployeeDetailsRows edr ON ts.EmployeeID =edr.BhavnaEmployeeId AND edr.RowNum = 1
inner join EmployeeType et on edr.Type = et.Id
inner join TimesheetDetail td on ts.TimesheetId=td.TimesheetId
inner join TimeSheetCategory tc on Td.TimeSheetCategoryID= tc.TimeSheetCategoryID
where ts.StatusId=4 AND ts.WeekStartDate >=@startDate AND ts.WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ts.ClientId = @ClientId)
Group by et.Function_Type, tc.TimeSheetCategoryName
END

-- =============================================
-- Author:	<Suramit Pramanik>
-- Create date: <10/07/2024>
-- Description:	<Validating Null, Empty And Domain Emails >
-- =============================================
GO
CREATE OR ALTER PROCEDURE [dbo].[usp_getEmployeeDetailsByTeamId]

@TeamId INT = 0

AS

BEGIN

    IF @TeamId > 0

        BEGIN

            select EmployeeDetails.TeamId, EmployeeDetails.Type,EmployeeMaster.EmployeeId, EmployeeMaster.DesignationId, EmployeeRoles.RoleId, EmployeeDetails.EmployeeName  from EmployeeDetails

            full join EmployeeMaster on EmployeeMaster.EmployeeId = EmployeeDetails.BhavnaEmployeeId

            full join EmployeeRoles on EmployeeRoles.EmployeeId = EmployeeDetails.BhavnaEmployeeId

            where EmployeeDetails.TeamId = @TeamId

        END

    Else

	    BEGIN

	        select * from EmployeeMaster where EmailId is NOT NULL AND EmailId != '' AND EmailId Like '%@bhavnacorp.com%'

	    END

End
GO

-- =============================================
-- Author:	<Suramit Pramanik>
-- Create date: <10/07/2024>
-- Description:	<Get Manager And Approver for Employee>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[usp_GetManagerAndApprover]
@EmployeeId VARCHAR(150)
As
BEGIN
SELECT
    em1.FullName AS TimesheetManagerName,
    em2.FullName AS TimesheetApproverName
FROM EmployeeDetails ed
INNER JOIN EmployeeMaster em1 ON ed.TimesheetManagerId = em1.EmployeeId
INNER JOIN EmployeeMaster em2 ON ed.TimesheetApproverId1 = em2.EmployeeId
where ed.BhavnaEmployeeId= @EmployeeId
END;

GO

-- =============================================
-- Author:	<Suramit Pramanik>
-- Create date: <26/07/2024>
-- Description:	<HR can also see all client and Teams like ADMIN for Assign Manager and Approver>
-- =============================================
ALTER   PROCEDURE [dbo].[usp_getClientMasterByEmployeeId] --'sthakur@bhavnacorp.com'
@EmailId VARCHAR(150),
@IsWithTeam bit=0
AS
BEGIN
SET NOCOUNT ON
IF @EmailId IS NOT NULL

BEGIN
DECLARE @Role VARCHAR(100) = '';
DECLARE @ClientId INT;

SELECT TOP(1) @ClientId=TeamMaster.ClientId, @Role=Roles.RoleName FROM EmployeeMaster
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.BhavnaEmployeeId
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

declare @sql Nvarchar(max)
--FILTER RECORD USING ROLE
IF (@Role = 'ADMIN' OR @Role='HR')
BEGIN
	IF (@IsWithTeam =0)
		BEGIN
		 set @sql='SELECT * FROM ClientMaster'
		END
		ELSE
		BEGIN
			 set @sql=	'SELECT distinct client.* FROM ClientMaster client
						INNER join TeamMaster team on client.Id= team.ClientId
						WHERE  team.Id is not null'
		END

END
ELSE IF (@Role = 'Reporting_Manager' OR @Role='Approver')
BEGIN
			set @sql='SELECT * FROM ClientMaster where Id  = '+  cast( @ClientId as varchar)



END
ELSE IF (@Role = 'EMPLOYEE')
	BEGIN
		    set @sql='SELECT distinct client.* FROM ClientMaster client
						INNER join TeamMaster team on client.Id= team.ClientId
						WHERE  team.Id is not null and client.Id  = '+ cast( @ClientId as varchar)


END
 print @sql
EXECUTE 	sp_executesql @sql
END
END
GO

-- =============================================
-- Author:	<Suramit Pramanik>
-- Create date: <26/07/2024>
-- Description:	<For SoftDelete EmployeeID change from Int to Varchar>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[usp_softDeleteEmployee]
	@EmpId varchar(150)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE EmployeeMaster SET IsDeleted = 1 WHERE EmployeeId=@EmpId;
	Update EmployeeDetails Set IsDeleted = 1 WHERE BhavnaEmployeeId=@EmpId
END
GO

-- =============================================
-- Author:	<Suramit Pramanik>
-- Create date: <26/07/2024>
-- Description:	<Insert HR Role into Roles table>
-- =============================================
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'HR')
BEGIN
    INSERT INTO [dbo].[Roles] ([RoleName], [CreatedDate], [UpdatedDate], [IsActive])
    VALUES ('HR', GETDATE(), GETDATE(), 1)
END
GO

-- =============================================
-- Author:	<Suramit Pramanik>
-- Create date: <26/07/2024>
-- Description:	<Insert HRRoleId for access into ApplicationMaster table>
-- =============================================

IF NOT EXISTS(SELECT 1 FROM [dbo].[ApplicationMaster] WHERE [RoleId] = 5)
BEGIN
INSERT INTO [dbo].[ApplicationMaster] ([ApplicationName], [ApplicationDescription], [RoleId], [ApplicationPath],[CanView],[CanEdit],[CanDelete])
    VALUES	('HR-Management','HRmanagement',5,'/hr-management',1,1,1)
END
GO

-- =============================================
-- Author:	<Chetna Upadhyay>
-- Create date: <28/07/2024>
-- Description:	<Get Employee List By Team Id>
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_getEmployeeDetailsByTeamId]
@TeamId INT = 0
AS
BEGIN
SET NOCOUNT ON
 IF @TeamId > 0

BEGIN
select EmployeeDetails.TeamId, EmployeeDetails.BhavnaEmployeeId,EmployeeDetails.Type, EmployeeMaster.EmailId,
EmployeeMaster.EmployeeId, EmployeeMaster.DesignationId, EmployeeType.Function_Type as FunctionType,
EmployeeRoles.RoleId AS Role, EmployeeMaster.FullName As EmployeeName  from EmployeeDetails
full join EmployeeMaster on EmployeeMaster.EmployeeId = EmployeeDetails.BhavnaEmployeeId
full join EmployeeRoles on EmployeeRoles.EmployeeId = EmployeeDetails.BhavnaEmployeeId
full join EmployeeType on EmployeeType.Id = EmployeeDetails.Type
where EmployeeDetails.TeamId = @TeamId ORDER BY EmployeeMaster.FullName
END
Else
	begin
	select * from EmployeeMaster
	end
End

-- =============================================
-- Author:  <Suramit Pramanik>
-- Create date: <02/08/2024>
-- Description: <Added HR Section to get Self Timesheet for getTimesheetDataStatusWise>
-- =============================================
GO
ALTER    PROCEDURE [dbo].[usp_getTimesheetDataStatusWise]   --3,'akash.maurya@bhavnacorp.com',12,'2024-06-09','2024-06-22',0,'',0,true
 @StatusID int,
  @EmailId varchar(200),
  @ClientId NVARCHAR(MAX) = '',
  @StartDate Datetime,
  @EndDate Datetime,
  @IsApproverPending bit,
  @SearchedText varchar(50),
  @SkipRows int,
  @ShowSelfRecordsToggle bit
AS
BEGIN
    DECLARE @EmpId varchar(50)
    Select @EmpId=EmployeeId from EmployeeMaster Where EmailId=@EmailId
    DECLARE @EmployeeRole varchar(200)
    DECLARE @TakeRows int= 10
    Select @EmployeeRole=r.RoleName from EmployeeRoles er  inner join Roles r on er.RoleId=r.RoleId where er.EmployeeId = @EmpId

    create table #tempEmployeeData(TimesheetId int,CreatedDate datetime, ApprovedDate datetime, WeekStartDate datetime, WeekEndDate datetime,
    SubmissionDate datetime,TotalCount int, StatusName varchar(30), Remarks nvarchar(max), EmployeeId varchar(50),
    ClientName varchar(400),TotalHours decimal, EmployeeName varchar(200),
     EmailId varchar(200))

  IF @StatusID=1 OR @IsApproverPending=1
  OR @EmployeeRole = 'Employee'
  OR (@EmployeeRole='Admin' AND (@StatusID = 3 OR @StatusID = 4 OR @StatusID = 2) AND @ShowSelfRecordsToggle=1)
  OR (@EmployeeRole='Reporting_Manager' AND (@StatusID = 3 OR @StatusID = 4) AND @ShowSelfRecordsToggle=1)
  OR (@EmployeeRole='Approver' AND (@StatusID = 3 OR @StatusID = 4) AND @ShowSelfRecordsToggle=1)
  OR (@EmployeeRole='HR' AND (@StatusID = 3 OR @StatusID = 4) AND @ShowSelfRecordsToggle=1)
  begin
  insert into #tempEmployeeData
  exec usp_getTimesheetDataStatusWise_Employee @StatusID, @SkipRows, @EmpId, @TakeRows, @SearchedText
  end
  else
  begin
    IF @EmployeeRole='Admin'
    begin
    insert into #tempEmployeeData
    exec usp_getTimesheetDataStatusWise_Admin @StatusID, @StartDate, @EndDate,  @SkipRows, @EmpId, @TakeRows, @SearchedText, @ClientId
    end
    else if EXISTS(SELECT * FROM EmployeeDetails WHERE (timesheetManagerId=@EmpId Or timesheetApproverId1=@EmpId Or timesheetApproverId2=@empId))
    begin
    insert into #tempEmployeeData
    exec usp_getTimesheetDataStatusWise_Manager @StatusID, @StartDate, @EndDate,  @SkipRows, @EmpId, @TakeRows, @SearchedText, @ClientId
end
end
select * from #tempEmployeeData
  DROP table #tempEmployeeData
END
GO

-- =============================================
-- Author:	<Suramit Pramanik>
-- Create date: <02/08/2024>
-- Description:	<TImesheet Access for HR role in ApplicationMaster>
-- =============================================

 IF NOT EXISTS(SELECT 1 FROM [dbo].[ApplicationMaster] WHERE [RoleId] = 5 AND [ApplicationPath] = '/timesheet')
BEGIN
INSERT INTO [dbo].[ApplicationMaster] ([ApplicationName], [ApplicationDescription], [RoleId], [ApplicationPath],[CanView],[CanEdit],[CanDelete])
    VALUES	('Timesheet','Timesheet application ',5,'/timesheet',1,1,1)
END

-- =============================================
-- Modified BY:	<Suramit Pramanik>
-- Modified date: <06/08/2024>
-- Description:	<Timesheet Submission report for HR role like Reporting Manager>
-- =============================================
GO
CREATE OR ALTER PROCEDURE [dbo].[usp_getTimesheetSubmissionReport] --'akash.maurya@bhavnacorp.com',0,0,0,'2024-06-16 00:00:00.000', '2024-07-06 00:00:00.000'
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
				ISNULL(CONVERT(varchar, CAST(t.WeekStartDate AS DATE),120),'') AS WeekStartDate,
				ISNULL(CONVERT(varchar, CAST(t.WeekEndDate AS DATE),120),'') AS WeekEndDate,
				ISNULL(ts.StatusName, '') AS Status,
				ISNULL(CONVERT(VARCHAR,t.TotalHours), '') AS TotalHours
				FROM EmployeeDetails ed
				LEFT JOIN Timesheet t ON ed.BhavnaEmployeeId = t.EmployeeID
				LEFT JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
					WHERE (@ClientId = 0 OR t.ClientId = @ClientId)
							AND (@TeamId = 0 OR t.TeamId = @TeamId) AND
							(t.WeekStartDate >= @StartDate AND t.WeekEndDate <= @EndDate)
							AND (@StatusId = 0 or t.StatusID = @StatusId)
							ORDER BY
				ed.EmployeeName desc;
		END
		Else IF (@Role = 'Reporting_Manager' OR @Role = 'HR')
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
				LEFT JOIN Timesheet t ON ed.BhavnaEmployeeId = t.EmployeeID
				LEFT JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
				INNER JOIN EmployeeRoles er ON ed.BhavnaEmployeeId  = er.EmployeeId
					WHERE (t.ClientId = @Client) AND
					(@TeamId = 0 OR t.TeamId = @TeamId) AND
							(t.WeekStartDate >= @StartDate AND t.WeekEndDate <= @EndDate)
							AND ( er.RoleId != 1 ) AND (@StatusId = 0 or t.StatusID = @StatusId)
					ORDER BY
				ed.EmployeeName desc;
		END
END
GO

-- =============================================
-- Modified BY:	<Suramit Pramanik>
-- Modified date: <06/08/2024>
-- Description:	<Timesheet Daywise(Detail Report) report for HR role like Reporting Manager>
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
				DECLARE @EmployeeId VARCHAR(50)='';
				DECLARE @Client INT;
				SELECT TOP(1) @Role=Roles.RoleName, @Client= team.ClientId, @EmployeeId=EmployeeMaster.EmployeeId FROM EmployeeMaster
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
		Else IF (@Role = 'Reporting_Manager' OR @Role ='HR')
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
					INNER JOIN Timesheet t ON ed.BhavnaEmployeeId=t.EmployeeID And ed.TimesheetManagerId=@EmployeeId
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
					AND (@StatusId = 0 or t.StatusID = @StatusId);
		END
END
GO



-- =============================================
-- Author:  <Chetna Upadhyay>
-- Create date: <7/11/2024>
-- Description: <Get Client Manager Team List>
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE OR ALTER PROCEDURE usp_getClientManagerTeamList
  @clientId INT,
  @employeeId VARCHAR(200)
  AS
  BEGIN
  SELECT DISTINCT(ED.TeamId) AS Id, TM.ClientId, TM.TeamName, TM.TeamDescription, TM.CreatedOn, TM.ModifiedOn
  FROM EmployeeDetails AS ED inner join TeamMaster AS TM
  ON TM.Id=ED.TeamId WHERE ED.TimesheetManagerId=@employeeId and TM.ClientId=@clientId
  END

-- =============================================
-- Author:  <Chetna Upadhyay>
-- Create date: <7/11/2024>
-- Description: <Get Timesheet Email Data>
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[usp_getTimesheetEmailData]
@EmailId VARCHAR(150),
@ClientId INT,
@TeamId INT,
@StartDate DATETIME,
@EndDate DATETIME,
@IsTimesheetCreated VARCHAR(3),
@IsTimesheetSubmitted VARCHAR(3)
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
				empM.EmailId AS EmailId,
				cm.ClientName AS Project,
				ISNULL(CONVERT(Date, CAST(t.Created AS DATE),120),'') AS CreatedDate,
				ISNULL(CONVERT(Date, CAST(t.SubmissionDate AS DATE),120),'') AS SubmittedDate,
				COALESCE(CONVERT(Date, CAST(t.WeekStartDate AS DATE), 120), CONVERT(varchar(10), @StartDate, 120)) AS WeekStartDate,
				COALESCE(CONVERT(Date, CAST(t.WeekEndDate AS DATE), 120), CONVERT(varchar(10), @EndDate, 120)) AS WeekEndDate,
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
						  AND(empM.IsDeleted = 0)
						AND((t.Created IS NOT NULL AND @IsTimesheetCreated='YES')
						OR(t.Created IS NULL AND @IsTimesheetCreated='NO'))
						AND((t.SubmissionDate IS NOT NULL AND @IsTimesheetSubmitted = 'YES')
						OR(t.SubmissionDate IS NULL AND @IsTimesheetSubmitted='NO'))
					ORDER BY
						ed.EmployeeName desc;
		END
		Else IF (@Role = 'Reporting_Manager')
		BEGIN
			SELECT

				ed.EmployeeName AS EmployeeName,
				empM.EmailId AS EmailId,
				cm.ClientName AS Project,
				ISNULL(CONVERT(Date, CAST(t.Created AS DATE),120),'') AS CreatedDate,
				ISNULL(CONVERT(Date, CAST(t.SubmissionDate AS DATE),120),'') AS SubmittedDate,
				COALESCE(CONVERT(Date, CAST(t.WeekStartDate AS DATE), 120), CONVERT(varchar(10), @StartDate, 120)) AS WeekStartDate,
				COALESCE(CONVERT(Date, CAST(t.WeekEndDate AS DATE), 120), CONVERT(varchar(10), @EndDate, 120)) AS WeekEndDate,
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
					AND (empM.IsDeleted = 0)
					AND((t.Created IS NOT NULL AND @IsTimesheetCreated='YES')
						OR(t.Created IS NULL AND @IsTimesheetCreated='NO'))
						AND((t.SubmissionDate IS NOT NULL AND @IsTimesheetSubmitted = 'YES')
						OR(t.SubmissionDate IS NULL AND @IsTimesheetSubmitted='NO'))
					ORDER BY
				ed.EmployeeName desc;
		END
END

-- =============================================
-- Author:	<Murali Sainath Reddy>
-- Create date: <07-08-2024>
-- Description:	<Modified SP TO handle divide by zero error>
-- =============================================
GO
CREATE OR ALTER   procedure [dbo].[usp_dashboard_lineData]    (@clientId int, @functionType varchar(25))
as begin
With tmp as(select
ClientName,
TeamId,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage1,
CAST(FORMAT(COALESCE(CAST(ES AS DECIMAL(5, 2)) / NULLIF(ClientExpectedScore, 0) * 100, 0), 'N2') AS FLOAT) AS EmployeeScorePercentage,

[EmployeeScore1],
Popularity,MatrixDate,
            case
            when cast([EmployeeScore] as float) between 1 AND 40 THEN 4
            when cast([EmployeeScore] as float) between 40 AND 70 THEN 3
            when cast([EmployeeScore] as float) between 70 AND 85 THEN 2
            when cast([EmployeeScore] as float) >85 THEN 1
            else '5'
            END As Levels from (
            SELECT
            ClientName,emp.TeamId,TeamName,em.EmployeeId,FullName as EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            CAST(FORMAT(COALESCE(CAST(SUM(EmployeeScore) AS DECIMAL(5, 2)) / NULLIF(SUM(ClientExpectedScore), 0) * 100, 0), 'N2') AS FLOAT) [EmployeeScore],
			COALESCE(cast(SUM(EmployeeScore) as decimal(5, 2))/NULLIF((count(*)*5),0)*100,0) [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill
			INNER JOIN EmployeeMaster em ON empSkill.EmployeeId = em.EmployeeId
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.BhavnaEmployeeId
			INNER JOIN EmployeeType empType ON emp.Type= empType.Id
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId = 0 or cl.Id=@clientId)
			AND subM.ClientExpectedScore > 0 AND (@functionType ='All' or empType.Function_Type=@functionType)
			group by cat.Id,FullName,CategoryName,ClientName,emp.TeamId,TeamName,em.EmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
            join
            (Select Row_number() over(order by ClientExpectedScore desc) Popularity,Id,TeamName,ClientExpectedScore from(SELECT
            cat.Id,
            SUM(ClientExpectedScore) ClientExpectedScore,
			tm.TeamName
            FROM
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id
            group by cat.Id,tm.TeamName) as t ) as t1 On t.CatId=t1.Id and t.TeamName= t1.TeamName)

select
ClientName,
TeamId,
TeamName,
CategoryName,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeId) employeeCount,
CAST(COALESCE(SUM(EmployeeScorePercentage) / NULLIF(COUNT(DISTINCT employeeId), 0),0) AS NUMERIC(36, 2)) AvgScorepercentage

            from tmp  group by ClientName,TeamId,TeamName,CategoryName  order by ClientName,TeamName
end


-- =============================================
-- Author:		<Murali Sainath Reddy>
-- Create date: <06-08-2024>
-- Description:	<Modified the SP to get employee score percentage report with categories by adding Year and Month Filter and chaneged empId to BhavnaId>
-- =============================================
GO
CREATE OR ALTER   PROCEDURE [dbo].[usp_getEmployeeScoreReportByCategoryClient]
(
	@EmailId VARCHAR(150),
    @CategoryId INT,
    @ClientId INT,
    @TeamId INT,
    @ReportType INT,
    @FunctionType INT,
    @Year INT,
    @Month INT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Role VARCHAR(100) = '';
	DECLARE @Client INT;
			IF @EmailId IS NOT NULL
			BEGIN
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

    DECLARE @CurrentMonth INT
    DECLARE @CurrentYear INT
    DECLARE @sql NVARCHAR(MAX)

    SET @CurrentYear = YEAR(GETDATE())
    SET @CurrentMonth = MONTH(GETDATE())

    -- Create temporary table
    CREATE TABLE #temp (
        ClientName VARCHAR(MAX),
        TeamName VARCHAR(MAX),
        TeamId INT,
        SubcategoryName VARCHAR(MAX),
        SubCategoryId INT,
        CategoryName VARCHAR(MAX),
        ClientExpectedScore INT,
        EmployeeName VARCHAR(MAX),
        EmployeeScore INT,
        EmployeeScorePercentage FLOAT,
        EmployeeScoreByCategory FLOAT,
        FunctionType VARCHAR(MAX)
    );

    -- Determine the table to use
        IF @Month = @CurrentMonth AND @Year = @CurrentYear
    BEGIN
        IF @Role = 'ADMIN'
        BEGIN
            SET @sql = N'
            INSERT INTO #temp (ClientName, TeamName, TeamId, SubcategoryName, SubCategoryId, CategoryName, ClientExpectedScore, EmployeeName, EmployeeScore, EmployeeScorePercentage, EmployeeScoreByCategory, FunctionType)
            SELECT
                cmaster.ClientName,
                team.TeamName,
                team.Id AS TeamId,
                subcatMaster.SubCategoryName,
                subcatMaster.Id AS SubCategoryId,
                catMaster.CategoryName,
                ISNULL(scm.ClientExpectedScore, 0) AS ClientExpectedScore,
                emp.EmployeeName,
                ISNULL(matrix.EmployeeScore, 0) AS EmployeeScore,
                CASE WHEN scm.ClientExpectedScore <> 0 THEN CAST(ROUND((ISNULL(CAST(matrix.EmployeeScore AS FLOAT), 0) / CAST(scm.ClientExpectedScore AS FLOAT)) * 100, 2) AS DECIMAL(10, 2)) ELSE 0 END AS EmployeeScorePercentage,
                CASE WHEN scm.ClientExpectedScore <> 0 THEN COALESCE(CAST(ROUND(AVG((CAST(matrix.EmployeeScore AS FLOAT) / CAST(scm.ClientExpectedScore AS FLOAT)) * 100 ) OVER (PARTITION BY emp.BhavnaEmployeeId, catMaster.Id), 2) AS DECIMAL(10, 2)), 0) ELSE 0 END AS EmployeeScoreByCategory,
                empType.Function_Type AS FunctionType
            FROM TeamMaster team
            INNER JOIN ClientMaster cmaster ON cmaster.Id = team.ClientId
            INNER JOIN SubCategoryMaster subcatMaster ON 1 = 1 -- Dummy condition for all subcategories
            INNER JOIN CategoryMaster catMaster ON catMaster.Id = subcatMaster.CategoryId
            LEFT JOIN SubCategoryMapping scm ON scm.SubCategoryId = subcatMaster.Id AND scm.TeamId = team.Id
            LEFT JOIN SkillsMatrix matrix ON matrix.SubCategoryId = subcatMaster.Id
            LEFT JOIN EmployeeDetails emp ON emp.BhavnaEmployeeId = matrix.EmployeeId AND emp.TeamId = team.Id
            LEFT JOIN EmployeeType empType ON empType.Id = emp.Type
            WHERE
                (@CategoryId = 0 OR catMaster.Id = @CategoryId)
                AND (@ClientId = 0 OR cmaster.Id = @ClientId)
                AND (@TeamId = 0 OR team.Id = @TeamId)
                AND (@FunctionType = 0 OR empType.Id = @FunctionType)
                AND (Year(matrix.MatrixDate) = @Year)
                AND (Month(matrix.MatrixDate) = @Month)
                AND subcatMaster.SubCategoryName <> catMaster.CategoryName
                AND ISNULL(scm.ClientExpectedScore, 0) <> 0
                AND emp.EmployeeName IS NOT NULL';
        END
        ELSE IF @Role = 'Reporting_Manager'
        BEGIN
            SET @sql = N'
            INSERT INTO #temp (ClientName, TeamName, TeamId, SubcategoryName, SubCategoryId, CategoryName, ClientExpectedScore, EmployeeName, EmployeeScore, EmployeeScorePercentage, EmployeeScoreByCategory, FunctionType)
            SELECT
                cmaster.ClientName,
                team.TeamName,
                team.Id AS TeamId,
                subcatMaster.SubCategoryName,
                subcatMaster.Id AS SubCategoryId,
                catMaster.CategoryName,
                ISNULL(scm.ClientExpectedScore, 0) AS ClientExpectedScore,
                emp.EmployeeName ,
                ISNULL(matrix.EmployeeScore, 0) AS EmployeeScore,
                CASE WHEN scm.ClientExpectedScore <> 0 THEN CAST(ROUND((ISNULL(CAST(matrix.EmployeeScore AS FLOAT), 0) / CAST(scm.ClientExpectedScore AS FLOAT)) * 100, 2) AS DECIMAL(10, 2)) ELSE 0 END AS EmployeeScorePercentage,
                CASE WHEN scm.ClientExpectedScore <> 0 THEN COALESCE(CAST(ROUND(AVG((CAST(matrix.EmployeeScore AS FLOAT) / CAST(scm.ClientExpectedScore AS FLOAT)) * 100 ) OVER (PARTITION BY emp.BhavnaEmployeeId, catMaster.Id), 2) AS DECIMAL(10, 2)), 0) ELSE 0 END AS EmployeeScoreByCategory,
                empType.Function_Type AS FunctionType
            FROM TeamMaster team
            INNER JOIN ClientMaster cmaster ON cmaster.Id = team.ClientId
            INNER JOIN SubCategoryMaster subcatMaster ON 1 = 1 -- Dummy condition for all subcategories
            INNER JOIN CategoryMaster catMaster ON catMaster.Id = subcatMaster.CategoryId
            LEFT JOIN SubCategoryMapping scm ON scm.SubCategoryId = subcatMaster.Id AND scm.TeamId = team.Id
            LEFT JOIN SkillsMatrix matrix ON matrix.SubCategoryId = subcatMaster.Id
            LEFT JOIN EmployeeDetails emp ON emp.BhavnaEmployeeId = matrix.EmployeeId AND emp.TeamId = team.Id
            LEFT JOIN EmployeeType empType ON empType.Id = emp.Type
            WHERE
                (@CategoryId = 0 OR catMaster.Id = @CategoryId)
                AND (cmaster.Id = @Client)
                AND (@TeamId = 0 OR team.Id = @TeamId)
                AND (@FunctionType = 0 OR empType.Id = @FunctionType)
                AND (Year(matrix.MatrixDate) = @Year)
                AND (Month(matrix.MatrixDate) = @Month)
                AND subcatMaster.SubCategoryName <> catMaster.CategoryName
                AND ISNULL(scm.ClientExpectedScore, 0) <> 0
                AND emp.EmployeeName  IS NOT NULL';
        END
    END
    ELSE
    BEGIN
		IF (@Role = 'ADMIN')
		BEGIN
			SET @sql = N'
			INSERT INTO #temp (ClientName, TeamName, TeamId, SubcategoryName, SubCategoryId, CategoryName, ClientExpectedScore, EmployeeName, EmployeeScore, EmployeeScorePercentage, EmployeeScoreByCategory, FunctionType)
			SELECT
				cmaster.ClientName,
				team.TeamName,
				team.Id AS TeamId,
				subcatMaster.SubCategoryName,
				subcatMaster.Id AS SubCategoryId,
				catMaster.CategoryName,
				ISNULL(scm.ClientExpectedScore, 0) AS ClientExpectedScore,
				emp.EmployeeName,
				ISNULL(matrix.EmployeeScore, 0) AS EmployeeScore,
				CASE WHEN scm.ClientExpectedScore <> 0 THEN CAST(ROUND((ISNULL(CAST(matrix.EmployeeScore AS FLOAT), 0) / CAST(scm.ClientExpectedScore AS FLOAT)) * 100, 2) AS DECIMAL(10, 2)) ELSE 0 END AS EmployeeScorePercentage,
				CASE WHEN scm.ClientExpectedScore <> 0 THEN COALESCE(CAST(ROUND(AVG((CAST(matrix.EmployeeScore AS FLOAT) / CAST(scm.ClientExpectedScore AS FLOAT)) * 100 ) OVER (PARTITION BY emp.BhavnaEmployeeId, catMaster.Id), 2) AS DECIMAL(10, 2)), 0) ELSE 0 END AS EmployeeScoreByCategory,
				empType.Function_Type AS FunctionType
			FROM TeamMaster team
			INNER JOIN ClientMaster cmaster ON cmaster.Id = team.ClientId
			INNER JOIN SubCategoryMaster subcatMaster ON 1 = 1 -- Dummy condition for all subcategories
			INNER JOIN CategoryMaster catMaster ON catMaster.Id = subcatMaster.CategoryId
			LEFT JOIN SubCategoryMapping scm ON scm.SubCategoryId = subcatMaster.Id AND scm.TeamId = team.Id
			LEFT JOIN SkillsMatrix_Archive matrix ON matrix.SubCategoryId = subcatMaster.Id
			LEFT JOIN EmployeeDetails emp ON emp.BhavnaEmployeeId = matrix.EmployeeId AND emp.TeamId = team.Id
			LEFT JOIN EmployeeType empType ON empType.Id = emp.Type
			WHERE
				(@CategoryId = 0 OR catMaster.Id = @CategoryId)
				AND (@ClientId = 0 OR cmaster.Id = @ClientId)
				AND (@TeamId = 0 OR team.Id = @TeamId)
				AND (@FunctionType = 0 OR empType.Id = @FunctionType)
				AND (Year(matrix.MatrixDate) = @Year)
				AND (Month(matrix.MatrixDate) = @Month)
				AND subcatMaster.SubCategoryName <> catMaster.CategoryName
				AND ISNULL(scm.ClientExpectedScore, 0) <> 0
				AND emp.EmployeeName IS NOT NULL'
			END
			ELSE IF(@Role = 'Reporting_Manager')
			BEGIN
				 SET @sql = N'
        INSERT INTO #temp (ClientName, TeamName, TeamId, SubcategoryName, SubCategoryId, CategoryName, ClientExpectedScore, EmployeeName, EmployeeScore, EmployeeScorePercentage, EmployeeScoreByCategory, FunctionType)
        SELECT
            cmaster.ClientName,
            team.TeamName,
            team.Id AS TeamId,
            subcatMaster.SubCategoryName,
            subcatMaster.Id AS SubCategoryId,
            catMaster.CategoryName,
            ISNULL(scm.ClientExpectedScore, 0) AS ClientExpectedScore,
            emp.EmployeeName,
            ISNULL(matrix.EmployeeScore, 0) AS EmployeeScore,
            CASE WHEN scm.ClientExpectedScore <> 0 THEN CAST(ROUND((ISNULL(CAST(matrix.EmployeeScore AS FLOAT), 0) / CAST(scm.ClientExpectedScore AS FLOAT)) * 100, 2) AS DECIMAL(10, 2)) ELSE 0 END AS EmployeeScorePercentage,
            CASE WHEN scm.ClientExpectedScore <> 0 THEN COALESCE(CAST(ROUND(AVG((CAST(matrix.EmployeeScore AS FLOAT) / CAST(scm.ClientExpectedScore AS FLOAT)) * 100 ) OVER (PARTITION BY emp.BhavnaEmployeeId, catMaster.Id), 2) AS DECIMAL(10, 2)), 0) ELSE 0 END AS EmployeeScoreByCategory,
            empType.Function_Type AS FunctionType
        FROM TeamMaster team
        INNER JOIN ClientMaster cmaster ON cmaster.Id = team.ClientId
        INNER JOIN SubCategoryMaster subcatMaster ON 1 = 1 -- Dummy condition for all subcategories
        INNER JOIN CategoryMaster catMaster ON catMaster.Id = subcatMaster.CategoryId
        LEFT JOIN SubCategoryMapping scm ON scm.SubCategoryId = subcatMaster.Id AND scm.TeamId = team.Id
        LEFT JOIN SkillsMatrix_Archive matrix ON matrix.SubCategoryId = subcatMaster.Id
        LEFT JOIN EmployeeDetails emp ON emp.BhavnaEmployeeId = matrix.EmployeeId AND emp.TeamId = team.Id
        LEFT JOIN EmployeeType empType ON empType.Id = emp.Type
        WHERE
            (@CategoryId = 0 OR catMaster.Id = @CategoryId)
            AND (cmaster.Id = @Client)
            AND (@TeamId = 0 OR team.Id = @TeamId)
            AND (@FunctionType = 0 OR empType.Id = @FunctionType)
            AND (Year(matrix.MatrixDate) = @Year)
            AND (Month(matrix.MatrixDate) = @Month)
            AND subcatMaster.SubCategoryName <> catMaster.CategoryName
            AND ISNULL(scm.ClientExpectedScore, 0) <> 0
            AND emp.EmployeeName IS NOT NULL'
			END
    END
 
    -- Execute the dynamic SQL to insert data into the temp table
    EXEC sp_executesql @sql, N'@CategoryId INT, @ClientId INT, @TeamId INT, @FunctionType INT, @Year INT, @Month INT, @Client INT, @Role VARCHAR(150)',
                      @CategoryId, @ClientId, @TeamId, @FunctionType, @Year, @Month, @Client, @Role
 
    -- Generate the report based on @ReportType
    IF @ReportType = 0
    BEGIN
        DECLARE @pivotColumns NVARCHAR(MAX)
        SELECT @pivotColumns = STRING_AGG(QUOTENAME(EmployeeName), ', ') WITHIN GROUP (ORDER BY EmployeeName) FROM (SELECT DISTINCT EmployeeName FROM #temp) AS Employees

        DECLARE @sqlReport NVARCHAR(MAX)
        SET @sqlReport = 'SELECT CategoryName, SubCategoryName, ClientExpectedScore, ' + @pivotColumns + ' FROM (SELECT CategoryName, SubCategoryName, ClientExpectedScore, EmployeeName, EmployeeScorePercentage FROM #temp) AS SourceTable PIVOT (MAX(EmployeeScorePercentage) FOR EmployeeName IN (' + @pivotColumns + ')) AS PivotTable'

        EXEC sp_executesql @sqlReport
    END
    ELSE IF @ReportType = 1
    BEGIN
        DECLARE @pivotColumns1 NVARCHAR(MAX)
        SELECT @pivotColumns = STRING_AGG(QUOTENAME(CategoryName), ', ') WITHIN GROUP (ORDER BY CategoryName) FROM (SELECT DISTINCT CategoryName FROM #temp) AS Categories

        DECLARE @sqlReport1 NVARCHAR(MAX)
        SET @sqlReport = 'SELECT ClientName, TeamName, EmployeeName, FunctionType, ' + @pivotColumns + ' FROM (SELECT ClientName, TeamName, EmployeeName, FunctionType, CategoryName, EmployeeScoreByCategory FROM #temp) AS SourceTable PIVOT (MAX(EmployeeScoreByCategory) FOR CategoryName IN (' + @pivotColumns + ')) AS PivotTable ORDER BY ClientName'

        EXEC sp_executesql @sqlReport
    END

    -- Drop the temporary table
    DROP TABLE #temp
END


-- =============================================
-- Author:		<Murali Sainath Reddy>
-- Create date: <06-08-2024>
-- Description:	<Modified the SP to get skill segment score report with categories and chaneged empId to BhavnaId>
-- =============================================
GO
CREATE OR ALTER   PROCEDURE [dbo].[usp_getskillsegmentscorereport_withcategories]

	@emailId varchar(150) = '',
	@categoryId int = null,
    @clientId int = null,
    @teamId int = null,
	@year int,
	@month int
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Role VARCHAR(100) = '';
	DECLARE @Client INT = @ClientId;
			IF @EmailId IS NOT NULL
			BEGIN
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
	DECLARE @CurrentMonth INT
    DECLARE @CurrentYear INT
    DECLARE @sql NVARCHAR(MAX)

    SET @CurrentYear = YEAR(GETDATE())
    SET @CurrentMonth = MONTH(GETDATE())

	IF @Month = @CurrentMonth AND @Year = @CurrentYear
    BEGIN
	IF (@Role = 'ADMIN')
		BEGIN
			SELECT
				c.CategoryName,
				s.SubCategoryName,
				SUM(CASE WHEN sm.EmployeeScore = 4 THEN 1 ELSE 0 END) AS Expert,
				SUM(CASE WHEN sm.EmployeeScore = 3 THEN 1 ELSE 0 END) AS Good,
				SUM(CASE WHEN sm.EmployeeScore = 2 THEN 1 ELSE 0 END) AS Average,
				SUM(CASE WHEN sm.EmployeeScore = 1 THEN 1 ELSE 0 END) AS NeedTraining,
				COUNT(*) AS GrandTotal
			FROM SkillsMatrix sm
			JOIN EmployeeDetails ed ON sm.EmployeeId = ed.BhavnaEmployeeId
			JOIN TeamMaster tm ON tm.Id = ed.TeamId
			JOIN ClientMaster cm ON cm.Id = tm.ClientId
			JOIN SubCategoryMaster s ON sm.SubCategoryId = s.Id
			JOIN CategoryMaster c ON s.CategoryId = c.Id
			WHERE (@teamId IS NULL OR tm.Id = @teamId)
				AND (@clientId IS NULL OR cm.Id = @clientId)
				AND (@categoryId IS NULL OR c.Id = @categoryId)
				AND (Year(sm.MatrixDate) = @year)
				AND (Month(sm.MatrixDate) = @month)
			GROUP BY c.CategoryName, s.SubCategoryName;
		END
		ELSE IF (@Role = 'Reporting_Manager')
		BEGIN
			SELECT
				c.CategoryName,
				s.SubCategoryName,
				SUM(CASE WHEN sm.EmployeeScore = 4 THEN 1 ELSE 0 END) AS Expert,
				SUM(CASE WHEN sm.EmployeeScore = 3 THEN 1 ELSE 0 END) AS Good,
				SUM(CASE WHEN sm.EmployeeScore = 2 THEN 1 ELSE 0 END) AS Average,
				SUM(CASE WHEN sm.EmployeeScore = 1 THEN 1 ELSE 0 END) AS NeedTraining,
				COUNT(*) AS GrandTotal
			FROM SkillsMatrix sm
			JOIN EmployeeDetails ed ON sm.EmployeeId = ed.BhavnaEmployeeId
			JOIN TeamMaster tm ON tm.Id = ed.TeamId
			JOIN ClientMaster cm ON cm.Id = tm.ClientId
			JOIN SubCategoryMaster s ON sm.SubCategoryId = s.Id
			JOIN CategoryMaster c ON s.CategoryId = c.Id
			WHERE (@teamId IS NULL OR tm.Id = @teamId)
				AND (cm.Id = @Client)
				AND (@categoryId IS NULL OR c.Id = @categoryId)
				AND (Year(sm.MatrixDate) = @year)
				AND (Month(sm.MatrixDate) = @month)
			GROUP BY c.CategoryName, s.SubCategoryName;
		END
	END
	ELSE
	BEGIN
	IF (@Role = 'ADMIN')
			BEGIN
			SELECT
				c.CategoryName,
				s.SubCategoryName,
				SUM(CASE WHEN sma.EmployeeScore = 4 THEN 1 ELSE 0 END) AS Expert,
				SUM(CASE WHEN sma.EmployeeScore = 3 THEN 1 ELSE 0 END) AS Good,
				SUM(CASE WHEN sma.EmployeeScore = 2 THEN 1 ELSE 0 END) AS Average,
				SUM(CASE WHEN sma.EmployeeScore = 1 THEN 1 ELSE 0 END) AS NeedTraining,
				COUNT(*) AS GrandTotal
			FROM SkillsMatrix_Archive sma
			JOIN EmployeeDetails ed ON sma.EmployeeId = ed.BhavnaEmployeeId
			JOIN TeamMaster tm ON tm.Id = ed.TeamId
			JOIN ClientMaster cm ON cm.Id = tm.ClientId
			JOIN SubCategoryMaster s ON sma.SubCategoryId = s.Id
			JOIN CategoryMaster c ON s.CategoryId = c.Id
			WHERE (@teamId IS NULL OR tm.Id = @teamId)
				AND (@clientId IS NULL OR cm.Id = @clientId)
				AND (@categoryId IS NULL OR c.Id = @categoryId)
				AND (Year(sma.MatrixDate) = @year)
				AND (Month(sma.MatrixDate) = @month)
			GROUP BY c.CategoryName, s.SubCategoryName;
		END
		IF (@Role = 'Reporting_Manager')
			BEGIN
			SELECT
				c.CategoryName,
				s.SubCategoryName,
				SUM(CASE WHEN sma.EmployeeScore = 4 THEN 1 ELSE 0 END) AS Expert,
				SUM(CASE WHEN sma.EmployeeScore = 3 THEN 1 ELSE 0 END) AS Good,
				SUM(CASE WHEN sma.EmployeeScore = 2 THEN 1 ELSE 0 END) AS Average,
				SUM(CASE WHEN sma.EmployeeScore = 1 THEN 1 ELSE 0 END) AS NeedTraining,
				COUNT(*) AS GrandTotal
			FROM SkillsMatrix_Archive sma
			JOIN EmployeeDetails ed ON sma.EmployeeId = ed.BhavnaEmployeeId
			JOIN TeamMaster tm ON tm.Id = ed.TeamId
			JOIN ClientMaster cm ON cm.Id = tm.ClientId
			JOIN SubCategoryMaster s ON sma.SubCategoryId = s.Id
			JOIN CategoryMaster c ON s.CategoryId = c.Id
			WHERE (@teamId IS NULL OR tm.Id = @teamId)
				AND (cm.Id = @Client)
				AND (@categoryId IS NULL OR c.Id = @categoryId)
				AND (Year(sma.MatrixDate) = @year)
				AND (Month(sma.MatrixDate) = @month)
			GROUP BY c.CategoryName, s.SubCategoryName;
		END
	END
END;



-- =============================================
-- Author:	<Murali Sainath Reddy>
-- Create date: <07-08-2024>
-- Description:	<Modified SP TO handle divide by zero error>
-- =============================================
GO
CREATE OR ALTER   procedure [dbo].[usp_dashboard_lineData_teamwise]   (@clientId int, @teamName varchar(max),@functionType varchar(20)='All')
as begin
With tmp as(select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage1,
CAST(FORMAT(COALESCE(CAST(ES AS DECIMAL(5, 2)) / NULLIF(ClientExpectedScore, 0) * 100, 0), 'N2') AS FLOAT) AS EmployeeScorePercentage,

[EmployeeScore1],
Popularity,MatrixDate,
            case
            when cast([EmployeeScore] as float) between 1 AND 40 THEN 4
            when cast([EmployeeScore] as float) between 40 AND 70 THEN 3
            when cast([EmployeeScore] as float) between 70 AND 85 THEN 2
            when cast([EmployeeScore] as float) >85 THEN 1
            else '5'
            END As Levels from (
            SELECT
            ClientName,TeamName,em.EmployeeId,FullName as EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            CAST(FORMAT(COALESCE(CAST(SUM(EmployeeScore) AS DECIMAL(5, 2)) / NULLIF(SUM(ClientExpectedScore), 0) * 100, 0), 'N2') AS FLOAT) [EmployeeScore],
			COALESCE(cast(SUM(EmployeeScore) as decimal(5, 2))/NULLIF((count(*)*5),0)*100,0) [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill
			INNER JOIN EmployeeMaster em ON empSkill.EmployeeId = em.EmployeeId
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.BhavnaEmployeeId
			INNER JOIN EmployeeType empType ON emp.Type= empType.Id
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId=0 or cl.Id=@clientId) and subM.ClientExpectedScore > 0
			and (@functionType ='All' or empType.Function_Type=@functionType)
			group by cat.Id,FullName,CategoryName,ClientName,TeamName,em.EmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
            join
            (Select Row_number() over(order by ClientExpectedScore desc) Popularity,Id,TeamName,ClientExpectedScore from(SELECT
            cat.Id,
            SUM(ClientExpectedScore) ClientExpectedScore,
			tm.TeamName
            FROM
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id
            group by cat.Id,tm.TeamName) as t ) as t1 On t.CatId=t1.Id and t.TeamName= t1.TeamName)

select
EmployeeName,
CategoryName,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeid) employeeCount,
CAST(COALESCE(SUM(EmployeeScorePercentage) / NULLIF(COUNT(DISTINCT employeeId), 0),0) AS NUMERIC(36, 2)) AvgScorepercentage
from tmp where ((@clientId=0 and ClientName=@teamName) or TeamName=@teamName)  group by EmployeeName,TeamName,CategoryName  order by EmployeeName
end

-- =============================================
-- Author:	<Murali Sainath Reddy>
-- Create date: <07-08-2024>
-- Description:	<Modified SP TO handle divide by zero error>
-- =============================================
GO
CREATE OR ALTER   procedure [dbo].[usp_dashboardshortcut] @clientId int,  @signValueStart varchar(3), @signValueEnd varchar(4),@functionType varchar(50) ='All'
as
begin
-- usp_dashboardshortcut 1,1,1000
declare @sql nvarchar(max);

With tmp as(select
			ClientName,
			t.TeamName,
			EmployeeId,
			EmployeeName,
			CategoryName,
			ES,CES,

[EmployeeScore] EmployeeScorePercentage1,
CAST(FORMAT(COALESCE(CAST(ES AS DECIMAL(5, 2)) / NULLIF(ClientExpectedScore, 0) * 100, 0), 'N2') AS FLOAT) as EmployeeScorePercentage,

[EmployeeScore1],
Popularity,MatrixDate,
            case
            when cast([EmployeeScore] as float) between 1 AND 40 THEN 4
            when cast([EmployeeScore] as float) between 40 AND 70 THEN 3
            when cast([EmployeeScore] as float) between 70 AND 85 THEN 2
            when cast([EmployeeScore] as float) >85 THEN 1
            else '5'
            END As Levels from (
            SELECT
            ClientName,TeamName,emp.BhavnaEmployeeId as EmployeeId,EmployeeName as EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            CAST(FORMAT(COALESCE(CAST(SUM(EmployeeScore) AS DECIMAL(5, 2)) / NULLIF(SUM(ClientExpectedScore), 0) * 100, 0), 'N2') AS FLOAT) [EmployeeScore],
			COALESCE(cast(SUM(EmployeeScore) as decimal(5, 2))/NULLIF((count(*)*5),0)*100,0) [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.BhavnaEmployeeId
			INNER JOIN EmployeeType empType ON emp.Type= empType.Id
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id
			where (@clientId = 0 or cl.Id=@clientId ) and subM.ClientExpectedScore > 0 and (@functionType ='All' or empType.Function_Type=@functionType)

			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.BhavnaEmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
            join
            (Select Row_number() over(order by ClientExpectedScore desc) Popularity,Id,TeamName,ClientExpectedScore from(SELECT
            cat.Id,
            SUM(ClientExpectedScore) ClientExpectedScore,
			tm.TeamName
            FROM
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id
            group by cat.Id,tm.TeamName) as t ) as t1 On t.CatId=t1.Id and t.TeamName= t1.TeamName)

		select * into #temp from tmp



		set @sql= 'SELECT
						ClientName,EmployeeName,TeamName,
						ROUND(COALESCE(SUM(EmployeeScorePercentage) / NULLIF(COUNT(CategoryName), 0),0),2) as EmployeeScorePercentage
						FROM #temp group by ClientName, EmployeeName,TeamName Having ROUND(COALESCE(SUM(EmployeeScorePercentage) / NULLIF(COUNT(CategoryName), 0),0),2) between ' + @signValueStart  + '  and ' + @signValueEnd + '
						 order by EmployeeScorePercentage desc ';
		print @sql
		exec sp_executesql @sql
		drop table #temp
end


-- =============================================
-- Author:	<Murali Sainath Reddy>
-- Create date: <07-08-2024>
-- Description:	<Modified SP TO handle divide by zero error>
-- =============================================
GO
CREATE OR ALTER   procedure [dbo].[usp_gettrendlinedataemployee]
(
@clientId int,
@teamId int,
@bhavnaEmployeeId varchar(50),
@functionType varchar(50)
)
as

begin
with tmp as(select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,

Round(CAST(FORMAT(COALESCE(CAST(ES AS DECIMAL(5, 2)) / NULLIF(ClientExpectedScore, 0) * 100, 0), 'N2') AS FLOAT),2) as EmployeeScorePercentage,
[EmployeeScore1],
Popularity, MatrixDate,
            case
            when cast([EmployeeScore] as float) between 1 AND 40 THEN 4
            when cast([EmployeeScore] as float) between 40 AND 70 THEN 3
            when cast([EmployeeScore] as float) between 70 AND 85 THEN 2
            when cast([EmployeeScore] as float) >85 THEN 1
            else '5'
            END As Levels from (
            SELECT
            ClientName,TeamName,em.EmployeeId,FullName as EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            CAST(FORMAT(COALESCE(CAST(SUM(EmployeeScore) AS DECIMAL(5, 2)) / NULLIF(SUM(ClientExpectedScore), 0) * 100, 0), 'N2') as float) [EmployeeScore],
			COALESCE(cast(SUM(EmployeeScore) as decimal(5, 2))/NULLIF((count(*)*5),0)*100,0) [EmployeeScore1],MatrixDate
            FROM [SkillsMatrix] empSkill
			INNER JOIN EmployeeMaster em ON empSkill.EmployeeId = em.EmployeeId
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.BhavnaEmployeeId
			INNER JOIN EmployeeType empType ON empType.Id = emp.Type   and (@functionType ='All' or empType.Function_Type=@functionType)
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId =0 or cl.Id=@clientId) and subM.ClientExpectedScore > 0 and (@teamId =0 or tm.Id=@teamId) and (@bhavnaEmployeeId =0 or em.EmployeeId=@bhavnaEmployeeId)
			group by cat.Id,FullName,CategoryName,ClientName,TeamName,em.EmployeeId,MatrixDate having MONTH(MatrixDate) = MONTH(GETDATE())) as t
            join
            (Select Row_number() over(order by ClientExpectedScore desc) Popularity,Id,TeamName,ClientExpectedScore from(SELECT
            cat.Id,
            SUM(ClientExpectedScore) ClientExpectedScore,
			tm.TeamName
            FROM
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id
            group by cat.Id,tm.TeamName) as t ) as t1 On t.CatId=t1.Id and t.TeamName= t1.TeamName

			union all

			select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
Round(CAST(FORMAT(COALESCE(CAST(ES AS DECIMAL(5, 2)) / NULLIF(ClientExpectedScore, 0) * 100, 0), 'N2') AS FLOAT),2) as EmployeeScorePercentage,
[EmployeeScore1],
Popularity, MatrixDate ,
            case
            when cast([EmployeeScore] as float) between 1 AND 40 THEN 4
            when cast([EmployeeScore] as float) between 40 AND 70 THEN 3
            when cast([EmployeeScore] as float) between 70 AND 85 THEN 2
            when cast([EmployeeScore] as float) >85 THEN 1
            else '5'
            END As Levels from (
            SELECT
            ClientName,TeamName,emp.BhavnaEmployeeId as EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            CAST(FORMAT(COALESCE(CAST(SUM(EmployeeScore) AS DECIMAL(5, 2)) / NULLIF(SUM(ClientExpectedScore), 0) * 100, 0), 'N2') as float) [EmployeeScore],
			COALESCE(cast(SUM(EmployeeScore) as decimal(5, 2))/NULLIF((count(*)*5),0)*100,0) [EmployeeScore1],MatrixDate
            FROM [dbo].[SkillsMatrix_Archive] empSkill
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.BhavnaEmployeeId
			INNER JOIN EmployeeType empType ON empType.Id = emp.Type   and (@functionType ='All' or empType.Function_Type=@functionType)
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId =0 or cl.Id=@clientId) and (@teamId =0 or tm.Id=@teamId) and (@bhavnaEmployeeId =0 or emp.BhavnaEmployeeId=@bhavnaEmployeeId)
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.BhavnaEmployeeId,MatrixDate having MatrixDate >= DATEADD(MONTH,-6,GETDATE())) as t
            join
           (Select Row_number() over(order by ClientExpectedScore desc) Popularity,Id,TeamName,ClientExpectedScore from(SELECT
            cat.Id,
            SUM(ClientExpectedScore) ClientExpectedScore,
			tm.TeamName
            FROM
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id
            group by cat.Id,tm.TeamName) as t ) as t1 On t.CatId=t1.Id and t.TeamName= t1.TeamName
			)

select * into #temp from (select
ClientName,
TeamName,
CategoryName,
EmployeeName,
EmployeeId,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeid) employeeCount,
CAST(COALESCE(SUM(EmployeeScorePercentage) / NULLIF(COUNT(DISTINCT employeeId), 0),0) AS NUMERIC(36, 2)) AvgScorepercentage,
Format(MatrixDate,'MMM yyyy') as date

            from tmp   group by ClientName,TeamName,CategoryName,Format(MatrixDate,'MMM yyyy'),EmployeeName,EmployeeId) as t order by ClientName,TeamName,cast(date as datetime) asc


if @clientId =0
begin
	select ClientName, COALESCE(SUM(AvgScorePercentage) / NULLIF(COUNT(*), 0),0) AvgScorepercentage, date from #temp
	group by ClientName,date order by ClientName,cast(date as datetime) asc
end

if ((@clientId <>0 and @teamId=0) or (@clientId <>0 and @teamId<>0 and @bhavnaEmployeeId=0))
begin
	select ClientName, TeamName, COALESCE(SUM(AvgScorePercentage) / NULLIF(COUNT(*), 0),0) AvgScorepercentage, date from #temp

	group by ClientName,date,TeamName order by ClientName,TeamName, cast(date as datetime) asc
end
end
-- =============================================
-- Author:	<Murali Sainath Reddy>
-- Create date: <02-08-2024>
-- Description:	<Alter Datatype of employeeId in Skillsmatrix and skillsmatrix_archive and To Update the employeeId to BhavnavEmployeeId for skillsmatrix and skillsmatrix_archive table.>
-- =============================================

ALTER TABLE SkillsMatrix ALTER COLUMN EmployeeId Varchar(50);

ALTER TABLE SkillsMatrix_Archive ALTER COLUMN EmployeeId Varchar(50);

UPDATE SkillsMatrix
SET employeeId = (
    SELECT em.EmployeeId
    FROM EmployeeDetails ed
    JOIN EmployeeMaster em ON ed.bhavnaEmployeeId = em.EmployeeId
    WHERE SkillsMatrix.employeeId = ed.EmployeeId
);

UPDATE SkillsMatrix_Archive
SET employeeId = (
    SELECT em.EmployeeId
    FROM EmployeeDetails ed
    JOIN EmployeeMaster em ON ed.bhavnaEmployeeId = em.EmployeeId
    WHERE SkillsMatrix_Archive.employeeId = ed.EmployeeId
);

-- =============================================
-- Author:		<Murali Sainath Reddy>
-- Create date: <06-08-2024>
-- Description:	<Modified [usp_getReportByCategoryAndClient] SP to get data according to Role.>
-- =============================================
GO
CREATE OR ALTER       PROCEDURE [dbo].[usp_getReportByCategoryAndClient]
(
	@EmailId varchar(150),
    @CategoryId int,
    @ClientId int
)
AS
BEGIN
	SET NOCOUNT ON
			DECLARE @Role VARCHAR(100) = '';
			DECLARE @Client INT
			IF @EmailId IS NOT NULL
			BEGIN
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

    DECLARE @columns NVARCHAR(MAX),
            @sql NVARCHAR(MAX);
IF(@Role='Reporting_Manager')
set @ClientId = @Client;
IF (@ClientId = 0 OR @Client = 0)
    SELECT @columns = STRING_AGG(QUOTENAME(ClientName), ',') FROM ClientMaster;
ELSE
    SELECT @columns = QUOTENAME(ClientName) FROM ClientMaster WHERE Id = @ClientId;

	IF (@Role ='ADMIN')
	BEGIN
	SET @sql = 'SELECT *
			FROM
			(SELECT
			cat_master.CategoryName,
			subcat_master.SubCategoryName,
			c_master.ClientName,
			CASE WHEN subcat_mapping.ClientExpectedScore > 0 THEN 1 ELSE 0 END AS InUse
			FROM
			ClientMaster AS c_master
			JOIN TeamMaster AS t_master ON c_master.Id = t_master.ClientId
			JOIN SubCategoryMapping AS subcat_mapping ON t_master.Id = subcat_mapping.TeamId
			JOIN SubCategoryMaster AS subcat_master ON subcat_master.id = subcat_mapping.SubCategoryId
			JOIN CategoryMaster AS cat_master ON cat_master.Id = subcat_master.CategoryId
			WHERE
			(@CategoryId = 0 OR cat_master.Id = @CategoryId)
			AND (@ClientId = 0 OR c_master.Id = @ClientId))
			AS t PIVOT (MAX(InUse)
			FOR ClientName IN ('+ @columns +')) AS PivotTable';
    EXECUTE sp_executesql @sql, N'@CategoryId int, @ClientId int', @CategoryId, @ClientId;
	END
	ELSE IF(@Role = 'Reporting_Manager')
	BEGIN 
	SET @sql = 'SELECT *
			FROM
			(SELECT
			cat_master.CategoryName,
			subcat_master.SubCategoryName,
			c_master.ClientName,
			CASE WHEN subcat_mapping.ClientExpectedScore > 0 THEN 1 ELSE 0 END AS InUse
			FROM
			ClientMaster AS c_master
			JOIN TeamMaster AS t_master ON c_master.Id = t_master.ClientId
			JOIN SubCategoryMapping AS subcat_mapping ON t_master.Id = subcat_mapping.TeamId
			JOIN SubCategoryMaster AS subcat_master ON subcat_master.id = subcat_mapping.SubCategoryId
			JOIN CategoryMaster AS cat_master ON cat_master.Id = subcat_master.CategoryId
			WHERE
			(@CategoryId = 0 OR cat_master.Id = @CategoryId)
			AND (c_master.Id = @Client))
			AS t PIVOT (MAX(InUse)
			FOR ClientName IN ('+ @columns +')) AS PivotTable';
    EXECUTE sp_executesql @sql, N'@CategoryId int, @ClientId int, @Client int', @CategoryId, @ClientId, @Client;
	END
END

