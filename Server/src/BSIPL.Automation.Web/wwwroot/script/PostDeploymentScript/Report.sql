DELETE FROM TimesheetDetail WHERE TimeSheetSubcategoryID=85
DELETE FROM TimeSheetSubcategory WHERE TimeSheetSubcategoryID=85

DELETE FROM TimesheetDetail WHERE TimeSheetSubcategoryID=174 AND TimesheetId=5847


DELETE FROM TimesheetDetail WHERE TimesheetId=5967 AND TimeSheetSubcategoryID=36 AND TaskDescription='BDEV deployment'

DELETE FROM TimesheetDetail where TimesheetId=5965 and TimeSheetSubcategoryID=36 and TaskDescription='XC-17148'

DELETE FROM TimesheetDetail where TimesheetId=5965 and TimeSheetSubcategoryID=36 and TaskDescription='XC-17156'


DELETE FROM TimesheetDetail where TimesheetId=6033 and TimeSheetSubcategoryID=36 
and TaskDescription='Documents audit for all new hires from 01 July 23'' till 30 June 24'''

DELETE FROM TimesheetDetail where TimesheetId=6033 and TimeSheetSubcategoryID=36 
and TaskDescription='Updated WSR compliance tab'

DELETE FROM TimesheetDetail where TimesheetId=5847 and TimeSheetSubcategoryID=36 
and TaskDescription='HR Activity'



DELETE FROM TimesheetDetail where TimesheetId=5859 and TimeSheetSubcategoryID<>126 
and TaskDescription='User management and vendor management'

DELETE FROM TimesheetDetail where TimesheetId=5849 and TimeSheetSubcategoryID<>126 
and TaskDescription='OLD user data backup'

DELETE FROM TimesheetDetail where TimesheetId=5914 and TimeSheetSubcategoryID<>172 
and TaskDescription='Misc PM activities'


DELETE FROM TimesheetDetail where TimesheetId=6033 and TimeSheetSubcategoryID=130 
and TaskDescription='Prepared and shared Service Certificate with Chetna'


UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=15 
Where TimeSheetSubcategoryID=40 and TaskDescription<>'emergency leave'
and Date >= '2024-06-16' and Date <= '2024-06-22'

UPDATE TimesheetDetail SET TimeSheetCategoryID=18, TimeSheetSubcategoryID=36 
WHERE TimesheetId=5855 AND TaskDescription='Leave'

Delete from TimesheetDetail WHERE TimesheetId=5897
Delete from Timesheet where TimesheetId=5897

DELETE FROM TimesheetDetail WHERE TimesheetId=5886 and TimeSheetSubcategoryID=16 
and TaskDescription='- leads call with Uno. - doctor''s session on posture.'

DELETE FROM TimesheetDetail WHERE TimesheetId=5916 and TimeSheetSubcategoryID=16 
and TaskDescription='#Meeting with Uno'

DELETE FROM TimesheetDetail WHERE TimesheetId=5896 and TimeSheetSubcategoryID=16 
and TaskDescription='1. Meet with Uno (Taj Mahal)'

DELETE FROM TimesheetDetail WHERE TimesheetId=5970 and TimeSheetSubcategoryID=16 
and TaskDescription='Access Daily standup'

DELETE FROM TimesheetDetail WHERE TimesheetId=5812 and TimeSheetSubcategoryID=16 
and TaskDescription='AI Initiative call'

DELETE FROM TimesheetDetail WHERE TimesheetId=5936 and TimeSheetSubcategoryID=16 
and TaskDescription='Attended "Invitation for Health Session "'

DELETE FROM TimesheetDetail WHERE TimesheetId=5999 and TimeSheetSubcategoryID=16 
and TaskDescription='Attended Health Session'

DELETE FROM TimesheetDetail WHERE TimesheetId=6036 and TimeSheetSubcategoryID=16 
and TaskDescription='Attended Health Session'

DELETE FROM TimesheetDetail WHERE TimesheetId=5945 and TimeSheetSubcategoryID=16 
and TaskDescription='Attended ML JIRA SRUM & Timesheet'

DELETE FROM TimesheetDetail WHERE TimesheetId=5853 and TimeSheetSubcategoryID=16 
and TaskDescription='Attended the health session'

DELETE FROM TimesheetDetail WHERE TimesheetId=6032 and TimeSheetSubcategoryID=16 
and TaskDescription='backlog grooming'


DELETE FROM TimesheetDetail WHERE TimesheetId=6017 and TimeSheetSubcategoryID=16 
and TaskDescription='Call with Deepak sir and Saumya for new timesheet demo and Action items status'

DELETE FROM TimesheetDetail WHERE TimesheetId=5996 and TimeSheetSubcategoryID=16 
and TaskDescription='Consumer Non-Scrum Meetings'

DELETE FROM TimesheetDetail WHERE TimesheetId=6009 and TimeSheetSubcategoryID=16 
and TaskDescription='Consumer Triage'


GO
WITH CTE AS (
    SELECT
        TimesheetId,
        TimeSheetCategoryID,
        TimeSheetSubcategoryID,
		TaskDescription,
		Value, Date,
        ROW_NUMBER() OVER (PARTITION BY TimesheetId,
        TimeSheetCategoryID,
        TimeSheetSubcategoryID,
		TaskDescription,
		Value, Date ORDER BY TimesheetId) AS RowNum
    FROM TimesheetDetail
)
DELETE FROM CTE WHERE RowNum > 1;

Update Timesheet SET TotalHours=40 WHERE TimesheetId=6025 and EmployeeID=1075

Update Timesheet SET TotalHours=40 WHERE TimesheetId=6026 and EmployeeID=751

Update Timesheet SET TotalHours=40 WHERE TimesheetId=5998 and EmployeeID=1082

DELETE FROM TimesheetDetail WHERE TimesheetId=6031 and TimeSheetSubcategoryID=16 
and TaskDescription='sync-up call'

DELETE FROM TimesheetDetail WHERE TimesheetId=6031 and TimeSheetSubcategoryID=16 
and TaskDescription='HR policy Refresher Session'

DELETE FROM TimesheetDetail WHERE TimesheetId=6031 and TimeSheetSubcategoryID=16 
and TaskDescription='Daily Sync-up Call'

DELETE FROM TimesheetDetail WHERE TimesheetId=6031 and TimeSheetSubcategoryID=16 
and TaskDescription='All Hands Meeting with Uno'

DELETE FROM TimesheetDetail WHERE TimesheetId=6031 and TimeSheetSubcategoryID=16 
and TaskDescription='one and one meeting with deepak sir'

SET IDENTITY_INSERT [dbo].[TimesheetDetail] ON 
GO
IF NOT EXISTS (SELECT * FROM TimesheetDetail where ID=71600 and TaskDescription='Follow-up with Awadh on a regular basis')
BEGIN
	INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) 
	VALUES (71600, 6031, 10, 155, N'Follow-up with Awadh on a regular basis', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-06-17T00:00:00.000' AS DateTime))
END


IF NOT EXISTS (SELECT * FROM TimesheetDetail where ID=71604 and TaskDescription='Follow-up with Awadh on a regular basis')
BEGIN
	INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) 
	VALUES (71604, 6031, 10, 155, N'Follow-up with Awadh on a regular basis', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-06-21T00:00:00.000' AS DateTime))
END
SET IDENTITY_INSERT [dbo].[TimesheetDetail] OFF
GO

SET IDENTITY_INSERT [dbo].[Timesheet] ON 
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) 
VALUES (6341, N'1094', 46, 1131, CAST(41.00 AS Decimal(5, 2)), CAST(N'2024-06-23T00:00:00.000' AS DateTime), CAST(N'2024-06-29T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-12T11:37:28.947' AS DateTime), NULL, NULL, 4, NULL)
GO
SET IDENTITY_INSERT [dbo].[Timesheet] OFF
GO

Update TimesheetDetail SET Date=DATEADD(day, 7, Date) where TimesheetId=6031 and TaskDescription='Daily Sync-up Call'

Update TimesheetDetail SET TimesheetId=6341 where TimesheetId=6031 and TaskDescription='Daily Sync-up Call'

Update TimesheetDetail SET TimesheetId=6341, Date=DATEADD(day, 7, Date) 
where TimesheetId=6031 and TaskDescription='Follow-up with Awadh on a regular basis' COLLATE Latin1_General_CS_AS 

Update TimesheetDetail SET TimesheetId=6341, Date=DATEADD(day, 7, Date) 
where TimesheetId=6031 and TaskDescription='Reviewing all the Registers' COLLATE Latin1_General_CS_AS 

Update TimesheetDetail SET TimesheetId=6341, Date=DATEADD(day, 7, Date) 
where TimesheetId=6031 and TaskDescription='Meeting related to iso' COLLATE Latin1_General_CS_AS 

Update TimesheetDetail SET TimesheetId=6341, Date=DATEADD(day, 7, Date) 
where TimesheetId=6031 and TaskDescription='Audited Inventory items, Pantry area and server room' COLLATE Latin1_General_CS_AS 

Update TimesheetDetail SET TimesheetId=6341, Date=DATEADD(day, 7, Date) 
where TimesheetId=6031 and TaskDescription='CO-ordinated with Avinash regarding exhaust fan and Ac maintenance' COLLATE Latin1_General_CS_AS 

Update TimesheetDetail SET TimesheetId=6341, Date=DATEADD(day, 7, Date) 
where TimesheetId=6031 and TaskDescription='All Hands Meeting with Uno' COLLATE Latin1_General_CS_AS 

Update TimesheetDetail SET TimesheetId=6341, Date=DATEADD(day, 7, Date) 
where TimesheetId=6031 and TaskDescription='one and one meeting with deepak sir' COLLATE Latin1_General_CS_AS 

Update TimesheetDetail SET TimesheetId=6341, Date=DATEADD(day, 7, Date) 
where TimesheetId=6031 and TaskDescription='Audited and Updated Kitty file' COLLATE Latin1_General_CS_AS 

Update TimesheetDetail SET TimesheetId=6341, Date=DATEADD(day, 7, Date) 
where TimesheetId=6031 and TaskDescription='HR policy Refresher Session' COLLATE Latin1_General_CS_AS 

Update TimesheetDetail SET TimesheetId=6341, Date=DATEADD(day, 7, Date) 
where TimesheetId=6031 and TaskDescription='training with Ganesh related to iso' COLLATE Latin1_General_CS_AS

DELETE FROM TimesheetDetail WHERE TimesheetId=5988 and TimeSheetSubcategoryID=16 
and TaskDescription='Daily Scrum'

DELETE FROM TimesheetDetail WHERE TimesheetId=5988 and TimeSheetSubcategoryID=16 
and TaskDescription='Team Assistance'

-- =============================================
-- Author:  <Akash Maurya>
-- Create date: <7/10/2024>
-- Description: <Get Pdf report>
-- =============================================
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
LEFT JOIN HolidayHours hh ON em.EmployeeId=hh.EmployeeID
LEFT JOIN TSProdNonProdHours tnh ON em.EmployeeId=tnh.EmployeeId
WHERE (ISNULL(@ClientId, 0) = 0 OR tm.ClientId = @ClientId)
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
Group by et.Function_Type, tc.TimeSheetCategoryName
END
-- =============================================
-- Author:		<Arpit Verma>
-- Create date: <7/19/24>
-- Description:	<to get the Adrenaline Leave hours>
-- =============================================
--select * from ClientMaster
GO
/****** Object:  StoredProcedure [dbo].[usp_AdrenalineLeave]    Script Date: 7/19/2024 6:19:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create or ALTER   PROCEDURE [dbo].[usp_AdrenalineLeave]-- '2024-06-16 00:00:00.000', '2024-06-22 00:00:00.000',9
 @startDate datetime,
 @endDate datetime,
 @clientId int
AS
BEGIN
	SET NOCOUNT ON;
with Leaves as (SELECT distinct(et.EmpId),Leave 
FROM EmployeeITProductivity et 
left Join Timesheet t on t.EmployeeID=et.EmpId  
inner join ClientMaster cm on cm.Id=t.ClientId
where  et.startDate >=@startDate AND et.weekenddate<=@endDate And et.Leave>0
AND (t.ClientId = @clientId))
select Sum(Leave) from Leaves
END


--if you have executed G&A report then only rename else run the below script
EXEC sp_rename '[usp_getG&AReport]', 'usp_getGandAReport';
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Arpit verma>
-- Create date: <17/7/24>
-- Description:	<to get the summary subcategory wise,>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[usp_getGandAReport] '2024-06-16 00:00:00.000' , '2024-06-22 00:00:00.000',46,'HR' 
@startDate datetime,
@endDate datetime,
@ClientId int,
@Function VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;	

    WITH EmployeeDetailsRows AS (    
	SELECT *, ROW_NUMBER() OVER (PARTITION BY BhavnaEmployeeId ORDER BY TeamId) AS RowNum FROM EmployeeDetails 
	)
	select Edr.EmployeeName as EmployeeName,
	tc.TimeSheetSubcategoryName as SubCategoryName,
	SUM(td.value) as Hours from  Timesheet ts 
	inner join EmployeeDetailsRows edr ON ts.EmployeeID =edr.BhavnaEmployeeId AND edr.RowNum = 1
	inner join EmployeeType et on edr.Type = et.Id
	inner join TimesheetDetail td on ts.TimesheetId=td.TimesheetId
	inner join TimeSheetSubcategory tc on Td.[TimeSheetSubCategoryID]= tc.[TimeSheetSubCategoryID]
	where ts.StatusId=4 AND ts.WeekStartDate >=@startDate AND ts.WeekEndDate<=@endDate AND tc.TimeSheetSubcategoryName!='PL' AND
	(ISNULL(@ClientId, 0) = 0 OR ts.ClientId = @ClientId) AND et.Function_Type = @Function
	Group by edr.EmployeeName, tc.TimeSheetSubcategoryName 
END
GO
--
Delete FROM Timesheet WHERE TimesheetId IN(
Select distinct ts.TimesheetId from JuneTimesheetData jtd 
left join Timesheet ts on jtd.[Emp Id]=ts.EmployeeID and jtd.[First Day of Period]=ts.WeekStartDate
left join TimesheetDetail tsd on tsd.TimesheetId=ts.TimesheetId
left join EmployeeDetails ed on ed.BhavnaEmployeeId=ts.EmployeeID
where ts.TimesheetId IS NOT NULL AND tsd.TimesheetId IS NULL)

GO
SET IDENTITY_INSERT [dbo].[Timesheet] ON
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6275, N'1074', 46, 1148, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-02T00:00:00.000' AS DateTime), CAST(N'2024-06-08T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6276, N'TEMP036', 9, 1051, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-02T00:00:00.000' AS DateTime), CAST(N'2024-06-08T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6277, N'645', 9, 1040, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-02T00:00:00.000' AS DateTime), CAST(N'2024-06-08T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6278, N'TEMP090', 46, 1133, CAST(20.00 AS Decimal(5, 2)), CAST(N'2024-06-02T00:00:00.000' AS DateTime), CAST(N'2024-06-08T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6279, N'344', 9, 1046, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-02T00:00:00.000' AS DateTime), CAST(N'2024-06-08T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6280, N'1074', 46, 1148, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-09T00:00:00.000' AS DateTime), CAST(N'2024-06-15T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6281, N'TEMP036', 9, 1051, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-09T00:00:00.000' AS DateTime), CAST(N'2024-06-15T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6282, N'645', 9, 1040, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-09T00:00:00.000' AS DateTime), CAST(N'2024-06-15T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6283, N'TEMP090', 46, 1133, CAST(20.00 AS Decimal(5, 2)), CAST(N'2024-06-09T00:00:00.000' AS DateTime), CAST(N'2024-06-15T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6284, N'645', 9, 1040, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-16T00:00:00.000' AS DateTime), CAST(N'2024-06-22T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6285, N'TEMP090', 46, 1133, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-23T00:00:00.000' AS DateTime), CAST(N'2024-06-29T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6286, N'TEMP090', 46, 1133, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-16T00:00:00.000' AS DateTime), CAST(N'2024-06-22T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6287, N'1074', 46, 1148, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-16T00:00:00.000' AS DateTime), CAST(N'2024-06-22T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6288, N'TEMP036', 9, 1051, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-23T00:00:00.000' AS DateTime), CAST(N'2024-06-29T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6289, N'1074', 46, 1148, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-23T00:00:00.000' AS DateTime), CAST(N'2024-06-29T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6290, N'645', 9, 1040, CAST(40.00 AS Decimal(5, 2)), CAST(N'2024-06-23T00:00:00.000' AS DateTime), CAST(N'2024-06-29T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (6291, N'1094', 46, 1131, CAST(41.00 AS Decimal(5, 2)), CAST(N'2024-06-23T00:00:00.000' AS DateTime), CAST(N'2024-06-29T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-07-14T23:31:25.320' AS DateTime), NULL, NULL, 4, NULL)
GO
SET IDENTITY_INSERT [dbo].[Timesheet] OFF

 GO
SET IDENTITY_INSERT [dbo].[TimesheetDetail] ON
 GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74800, 6289, 5, 170, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74802, 6289, 5, 167, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74803, 6289, 5, 167, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74804, 6289, 5, 167, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74807, 6289, 5, 171, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74809, 6286, 20, 181, N'Sourcing the profiles from LikedIn & Google', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74810, 6286, 20, 181, N'Sourcing the profiles from LikedIn & Google', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74811, 6286, 20, 181, N'Sourcing the profiles from LikedIn & Google', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74812, 6286, 20, 181, N'Sourcing the profiles from LikedIn & Google', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-20T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74813, 6286, 20, 181, N'Sourcing the profiles from LikedIn & Google', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74814, 6286, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74815, 6286, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74816, 6286, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-20T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74817, 6286, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74818, 6286, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74819, 6286, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74820, 6286, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74821, 6286, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-20T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74822, 6286, 20, 183, N'Scheduling and coordination', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74823, 6286, 20, 183, N'Scheduling and coordination', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-20T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74824, 6286, 20, 183, N'Scheduling and coordination', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74825, 6286, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74826, 6286, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74827, 6286, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74828, 6286, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74829, 6286, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74830, 6286, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-20T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74831, 6286, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74832, 6286, 20, 183, N'Scheduling and coordination', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74833, 6286, 20, 183, N'Scheduling and coordination', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74836, 6275, 5, 171, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74840, 6275, 5, 171, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74844, 6275, 5, 171, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74847, 6275, 5, 170, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74849, 6275, 5, 167, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74850, 6278, 20, 181, N'Sourcing the profiles in Linked In', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74851, 6278, 20, 181, N'Sourcing the profiles in Linked In', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74852, 6278, 20, 181, N'Sourcing the profiles in Linked In', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74853, 6278, 20, 181, N'Sourcing the profiles in Linked In', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74854, 6278, 20, 181, N'Sourcing the profiles in Linked In', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74855, 6278, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74856, 6278, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74857, 6278, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74858, 6278, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74859, 6278, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74860, 6278, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74861, 6278, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74862, 6278, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74863, 6278, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74864, 6278, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74865, 6278, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74866, 6278, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74867, 6278, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74868, 6278, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74869, 6278, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74870, 6278, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74871, 6278, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74872, 6278, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74873, 6278, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74874, 6278, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74877, 6287, 5, 171, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74881, 6287, 5, 171, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74884, 6287, 5, 170, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74886, 6287, 1, 26, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74887, 6287, 5, 167, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-20T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74888, 6281, 1, 18, N'TazWorks Scrum Meetings', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74889, 6281, 2, 1, N'TAZ-27208', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74890, 6281, 2, 1, N'TAZ-27208', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74891, 6281, 1, 25, N'TAZ-27085', N'HH', CAST(0.33 AS Decimal(5, 2)), CAST(N'2024-06-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74892, 6281, 1, 25, N'TAZ-27085', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74893, 6281, 1, 25, N'TAZ-27085', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74894, 6281, 1, 25, N'TAZ-27085', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74895, 6281, 2, 1, N'TAZ-27139', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74896, 6281, 2, 1, N'TAZ-27208', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74897, 6281, 1, 18, N'TazWorks Scrum Meetings', N'HH', CAST(0.67 AS Decimal(5, 2)), CAST(N'2024-06-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74898, 6281, 1, 18, N'TazWorks Scrum Meetings', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74899, 6281, 1, 18, N'TazWorks Scrum Meetings', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74900, 6281, 2, 1, N'TAZ-19688', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74901, 6281, 2, 1, N'TAZ-19688', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74902, 6281, 1, 25, N'TAZ-27085', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74903, 6284, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74904, 6284, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74905, 6284, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74906, 6284, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-20T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74907, 6284, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74908, 6284, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74909, 6284, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74910, 6284, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-20T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74911, 6284, 18, 36, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-21T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74912, 6290, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74913, 6290, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74914, 6290, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74915, 6290, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74916, 6290, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74918, 6290, 1, 17, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74920, 6290, 1, 17, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74922, 6290, 1, 17, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74924, 6290, 1, 17, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74926, 6290, 1, 17, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74927, 6279, 18, 39, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74928, 6279, 18, 39, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74929, 6279, 18, 39, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74930, 6279, 18, 39, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74931, 6279, 18, 39, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74932, 6282, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74933, 6282, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74934, 6282, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74935, 6282, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74936, 6282, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74937, 6282, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74938, 6282, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74939, 6282, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74940, 6282, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74941, 6282, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74942, 6276, 1, 18, N'TazWorks Scrum Meetings', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74943, 6276, 1, 18, N'TazWorks Scrum Meetings', N'HH', CAST(1.50 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74944, 6276, 1, 18, N'TazWorks Scrum Meetings', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74945, 6276, 1, 18, N'TazWorks Scrum Meetings', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74946, 6276, 2, 1, N'TAZ-19688', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74947, 6276, 2, 1, N'TAZ-19688', N'HH', CAST(6.00 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74948, 6276, 2, 1, N'TAZ-27239', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74949, 6276, 1, 25, N'TAZ-27085', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74950, 6276, 1, 25, N'TAZ-27085', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74951, 6276, 2, 1, N'TAZ-27139', N'HH', CAST(6.00 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74952, 6276, 2, 1, N'TAZ-27139', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74953, 6276, 2, 1, N'TAZ-27139', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74954, 6276, 2, 1, N'TAZ-27139', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74955, 6276, 2, 1, N'TAZ-26971', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74956, 6276, 2, 1, N'TAZ-26971', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74957, 6276, 2, 1, N'TAZ-26971', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74958, 6276, 1, 25, N'TAZ-27085', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74959, 6276, 1, 25, N'TAZ-27085', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74960, 6276, 1, 25, N'TAZ-27085', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74961, 6285, 20, 181, N'Sourcing the profiles in LinkedIn & Google', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74962, 6285, 20, 181, N'Sourcing the profiles in LinkedIn & Google', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74963, 6285, 20, 181, N'Sourcing the profiles in LinkedIn & Google', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74964, 6285, 20, 181, N'Sourcing the profiles in LinkedIn & Google', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74965, 6285, 20, 181, N'Sourcing the profiles in LinkedIn & Google', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74966, 6285, 20, 182, N'Screening the profiles and collecting the details fro the candidates', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74967, 6285, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74968, 6285, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74969, 6285, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74970, 6285, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74971, 6285, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74972, 6285, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74973, 6285, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74974, 6285, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74975, 6285, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74976, 6285, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74977, 6285, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74978, 6285, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74979, 6285, 1, 19, N'Daily meeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74980, 6285, 20, 182, N'Screening the profiles and collecting the details fro the candidates', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74981, 6285, 20, 182, N'Screening the profiles and collecting the details fro the candidates', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74982, 6285, 20, 182, N'Screening the profiles and collecting the details fro the candidates', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74983, 6285, 20, 182, N'Screening the profiles and collecting the details fro the candidates', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74984, 6285, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74985, 6285, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74986, 6288, 1, 18, N'TazWorks Scrum Meetings', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74987, 6288, 1, 18, N'TazWorks Scrum Meetings', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74988, 6288, 1, 18, N'TazWorks Scrum Meetings', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74989, 6288, 2, 1, N'TAZ-27208', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74990, 6288, 2, 1, N'TAZ-27208', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74991, 6288, 1, 25, N'TAZ-27085', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74992, 6288, 2, 1, N'TAZ-27305', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74993, 6288, 1, 25, N'TAZ-27085', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74994, 6288, 1, 25, N'TAZ-27085', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74995, 6288, 1, 25, N'TAZ-27085', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74996, 6288, 1, 25, N'TAZ-27085', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74997, 6288, 2, 1, N'TAZ-27139', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74998, 6288, 2, 1, N'TAZ-27139', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (74999, 6277, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75000, 6277, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75001, 6277, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75002, 6277, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75003, 6277, 2, 1, N'NA', N'HH', CAST(7.00 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75004, 6277, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-03T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75005, 6277, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75006, 6277, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75007, 6277, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-06T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75008, 6277, 1, 16, N'NA', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-07T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75010, 6291, 1, 17, N'Daily Sync-up Call', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75012, 6291, 1, 17, N'Daily Sync-up Call', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75014, 6291, 1, 17, N'Daily Sync-up Call', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75016, 6291, 1, 17, N'Daily Sync-up Call', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75018, 6291, 1, 17, N'Daily Sync-up Call', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75019, 6291, 10, 155, N'Follow-up with Awadh on a regular basis', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75021, 6291, 1, 17, N'HR policy Refresher Session', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75022, 6291, 10, 155, N'training with Ganesh related to iso', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75023, 6291, 10, 149, N'CO-ordinated with Avinash regarding exhaust fan and Ac maintenance', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75024, 6291, 10, 149, N'CO-ordinated with Avinash regarding exhaust fan and Ac maintenance', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75025, 6291, 10, 149, N'CO-ordinated with Avinash regarding exhaust fan and Ac maintenance', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75027, 6291, 1, 17, N'All Hands Meeting with Uno', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75029, 6291, 1, 17, N'one and one meeting with deepak sir', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75030, 6291, 10, 146, N'Audited and Updated Kitty file', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75031, 6291, 10, 149, N'Audited Inventory items, Pantry area and server room', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75032, 6291, 10, 149, N'Audited Inventory items, Pantry area and server room', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75033, 6291, 10, 149, N'Audited Inventory items, Pantry area and server room', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75034, 6291, 10, 149, N'Audited Inventory items, Pantry area and server room', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75035, 6291, 10, 149, N'CO-ordinated with Avinash regarding exhaust fan and Ac maintenance', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75036, 6291, 10, 149, N'CO-ordinated with Avinash regarding exhaust fan and Ac maintenance', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75037, 6291, 10, 155, N'Event Planning and Management', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75038, 6291, 10, 155, N'Meeting related to iso', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75039, 6291, 10, 155, N'Meeting related to iso', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75040, 6291, 10, 155, N'Meeting related to iso', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75041, 6291, 10, 155, N'Meeting related to iso', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75042, 6291, 10, 149, N'Audited Inventory items, Pantry area and server room', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75043, 6291, 10, 155, N'Reviewing all the Registers', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75044, 6291, 10, 155, N'Reviewing all the Registers', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75045, 6291, 10, 155, N'Reviewing all the Registers', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75046, 6291, 10, 155, N'Event Planning and Management', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75047, 6291, 10, 155, N'Event Planning and Management', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75048, 6291, 10, 155, N'Event Planning and Management', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75049, 6291, 10, 155, N'Follow-up with Awadh on a regular basis', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75050, 6291, 10, 155, N'Follow-up with Awadh on a regular basis', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-06-26T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75051, 6291, 10, 155, N'Follow-up with Awadh on a regular basis', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-27T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75052, 6291, 10, 155, N'Follow-up with Awadh on a regular basis', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-06-28T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75053, 6291, 10, 155, N'Reviewing all the Registers', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-24T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75054, 6291, 10, 155, N'Reviewing all the Registers', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-25T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75055, 6283, 20, 181, N'Sourcing the profiles in Linked In & Google', N'HH', CAST(1.50 AS Decimal(5, 2)), CAST(N'2024-06-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75056, 6283, 20, 181, N'Sourcing the profiles in Linked In & Google', N'HH', CAST(1.50 AS Decimal(5, 2)), CAST(N'2024-06-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75057, 6283, 20, 181, N'Sourcing the profiles in Linked In & Google', N'HH', CAST(1.50 AS Decimal(5, 2)), CAST(N'2024-06-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75058, 6283, 20, 181, N'Sourcing the profiles in Linked In & Google', N'HH', CAST(1.50 AS Decimal(5, 2)), CAST(N'2024-06-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75059, 6283, 20, 181, N'Sourcing the profiles in Linked In & Google', N'HH', CAST(1.50 AS Decimal(5, 2)), CAST(N'2024-06-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75060, 6283, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75061, 6283, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75062, 6283, 1, 19, N'Daily neeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75063, 6283, 1, 19, N'Daily neeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75064, 6283, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75065, 6283, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75066, 6283, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75067, 6283, 2, 11, N'MIS', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75068, 6283, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75069, 6283, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75070, 6283, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75071, 6283, 1, 19, N'Daily neeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75072, 6283, 1, 19, N'Daily neeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75073, 6283, 1, 19, N'Daily neeting', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75074, 6283, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75075, 6283, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75076, 6283, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75077, 6283, 20, 182, N'Screening the profiles and collecting the details from the candidates', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-06-14T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75078, 6283, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75079, 6283, 20, 183, N'Scheduling and coordinating the interviews', N'HH', CAST(0.50 AS Decimal(5, 2)), CAST(N'2024-06-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75082, 6280, 5, 171, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75085, 6280, 5, 170, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75087, 6280, 5, 167, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75088, 6280, 1, 26, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (75089, 6280, 5, 161, N'NA', N'HH', CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-06-14T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[TimesheetDetail] OFF
GO



	Delete FROM TimesheetDetail where TimesheetId IN (6121)
	and TaskDescription='- Fun activity.' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5886)
	and TaskDescription='- leads call with Uno. - doctor''s session on posture.' and TimeSheetSubcategoryID=16
 
 
	Delete FROM TimesheetDetail where TimesheetId IN (6124, 6088)
	and TaskDescription='#All Hands Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5774)
	and TaskDescription='#Internal DSM(S2C/Opic/DC/TendSign/MSS) #Dev Discussion meetings #Sync ups/technical/team issues discussion. #Meeting for AI Better Matching queries/technical discussions #Rubicon Importer tech discussions #S2C MeForms transition' and TimeSheetSubcategoryID=16
 
 
	Delete FROM TimesheetDetail where TimesheetId IN (5916)
	and TaskDescription='#Meeting with Uno' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5573)
	and TaskDescription='#Staff Call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5445)
	and TaskDescription='1 - 1 with Sasi' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6095)
	and TaskDescription='1. All Hands Meeting 2. Policy Refresher Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5490)
	and TaskDescription='1. Connect with Puneet - Intro' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5682)
	and TaskDescription='1. HR fun activity' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6126)
	and TaskDescription='1. HR session 2. All hands meeting with uno' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5896)
	and TaskDescription='1. Meet with Uno (Taj Mahal)' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5480)
	and TaskDescription='1.Employee Engagement Committee - Catch Up Meeting 2.Sync up with Dhiraj' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5549, 5666)
	and TaskDescription='1:1 with Maryam' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5468)
	and TaskDescription='1:1 with Sasi' and TimeSheetSubcategoryID=16
 
 
	Delete FROM TimesheetDetail where TimesheetId IN (5666, 5549, 6172)
	and TaskDescription='1:1 with Subba' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6041)
	and TaskDescription='5. All hand meeting.' and TimeSheetSubcategoryID=16
 
 
	Delete FROM TimesheetDetail where TimesheetId IN (5786, 6176, 5578, 5970)
	and TaskDescription='Access Daily standup' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6043)
	and TaskDescription='Admad - Celebration' and TimeSheetSubcategoryID=16
 

	Delete FROM TimesheetDetail where TimesheetId IN (6186)
	and TaskDescription='ADMAD Game' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6227, 5812, 5838)
	and TaskDescription='AI Initiative call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6227)
	and TaskDescription='All Hand Meet' and TimeSheetSubcategoryID=16
	
 
	Delete FROM TimesheetDetail where TimesheetId IN (6197, 6089, 6133, 6148)
	and TaskDescription='All hand meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6167, 6116, 6112, 6113, 6090, 6097, 6184, 6186)
	and TaskDescription='All hands' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6043)
	and TaskDescription='All Hands Meet' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6109)
	and TaskDescription='All Hands meet UNO Fun session in hyd office' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6115, 6129, 6125, 6076, 6144, 6139, 6153,
	6147, 6146, 6135, 6164, 6182, 6188, 6192, 6194, 6191, 6193, 6210, 6179, 6204, 6224, 6092,
	6087, 6086, 6085, 6077, 6073, 6074, 6103, 6101, 6024, 6016, 6065, 6064, 6049, 5627)
	and TaskDescription='All Hands Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6174)
	and TaskDescription='ALL Hands meeting Bhavna' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6198)
	and TaskDescription='All Hands Meeting and Policy Refresher Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6099)
	and TaskDescription='All Hands Meeting with CEO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6120)
	and TaskDescription='All hands meeting with CEO.' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6111, 6223, 6177, 6172, 6031, 6291)
	and TaskDescription='all hands meeting with UNO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6063)
	and TaskDescription='All Hands Meeting, Bhavna Informal Training' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6141)
	and TaskDescription='All Hands Meeting, Policy Refresher' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6104)
	and TaskDescription='All hands meeting, Policy refresher meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6114)
	and TaskDescription='All Hands Meeting, Policy Refresher Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6143)
	and TaskDescription='All hands meeting.' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6136)
	and TaskDescription='All hands meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6071)
	and TaskDescription='All-hands meeting + HR refresher meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5936)
	and TaskDescription='Attended "Invitation for Health Session "' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6189, 6107)
	and TaskDescription='Attended All hands meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6154)
	and TaskDescription='Attended All hands meeting with UNO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6036, 5999)
	and TaskDescription='Attended Health Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6154)
	and TaskDescription='Attended meeting on "Policy refreshed Session" with Swetha' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5945)
	and TaskDescription='Attended ML JIRA SRUM & Timesheet' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5745)
	and TaskDescription='Attended ML-KT about project' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6074, 6189)
	and TaskDescription='Attended Policy refresher session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6019)
	and TaskDescription='Attended Policy refresher session All hands meeting-UNO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6189)
	and TaskDescription='Attended Product domain KT session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5853)
	and TaskDescription='Attended the health session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5745)
	and TaskDescription='Attended Understanding the process of KT' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5825)
	and TaskDescription='Audited tracker items and updated it' and TimeSheetSubcategoryID=141
 
	Delete FROM TimesheetDetail where TimesheetId IN (5464)
	and TaskDescription='backlog groomimg' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6032, 5561)
	and TaskDescription='backlog grooming' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5967, 5649)
	and TaskDescription='BDEV deployment' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (6102)
	and TaskDescription='Bhavna All hands' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6106)
	and TaskDescription='Bhavna All hands/Policy refresher meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6149)
	and TaskDescription='Bhavna Meeting : All Hands' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6149)
	and TaskDescription='Bhavna Meeting : Policy Refresher' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6139)
	and TaskDescription='Bhavna Policy refresher' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6136)
	and TaskDescription='Call for Laptop Change Process' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6017)
	and TaskDescription='Call with Deepak sir and Saumya for new timesheet demo and Action items status' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5579)
	and TaskDescription='Call with Deepak sir to discuss PO & Diwali' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5579)
	and TaskDescription='Call with Saumya and Awadh to discuss ISO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5575)
	and TaskDescription='Connect with Orlando' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5743)
	and TaskDescription='Connected with Ranjan For SetUp' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5996)
	and TaskDescription='Consumer Non-Scrum Meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5654)
	and TaskDescription='Consumer Offshore Triage Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5417)
	and TaskDescription='Consumer Offshore Triage Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5665)
	and TaskDescription='Consumer QA Monthly Connect' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6156, 6009, 5795, 5561)
	and TaskDescription='Consumer Triage' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6123)
	and TaskDescription='Consumer Triage Session Offshore' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6017)
	and TaskDescription='Cordination with Awadh for AC issues, Followups and Uno''s Lunch arrangements and followup with Avinash for updates' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6227)
	and TaskDescription='CTM & Tendsign backlog review call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5635)
	and TaskDescription='CTM-TendSign Repo access discussion with Ankur Rusia' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5417, 6123, 5654, 5988)
	and TaskDescription='Daily Scrum' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6156, 6009, 5795, 5561)
	and TaskDescription='Daily Standup' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5419)
	and TaskDescription='Daily Standup - Consumer, Internal Meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5653)
	and TaskDescription='Daily Standup - Consumer, Titans Offshore Daily Sync up' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6031, 6291)
	and TaskDescription='Daily Sync-up Call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6017, 5826, 5579)
	and TaskDescription='Daily Syncup call and other adhoc calls for Operational activities' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5627)
	and TaskDescription='Data collection - Rubicon integration' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5518)
	and TaskDescription='David & Bhavna Meetup' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5627)
	and TaskDescription='Delivery process discussion with Matt' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5627)
	and TaskDescription='Demo Call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5953)
	and TaskDescription='Desk Exercise Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5441, 5955, 5759)
	and TaskDescription='Dipanshu & Hapa 1:! time' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5413)
	and TaskDescription='Discussion with CEO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5413)
	and TaskDescription='Discussion with HR' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5413)
	and TaskDescription='Discussion with RM' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5435)
	and TaskDescription='Discussion with uno' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6033)
	and TaskDescription='Documents audit for all new hires from 01 July 23'' till 30 June 24''' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5627, 5838, 6227, 5812)
	and TaskDescription='DSM and Internal query session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6230)
	and TaskDescription='Email leave request against Actual Adrenalin updated. Audit report shared with Swati' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5924)
	and TaskDescription='Ergonomics session (HR activity)' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5484)
	and TaskDescription='Ethics sync up' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5476)
	and TaskDescription='FareWell Call for Sohit' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5705)
	and TaskDescription='Fire drill' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5716)
	and TaskDescription='fire mock' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5711)
	and TaskDescription='fire mock drill' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5739)
	and TaskDescription='Fire mock drill meet' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5709)
	and TaskDescription='Fire mock drill session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6069)
	and TaskDescription='Friday: All hands meeting with UNO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6068, 5595, 5610, 6064)
	and TaskDescription='Fun activity' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6034)
	and TaskDescription='Fun Activity and team lunch' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5937)
	and TaskDescription='Fun activity at office' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5683)
	and TaskDescription='Fun Activity In Office (Org by HR)' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5659)
	and TaskDescription='Fun Filled Thursday' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5724)
	and TaskDescription='Fun Filled Thursday in Office' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6167)
	and TaskDescription='Fun meet in office' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5952)
	and TaskDescription='Fun Session and Health Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6167)
	and TaskDescription='Fun session Mortgage' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6090)
	and TaskDescription='Fun Session with team' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5749)
	and TaskDescription='Fun thursday in office' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6090)
	and TaskDescription='Fun time in Office' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6103)
	and TaskDescription='Get together in office with Uno' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6227, 5812, 5838)
	and TaskDescription='Grooming call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5441, 5759, 5955)
	and TaskDescription='GSD Crew Weekly Sync' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6097)
	and TaskDescription='Gundam demo' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5450)
	and TaskDescription='Gunners Backlog Grooming, Gunners Daily Standup' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5937)
	and TaskDescription='Health awareness' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5921, 5862, 5827, 5870, 5918, 5946)
	and TaskDescription='Health Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5878, 5962)
	and TaskDescription='Health Session : Desk Workouts' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5859, 5954, 6002)
	and TaskDescription='Health talk session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5995)
	and TaskDescription='Healthtalk session.' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6011, 5783, 5562)
	and TaskDescription='Helping team member, MCL Processes, Weekely Dashboard Review' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6196)
	and TaskDescription='Helping team member, MCL Processes, Weekely Dashboard Review, all hands' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6220)
	and TaskDescription='HR - Policy Refresher Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5847)
	and TaskDescription='HR Activity' and TimeSheetSubcategoryID IN (36, 174)
 
	Delete FROM TimesheetDetail where TimesheetId IN (6172)
	and TaskDescription='HR connect session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6200)
	and TaskDescription='HR fun activity' and TimeSheetSubcategoryID IN (36, 174)
 
	Delete FROM TimesheetDetail where TimesheetId IN (5591, 5674)
	and TaskDescription='HR Fun activity session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6201)
	and TaskDescription='HR Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6197)
	and TaskDescription='HR policy meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6031, 6291)
	and TaskDescription='HR policy Refresher Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6016)
	and TaskDescription='HR Policy Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6097)
	and TaskDescription='informal training' and TimeSheetSubcategoryID=16
	
	Delete FROM TimesheetDetail where TimesheetId IN (5637)
	and TaskDescription='Internal ABC and Migrations teams meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6047)
	and TaskDescription='Internal call- Policy refresher meeting with HR, All hands meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5526)
	and TaskDescription='Internal calls' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5510, 5663)
	and TaskDescription='Internal DSM' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6161)
	and TaskDescription='Internal meeting - Policy Refresher Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5443)
	and TaskDescription='Internal meeting QACNT-19' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6078)
	and TaskDescription='Internal Non-Tech Meeting- All hands Mortgage team fun session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5971)
	and TaskDescription='Invitation for Health Session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5959, 5948, 6027, 5919, 5874, 5871, 5845)
	and TaskDescription='Invitation for Health Session : Desk Workouts' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6230)
	and TaskDescription='ISO Audit deck prepared and shared with Swetha' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5812, 5838)
	and TaskDescription='JIRA Migration DC-Opic' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6134)
	and TaskDescription='Joined the All Hance meeting.' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6134)
	and TaskDescription='Joined the HR meeting related to Policy Refresher Session.' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5441)
	and TaskDescription='Kofax and Payment Allocations' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5759, 5955, 5441)
	and TaskDescription='Marketplace Operations Huddle' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5520)
	and TaskDescription='MCL Weekly Sync Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5657)
	and TaskDescription='MCL Weekly Sync-up Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6192)
	and TaskDescription='Meet and Greet with Tazworks' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6099)
	and TaskDescription='Meet and Greet with Tazworks' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6008)
	and TaskDescription='Meet with Uno' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5585)
	and TaskDescription='meeting & discussion' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6219)
	and TaskDescription='meeting and discussion' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5829)
	and TaskDescription='meeting and discussion' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (2102)
	and TaskDescription='meeting and discussion' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5565)
	and TaskDescription='Meeting regarding weekly dashboard update' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5825)
	and TaskDescription='Meeting related to ISO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6014)
	and TaskDescription='Meeting to discuss Korn Ferry ranking exercise and north star metrics' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5826)
	and TaskDescription='Meeting with Deepak sir for Team action items review and ISO audit' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5733, 5958, 5536, 6159)
	and TaskDescription='Meeting with QA team members on requirement basis' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6014)
	and TaskDescription='Meeting with RevOps team members regarding RevOps Hackathon' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5826)
	and TaskDescription='Meeting with Smartworks team for Parking' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5767)
	and TaskDescription='Meeting with Subba' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5700)
	and TaskDescription='Meeting With Subba (understand the  progress of KT Session)  and Fun Thursday' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5772)
	and TaskDescription='Meeting with Subba : Progress on Document setup, Report on KT, Fun activity' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5628)
	and TaskDescription='Meeting With Subba, Meeting with New joinee' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5579)
	and TaskDescription='Meeting with Trident team to discuss Diwali venue' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5967, 6009, 6012, 5990, 5504, 5505)
	and TaskDescription='meeting with UNO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5604)
	and TaskDescription='Meeting with Uno,' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6058)
	and TaskDescription='meetings and discussion' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5541)
	and TaskDescription='Meetings and working on deliverables' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6221)
	and TaskDescription='Meetings with client and performing assigned tasks' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5637)
	and TaskDescription='Migration to Reporting Layer - QA Meeting regarding to same' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5914)
	and TaskDescription='Misc PM activities' and TimeSheetSubcategoryID IN (36, 130)
 
	Delete FROM TimesheetDetail where TimesheetId IN (5755, 5560)
	and TaskDescription='Misc PM activities' and TimeSheetSubcategoryID IN (36, 130)
 
	Delete FROM TimesheetDetail where TimesheetId IN (5948, 5871, 5868)
	and TaskDescription='ML JIRA, scrum/kanban and timesheet related training' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5982)
	and TaskDescription='ML/Jira Scrum kanban meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5736)
	and TaskDescription='Mock Drill On Fire alarm' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5753, 5814)
	and TaskDescription='Mock Fire Drill' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5458)
	and TaskDescription='Monthly 1-1 with Sasikala' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6227)
	and TaskDescription='MTS Escalation review call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6289)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (36, 174) and Date='2024-06-27 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6289)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (36, 126, 174) and Date='2024-06-28 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6275)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (36, 126, 174) and Date='2024-06-03 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6275)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (36, 126, 174) and Date='2024-06-04 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6275)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (36, 126, 174) and Date='2024-06-06 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6275)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (36, 174) and Date='2024-06-05 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6287)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (36, 126, 174) and Date='2024-06-17 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6287)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (36, 126, 174)
	
	Delete FROM TimesheetDetail where TimesheetId IN (6290)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (16) and Date='2024-06-24 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6290)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (16) and Date='2024-06-25 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6290)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (16) and Date='2024-06-26 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6290)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (16) and Date='2024-06-27 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6290)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (16) and Date='2024-06-28 00:00:00.000'
 
	Delete FROM TimesheetDetail where TimesheetId IN (6280)
	and TaskDescription='NA' and TimeSheetSubcategoryID IN (36, 126, 174)
	
	Delete FROM TimesheetDetail where TimesheetId IN (5730)
	and TaskDescription='New joiners KT review with Subba and Consumer qa connect' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5955, 5759, 5441)
	and TaskDescription='NEW Open Office Hours' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5951, 5734, 5544)
	and TaskDescription='Non- Scrum Meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5549, 6172, 5924, 5666)
	and TaskDescription='Non-scrum meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6155)
	and TaskDescription='Offshore team meeting, Policy related meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5422)
	and TaskDescription='Old user backup' and TimeSheetSubcategoryID IN (36, 171, 174)
	
	Delete FROM TimesheetDetail where TimesheetId IN (5416)
	and TaskDescription='OLD User data backup' and TimeSheetSubcategoryID IN (36, 171, 174)
	
	Delete FROM TimesheetDetail where TimesheetId IN (5849)
	and TaskDescription='OLD User data backup' and TimeSheetSubcategoryID IN (36, 171, 174) 
	
	Delete FROM TimesheetDetail where TimesheetId IN (5656)
	and TaskDescription='User management and system preparation' and TimeSheetSubcategoryID IN (36, 171, 174)
	
	Delete FROM TimesheetDetail where TimesheetId IN (5646)
	and TaskDescription='OLD User data backup' and TimeSheetSubcategoryID IN (36, 171, 174)
	
	Delete FROM TimesheetDetail where TimesheetId IN (6031, 6291)
	and TaskDescription='one and one meeting with deepak sir' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5508)
	and TaskDescription='One on One with Asmani for PMS review' and TimeSheetSubcategoryID=16
	
	Delete FROM TimesheetDetail where TimesheetId IN (5617)
	and TaskDescription='Operations' and TimeSheetSubcategoryID=85
	
	Delete FROM TimesheetDetail where TimesheetId IN (6055, 6072, 5841)
	and TaskDescription='Operations' and TimeSheetSubcategoryID=85
 
	Delete FROM TimesheetDetail where TimesheetId IN (6195)
	and TaskDescription='org meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5955)
	and TaskDescription='Partner Invoice Review - Equifax' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5758)
	and TaskDescription='Performing scheduled tasks and meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6220)
	and TaskDescription='PMO Report & Next Step Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5932)
	and TaskDescription='PMO Sync Up/Meeting with CEO/Discussion Call with Asmani on Confirmation and Feedback' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5658, 5847, 5413)
	and TaskDescription='PMO Syncup' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5932)
	and TaskDescription='PMO SyncUp Call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5932)
	and TaskDescription='PMO SyncUp Call/Reverse KT' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5847)
	and TaskDescription='PMO Team discussion with UNO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6227)
	and TaskDescription='Policy refresher' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6206)
	and TaskDescription='Policy Refresher + All hands meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6167, 6089, 6108)
	and TaskDescription='Policy refresher meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6145)
	and TaskDescription='Policy Refresher Meeting & All Hands' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6168)
	and TaskDescription='Policy refresher meeting, All hands meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6158, 6135, 6164, 6077, 6085, 6073,
	6144, 6148, 6147, 6099, 6103, 6111, 6115, 6125, 6204, 6223, 6224, 6182, 6192, 6179, 6193,
	6024, 6043, 6049, 6067)
	and TaskDescription='policy refresher session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6100)
	and TaskDescription='Policy Refresher session & All Hands Meeting with UNO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6122)
	and TaskDescription='Policy refresher session , All hand Meeting with UNO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6132)
	and TaskDescription='Policy Refresher Session All Hands Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6060)
	and TaskDescription='Policy Refresher Session All Hands Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6137)
	and TaskDescription='Policy Refresher Session All Hands Meeting Farewell meet' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6138)
	and TaskDescription='Policy Refresher Session and All Hands Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6081)
	and TaskDescription='Policy Refresher Session Uno''s All Hand' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6169)
	and TaskDescription='Policy refresher, All Hands , Fun session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6131)
	and TaskDescription='Policy Refresher, SIE Team Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6065)
	and TaskDescription='Policy Refreshing Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6186)
	and TaskDescription='Policy Refreshment' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6210)
	and TaskDescription='Policy refreshment session' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6045)
	and TaskDescription='Policy Session, All Hand Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5557)
	and TaskDescription='POS Scrum Meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5991, 6225, 5790)
	and TaskDescription='POS Non-Scrum Meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5621)
	and TaskDescription='Worked on Leave Audit File and with Swetha' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5621)
	and TaskDescription='Prepared and shared Consolidated Attendance data as per Org chart with Swati' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (6033)
	and TaskDescription='Prepared and shared Service Certificate with Chetna' and TimeSheetSubcategoryID=130
 
	Delete FROM TimesheetDetail where TimesheetId IN (6230)
	and TaskDescription='Preparing attendance report and WSR Data update' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5795, 6156, 5561, 6009)
	and TaskDescription='Project Refinement Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5957)
	and TaskDescription='QA / BA - Regarding observation and testing point of view discussion' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6161)
	and TaskDescription='QA Internal meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5823)
	and TaskDescription='QA Meeting regarding to observations and found some issues' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6054)
	and TaskDescription='QA status meeting with Sejal' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5957)
	and TaskDescription='QA SYNC UP meeting regarding to migration team.' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5984, 5738)
	and TaskDescription='QACNT-25 Daily standup meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6135, 5489)
	and TaskDescription='QACNT-25 Daily standup meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5955)
	and TaskDescription='Re-Group BlackLine' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6097)
	and TaskDescription='Retrospecive' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5689)
	and TaskDescription='Retrospective' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5627)
	and TaskDescription='S2C capacity and Retrospective' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6227)
	and TaskDescription='S2C requirement call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5812, 5838)
	and TaskDescription='S2C SPS call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5621)
	and TaskDescription='Shared email with Leave defaulters' and TimeSheetSubcategoryID=130
 
	Delete FROM TimesheetDetail where TimesheetId IN (6230)
	and TaskDescription='Shared email with WFH criteria not met defaulter''s RM for confirmation' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5574)
	and TaskDescription='Sohit Farewell' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5529)
	and TaskDescription='Sohit''s Farewell and Connected With Ranjan for Dev Setup' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6097, 5795, 6156, 5689)
	and TaskDescription='Sprint demo' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6156, 5795, 6097, 5689)
	and TaskDescription='Sprint Planning' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5795, 6156)
	and TaskDescription='Sprint Retro' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5788, 6192)
	and TaskDescription='Srikanth/Casey 1:1' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6032)
	and TaskDescription='Stand up and scrum' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6097, 5464, 5689)
	and TaskDescription='Standup and scrum' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5825)
	and TaskDescription='Sync up call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5410)
	and TaskDescription='Sync up with Subba' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5616, 6031)
	and TaskDescription='syncup call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6031)
	and TaskDescription='sync-up call' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5782, 5992, 5572)
	and TaskDescription='Sync-up call with Saumya Singh, Ganesh and Deepak Sir on facility about daily activity' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6134)
	and TaskDescription='Sync-up call with Saumya Singh, Ganesh and Deepak Sir on facility about daily activity. coordinate with Saumya and Ganesh Sir related to facility.' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6204)
	and TaskDescription='Sync-Up Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6227)
	and TaskDescription='Sync-up meeting with Santhosh' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6210)
	and TaskDescription='system preparation and user management' and TimeSheetSubcategoryID IN (36, 171, 174)
	
	Delete FROM TimesheetDetail where TimesheetId IN (5828)
	and TaskDescription='System Setup and Training Status with Thula, Understanding of Roles and Responsibility' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5970)
	and TaskDescription='Team Activity Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5988, 5654, 6123, 5417)
	and TaskDescription='Team Assistance' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5965)
	and TaskDescription='Team Building Event' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5460, 5484)
	and TaskDescription='Team Connect' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6201)
	and TaskDescription='Team Internal Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6230)
	and TaskDescription='Teams meeting with HR Team and Sandeep for ISO Audit' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (6183)
	and TaskDescription='Thursday Fun event' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6038)
	and TaskDescription='Training and Assignment Status Meeting with New Joinee - Vivel Raj and Thula Dhanasheela, Syncup Meeting with Subba, Policy Refresher Session, All Hands Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5955)
	and TaskDescription='TRAVEL FAQ Revenue Operations HQ Invasion: July 8-10, Costa Mesa, CA -' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5924)
	and TaskDescription='Understanding of roles and responsibilities of SM with Uno' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5802)
	and TaskDescription='Understanding the progress of KT sessions' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6201)
	and TaskDescription='UNO Meeting' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5621)
	and TaskDescription='Updated Notice period Scores for Resignation Tab in Org. chart' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (6033)
	and TaskDescription='Updated WSR compliance tab' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5859)
	and TaskDescription='User management and vendor management' and TimeSheetSubcategoryID IN (36, 171, 174)
	
	Delete FROM TimesheetDetail where TimesheetId IN (5926, 5960)
	and TaskDescription='Virtual Team Building' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5441, 5955)
	and TaskDescription='Weekly 1 on 1 - Dipanshu and Josh' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5881)
	and TaskDescription='Weekly 1-1 with Prashant; Health Session - Desk workouts arranged by HR' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6009, 5561, 5795)
	and TaskDescription='Weekly BA connect' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5995)
	and TaskDescription='Weekly fun activity conducted in office.' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5465)
	and TaskDescription='Weekly Meeting with Prashant; Monthly 1-1s with Deepak, Manav, Vikas, Sudheer, Tulika & Arshad, BiWeekly 1-1 with Subba' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5441)
	and TaskDescription='Weekly Standups' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5661)
	and TaskDescription='Weekly Status meeting; Bi-Weekly 1-1 with Subba; Consumer QA Monthly Meet' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6096)
	and TaskDescription='Weekly status with Prashant; Policy Refresher meeting with Swetha; All hands meeting with UNO' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (6230)
	and TaskDescription='Work from WFH Criteria Met/not Met list prepared and shared with Swati and Swetha' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5940)
	and TaskDescription='Working on deliverables and meetings' and TimeSheetSubcategoryID=16
 
	Delete FROM TimesheetDetail where TimesheetId IN (5575)
	and TaskDescription='XC-16986' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5575)
	and TaskDescription='XC-17146' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5965)
	and TaskDescription='XC-17148' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5965)
	and TaskDescription='XC-17156' and TimeSheetSubcategoryID=36
 
	Delete FROM TimesheetDetail where TimesheetId IN (5852)
	and TaskDescription='yoga session' and TimeSheetSubcategoryID=16
	
	
	DELETE FROM TimeSheetSubcategory WHERE TimeSheetSubcategoryID=85

	
 GO
SET IDENTITY_INSERT [dbo].[TimeSheetSubcategory] ON
GO
 INSERT INTO TimeSheetSubcategory(TimeSheetSubcategoryID, TimeSheetSubcategoryName, TimeSheetCategoryID) 
 VALUES (195, 'Backlog Review/Grooming', 21)
 GO
 INSERT INTO TimeSheetSubcategory(TimeSheetSubcategoryID, TimeSheetSubcategoryName, TimeSheetCategoryID) 
 VALUES (196, 'Story Validation', 21)
 GO
 INSERT INTO TimeSheetSubcategory(TimeSheetSubcategoryID, TimeSheetSubcategoryName, TimeSheetCategoryID) 
 VALUES (197, 'Billing verifcation/Data Validation', 3)
 GO
SET IDENTITY_INSERT [dbo].[TimeSheetSubcategory] OFF
GO


UPDATE TimesheetDetail SET TimeSheetCategoryID=21, TimeSheetSubcategoryID=195 
WHERE TaskDescription='OBS Product backlog refinement' and TimeSheetSubcategoryID IS NULL

UPDATE TimesheetDetail SET TimeSheetCategoryID=21, TimeSheetSubcategoryID=195 
WHERE TaskDescription='Worked on stories bugs and Inquiries' and TimeSheetSubcategoryID IS NULL

UPDATE TimesheetDetail SET TimeSheetCategoryID=21, TimeSheetSubcategoryID=195 
WHERE TaskDescription='OBS Grooming' and TimeSheetSubcategoryID IS NULL

UPDATE TimesheetDetail SET TimeSheetCategoryID=21, TimeSheetSubcategoryID=196 
WHERE TaskDescription='Worked on stories' and TimeSheetSubcategoryID IS NULL

UPDATE TimesheetDetail SET TimeSheetCategoryID=21, TimeSheetSubcategoryID=196 
WHERE TaskDescription='Worked on Stories and Support tickets' and TimeSheetSubcategoryID IS NULL

UPDATE TimesheetDetail SET TimeSheetCategoryID=18, TimeSheetSubcategoryID=36 
WHERE TaskDescription='Leave' and TimeSheetSubcategoryID IS NULL and TimesheetId=6084

UPDATE TimesheetDetail SET TimeSheetCategoryID=18, TimeSheetSubcategoryID=36 
WHERE TaskDescription='LEave' and TimeSheetSubcategoryID IS NULL and TimesheetId=6171

UPDATE TimesheetDetail SET TimeSheetCategoryID=18, TimeSheetSubcategoryID=36 
WHERE TaskDescription='Leave' and TimeSheetSubcategoryID IS NULL and TimesheetId=5855

UPDATE TimesheetDetail SET TimeSheetCategoryID=18, TimeSheetSubcategoryID=36 
WHERE TaskDescription='Leave' and TimeSheetSubcategoryID IS NULL and TimesheetId=5547

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='QA investigation on PIF CASH LIABILITY on V2 to PROD discrepancies' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5957

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='QA work - IN PROGRESS -PF Custom - EFT Allocation Annual - Add date parameter to report and update sources' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5957

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='QA Scheduled ticket - Paginated Schedule - PIF Cash Liability - schedule fails due to Location parameter issue' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5637

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Paginated Schedule - Multiple Reports - Schedules without attachment due to data not ready on time (cancelled)' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5637

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Paginated Schedule - RFC to Agency - schedule fails due to Location parameter issue (03/01/2024)' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5637

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Worked on Data Migration: Verified migrated clubs data on Prod using Upgrade2.0' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6021

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Worked on Data Migration and verified the Migrated clubs data' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5816

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Analyze Report - @HIDE_Daily Account Adjustments - Freeze Billing - repetitive Lines of Member information/Incorrect Display' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5823

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Analyze Report - @HIDE_Daily Account Adjustments - Expired Accounts- repetitive Lines of Member information/Incorrect Display' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5823

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Analyze Report - @HIDE_Daily Account Adjustments - Transacations iN/OUT - repetitive Lines of Member information/Incorrect Display' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5823

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Analyze Report - @HIDE_Daily Account Adjustments - Pending Cancellations - repetitive Lines of Member information/Incorrect Display' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5823

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Analyze Report - @HIDE_Daily Account Adjustments - Cancelled Accounts - repetitive Lines of Member information/Incorrect Display' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5823

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='#3 PF - sub-report | Revenue by Profit Center Detail - Add new column and parameter for Income/Non-Income transactions' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6161

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='#3 PF - Custom DRDR - Add parameter to exclude Non-Income Transactions' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6161

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='QA work - Analyze Report - Integrated Sales Tax (Ignite) - significantly higher amounts than expected (5/8/2024)' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6161

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Report - Integrated Sales Tax (Ignite) and Integrated Sales Tax (Legacy) - Formatting issues' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6161

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Analyze Report - @HIDE_Daily Account Adjustments - Pending Cancellations - repetitive Lines of Member information/Incorrect Display' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6161

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='QA work - PF Custom - EFT Allocation Annual - Add date parameter to report and update sources' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6161

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='QA work - Analyze Report - @HIDE_Daily Account Adjustments - Cancelled Accounts - repetitive Lines of Member information/Incorrect Display' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6161

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Analyze Report - @HIDE_Daily Account Adjustments - Freeze Billing - repetitive Lines of Member information/Incorrect Display' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6161

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Worked on Data Migration migrated clubs details verification' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5564

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=197 
WHERE TaskDescription='Worked on Data Migration: Verified migrated clubs data on Prod' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6216

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='DL-Missed User Replication-ctd' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5979

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='DL-Missed user Replication' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6193

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='Kibana Logs and Prod Regression' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6193

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='Reviewing Vinay and Abhishek Tickets and Automation PRs' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5599

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='Team issues and support Code Review' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5596

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='Team Issues and Support and Code Review' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5832

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='Team Issues and Support and Code Review' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6018

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='Team issues and support Review, MA GPG Issue' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6209

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='MR review' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6044

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='MR review' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6162

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='PR Reviews' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5468

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='PR Review(Sudheer and Tulika)' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5856

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='did cred' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5496

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='Test case review =  MCL-31899' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5789

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='Test Plan Review -  MCL-32015' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=6202

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='Kibana log' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5513

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='Kibana log' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5765

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='RM MX | MExp Edocs | Left Panel | New Doc Drop Zone - Trigger Split Doc Drawer, Auto-Save New Doc, & Save of Source Doc' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5777

UPDATE TimesheetDetail SET TimeSheetCategoryID=3, TimeSheetSubcategoryID=191 
WHERE TaskDescription='RM MX | MExp Edocs | Performance | Add Stack Order to Initial Load' 
and TimeSheetSubcategoryID IS NULL and TimesheetId=5777

-- =============================================
-- Author:		<Akash Maurya>
-- Create date: <17/7/24>
-- Description:	<Updated Some LOP Subcategory data>
-- =============================================

UPDATE TimesheetDetail
SET TimesheetCategoryID = 3,
    TimesheetSubcategoryID = 15
FROM TimesheetDetail
INNER JOIN Timesheet ON TimesheetDetail.TimesheetId = Timesheet.TimesheetId
WHERE Timesheet.WeekStartDate = '2024-06-16 00:00:00.000'
  AND Timesheet.WeekEndDate = '2024-06-22 00:00:00.000'
  AND Timesheet.EmployeeID  IN ('333')
  AND TimesheetDetail.TaskDescription IN ('QAF-508 Mortgage Automation Parallel Execution Issue');


  UPDATE TimesheetDetail
SET TimesheetCategoryID = 3,
    TimesheetSubcategoryID = 15
FROM TimesheetDetail
INNER JOIN Timesheet ON TimesheetDetail.TimesheetId = Timesheet.TimesheetId
WHERE Timesheet.WeekStartDate = '2024-06-16 00:00:00.000'
  AND Timesheet.WeekEndDate = '2024-06-22 00:00:00.000'
  AND Timesheet.EmployeeID  IN ('716')
  AND TimesheetDetail.TaskDescription IN ('Bhavna - Connect with Common pool QA team, connect with UNO, Selenium Java Automation, Jira plugin of test management R&D');


  UPDATE TimesheetDetail
SET TimesheetCategoryID = 3,
    TimesheetSubcategoryID = 15
FROM TimesheetDetail
INNER JOIN Timesheet ON TimesheetDetail.TimesheetId = Timesheet.TimesheetId
WHERE Timesheet.WeekStartDate = '2024-06-16 00:00:00.000'
  AND Timesheet.WeekEndDate = '2024-06-22 00:00:00.000'
  AND Timesheet.EmployeeID  IN ('799')
  AND TimesheetDetail.TaskDescription IN ('Failure analysis of MX Regression using Sel 4', 'Go through the video of swagger mate ad RND');

  -- =============================================
-- Author:		<Akash Maurya>
-- Create date: <17/7/24>
-- Description:	<Get All Clients>
-- =============================================
GO
CREATE OR ALTER PROCEDURE usp_GetAllClients
AS
BEGIN
    -- Select all records from the ClientMaster table
    SELECT * FROM dbo.ClientMaster;
END;

---Arpit verma 19/7/2024---ADrenaline Leaves

ALTER TABLE EmployeeITProductivity
ALTER COLUMN [ITActiveHours] decimal(10, 2);
ALTER TABLE EmployeeITProductivity
ALTER COLUMN [ITProductiveHours] decimal(10, 2);
ALTER TABLE EmployeeITProductivity
ALTER COLUMN Leave decimal(10, 2);
update  EmployeeITProductivity
SET Leave=0
--
GO
/****** Object:  Table [dbo].[IT16JuneHrs]    Script Date: 7/18/2024 2:28:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IT16JuneHrs](
	[S No] [float] NULL,
	[User Name] [nvarchar](255) NULL,
	[Emp Code] [nvarchar](255) NULL,
	[Team] [nvarchar](255) NULL,
	[Location] [nvarchar](255) NULL,
	[Total time] [float] NULL,
	[Active time] [float] NULL,
	[Productive time] [float] NULL,
	[Unproductive time] [float] NULL,
	[Downtime] [float] NULL
) ON [PRIMARY]
GO
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (1, N'Aamir Khan', N'983', N'Mercell', N'Noida', 27.616666666666667, 3.4666666666666663, 3.3833333333333333, 0.066666666666666666, 24.133333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (2, N'Abhimanyu Sharma', N'585', N'ML', N'Noida', 13.133333333333335, 7.833333333333333, 7.8166666666666673, 0, 5.2833333333333332)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (3, N'Abhishek Banerjee', N'730', N'ABC-Special', N'Noida', 83.033333333333331, 18.833333333333332, 18.816666666666666, 0, 64.183333333333337)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (4, N'Abhishek Dhiman', N'1072', N'ML-Special', N'Noida', 41.233333333333334, 21.516666666666666, 21.516666666666666, 0, 19.7)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (5, N'Abhishek Goyal.', N'891', N'ML', N'Noida', 100.85, 19.45, 19.433333333333334, 0, 81.38333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (6, N'Abhishek Sharma', N'988', N'ML', N'Noida', 105.96666666666667, 44.1, 44.016666666666666, 0.066666666666666666, 61.85)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (7, N'Ache Rajinikanth', N'742', N'ML', N'Hyderabad', 96.316666666666663, 51.483333333333334, 51.466666666666669, 0, 44.81666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (8, N'Adesh Kumar', N'1022', N'Mercell', N'Noida', 26.483333333333334, 17.566666666666666, 17.56666666666667, 0, 8.9)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (9, N'Ajay Kumar Singh', N'614', N'ML', N'Hyderabad', 65.85, 32.166666666666664, 32.050000000000004, 0.1, 33.68333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (10, N'Ajay Sachan', N'453', N'ML', N'Noida', 102.8, 40.3, 39.883333333333333, 0.4, 62.483333333333341)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (11, N'Ajeet Kumar Mittal', N'5', N'ML', N'Noida', 67.733333333333334, 48.766666666666666, 48.616666666666667, 0.13333333333333333, 18.95)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (12, N'Akash Maurya', N'1075', N'CP', N'Noida', 57.6, 38.68333333333333, 38.666666666666664, 0, 18.916666666666668)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (13, N'Akriti Dubey', N'TEMP073', N'ABC-Special', N'Noida', 90.11666666666666, 9.35, 9.3333333333333339, 0, 80.766666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (14, N'Akshay Verma', N'387', N'ML', N'Noida', 66.033333333333346, 27.833333333333336, 27.816666666666666, 0, 38.2)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (15, N'Amardeep Kumar', N'1068', N'ML', N'Noida', 92.45, 25.816666666666666, 25.816666666666666, 0, 66.61666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (16, N'Amit Kumar Sah', N'1079', N'ML-Special', N'Hyderabad', 100.56666666666668, 24.466666666666665, 24.45, 0, 76.083333333333329)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (17, N'Amit Maurya', N'1095', N'G&A-IT', N'Noida', 52.483333333333334, 34.18333333333333, 34.166666666666664, 0, 18.3)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (18, N'Amit Ramaning Masali', N'TEMP076', N'ABC-Special', N'Hyderabad', 12.533333333333333, 4.166666666666667, 4.15, 0, 8.35)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (19, N'Amitkumar Panasara', N'798', N'ABC-Special', N'Noida', 66.016666666666666, 22.033333333333335, 22.033333333333335, 0, 43.966666666666669)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (20, N'Amrita', N'504', N'ML', N'Noida', 50.93333333333333, 22.666666666666668, 22.65, 0, 28.266666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (21, N'Anas Mansoor Khan', N'408', N'ML', N'Noida', 40.166666666666664, 17.083333333333332, 16.95, 0.13333333333333333, 23.066666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (22, N'Anish Kumar', N'544', N'ML', N'Hyderabad', 56.916666666666664, 37.483333333333334, 37.466666666666669, 0, 19.433333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (23, N'Anjali Singh', N'630', N'ML', N'Noida', 98.35, 23.983333333333334, 23.983333333333331, 0, 74.35)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (24, N'Ankit Sharma.', N'493', N'ML', N'Noida', 56.283333333333339, 19.316666666666666, 19.3, 0, 36.95)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (25, N'Ankur Gupta', N'403', N'ML', N'Noida', 76.2, 40.716666666666669, 40.716666666666669, 0, 35.466666666666669)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (26, N'Ankur Rusia', N'1060', N'Mercell', N'Noida', 39.68333333333333, 35.266666666666666, 35.266666666666666, 0, 4.4)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (27, N'Annavarapu Sahiti Lakshmi Durga', N'751', N'CP', N'Hyderabad', 47.7, 37.833333333333336, 37.833333333333329, 0, 9.85)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (28, N'Anuj Ojha', N'432', N'ML', N'Noida', 58.35, 35.5, 35.5, 0, 22.833333333333332)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (29, N'Anuj Oscar', N'857', N'ML', N'Noida', 84.61666666666666, 46, 45.916666666666671, 0.066666666666666666, 38.616666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (30, N'Archana Prajapati', N'1051', N'Mercell', N'Noida', 42.616666666666667, 35.75, 35.75, 0, 6.85)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (31, N'Arpit Verma', N'912', N'CP', N'Noida', 52.833333333333336, 31.083333333333332, 31.083333333333332, 0, 21.733333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (32, N'Arushi Rana', N'270', N'Mercell', N'Noida', 39.35, 30.45, 30.45, 0, 8.8833333333333329)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (33, N'Arvind Kumar Modanwal', N'969', N'Mercell', N'Noida', 32.300000000000004, 23.483333333333334, 21.583333333333332, 1.8833333333333333, 8.8)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (34, N'Ashish Rawat', N'816', N'G&A-IT', N'Noida', 20.45, 15.9, 15.833333333333332, 0.033333333333333333, 4.55)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (35, N'Ashok Kumar', N'473', N'ML', N'Noida', 54.616666666666667, 22.416666666666668, 22.416666666666668, 0, 32.18333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (36, N'Ashok Kumar.', N'480', N'ML', N'Noida', 0.9, 0.6333333333333333, 0.6166666666666667, 0, 0.26666666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (37, N'Asmani Roy', N'599', N'G&A-MGMT', N'Noida', 44.233333333333334, 37.116666666666667, 36.550000000000004, 0.53333333333333333, 7.1166666666666663)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (38, N'Avin Panwar', N'ABC-0008', N'ABC-Special', N'Noida', 85.38333333333334, 16.45, 16.433333333333334, 0, 68.933333333333337)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (39, N'Avinash Shrivastava', N'669', N'ML', N'Noida', 30.5, 11.85, 11.833333333333334, 0, 18.65)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (40, N'Avneet', N'TEMP091', N'G&A-Marketing', N'Noida', 0, 0, 0, 0, 0)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (41, N'Awadh Kishor', N'976', N'G&A-OPS', N'Noida', 53.68333333333333, 10.933333333333334, 10.916666666666666, 0, 42.75)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (42, N'Ayush Rameshchandra Verma', N'139', N'Mercell', N'Noida', 45.633333333333333, 35.95, 33.233333333333334, 2.7, 9.6666666666666661)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (43, N'Ayush Soni', N'1041', N'ML-Special', N'Noida', 86.483333333333334, 38.31666666666667, 34.833333333333336, 3.4666666666666663, 48.166666666666671)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (44, N'Ayushi Pahwa', N'1076', N'ABC-Special', N'Noida', 105.58333333333333, 43.083333333333336, 43.083333333333336, 0, 62.5)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (45, N'Azra Parveen', N'606', N'ML', N'Noida', 53.3, 32.65, 32.633333333333333, 0.016666666666666666, 20.633333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (46, N'Bhavya Sukhavasi', N'705', N'ML', N'Hyderabad', 46.6, 30.483333333333334, 30.466666666666669, 0, 16.116666666666664)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (47, N'Bhupendra Rathore', N'537', N'ML', N'Noida', 42.983333333333334, 37.4, 37.4, 0, 5.583333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (48, N'Bommaraju Sesha Srinivas', N'610', N'ML', N'Hyderabad', 46.966666666666669, 24.433333333333334, 24.416666666666668, 0, 22.516666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (49, N'Bondla Ganesh', N'948', N'ML', N'Hyderabad', 29.9, 23.3, 22.183333333333334, 1.1, 6.5833333333333339)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (50, N'Byrisetty Durgaprasad', N'1061', N'ABC-Special', N'Hyderabad', 104.76666666666667, 39.716666666666669, 39.716666666666669, 0, 65.033333333333331)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (51, N'Cavungal Reema Simon John', N'787', N'CP', N'Hyderabad', 48.733333333333334, 33.016666666666673, 33, 0, 15.7)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (52, N'Chetna Upadhyay', N'1080', N'CP', N'Noida', 46.35, 33.483333333333334, 33.133333333333333, 0.35, 12.85)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (53, N'Deepak Bindal', N'716', N'ML', N'Noida', 59.75, 27.416666666666668, 27.3, 0.11666666666666667, 32.31666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (54, N'Deepak Karihalu', N'1', N'G&A-MGMT', N'Noida', 0, 0, 0, 0, 0)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (55, N'Deepak Khetan', N'376', N'ML', N'Noida', 70.183333333333337, 32.400000000000006, 32.383333333333333, 0, 37.783333333333331)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (56, N'Deepak Kumar', N'702', N'Mercell', N'Noida', 46.95, 35.18333333333333, 35.133333333333333, 0.016666666666666666, 11.766666666666668)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (57, N'Deepesh Hassija', N'1013', N'ABC-Special', N'Hyderabad', 40.7, 17, 16.999999999999996, 0, 23.683333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (58, N'Devasani Ganesh', N'875', N'G&A-OPS', N'Hyderabad', 43.633333333333333, 27.283333333333335, 26.033333333333335, 1.2333333333333334, 16.35)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (59, N'Devesh Kumar Singh', N'910', N'CP', N'Noida', 72, 46.016666666666666, 45.933333333333337, 0.066666666666666666, 25.983333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (60, N'Dhiraj Kumar', N'101', N'CP', N'Noida', 37.216666666666669, 24.916666666666668, 24.900000000000002, 0, 12.283333333333331)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (61, N'Dinesh Chandra Pandey', N'706', N'ML', N'Noida', 54.93333333333333, 37.15, 36.966666666666669, 0.16666666666666666, 17.783333333333335)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (62, N'Dipak Kumar Singh', N'665', N'ML', N'Noida', 105.58333333333333, 34.85, 34.849999999999994, 0, 70.716666666666669)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (63, N'Dipanshu Tyagi', N'1069', N'ML-Special', N'Noida', 40.866666666666667, 20.283333333333335, 20.266666666666666, 0, 20.583333333333332)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (64, N'G Mohmmed Ali', N'TEMP090', N'G&A-TA', N'Hyderabad', 23.65, 15.95, 14.799999999999999, 1.1333333333333333, 7.6833333333333327)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (65, N'Gagan Narang', N'941', N'Mercell', N'Noida', 37.966666666666669, 30.150000000000002, 30.133333333333336, 0, 7.8166666666666664)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (66, N'Gajula Sai Bhavana', N'779', N'ML', N'Hyderabad', 43.3, 35.95, 35.949999999999996, 0, 7.3500000000000005)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (67, N'Gaurav Singh', N'850', N'CP', N'Noida', 65.266666666666666, 43.533333333333331, 40.433333333333337, 3.1000000000000005, 21.733333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (68, N'Govind Patidar', N'795', N'ML', N'Noida', 62.483333333333341, 47.966666666666669, 47.949999999999996, 0, 14.5)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (69, N'Gunashreya Maram', N'531', N'ML', N'Hyderabad', 48.233333333333341, 30.800000000000004, 30.8, 0, 17.416666666666668)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (70, N'Gundla Thrived', N'738', N'ML', N'Hyderabad', 51.483333333333334, 28.95, 28.866666666666667, 0.066666666666666666, 22.516666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (71, N'Guneet Kaur', N'426', N'ML', N'Noida', 104.7, 21.566666666666666, 21.566666666666666, 0, 83.11666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (72, N'Gurramkonda Rajesh Babu', N'987', N'ABC-Special', N'Hyderabad', 104.45000000000002, 39.633333333333333, 39.616666666666667, 0, 64.816666666666663)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (73, N'Gyanendra Pal Singh', N'921', N'ML', N'Noida', 65.11666666666666, 35.733333333333334, 35.716666666666669, 0, 29.366666666666671)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (74, N'Harsh Kumar', N'1082', N'CP', N'Noida', 63.266666666666666, 34.083333333333336, 33.95, 0.11666666666666667, 29.183333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (75, N'Himanshu Kumar', N'533', N'ML', N'Noida', 75.083333333333329, 28.283333333333335, 28.266666666666662, 0, 46.8)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (76, N'Jampana Ramya', N'1088', N'CP', N'Hyderabad', 45.93333333333333, 35.483333333333334, 35.183333333333337, 0.28333333333333333, 10.45)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (77, N'Jana Suresh', N'1045', N'G&A-IT', N'Hyderabad', 41.56666666666667, 30.316666666666666, 30.300000000000004, 0, 11.25)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (78, N'Janne Harish Naidu', N'TEMP078', N'ABC-Special', N'Noida', 103.68333333333334, 36.466666666666669, 36.466666666666669, 0, 67.216666666666669)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (79, N'Jeevan Reddy Maru', N'841', N'ABC-Special', N'Hyderabad', 45.483333333333334, 28.433333333333334, 28.416666666666668, 0, 17.05)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (80, N'Jogender Rohilla', N'331', N'ML', N'Noida', 59.233333333333334, 40.9, 40.866666666666667, 0.016666666666666666, 18.316666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (81, N'kamsetti Vyshnavi', N'757', N'ML', N'Hyderabad', 82.13333333333334, 23.133333333333333, 23.133333333333333, 0, 58.983333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (82, N'Katkam Mallikarjun', N'736', N'ML', N'Hyderabad', 97.666666666666671, 62.083333333333329, 62.066666666666663, 0, 35.56666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (83, N'Kavita Devendra Pardeshi', N'1073', N'ML-Special', N'Noida', 43, 14.833333333333334, 14.816666666666668, 0, 28.15)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (84, N'Keshika Gupta', N'1062', N'ML', N'Noida', 33.2, 15.683333333333334, 15.683333333333334, 0, 17.5)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (85, N'Koppuravuri Srinivasa Rao', N'TEMP039', N'ABC-Special', N'Hyderabad', 47.25, 16.183333333333334, 16.166666666666668, 0, 31.05)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (86, N'Kota Poojitha', N'786', N'ML', N'Hyderabad', 49.7, 31.166666666666668, 31.050000000000004, 0.1, 18.533333333333335)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (87, N'Kumar Rishabh', N'344', N'ML', N'Noida', 43, 20.2, 20.183333333333334, 0, 22.783333333333335)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (88, N'Kumar Saurabh', N'690', N'Mercell', N'Noida', 46.083333333333336, 32.9, 32.883333333333333, 0, 13.166666666666668)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (89, N'Lakshay Guglani', N'629', N'ML', N'Noida', 57.983333333333341, 19, 19, 0, 38.966666666666669)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (90, N'Laxman Singh Karki', N'515', N'ML', N'Noida', 107.15, 50.633333333333326, 50.633333333333333, 0, 56.5)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (91, N'Litil Gupta', N'633', N'ML', N'Noida', 46.81666666666667, 33.43333333333333, 33.433333333333337, 0, 13.366666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (92, N'Litton Mazumder', N'581', N'ML', N'Hyderabad', 26.533333333333335, 8.1833333333333336, 8.1166666666666671, 0.033333333333333333, 18.35)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (93, N'Lokesh Suthar', N'1052', N'Mercell', N'Noida', 33.483333333333334, 29.433333333333337, 29.316666666666663, 0.083333333333333329, 4.0500000000000007)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (94, N'M Anil Kumar', N'541', N'Mercell', N'Hyderabad', 46.81666666666667, 39.75, 39.733333333333334, 0, 7.0666666666666664)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (95, N'Madhulika Gupta', N'209', N'CP', N'Noida', 0, 0, 0, 0, 0)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (96, N'Madhvendra Singh', N'382', N'ML', N'Noida', 0, 0, 0, 0, 0)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (97, N'Malgireddy Swapna', N'783', N'ML', N'Hyderabad', 82.733333333333334, 30.283333333333335, 30.283333333333331, 0, 52.43333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (98, N'Malladi Venkata Lakshmi Pravallika', N'743', N'ML', N'Hyderabad', 55.43333333333333, 38.466666666666669, 38.45, 0, 16.950000000000003)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (99, N'Manav Sharma', N'442', N'ML', N'Noida', 46.833333333333336, 36.266666666666666, 36.25, 0, 10.55)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (100, N'Manish Kumar', N'257', N'ABC-Special', N'Noida', 50.3, 41.666666666666664, 40.95, 0.7, 8.6333333333333329)
GO
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (101, N'Manish Kumar Mishra', N'993', N'ML', N'Noida', 105.26666666666667, 30.016666666666669, 30.016666666666666, 0, 75.233333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (102, N'Manoj Gandhi', N'1026', N'Mercell', N'Noida', 39.95, 30.983333333333334, 30.916666666666664, 0.05, 8.95)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (103, N'Manoj Kumar Agarwal', N'56', N'ABC', N'Noida', 110.9, 40.866666666666667, 40.866666666666667, 0, 70.033333333333331)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (104, N'Manoj Singh Bisht', N'1000', N'Mercell', N'Noida', 39.43333333333333, 31.449999999999996, 31.45, 0, 7.9666666666666668)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (105, N'Maryam Wahab', N'495', N'ML', N'Noida', 51.4, 27.333333333333332, 27.083333333333339, 0.23333333333333334, 24.066666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (106, N'Mehneen Kaur', N'766', N'ML', N'Noida', 109.85, 52.050000000000004, 52.05, 0, 57.8)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (107, N'Mithun Kumar', N'724', N'ABC', N'Noida', 45.65, 31.75, 31.5, 0.23333333333333334, 13.883333333333335)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (108, N'Mohammad Hasan Raza', N'632', N'ML', N'Noida', 86.916666666666671, 35.35, 35.333333333333343, 0, 51.56666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (109, N'Mohd Arshad', N'662', N'ML', N'Noida', 23.566666666666666, 12.2, 12.183333333333334, 0, 11.366666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (110, N'Mohit', N'893', N'ML', N'Noida', 45.06666666666667, 27.483333333333334, 27.483333333333331, 0, 17.583333333333332)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (111, N'Mohit Nautiyal', N'929', N'ML', N'Noida', 107.55, 43, 42.983333333333334, 0, 64.55)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (112, N'Mudit Arya', N'902', N'CP', N'Noida', 43.3, 27.233333333333334, 27.216666666666669, 0, 16.049999999999997)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (113, N'Murali Sainath Reddy Gudibandi', N'1081', N'CP', N'Hyderabad', 50.016666666666659, 37.15, 37.083333333333336, 0.033333333333333333, 12.866666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (114, N'Nagullapally Sandeep Kumar', N'670', N'G&A-IT', N'Hyderabad', 59.016666666666659, 37.366666666666667, 36.95, 0.4, 21.633333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (115, N'Naina Upadhyay', N'909', N'ML', N'Noida', 106.91666666666666, 35.25, 35.25, 0, 71.666666666666671)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (116, N'Nangineedi Manikanta', N'628', N'ML', N'Hyderabad', 61.966666666666669, 24.366666666666667, 24.35, 0, 37.6)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (117, N'Narendra Kumar Gopisetti', N'1046', N'Mercell', N'Hyderabad', 46.416666666666664, 33.233333333333334, 33, 0.23333333333333334, 13.166666666666668)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (118, N'Narendra Singh', N'1058', N'CP', N'Noida', 46.25, 15.833333333333334, 15.799999999999999, 0.016666666666666666, 30.4)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (119, N'Naveen Kollu', N'679', N'ML', N'Hyderabad', 105.33333333333334, 40, 39.983333333333334, 0, 65.333333333333329)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (120, N'Naveen Kumar Mummadi', N'1083', N'CP', N'Hyderabad', 53.366666666666667, 35.416666666666664, 35.4, 0, 17.933333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (121, N'Navneet Apoorva', N'792', N'ML', N'Noida', 48.18333333333333, 23.766666666666666, 23.766666666666669, 0, 24.4)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (122, N'Navneet Tyagi', N'333', N'ML', N'Noida', 103.26666666666667, 28.183333333333334, 28.183333333333334, 0, 75.066666666666663)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (123, N'Neha Bhagat', N'1039', N'G&A-PMO', N'Noida', 40.25, 28.449999999999996, 28.433333333333334, 0, 11.783333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (124, N'Neha Mittal', N'445', N'ML', N'Noida', 67.3, 32.133333333333333, 32.116666666666667, 0, 35.15)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (125, N'Neha Singh', N'384', N'Mercell', N'Noida', 46.466666666666669, 30.233333333333334, 30.216666666666669, 0, 16.233333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (126, N'Nehal Sati', N'600', N'ML', N'Noida', 17.283333333333335, 11.666666666666666, 8.05, 3.6166666666666667, 5.6)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (127, N'Nidhi Tyagi', N'1050', N'Mercell', N'Noida', 49.416666666666664, 35.45, 35.449999999999996, 0, 13.950000000000001)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (128, N'Nigar Sultana', N'TEMP081', N'G&A-Marketing', N'Noida', 0, 0, 0, 0, 0)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (129, N'Nikhil Rana', N'631', N'ML', N'Noida', 105.5, 40.483333333333334, 40.466666666666669, 0, 65.016666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (130, N'Niraj Kumar Jha', N'660', N'ML', N'Noida', 65.933333333333337, 31.133333333333333, 30.8, 0.3, 34.8)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (131, N'Niraj Kumar Singh', N'494', N'Mercell', N'Noida', 58.483333333333334, 32.31666666666667, 32.316666666666663, 0, 26.15)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (132, N'Nishant Soni', N'981', N'Mercell', N'Noida', 48.083333333333336, 32.199999999999996, 32.199999999999996, 0, 15.866666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (133, N'Niti Prabha', N'TEMP091', N'G&A-EA', N'Noida', 0, 0, 0, 0, 0)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (134, N'Nitin Kumar', N'458', N'ML', N'Noida', 80.666666666666671, 38.1, 37.666666666666664, 0.41666666666666669, 42.56666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (135, N'Nitish Kumar Gautam', N'325', N'ML', N'Noida', 30.816666666666666, 22.2, 22.2, 0, 8.6166666666666671)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (136, N'Pavitra Madiwalar', N'844', N'ML', N'Hyderabad', 34.616666666666667, 23.933333333333334, 23.916666666666664, 0, 10.683333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (137, N'Polineni Himaja', N'1012', N'Mercell', N'Hyderabad', 43.283333333333331, 32.916666666666664, 32.9, 0, 10.366666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (138, N'Prabhakar Verma', N'286', N'ABC', N'Noida', 46.833333333333336, 41.3, 41.3, 0, 5.5166666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (139, N'Prakash Dwivedi', N'1007', N'Mercell', N'Noida', 43.733333333333334, 24.050000000000004, 24.05, 0, 19.683333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (140, N'Prashant Shrivastava', N'810', N'ML', N'Hyderabad', 60.93333333333333, 52.583333333333336, 51.900000000000006, 0.66666666666666663, 8.35)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (141, N'Prashant Yadav', N'594', N'ML', N'Noida', 94.05, 52.366666666666667, 52.35, 0, 41.68333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (142, N'Pratik Jain', N'928', N'ML', N'Noida', 54.383333333333326, 21.316666666666666, 21.316666666666666, 0, 33.050000000000004)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (143, N'Praveen Kumar Mala Shyam', N'563', N'G&A-TA', N'Hyderabad', 36.93333333333333, 15.866666666666667, 11.35, 4.5, 21.05)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (144, N'Priti Pallabi Routray', N'568', N'ML', N'Hyderabad', 1.4666666666666666, 1.25, 1.25, 0, 0.21666666666666665)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (145, N'Priyanshu', N'774', N'ABC-Special', N'Noida', 105.68333333333332, 40.766666666666666, 39.166666666666664, 1.5666666666666667, 64.916666666666671)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (146, N'Rajani Gupta', N'618', N'ML', N'Noida', 63.649999999999991, 33.733333333333327, 33.733333333333327, 0, 29.9)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (147, N'Ram Kumar', N'1036', N'Mercell', N'Hyderabad', 45.18333333333333, 31.533333333333335, 31.533333333333335, 0, 13.65)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (148, N'Ramana Reddy Bolla', N'190', N'ML', N'Hyderabad', 58.766666666666666, 36.85, 36.65, 0.18333333333333332, 21.9)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (149, N'Ramit Manuja', N'555', N'ML', N'Noida', 45.35, 14.983333333333333, 14.983333333333333, 0, 30.35)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (150, N'Ranjan Kumar', N'627', N'ML', N'Noida', 133.1, 33.216666666666669, 32.883333333333333, 0.33333333333333331, 99.86666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (151, N'Ratima Saxena', N'799', N'ML', N'Noida', 51.883333333333333, 36.65, 36.65, 0, 15.233333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (152, N'Ravi Gupta', N'722', N'ML', N'Noida', 18.6, 14.15, 14.066666666666668, 0.066666666666666666, 4.4333333333333336)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (153, N'Ravi Ranjan', N'672', N'ABC-Special', N'Noida', 49.45, 37.55, 37.533333333333331, 0, 11.883333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (154, N'Ravichandran M', N'1043', N'Mercell', N'Hyderabad', 47.916666666666664, 36.05, 35.93333333333333, 0.1, 11.866666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (155, N'Ravikumar Gunji', N'695', N'ML', N'Hyderabad', 83.11666666666666, 45.083333333333336, 45.083333333333329, 0, 38.016666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (156, N'Ravish Kumar', N'449', N'Mercell', N'Noida', 43.966666666666669, 35.2, 35.033333333333339, 0.16666666666666666, 8.75)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (157, N'Reshma Akash Lagad', N'1023', N'CP', N'Hyderabad', 39.883333333333333, 12.55, 12.533333333333335, 0, 27.333333333333332)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (158, N'Revathi Mandadi', N'ABC-0005', N'ABC-Special', N'Noida', 60.366666666666674, 11.6, 11.600000000000001, 0, 48.766666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (159, N'Richa Sharma', N'201', N'ML', N'Noida', 0, 0, 0, 0, 0)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (160, N'Ritesh Kumar', N'1009', N'Mercell', N'Noida', 36.6, 24.45, 24.433333333333334, 0, 12.15)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (161, N'S Chandra Sekhara Reddy', N'800', N'ML', N'Hyderabad', 66.15, 40.016666666666666, 39.983333333333334, 0.016666666666666666, 26.133333333333329)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (162, N'Sachin Chugh', N'342', N'ML', N'Noida', 50.1, 22.233333333333334, 22.216666666666669, 0, 27.85)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (163, N'Sadia Anjum', N'768', N'G&A-HR', N'Noida', 20.633333333333333, 11.716666666666667, 11.716666666666667, 0, 8.9)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (164, N'Sai Vamsidhar Gandikota', N'1006', N'ABC-Special', N'Hyderabad', 13.366666666666667, 8.35, 8.3333333333333339, 0, 5.0166666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (165, N'Saksham Singhal', N'1055', N'ML-Special', N'Noida', 83.183333333333337, 28.05, 28.033333333333339, 0, 55.116666666666674)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (166, N'Sakshi', N'560', N'ML', N'Noida', 43.883333333333333, 19.45, 18.099999999999998, 1.3333333333333333, 24.433333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (167, N'Saleemuddin Mewati', N'422', N'Mercell', N'Noida', 51.233333333333341, 25.9, 25.883333333333329, 0, 25.333333333333332)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (168, N'Salonee Sharma', N'556', N'ML', N'Noida', 87, 35.93333333333333, 35.916666666666664, 0, 51.06666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (169, N'Sana Patni', N'TEMP062', N'G&A-TA', N'Hyderabad', 36.133333333333333, 15.95, 13.866666666666667, 2.0666666666666669, 20.183333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (170, N'Sandeep Kumar Rampa', N'1016', N'ML', N'Hyderabad', 56.8, 41.083333333333336, 41.06666666666667, 0, 15.7)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (171, N'Sandeep Kumar Thakur', N'116', N'ML', N'Noida', 104.6, 29.766666666666666, 29.066666666666663, 0.66666666666666663, 74.833333333333329)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (172, N'Sandeep Kumar Verma', N'666', N'ML', N'Noida', 75.216666666666669, 36.283333333333331, 36.283333333333331, 0, 38.93333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (173, N'Sangem Raj Kumar', N'1042', N'ML', N'Hyderabad', 61.216666666666669, 43.31666666666667, 43.266666666666666, 0.033333333333333333, 17.9)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (174, N'Sanjay Mishra', N'413', N'ML', N'Noida', 50.65, 26.583333333333332, 26.566666666666666, 0, 24.066666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (175, N'Sanjay Singh', N'650', N'ML', N'Noida', 51.283333333333331, 37.366666666666667, 37.099999999999994, 0.23333333333333334, 13.916666666666668)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (176, N'Sanjeev Kumar Sinha', N'444', N'ML', N'Noida', 47.416666666666664, 18.433333333333334, 18.416666666666664, 0, 28.983333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (177, N'Santosh Kumar', N'42', N'Mercell', N'Noida', 47.18333333333333, 38.8, 38.8, 0, 8.3833333333333329)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (178, N'Sapna Batan', N'290', N'ABC', N'Noida', 41.18333333333333, 35.266666666666666, 35.266666666666666, 0, 5.916666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (179, N'Sarvesh Rana', N'ABC-0006', N'ABC-Special', N'Noida', 0, 0, 0, 0, 0)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (180, N'Sasikala Balasubramanyam', N'723', N'ML', N'Hyderabad', 52.7, 34.35, 34.333333333333329, 0, 18.35)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (181, N'Satish Chandra Boinpally', N'601', N'ABC-Special', N'Hyderabad', 37.95, 26.716666666666665, 26.05, 0.65, 11.233333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (182, N'Satish Singh', N'1025', N'Mercell', N'Noida', 43.633333333333333, 37, 36.983333333333334, 0, 6.6333333333333337)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (183, N'Saumya Singh', N'1094', N'G&A-OPS', N'Noida', 32.833333333333336, 6.8666666666666663, 6.8666666666666663, 0, 25.95)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (184, N'Shahid Anwar', N'1027', N'Mercell', N'Hyderabad', 43.25, 36.083333333333336, 36.083333333333336, 0, 7.166666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (185, N'Shaik Feroz', N'19', N'ML', N'Hyderabad', 24.45, 15.066666666666666, 15.066666666666666, 0, 9.3833333333333329)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (186, N'Shiva Raj Acharya', N'460', N'ML', N'Noida', 72.85, 38.416666666666664, 37.966666666666669, 0.43333333333333329, 34.43333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (187, N'Shivam Chauhan', N'1065', N'Mercell', N'Noida', 53.06666666666667, 41.516666666666666, 41.5, 0, 11.55)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (188, N'Shivam Jetly', N'368', N'ML', N'Noida', 47.25, 23.883333333333333, 23.833333333333332, 0.016666666666666666, 23.4)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (189, N'Shivani Kavva', N'927', N'ML', N'Hyderabad', 62.45, 47.81666666666667, 47.783333333333331, 0.016666666666666666, 14.616666666666665)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (190, N'Shohil Sethia', N'ABC-0007', N'ABC-Special', N'Noida', 20.516666666666666, 6.8833333333333337, 6.8833333333333337, 0, 13.633333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (191, N'Shubham Choudhary', N'474', N'ML', N'Noida', 49.7, 34.85, 34.699999999999996, 0.11666666666666667, 14.85)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (192, N'Shubham', N'620', N'ML', N'Noida', 107.58333333333334, 40.516666666666666, 40.516666666666666, 0, 67.050000000000011)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (193, N'Shubham Jagdish Upadhyay', N'1024', N'ML', N'Noida', 72.816666666666663, 24.083333333333336, 24.066666666666666, 0, 48.716666666666661)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (194, N'Shubham Srivastav', N'383', N'ML', N'Noida', 76.183333333333337, 29.416666666666668, 29.416666666666664, 0, 46.766666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (195, N'Shubham.', N'964', N'ML', N'Noida', 118.25, 24.483333333333334, 24.466666666666669, 0, 93.766666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (196, N'Siddhant Sharma', N'1067', N'G&A-PMO', N'Noida', 28.583333333333336, 14.416666666666666, 14.416666666666666, 0, 14.15)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (197, N'Sindhu Upperla', N'1087', N'CP', N'Hyderabad', 45.516666666666666, 39.283333333333331, 38.949999999999996, 0.31666666666666665, 6.2333333333333343)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (198, N'Siripuram Santhosh', N'1034', N'Mercell', N'Hyderabad', 35.583333333333336, 15.299999999999999, 15.283333333333333, 0, 20.266666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (199, N'Somendra Mishra', N'99', N'ML', N'Noida', 49.966666666666669, 32.199999999999996, 32.133333333333333, 0.066666666666666666, 17.766666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (200, N'Soumyakanta Mishra', N'734', N'ABC-Special', N'Noida', 131.38333333333333, 43.616666666666667, 41.68333333333333, 1.9166666666666665, 87.75)
GO
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (201, N'Sravani Bhagam', N'967', N'CP', N'Hyderabad', 53.06666666666667, 31.266666666666666, 31.25, 0, 21.8)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (202, N'Srikanth Nanaboina', N'755', N'ML', N'Hyderabad', 16.583333333333332, 11.183333333333334, 11.183333333333334, 0, 5.3833333333333337)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (203, N'Srinivas Chintakindhi', N'TEMP036', N'ML', N'Hyderabad', 42.8, 31.083333333333332, 30.983333333333338, 0.083333333333333329, 11.716666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (204, N'Subba Kuracha', N'1093', N'G&A-MGMT', N'Hyderabad', 59.93333333333333, 24.050000000000004, 18.533333333333335, 5.5166666666666666, 35.866666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (205, N'Sujeet Thakur', N'TEMP086', N'G&A-MGMT', N'Noida', 0, 0, 0, 0, 0)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (206, N'Sunkireddy Sudheer Kumar', N'663', N'ML', N'Hyderabad', 63.68333333333333, 54.733333333333334, 54.733333333333334, 0, 8.9333333333333336)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (207, N'Suraj Pal Sharma', N'1049', N'Mercell', N'Noida', 39.3, 32.633333333333333, 32.6, 0.016666666666666666, 6.65)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (208, N'Suraj Singh Bisht', N'776', N'ABC', N'Noida', 47.68333333333333, 30.35, 30.333333333333332, 0, 17.316666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (209, N'Suramit Pramanik', N'1090', N'CP', N'Hyderabad', 47.93333333333333, 37.366666666666667, 37.366666666666667, 0, 10.55)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (210, N'Suresh Nagula', N'704', N'ML', N'Hyderabad', 69.13333333333334, 50.81666666666667, 50.816666666666663, 0, 18.316666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (211, N'Swati Pandey', N'221', N'G&A-MGMT', N'Noida', 33.31666666666667, 18.233333333333334, 17.533333333333331, 0.7, 15.066666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (212, N'Swetha Seethiraju', N'1074', N'G&A-HR', N'Hyderabad', 48.083333333333336, 28.550000000000004, 26.016666666666669, 2.5333333333333332, 19.516666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (213, N'T Abhishek', N'652', N'Mercell', N'Noida', 39.75, 30.1, 30.083333333333336, 0, 9.65)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (214, N'Tanmaya Kumar Tripathy', N'796', N'ML', N'Noida', 75, 32.233333333333327, 32.216666666666669, 0, 42.766666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (215, N'Tarang Malvaniya', N'942', N'Mercell', N'Noida', 51.216666666666669, 44.65, 44.633333333333333, 0, 6.5666666666666673)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (216, N'Tarun Kumar', N'965', N'ML', N'Noida', 105.81666666666668, 38.95, 38.93333333333333, 0, 66.86666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (217, N'Thakur Kranthi Singh', N'645', N'ML', N'Hyderabad', 58.45, 29.849999999999998, 29.716666666666665, 0.13333333333333333, 28.583333333333336)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (218, N'Thirupathi Gundarapu', N'332', N'ML', N'Hyderabad', 57.716666666666661, 31.483333333333331, 31.483333333333334, 0, 26.216666666666665)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (219, N'Thula Dhanasheela', N'761', N'ML', N'Hyderabad', 66.366666666666674, 35.216666666666669, 35.166666666666671, 0.033333333333333333, 31.133333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (220, N'Tulika Bhargava', N'402', N'ML', N'Hyderabad', 47.083333333333336, 28.7, 28.700000000000003, 0, 18.366666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (221, N'Tushar Borchate', N'ABC-0001', N'ABC-Special', N'Noida', 54.833333333333336, 29.566666666666666, 27.450000000000003, 2.0999999999999996, 25.266666666666666)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (222, N'Usha Sri Annadevara', N'741', N'ML', N'Hyderabad', 99.25, 50.416666666666671, 50.416666666666664, 0, 48.81666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (223, N'Vaibhav Prabhu Badadale', N'996', N'Mercell', N'Hyderabad', 45.416666666666664, 41.85, 41.849999999999994, 0, 3.55)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (224, N'Vaibhav Umakant Wagh', N'997', N'Mercell', N'Hyderabad', 54.083333333333336, 35.4, 35.383333333333326, 0, 18.683333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (225, N'Vajrala Dharani', N'979', N'CP', N'Hyderabad', 50.5, 38.616666666666667, 38.61666666666666, 0, 11.866666666666667)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (226, N'Vanapalli Hemadevi', N'1001', N'Mercell', N'Hyderabad', 47.866666666666667, 39.35, 39.35, 0, 8.5166666666666675)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (227, N'Varsha Harkut', N'1092', N'G&A-PMO', N'Hyderabad', 41.18333333333333, 29.400000000000002, 29.400000000000006, 0, 11.783333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (228, N'Vayalpad Anil Kumar', N'TEMP075', N'ABC-Special', N'Hyderabad', 104.28333333333333, 45.25, 45.1, 0.13333333333333333, 59.033333333333331)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (229, N'Vemula Kavya', N'744', N'ABC', N'Hyderabad', 51.15, 41.166666666666664, 41.150000000000006, 0, 9.9833333333333325)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (230, N'Venkateswararao Pyla', N'1086', N'G&A-PMO', N'Hyderabad', 33.033333333333331, 24.916666666666668, 24.900000000000006, 0, 8.1000000000000014)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (231, N'Vikas Kumar Verma', N'479', N'ML', N'Noida', 48.2, 39.333333333333336, 39.333333333333336, 0, 8.85)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (232, N'Vinay Kumar', N'1018', N'ML', N'Noida', 37.983333333333334, 23.716666666666665, 23.416666666666668, 0.28333333333333333, 14.25)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (233, N'Viraja Sai Vittala', N'1085', N'ML', N'Hyderabad', 49.866666666666674, 36.7, 36.699999999999996, 0, 13.150000000000002)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (234, N'Vishal Chauhan', N'TEMP055', N'ABC-Special', N'Noida', 104.41666666666667, 36.85, 36.833333333333336, 0.016666666666666666, 67.55)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (235, N'Vishal Kumar', N'918', N'ML', N'Hyderabad', 127.85, 64.75, 64.51666666666668, 0.21666666666666665, 63.100000000000009)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (236, N'Vishnu Reddy Pemmaka', N'1078', N'ML-Special', N'Hyderabad', 101.48333333333333, 14.933333333333334, 14.933333333333334, 0, 86.533333333333331)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (237, N'Vivek Raj', N'1011', N'ML', N'Noida', 132.46666666666667, 36.31666666666667, 36.300000000000004, 0, 96.13333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (238, N'VVN Krishna Chellaboyina', N'1089', N'ML', N'Hyderabad', 85.85, 45.983333333333334, 45.983333333333334, 0, 39.85)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (239, N'Yadav Deepak Rajendra', N'709', N'Mercell', N'Noida', 55.1, 49.5, 49.5, 0, 5.583333333333333)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (240, N'Yashpal Singh', N'377', N'ML', N'Noida', 119.41666666666667, 31.266666666666666, 31.183333333333334, 0.066666666666666666, 88.13333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (241, N'Yesbir Singh', N'622', N'ML', N'Noida', 69.86666666666666, 23.45, 23.450000000000003, 0, 46.4)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (242, N'Yogander Puri', N'392', N'Mercell', N'Noida', 41.233333333333334, 21.233333333333334, 21.05, 0.16666666666666666, 19.983333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (243, N'Yogesh Thakur', N'463', N'Mercell', N'Noida', 48.616666666666667, 30.633333333333329, 28.883333333333333, 1.7166666666666666, 17.983333333333334)
INSERT [dbo].[IT16JuneHrs] ([S No], [User Name], [Emp Code], [Team], [Location], [Total time], [Active time], [Productive time], [Unproductive time], [Downtime]) VALUES (244, N'Zubis Chakerverty', N'1040', N'Mercell', N'Noida', 34.366666666666667, 24.316666666666666, 24.300000000000004, 0, 10.05)
GO

--
INSERT INTO EmployeeITProductivity ([EmpId], [ITProductiveHours], [ITActiveHours], [startDate], [weekenddate])
SELECT [Emp Code], [Productive time], [Active time], '2024-06-16 00:00:00.000', '2024-06-22 00:00:00.000'
FROM [Automation10JulyNewDB].[dbo].[IT16JuneHrs]
--insert records of adrenalineleaves
USE [Automation10JulyNewDB]
GO
/****** Object:  Table [dbo].[Leave17June]    Script Date: 7/19/2024 5:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Leave17June](
	[Employee ID] [nvarchar](255) NULL,
	[Project Name] [nvarchar](255) NULL,
	[Employee Name] [nvarchar](255) NULL,
	[OU Name] [nvarchar](255) NULL,
	[Leave Type] [nvarchar](255) NULL,
	[Leave Name] [nvarchar](255) NULL,
	[From Date] [datetime] NULL,
	[To Date] [datetime] NULL,
	[Total No# Of Leave Days / Hours] [float] NULL,
	[Reason] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Approved By] [nvarchar](255) NULL,
	[Approved On] [datetime] NULL,
	[Status 1] [nvarchar](255) NULL,
	[Leave Days] [float] NULL
) ON [PRIMARY]
GO
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'19', N'MeridianLink', N'Shaik Feroz', N'Bhavna Software India Private Ltd', N'PTL-Request', N'PTL-Paternity leave', CAST(N'2024-06-13T00:00:00.000' AS DateTime), CAST(N'2024-06-17T00:00:00.000' AS DateTime), 3, N'Taking paternity leave', N'Approved', N'0810', CAST(N'2024-06-12T16:40:13.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'458', N'MeridianLink', N'Nitin Kumar', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-21T00:00:00.000' AS DateTime), CAST(N'2024-06-24T00:00:00.000' AS DateTime), 2, N'home shifting', N'Approved', N'0005', CAST(N'2024-06-17T13:18:26.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'606', N'MeridianLink', N'Azra  Parveen', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-21T00:00:00.000' AS DateTime), CAST(N'2024-06-24T00:00:00.000' AS DateTime), 2, N'Family Function', N'Approved', N'0474', CAST(N'2024-06-03T11:16:59.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'786', N'MeridianLink', N'Kota Poojitha', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-13T00:00:00.000' AS DateTime), CAST(N'2024-06-17T00:00:00.000' AS DateTime), 3, N'Going out with family', N'Approved', N'0019', CAST(N'2024-06-02T20:59:58.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'1062', N'MeridianLink', N'Keshika Gupta', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-20T00:00:00.000' AS DateTime), CAST(N'2024-06-26T00:00:00.000' AS DateTime), 5, N'Going to Kedarnath & Badrinath with family', N'Approved', N'1093', CAST(N'2024-05-29T18:27:52.000' AS DateTime), NULL, 2)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'201', N'Common Pool', N'Richa Sharma', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-25T00:00:00.000' AS DateTime), 7, N'Going out of station', N'Approved', N'0101', CAST(N'2024-05-13T11:16:56.000' AS DateTime), NULL, 5)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'776', N'ABC', N'Suraj Singh Bisht', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-17T00:00:00.000' AS DateTime), 1, N'Due to travelling.', N'Pending', NULL, NULL, NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'101', N'G&A', N'Dhiraj Kumar', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-20T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 2, N'Family Issues and illness', N'Approved', N'0221', CAST(N'2024-06-19T12:32:13.000' AS DateTime), N'Not Consider', NULL)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'221', N'G&A', N'Swati Pandey', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-21T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 1, N'Visit to Vaishnodevi with family', N'Approved', N'0999', CAST(N'2024-06-20T12:38:55.000' AS DateTime), N'Not Consider', NULL)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'563', N'G&A', N'Praveen  Kumar Mala Shyam', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 1, N'Sick Leave', N'Pending', NULL, NULL, N'Not Consider', NULL)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'768', N'HR-TM', N'Sadia Anjum', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-19T00:00:00.000' AS DateTime), 3, N'Leave to Celebrate Eid ul Adha', N'Approved', N'0221', CAST(N'2024-06-24T11:38:57.000' AS DateTime), NULL, 3)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'816', N'IT', N'Ashish Rawat', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-14T00:00:00.000' AS DateTime), CAST(N'2024-06-19T00:00:00.000' AS DateTime), 4, N'Hometown Visit', N'Approved', N'Temp086', CAST(N'2024-06-13T15:28:55.000' AS DateTime), N'Not Consider', NULL)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'1093', N'G&A', N'Subba Rao Kuracha', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-17T00:00:00.000' AS DateTime), 1, N'Travelled over the weekend', N'Approved', N'1093', CAST(N'2024-06-18T15:59:58.000' AS DateTime), N'Not Consider', NULL)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'1067', N'PMO', N'Siddhant Sharma', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-21T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 1, N'Emergency Leave', N'Approved', N'0599', CAST(N'2024-06-24T12:36:57.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'1086', N'PMO', N'Venkateswararao Pyla', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-20T00:00:00.000' AS DateTime), CAST(N'2024-06-20T00:00:00.000' AS DateTime), 1, N'Sick', N'Approved', N'0599', CAST(N'2024-06-24T12:37:02.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'377', N'MeridianLink', N'Yashpal Singh', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-21T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 1, N'Personal Work', N'Approved', N'0599', CAST(N'2024-06-24T12:36:55.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'422', N'Mercell', N'Saleemuddin Mewati', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-17T00:00:00.000' AS DateTime), 1, N'Eid-ul-Adha', N'Approved', N'0042', CAST(N'2024-06-12T16:06:28.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'422', N'Mercell', N'Saleemuddin Mewati', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-19T00:00:00.000' AS DateTime), CAST(N'2024-06-19T00:00:00.000' AS DateTime), 1, N'Family Emergency', N'Approved', N'0042', CAST(N'2024-06-19T17:07:49.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'969', N'Mercell', N'Arvind Kumar Modanwal', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-21T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 1, N'Not well', N'Approved', N'0392', CAST(N'2024-06-21T12:04:53.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'983', N'Mercell', N'Aamir Khan', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 5, N'Eid-ul-Adha', N'Approved', N'0270', CAST(N'2024-06-06T11:13:06.000' AS DateTime), NULL, 5)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'1012', N'Mercell', N'Polineni Himaja', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-20T00:00:00.000' AS DateTime), CAST(N'2024-06-20T00:00:00.000' AS DateTime), 1, N'I will be out of office as not feeling well,', N'Pending', NULL, NULL, NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'1025', N'Mercell', N'Satish Singh', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-19T00:00:00.000' AS DateTime), CAST(N'2024-06-19T00:00:00.000' AS DateTime), 1, N'Urgent work at home', N'Approved', N'0042', CAST(N'2024-06-19T10:17:36.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'1027', N'Mercell', N'Shahid Anwar', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-17T00:00:00.000' AS DateTime), 1, N'Due to Eid al-Adha festival, I won''t be able to join the office on 17th June 2024.', N'Approved', N'0463', CAST(N'2024-06-17T11:13:46.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'1052', N'Mercell', N'Lokesh Suthar', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-20T00:00:00.000' AS DateTime), CAST(N'2024-06-20T00:00:00.000' AS DateTime), 1, N'Sick leave', N'Approved', N'0042', CAST(N'2024-06-20T10:08:32.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'19', N'MeridianLink', N'Shaik Feroz', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 1, N'Initially i applied three days Paternity Leave, Now applying one day PL as baby is not well due to jaundice', N'Approved', N'0810', CAST(N'2024-06-18T11:57:30.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'19', N'MeridianLink', N'Shaik Feroz', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-21T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 1, N'Applying leave on Portal - Reason - My baby is not well and admitted in hospital.', N'Approved', N'0810', CAST(N'2024-06-24T15:30:36.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'368', N'MeridianLink', N'Shivam Jetly', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-17T00:00:00.000' AS DateTime), 1, N'Not Feeling well', N'Approved', N'0810', CAST(N'2024-06-17T12:48:23.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'382', N'MeridianLink', N'Madhvendra Singh', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 5, N'Family time off.', N'Approved', N'0377', CAST(N'2024-06-24T12:01:01.000' AS DateTime), NULL, 5)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'383', N'MeridianLink', N'Shubham Srivastav', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-20T00:00:00.000' AS DateTime), CAST(N'2024-06-20T00:00:00.000' AS DateTime), 1, N'Family Commitment', N'Approved', N'0599', CAST(N'2024-06-18T11:43:15.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'413', N'MeridianLink', N'Sanjay Mishra', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-20T00:00:00.000' AS DateTime), CAST(N'2024-06-20T00:00:00.000' AS DateTime), 1, N'Peronal work', N'Pending', NULL, NULL, NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'444', N'MeridianLink', N'Sanjeev Kumar Sinha', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-19T00:00:00.000' AS DateTime), CAST(N'2024-06-19T00:00:00.000' AS DateTime), 1, N'Family Commitment', N'Pending', NULL, NULL, NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'473', N'MeridianLink', N'Ashok Kumar', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 1, N'Personal', N'Approved', N'0599', CAST(N'2024-06-18T11:43:12.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'474', N'MeridianLink', N'Shubham Choudhary', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-20T00:00:00.000' AS DateTime), CAST(N'2024-06-20T00:00:00.000' AS DateTime), 1, N'Not feeling well', N'Approved', N'0599', CAST(N'2024-06-20T16:35:12.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'480', N'MeridianLink', N'Ashok kumar', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 5, N'Going to home town.', N'Approved', N'0599', CAST(N'2024-06-11T18:11:37.000' AS DateTime), NULL, 5)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'493', N'MeridianLink', N'Ankit Sharma', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 2, N'Due to some family function I would be on PTO on 17th and 18th June', N'Approved', N'0722', CAST(N'2024-06-06T15:41:24.000' AS DateTime), NULL, 2)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'495', N'MeridianLink', N'Maryam Wahab', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-17T00:00:00.000' AS DateTime), 1, N'Eid', N'Approved', N'0599', CAST(N'2024-06-05T19:47:25.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'495', N'MeridianLink', N'Maryam Wahab', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-19T00:00:00.000' AS DateTime), CAST(N'2024-06-19T00:00:00.000' AS DateTime), 0.5, N'son not well', N'Approved', N'0599', CAST(N'2024-06-24T12:37:01.000' AS DateTime), NULL, 0.5)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'531', N'MeridianLink', N'Gunashreya Maram', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 1, N'demise of our near one''s', N'Approved', N'0190', CAST(N'2024-06-20T14:36:42.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'555', N'MeridianLink', N'Ramit Manuja', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-21T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 0.5, N'Planned leave', N'Approved', N'0810', CAST(N'2024-06-24T12:03:52.000' AS DateTime), NULL, 0.5)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'560', N'MeridianLink', N'Sakshi', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-21T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 0.5, N'sick leave', N'Approved', N'0810', CAST(N'2024-06-24T11:33:55.000' AS DateTime), NULL, 0.5)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'585', N'MeridianLink', N'Abhimanyu Sharma', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-20T00:00:00.000' AS DateTime), 4, N'travelling outstation with family', N'Approved', N'0445', CAST(N'2024-05-16T15:33:25.000' AS DateTime), NULL, 4)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'629', N'MeridianLink', N'Lakshay Guglani', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 3.5, N'Sick leave', N'Pending', NULL, NULL, NULL, 3.5)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'630', N'MeridianLink', N'Anjali Singh', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-21T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 0.5, N'Not feeling well', N'Pending', NULL, NULL, NULL, 0.5)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'632', N'MeridianLink', N'Mohammad Hasan Raza', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 2, N'Bakreed Festival', N'Approved', N'0474', CAST(N'2024-05-24T09:48:46.000' AS DateTime), NULL, 2)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'633', N'MeridianLink', N'Litil Gupta', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 1, N'Health Issue', N'Approved', N'0810', CAST(N'2024-06-24T11:33:27.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'645', N'MeridianLink', N'Thakur Kranthi Singh', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-21T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 1, N'Personal', N'Approved', N'0495', CAST(N'2024-06-21T15:33:34.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'662', N'MeridianLink', N'Mohd Arshad', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-19T00:00:00.000' AS DateTime), 3, N'EID', N'Approved', N'0810', CAST(N'2024-05-24T10:49:55.000' AS DateTime), NULL, 3)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'695', N'MeridianLink', N'RaviKumar  Gunji', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 1, N'have taken a PL  as I was not feeling well.', N'Approved', N'0495', CAST(N'2024-06-20T10:02:30.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'722', N'MeridianLink', N'Ravi Gupta', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-20T00:00:00.000' AS DateTime), 3, N'Going out of station', N'Approved', N'0599', CAST(N'2024-06-07T11:10:17.000' AS DateTime), NULL, 3)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'755', N'MeridianLink', N'Srikanth Nanaboina', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-21T00:00:00.000' AS DateTime), 5, N'Vacation for a trip.', N'Approved', N'0599', CAST(N'2024-06-07T11:10:20.000' AS DateTime), NULL, 5)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'757', N'MeridianLink', N'kamsetti Vyshnavi', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-17T00:00:00.000' AS DateTime), 1, N'Some personal comments', N'Approved', N'0480', CAST(N'2024-06-24T08:51:21.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'761', N'MeridianLink', N'Thula Dhanasheela', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 1, N'due to family puja', N'Pending', NULL, NULL, NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'795', N'MeridianLink', N'Govind Patidar', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 1, N'Personel Urgency', N'Pending', NULL, NULL, NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'844', N'MeridianLink', N'Pavitra  Madiwalar', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 1, N'Personal work', N'Approved', N'0810', CAST(N'2024-06-18T11:57:36.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'893', N'MeridianLink', N'Mohit', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-18T00:00:00.000' AS DateTime), CAST(N'2024-06-18T00:00:00.000' AS DateTime), 1, N'Medical Reason', N'Approved', N'0383', CAST(N'2024-06-21T21:14:45.000' AS DateTime), NULL, 1)
INSERT [dbo].[Leave17June] ([Employee ID], [Project Name], [Employee Name], [OU Name], [Leave Type], [Leave Name], [From Date], [To Date], [Total No# Of Leave Days / Hours], [Reason], [Status], [Approved By], [Approved On], [Status 1], [Leave Days]) VALUES (N'929', N'MeridianLink', N'Mohit Nautiyal', N'Bhavna Software India Private Ltd', N'PL-Request', N'PL-Privilege Leave', CAST(N'2024-06-17T00:00:00.000' AS DateTime), CAST(N'2024-06-17T00:00:00.000' AS DateTime), 0.5, N'Have to travel for some bank related work.', N'Approved', N'1093', CAST(N'2024-06-18T11:01:41.000' AS DateTime), NULL, 0.5)

GO
--
WITH AggLeaves AS (    
SELECT[Employee ID],SUM ([Leave Days]) AS AggLeaves FROM [Leave17June]
GROUP BY [Employee ID]
)
UPDATE EmployeeITProductivity
SET Leave = AggLeaves
FROM AggLeaves
WHERE [EmpId] = CAST([Employee ID] as VARCHAR(MAX))
--

--updated Adrenaline Leave SP--
USE [Automation10JulyNewDB]
GO


--Dhiraj Kumar 07/17/24 
--Purpose: Correct the data mismatch

Delete from TimesheetDetail where TimesheetId in (Select TimesheetId  from Timesheet where ClientId=44)
Delete from Timesheet where ClientId=44  

UPDATE Timesheet SET ClientId=12, TeamId=1100 WHERE EmployeeID='201'

DELETE FROM TimesheetDetail WHERE TimesheetId IN (SELECT TimesheetId from Timesheet where EmployeeID='377' and ClientId=1)

DELETE FROM Timesheet where EmployeeID='377' and ClientId=1


Update Timesheet set TeamId=1042, ClientId=9 where EmployeeID='1018' and TeamId!=1042

UPDATE Timesheet SET TeamId=1146, ClientId=51 where EmployeeID IN (
SELECT BhavnaEmployeeId FROM EmployeeDetails ed where ed.TeamId=1118 )

UPDATE EmployeeDetails SET TeamId=1146 where TeamId=1118

Delete TimesheetDetail where Id in (
71610,
71611,
71612,
71613)

GO
CREATE OR ALTER PROCEDURE usp_GetAllClients
AS
BEGIN
    -- Select all records from the ClientMaster table
    SELECT * FROM dbo.ClientMaster where ClientOrderRank is not null order by ClientOrderRank 
END;

-- To update ClientMaster to keep reports in order matching with old one
Alter table ClientMaster Add  ClientOrderRank int  null 

Update ClientMaster set  ClientOrderRank = (case id when 37 then 1 when 9 then 3 when 51 then 4 when 1 then 2when 12 then 5 when 48 then 6 when 46 then 7 else null end)  


--Modified PDF SP

--Exec [dbo].[usp_getTimesheetPdfReport]  '2024-06-16 00:00:00.000', '2024-06-22 00:00:00.000',1
GO
ALTER     PROCEDURE [dbo].[usp_getTimesheetPdfReport]--  '2024-06-16 00:00:00.000', '2024-06-22 00:00:00.000',0
@startDate datetime,
@endDate datetime,
@ClientId int
AS
BEGIN
 
WITH AggregatedTimesheets AS (    
SELECT EmployeeID,ClientId, SUM (TotalHours) AS TotalHours FROM Timesheet WHERE StatusId = 4 
AND WeekStartDate >=@startDate AND WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ClientId = @ClientId)
GROUP BY EmployeeID,ClientId
),
DateRange AS (
    SELECT @startDate AS Date
    UNION ALL
    SELECT DATEADD(DAY, 1, Date)
    FROM DateRange
    WHERE DATEADD(DAY, 1, Date) <= @endDate
),
WeekEndHour as  (select  t.EmployeeId , Sum(td.Value) As WeekendHour from TimesheetDetail td 
inner join Timesheet t ON t.TimesheetId= td.TimesheetId where (td.Date=@startDate OR td.Date=@endDate) AND (ISNULL(@ClientId, 0) = 0 OR ClientId = @ClientId) GROUP BY t.EmployeeID),
EmployeeDetailsRanked AS (    
SELECT *, ROW_NUMBER() OVER (PARTITION BY BhavnaEmployeeId ORDER BY TeamId) AS RowNum FROM EmployeeDetails 
),
NewExpectedHours As (
select Distinct T.EmployeeID, (count(distinct Date)) as DateCount,(count(distinct Date)*8) as HoursExpected   from TimesheetDetail td 
inner join Timesheet t ON t.TimesheetId= td.TimesheetId join EmployeeDetails ED on t.EmployeeID=ED.BhavnaEmployeeId 
where (td.Date>=@startDate and td.Date<=@endDate) AND  (ISNULL(@ClientId, 0) = 0 OR ClientId = @ClientId) Group by t.EmployeeID
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
where TimeSheetSubcategoryName IN ('PL','SL','BL','PAT','LOP'))
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
SELECT EmpID, ROUND(SUM(ROUND(ITProductiveHours, 0)), 0) AS ITHours
FROM EmployeeITProductivity
WHERE startDate >= @startDate AND weekenddate <= @endDate
GROUP BY EmpID
),
TSProdNonProdHours AS (
select t.EmployeeId,
SUM(Case when sub.TimeSheetSubcategoryID= 17 THEN tsd.Value 
	 when sub.TimeSheetSubcategoryID= 24 THEN tsd.Value
     when sub.TimeSheetSubcategoryID= 22 THEN tsd.Value
     when sub.TimeSheetSubcategoryID= 23 THEN tsd.Value
     when sub.TimeSheetSubcategoryID= 25 THEN tsd.Value
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
 
SELECT  et.Function_Type as FunctionType,    
COUNT(DISTINCT em.EmployeeId) AS EmployeeCount, 
COUNT(DISTINCT ats.EmployeeId) AS TimesheetSubmitted,  
COALESCE(SUM(hh.Holiday),0) AS HolidayHours,
Round((COALESCE(SUM(ats.TotalHours),0)-COALESCE(SUM(hh.Holiday),0)),0) AS TSActualHours,
(SUM(HoursExpected)-COALESCE(SUM(hh.Holiday),0)) AS TSExpectedHours,
ROUND((COUNT(DISTINCT ats.EmployeeID) * 100.0 / COUNT(DISTINCT em.EmployeeId)),0) AS TSCompliance,
COUNT (DISTINCT ats.EmployeeId) AS TimesheetSubmitted,
Round(COALESCE(SUM(tth.TotalTimesheetHours),0),0) AS LeaveHours,
Round(COALESCE(SUM(tnh.TSProdHours),0),0) AS TSProdHours,
COALESCE(SUM(tnh.TsNonProdHours),0) AS TSNonProdHours,
Round(COALESCE(SUM(ita.ITHours),0),0) AS ITHours,
Round(COALESCE(SUM(wkh.WeekendHour),0),0) AS WeekEndHour,
ROUND(CASE WHEN SUM(ats.TotalHours) <> 0 
--THEN Round(COALESCE(SUM(ats.TotalHours),0) *100/ COALESCE((COUNT(DISTINCT em.EmployeeId) *40),0),0)
THEN Round((COALESCE(SUM(ats.TotalHours),0) - SUM(tth.TotalTimesheetHours))*100/ COALESCE(SUM(HoursExpected)-COALESCE(SUM(hh.Holiday),0),0),0)
ELSE
0
END,2) as UtilisationPer,
CASE WHEN SUM(ats.TotalHours) <> 0 AND SUM(tnh.TSProdHours) <> 0
THEN Round(COALESCE(SUM(tnh.TSProdHours),0) *100/ COALESCE(SUM(ats.TotalHours),0),0)
ELSE
0
END as ProdPercent
FROM EmployeeType et    
left JOIN EmployeeDetailsRanked edr ON et.Id =CONVERT(int, edr.Type) AND edr.RowNum = 1
left JOIN EmployeeMaster em ON edr.BhavnaEmployeeId = em.EmployeeId
LEFT JOIN TeamMaster tm ON edr.TeamId = tm.Id  LEFT JOIN ITActiveHours ita ON em.EmployeeId=ita.EmpId 
LEFT JOIN WeekEndHour wkh ON em.EmployeeId=wkh.EmployeeID
LEFT JOIN AggregatedTimesheets ats ON em.EmployeeId = ats.EmployeeID    
LEFT JOIN TimesheetTotalHours tth ON em.EmployeeId=tth.EmployeeID
LEFT JOIN HolidayHours hh ON em.EmployeeId=hh.EmployeeID
LEFT JOIN TSProdNonProdHours tnh ON em.EmployeeId=tnh.EmployeeId
Inner JOin NewExpectedHours neh on em.EmployeeId=neh.EmployeeID
 
WHERE (ISNULL(@ClientId, 0) = 0 OR ats.ClientId = @ClientId)
--AND ((em.IsDeleted <> 1 AND em.isTimesheetRequired <> 0) OR ats.EmployeeID IS NOT NULL)
AND ats.ClientId<>44
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
and sub.TimeSheetSubcategoryID IN (17,23,22,24,25)
AND ClientId<>44
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
AND ClientId<>44
Group by et.Function_Type, tc.TimeSheetCategoryName
END


Update TimesheetDetail set TimeSheetCategoryID=null, TimeSheetSubcategoryID=null where id=73148
Update TimesheetDetail set TimeSheetCategoryID=null, TimeSheetSubcategoryID=null where id=73081


---
update EmployeeMaster set isTimesheetRequired=0  where EmployeeID in (SELECT EmployeeId FROM EmployeeMaster WHERE DesignationId = 50) 
update EmployeeMaster set isTimesheetRequired=1  where EmployeeID in (SELECT DISTINCT [Emp Id] FROM JuneTimesheetData where [Emp Id] IN
(SELECT EmployeeId FROM EmployeeMaster where DesignationId=50)
AND [First Day of Period]='2024-06-16'
AND Status='Approved'
AND Project<>'ABC Special') 
/****** Object:  StoredProcedure [dbo].[usp_getTimesheetConsultantReport]    Script Date: 7/23/2024 7:29:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create or ALTER    PROCEDURE [dbo].[usp_getTimesheetConsultantReport] --'2024-06-23 00:00:00.000', '2024-06-29 00:00:00.000',0
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
WHERE (ISNULL(@ClientId, 0) = 0 OR tm.ClientId = @ClientId)
AND ((em.IsDeleted <> 1 AND em.isTimesheetRequired <> 0) OR ats.EmployeeID IS NOT NULL)
AND em.EmployeeId IN (SELECT EmployeeId FROM EmployeeMaster WHERE DesignationId = 50)
GROUP BY et.Function_Type;

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
where ts.StatusId=4 AND ts.WeekStartDate >=@startDate AND ts.WeekEndDate<=@endDate AND (ISNULL(@ClientId, 0) = 0 OR ts.ClientId = @ClientId) AND edr.BhavnaEmployeeId IN (SELECT EmployeeId FROM EmployeeMaster WHERE DesignationId = 50)
AND ClientId<>44
Group by et.Function_Type, tc.TimeSheetCategoryName
END
 
 --Missing changes from Suramit
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