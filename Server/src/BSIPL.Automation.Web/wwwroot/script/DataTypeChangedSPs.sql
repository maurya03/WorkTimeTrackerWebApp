-- =============================================
-- Author:		<Murali Sainath Reddy>
-- Create date: <31-05-2024>
-- Description:	<Changes the Datatype From int to varchar for all EmployeeId and BhavnaEmployeeId>
-- =============================================


/****** Object:  DataType Change Scripts    Script Date: 5/30/2024 ******/

---------EmployeeMaster-----------
ALTER TABLE dbo.EmployeeMaster DROP CONSTRAINT PK__Employee__7AD04F119EA6B62A;
ALTER TABLE dbo.EmployeeMaster ALTER COLUMN EmployeeId VARCHAR(50) NOT NULL;
ALTER TABLE dbo.EmployeeMaster ADD CONSTRAINT PK__Employee__7AD04F119EA6B62A PRIMARY KEY (EmployeeId);


---------EmployeeDetails-----------
ALTER TABLE dbo.EmployeeDetails ALTER COLUMN BhavnaEmployeeId VARCHAR(50) NULL;
ALTER TABLE dbo.EmployeeDetails ALTER COLUMN TimesheetManagerId VARCHAR(50) NULL;
ALTER TABLE dbo.EmployeeDetails ALTER COLUMN TimesheetApproverId1 VARCHAR(50) NULL;
ALTER TABLE dbo.EmployeeDetails ALTER COLUMN TimesheetApproverId2 VARCHAR(50) NULL;


----------Timesheet----------------
ALTER TABLE dbo.Timesheet ALTER COLUMN EmployeeID VARCHAR(50) NOT NULL;


-----------EmployeeRoles--------------
ALTER TABLE dbo.EmployeeRoles ALTER COLUMN EmployeeId VARCHAR(50) NOT NULL;


----------------------View--------------------------------
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
INNER JOIN EbProjects ON EbProjects.Id = Em.ProjectId
INNER JOIN EbDesignation ON EbDesignation.Id = Em.DesignationId
GO




ALTER   PROCEDURE [dbo].[UpdateTimesheetEmployeeDetail]
(
@EmployeeId VARCHAR(50),
@ManagerId VARCHAR(50),
@FirstApproverId VARCHAR(50),
@SecondApproverId VARCHAR(50),
@TeamId INT
)
AS
BEGIN
    UPDATE EmployeeDetails
    SET TimesheetManagerId = @ManagerId,
        TimesheetApproverId1 = @FirstApproverId,
        TimesheetApproverId2 = @SecondApproverId
        WHERE BhavnaEmployeeId = @EmployeeId
        AND TeamId = @TeamId;
END;

-----------------------------------------------------------------------------------------------

ALTER procedure [dbo].[usp_AddModifyEmployeeData]
(
@EmployeeId VARCHAR(50),
@FullName varchar(200),
@emailId varchar(200),
@RoleId int,
@CreatedDate DateTime,
@UpdatedDate DateTime,
@DesignationId int
)
AS
BEGIN
	BEGIN
	IF NOT EXISTS (select 1 from EmployeeRoles where EmployeeId=@EmployeeId)
	BEGIN
	INSERT INTO EmployeeRoles(EmployeeId,RoleId,CreatedDate) VALUES (@EmployeeId,@RoleId,@CreatedDate)
	END
	ELSE
	BEGIN
		UPDATE EmployeeRoles SET RoleId=@RoleId,UpdatedDate=@UpdatedDate WHERE EmployeeId=@EmployeeId
	END
	END
	BEGIN
	IF NOT EXISTS (select 1 from EmployeeMaster where EmployeeId=@EmployeeId)
	BEGIN
		INSERT INTO EmployeeMaster(EmployeeId,FullName,EmailId,DesignationId) VALUES (@EmployeeId,@FullName,@emailId,@DesignationId)
	END
	ELSE
	BEGIN
		UPDATE EmployeeMaster SET FullName =@FullName, EmailId=@emailId, DesignationId=@DesignationId WHERE EmployeeId=@EmployeeId
	END
	END
END
-----------------------------------------------------------------------------------------------------
--exec [dbo].[usp_getApplicationAccessByEmailId] 'dhirajkumar@bhavnacorp.com'

ALTER    PROCEDURE [dbo].[usp_getApplicationAccessByEmailId]
@EmailId VARCHAR(150)
AS
BEGIN

 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @ClientId INT;
 DECLARE @TeamId INT;
 DECLARE @EmployeeId VARCHAR(50);
 DECLARE @RoleId Int;


 SELECT top 1  @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId,
 @RoleId = Roles.RoleId
FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId  = @EmailId;


Select EM.EmployeeId, ER.RoleId, Roles.RoleName,AM.ApplicationName, AM.Id as ApplicationId, AM.canView, AM.CanEdit, AM.CanDelete, AM.ApplicationPath FROM EmployeeMaster EM
--INNER JOIN EmployeeDetails ED ON EM.EmployeeId = ED.EmployeeId
INNER JOIN EmployeeRoles ER ON ER.EmployeeId = EM.EmployeeId
INNER JOIN Roles ON Roles.RoleId = ER.RoleId
INNER JOIN ApplicationMaster AM on AM.RoleId= Roles.RoleId 
--INNER JOIN TeamMaster ON TeamMaster.Id = ED.TeamId 
where ER.RoleId= @RoleId and AM.canView=1 and EM.EmailId=@EmailId



END
END

--------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_getEmployeeDetailByEmailId]
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
SELECT * FROM EmployeeDetails
END
ELSE IF (@Role = 'Reporting_Manager')
BEGIN
SELECT * FROM EmployeeDetails WHERE TeamId = @TeamId
END
ELSE IF (@Role = 'EMPLOYEE')
BEGIN
SELECT * FROM EmployeeDetails WHERE BhavnaEmployeeId  = @EmployeeId
END

END
END
----------------------------------------------------------------------------------------------------

ALTER   PROCEDURE [dbo].[usp_getEmployeeProject]
@EmailId varchar(200)
As
Begin
DECLARE @EmpId varchar(50)
    Select @EmpId=EmployeeId from EmployeeMaster Where EmailId=@EmailId
	
  Select ClientId AS ProjectId,ClientName from EmployeeDetails empD inner join EmployeeMaster empM on  empD.BhavnaEmployeeId=empM.EmployeeId 
  inner join TeamMaster tm on tm.Id=empD.TeamId 
  inner join ClientMaster cli on cli.Id=tm.ClientId 
  where empM.EmailId=@EmailId
	
 
End

-----------------------------------------------------------------------------------------------------------

ALTER     PROCEDURE [dbo].[usp_getEmployeeRoleDetailByEmailId] 
@EmailId VARCHAR(150)
AS
BEGIN
SET NOCOUNT ON
IF @EmailId IS NOT NULL
 
BEGIN
DECLARE @Role VARCHAR(100) = '';
DECLARE @ClientId INT;
DECLARE @TeamId INT;
DECLARE @EmployeeId VARCHAR(50);
DECLARE @RoleId Int;
declare @EmployeeName varchar(max)=''
 
SELECT TOP(1) @TeamId=EmployeeDetails.TeamId, @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId,@EmployeeName= EmployeeMaster.FullName,
@RoleId = Roles.RoleId,@ClientId = TeamMaster.ClientId
FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.BhavnaEmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId;
 
IF @Role = ''
BEGIN
IF EXISTS (SELECT 1 FROM EmployeeMaster emp JOIN EmployeeDetails detail on emp.EmployeeId= detail.BhavnaEmployeeId where emp.EmailId=@EmailId and detail.BhavnaEmployeeId NOT IN (select EmployeeId from EmployeeRoles))
	BEGIN
		INSERT INTO EmployeeRoles(RoleId,EmployeeId,CreatedDate) values (2,(select top 1 EmployeeId from EmployeeMaster where EmailId =@EmailId),getdate())
 
		 SELECT TOP(1) @TeamId=EmployeeDetails.TeamId, @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId,@EmployeeName= EmployeeMaster.FullName,
		 @RoleId = Roles.RoleId,@ClientId = TeamMaster.ClientId
		FROM EmployeeMaster 
		INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.BhavnaEmployeeId
		INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
		INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
		INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
		WHERE EmployeeMaster.EmailId  = @EmailId;
   END
   ELSE
   BEGIN
		 SELECT TOP(1) @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId,
		 @RoleId = Roles.RoleId
		 FROM EmployeeMaster 
		 INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
		 INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
		 WHERE EmployeeMaster.EmailId  = @EmailId;
END
END
 
 
SELECT @RoleId AS RoleId, @TeamId AS TeamId, @Role AS RoleName, @EmployeeId AS EmployeeId, @ClientId AS ClientId, @EmployeeName as EmployeeName
 
END
END

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER procedure [dbo].[usp_gettimesheetcategory] 
(@emailId varchar(200))
as
begin
 
declare @employeeId varchar(50)
set @employeeId = (select employeeId from EmployeeMaster where EmailId=@emailId)
declare @function varchar(500)
set @function=(select top 1 type from EmployeeDetails where bhavnaEmployeeId=@employeeId)
 
 
SELECT  200 + ROW_NUMBER() over(order by TimeSheetCategoryID), * FROM TimeSheetCategory where  [Function]=@function
union 
SELECT 1000000 + ROW_NUMBER() over(order by TimeSheetCategoryID),* FROM TimeSheetCategory where [Function] <> @function
 
end

------------------------------------------------------------------------------------------------------------------------------------------

ALTER    procedure [dbo].[usp_getTimesheetCategoryByEmployeeId] --'akash.maurya@bhavnacorp.com', 0
@emailId varchar(200),
@employeeIdParam varchar(50)
as
begin
declare @roleId int
declare @employeeId varchar(50)
If @employeeIdParam = 0
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
		SELECT 1000000 + ROW_NUMBER() over(order by TimeSheetCategoryID),* FROM TimeSheetCategory where [Function] ='Common' and 
		TimeSheetCategoryID IN (select Distinct TimeSheetCategoryID from TimeSheetSubcategory)
END;
end

-----------------------------------------------------------------------------------------------------------

ALTER   PROCEDURE [dbo].[usp_getTimesheetDataStatusWise] --2, 'akash.maurya@bhavnacorp.com', '19,20', '2024-03-31', '2024-04-06', false, '',0
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
  begin
  insert into #tempEmployeeData
  exec usp_getTimesheetDataStatusWise_Employee @StatusID, @SkipRows, @EmpId, @TakeRows
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

-----------------------------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_getTimesheetDataStatusWise_Admin] 
  @StatusID int,
  @StartDate datetime, 
  @EndDate datetime, 
  @SkipRows int,
  @EmpId varchar(50),
  @TakeRows int,
  @SearchedText varchar(50),
  @ClientId NVARCHAR(MAX) = ''
AS
BEGIN
select Tse.TimesheetId,Tse.Created As CreatedDate, Tse.ApprovedDate, Tse.WeekStartDate,Tse.WeekEndDate, 
	Tse.SubmissionDate,COUNT(*) OVER () as TotalCount
	,CASE
    WHEN tss.StatusName = 'PENDING' THEN 'Submitted'
    ELSE tss.StatusName
END as StatusName,
Tse.Remarks,
	empM.EmployeeId,
	cm.ClientName, 
	Tse.TotalHours, empM.FullName as EmployeeName,
	empM.EmailId from Timesheet Tse 
	inner Join TimeSheetStatus tss on Tse.StatusId=tss.StatusID
	inner Join EmployeeMaster empM on empM.EmployeeID=Tse.EmployeeId
	inner Join EmployeeDetails emp on emp.BhavnaEmployeeId = empM.EmployeeId
	Inner join TeamMaster tm on Tse.TeamId=tm.Id And tm.Id=emp.TeamId
	Inner join ClientMaster cm on Tse.ClientId=cm.Id
	Where Tse.StatusId = @StatusID and Tse.ClientId IN (select value from string_split(@ClientId, ',')) 
	and Tse.WeekStartDate >=@StartDate and  Tse.WeekEndDate<=@EndDate 
	and empM.EmployeeId <> @EmpId
	and empM.FullName  LIKE '%'+@SearchedText+'%'
	order by
	case
		when tss.StatusName = 'Approved' Then Tse.ApprovedDate
		Else tse.Created
	end DESC
	OFFSET @SkipRows ROWS
   FETCH NEXT @TakeRows ROWS ONLY;
END

-------------------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_getTimesheetDataStatusWise_Employee]
  @StatusID int,
  @SkipRows int,
  @EmpId varchar(50),
  @TakeRows int
AS
BEGIN
  select Tse.TimesheetId,Tse.Created As CreatedDate,Tse.ApprovedDate, Tse.WeekStartDate,Tse.WeekEndDate, 
    Tse.SubmissionDate,COUNT(*) OVER () as TotalCount,tss.StatusName,
	Tse.Remarks,empM.EmployeeId,cm.ClientName,Tse.TotalHours, empM.FullName as EmployeeName,
	empM.EmailId
	from Timesheet Tse 
	inner Join TimeSheetStatus tss on Tse.StatusId=tss.StatusID
	inner Join EmployeeMaster empM on empM.EmployeeID=Tse.EmployeeID
	inner Join EmployeeDetails emp on emp.BhavnaEmployeeId = empM.EmployeeId
	Inner join TeamMaster tm on Tse.TeamId=tm.Id And tm.Id=emp.TeamId
	inner join ClientMaster cm on Tse.ClientId=cm.Id
	Where Tse.StatusId = @StatusID ANd empM.EmployeeId=@EmpId
	order by Tse.Created desc 
	OFFSET @SkipRows ROWS
   FETCH NEXT @TakeRows ROWS ONLY;
END

-----------------------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_getTimesheetDataStatusWise_Manager] --2, 'akash.maurya@bhavnacorp.com', '19,20', '2024-03-31', '2024-04-06', false, '',0
  @StatusID int,
  @StartDate datetime, 
  @EndDate datetime, 
  @SkipRows int,
  @EmpId varchar(50),
  @TakeRows int,
  @SearchedText varchar(50),
  @ClientId NVARCHAR(MAX) = ''
AS
BEGIN
select Tse.TimesheetId,Tse.Created As CreatedDate,Tse.ApprovedDate, Tse.WeekStartDate,Tse.WeekEndDate, 
Tse.SubmissionDate,
COUNT(*) OVER () as TotalCount
	,CASE
    WHEN tss.StatusName = 'PENDING' THEN 'Submitted'
    ELSE tss.StatusName
END as StatusName,
Tse.Remarks,
empM.EmployeeId,
cm.ClientName, 
Tse.TotalHours, empM.FullName as EmployeeName,empM.EmailId  from Timesheet Tse 
	inner Join TimeSheetStatus tss on Tse.StatusId=tss.StatusID
	inner Join EmployeeMaster empM on empM.EmployeeId=Tse.EmployeeID
	inner join EmployeeDetails ed on ed.BhavnaEmployeeId = empM.EmployeeId
	--inner Join EmployeeMaster empM on empM.EmployeeID=ed.EmployeeId
	Inner join TeamMaster tm on Tse.TeamId=tm.Id And tm.Id=ed.TeamId
	Inner join ClientMaster cm on Tse.ClientId=cm.Id
	Where Tse.StatusId = @StatusID
and Tse.WeekStartDate >=@StartDate and  Tse.WeekEndDate<=@EndDate and
	(ed.TimesheetManagerId =@EmpId Or ed.TimesheetApproverId1=@EmpId Or ed.TimesheetApproverId2=@EmpId) 
	and empM.FullName  LIKE '%'+@SearchedText+'%'
	order by
	case
		when tss.StatusName = 'Approved' Then Tse.ApprovedDate
		Else tse.Created
	end DESC
	OFFSET @SkipRows ROWS
   FETCH NEXT @TakeRows ROWS ONLY;
END

-------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_getTimesheetDayWiseReport]
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
					INNER JOIN EmployeeRoles er ON ed.BhavnaEmployeeId  = er.EmployeeId
					WHERE (t.ClientId = @Client) AND 
					(@TeamId = 0 OR t.TeamId = @TeamId) AND
					( er.RoleId != 1 )AND
					(td.Date >= @StartDate AND td.Date <= @EndDate)
					AND (@StatusId = 0 or t.StatusID = @StatusId);
		END
END
--------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_getTimeSheetDetailByTimesheetId] 
  @EmailId AS varchar(200),
  @TimesheetId int= 0,
  @StartDate datetime=Null,
  @EndDate datetime=NUll,
  @IsBehalf bit =0,
  @SelectedEmployeeIdForBehalf AS int = 0,
  @ClientId AS int = 0
AS
BEGIN
   DECLARE @EmpId varchar(50)
   DECLARE @OnBehalfTimesheetCreatedBy int=0
   Select @EmpId=EmployeeId from EmployeeMaster Where EmailId=@EmailId
   DECLARE @EmployeeRole varchar(200)
	Select @EmployeeRole=r.RoleName from EmployeeRoles er  inner join Roles r on er.RoleId=r.RoleId where er.EmployeeId = @EmpId
 
 
If @IsBehalf=0
Begin
   IF @EmployeeRole='Admin'
   begin
  select ts.TimesheetId,ts.StatusId,ts.ClientId as ProjectId, cm.ClientName as ProjectName, DATEPART(WEEKDAY, td.Date) DayOfWeek,
	 td.TimesheetUnit,td.Value HoursWorked,td.Date,TaskDescription,td.TimeSheetCategoryId,td.TimeSheetsubCategoryId, td.Id as TimesheetDetailId,
	 tc.TimeSheetCategoryName as CategoryName, tsc.TimeSheetSubcategoryName as SubCategoryName from [TimesheetDetail] td 
     inner join [Timesheet] ts on ts.TimesheetId=td.TimesheetId
	 inner join ClientMaster cm on ts.ClientId=cm.Id
	 inner join TimeSheetCategory tc on td.TimeSheetCategoryID=tc.TimeSheetCategoryID
	 inner join TimeSheetSubcategory tsc on td.TimeSheetSubcategoryID = tsc.TimeSheetSubcategoryID
	 where (@TimesheetId =0 And ts.WeekStartDate=@StartDate And ts.WeekEndDate<=@EndDate AND ts.EmployeeID=@EmpId ) OR (@TimesheetId !=0 And td.TimesheetId=@TimesheetId) 
   end
   else If not exists(Select 1 from EmployeeDetails where TimesheetApproverId1=@EmpId or TimesheetApproverId2=@EmpId or TimesheetManagerId=@EmpId)
   begin
     select ts.TimesheetId,ts.StatusId,ts.ClientId as ProjectId, cm.ClientName as ProjectName,
	 DATEPART(WEEKDAY, td.Date) as DayOfWeek,
	 td.TimesheetUnit,td.Value HoursWorked,td.Date,TaskDescription,
	 td.TimeSheetCategoryId,td.TimeSheetsubCategoryId, td.Id as TimesheetDetailId,
	tc.TimeSheetCategoryName as CategoryName, tsc.TimeSheetSubcategoryName as SubCategoryName
	 from [TimesheetDetail] td 
     inner join [Timesheet] ts on ts.TimesheetId=td.TimesheetId
	  inner join ClientMaster cm on ts.ClientId=cm.Id
	 inner join TimeSheetCategory tc on td.TimeSheetCategoryID=tc.TimeSheetCategoryID
	 inner join TimeSheetSubcategory tsc on td.TimeSheetSubcategoryID = tsc.TimeSheetSubcategoryID
	 where (@TimesheetId =0 And ts.WeekStartDate=@StartDate And ts.WeekEndDate<=@EndDate AND ts.EmployeeID=@EmpId ) OR (@TimesheetId !=0 And td.TimesheetId=@TimesheetId) And ts.EmployeeID=@EmpId
	 return
   end
   else
   begin
     select ts.TimesheetId,ts.StatusId,ts.ClientId as ProjectId,  cm.ClientName as ProjectName, DATEPART(WEEKDAY, td.Date) DayOfWeek,
	 td.TimesheetUnit,td.Value HoursWorked,td.Date,TaskDescription,
	 td.TimeSheetCategoryId,td.TimeSheetsubCategoryId,  td.Id as TimesheetDetailId,
	 tc.TimeSheetCategoryName as CategoryName, tsc.TimeSheetSubcategoryName as SubCategoryName from [TimesheetDetail] td 
     inner join [Timesheet] ts on ts.TimesheetId=td.TimesheetId
	 inner join ClientMaster cm on ts.ClientId=cm.Id
	 inner join TimeSheetCategory tc on td.TimeSheetCategoryID=tc.TimeSheetCategoryID
	 inner join TimeSheetSubcategory tsc on td.TimeSheetSubcategoryID = tsc.TimeSheetSubcategoryID
	 where (@TimesheetId =0 And ts.WeekStartDate=@StartDate And ts.WeekEndDate<=@EndDate AND ts.EmployeeID=@EmpId ) OR (@TimesheetId !=0 And td.TimesheetId=@TimesheetId) And (ts.EmployeeID in (select BhavnaEmployeeId from EmployeeDetails where TimesheetApproverId1=@EmpId or TimesheetApproverId2=@EmpId or TimesheetManagerId=@EmpId) or ts.EmployeeID=@EmpId)
   end
End
Else
	Begin
	  IF @EmployeeRole='Admin'
	   begin
	   With T As
		 (select ts.TimesheetId,ts.StatusId,ts.ClientId ProjectId,DATEPART(WEEKDAY, td.Date) DayOfWeek,td.TimesheetUnit,td.Value as HoursWorked,td.Date,TaskDescription,TimeSheetCategoryId,TimeSheetsubCategoryId,Case When ts.OnBehalfTimesheetCreatedBy is null Then 'self' Else 'other' End As CreatedBy from [TimesheetDetail] td 
		 inner join [Timesheet] ts on ts.TimesheetId=td.TimesheetId where ts.ClientId=@clientId And ts.WeekStartDate=@StartDate And ts.WeekEndDate<=@EndDate AND ts.EmployeeID=@SelectedEmployeeIdForBehalf )
		 Select * from T
	   end
	   Else If exists(Select 1 from EmployeeDetails where TimesheetApproverId1=@EmpId or TimesheetApproverId2=@EmpId or TimesheetManagerId=@EmpId)
	   begin
	    With T As
		 (select ts.TimesheetId,ts.StatusId,ts.ClientId ProjectId,DATEPART(WEEKDAY, td.Date) DayOfWeek,td.TimesheetUnit,td.Value HoursWorked,td.Date,TaskDescription,TimeSheetCategoryId,TimeSheetsubCategoryId,Case When ts.OnBehalfTimesheetCreatedBy is null Then 'self' Else 'other' End As CreatedBy from [TimesheetDetail] td 
         inner join [Timesheet] ts on ts.TimesheetId=td.TimesheetId where ts.ClientId=@clientId And ts.EmployeeID=@SelectedEmployeeIdForBehalf And ts.WeekStartDate=@StartDate And ts.WeekEndDate<=@EndDate And (ts.EmployeeID in (select EmployeeID from EmployeeDetails where TimesheetApproverId1=@EmpId or TimesheetApproverId2=@EmpId or TimesheetManagerId=@EmpId) or ts.EmployeeID=@EmpId))
		 Select * from T
		 return
	   end	
	End
END

-------------------------------------------------------------------------------------------------------------------------------------------------

ALTER    PROCEDURE [dbo].[usp_getTimesheetEmployee]
@EmailId VARCHAR(150),
@ProjectId int=0
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100);
 DECLARE @EmployeeId varchar(50);

 Select @EmployeeId=EmployeeId from EmployeeMaster Where EmailId=@EmailId

SELECT distinct @Role=Roles.RoleName FROM EmployeeMaster 
INNER JOIN EmployeeDetails ON EmployeeMaster.EmployeeId = EmployeeDetails.BhavnaEmployeeId
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
INNER JOIN TeamMaster ON TeamMaster.Id = EmployeeDetails.TeamId
WHERE EmployeeMaster.EmailId  = @EmailId

--FILTER RECORD USING ROLE
IF (@ProjectId !=0 And @Role = 'ADMIN')
BEGIN
  SELECT empM.EmployeeId,FullName EmployeeName,empM.EmailId FROM EmployeeMaster empM 
  Inner Join EmployeeDetails empD on empD.BhavnaEmployeeId=empM.EmployeeId 
  Inner Join TeamMaster tm on tm.Id = empD.TeamId
  Inner Join ClientMaster cli on cli.Id=tm.ClientId
  WHERE cli.Id=@ProjectId And empM.EmployeeId !=@EmployeeId
END
ELSE
BEGIN
  SELECT empM.EmployeeId,FullName EmployeeName,empM.EmailId FROM EmployeeMaster empM Inner Join EmployeeDetails empD on empD.BhavnaEmployeeId=empM .EmployeeId WHERE (timesheetManagerId=@EmployeeId Or timesheetApproverId1=@EmployeeId Or timesheetApproverId2=@EmployeeId) And empM.EmployeeId !=@EmployeeId
END
END
END

--------------------------------------------------------------------------------------------------------------------------------------------

ALTER    PROCEDURE [dbo].[usp_getTimeSheetForApprover]
  @StatusID int,
  @EmailId AS varchar(200)
AS
BEGIN
    DECLARE @ApproverId varchar(50)
   Select @ApproverId=EmployeeId from EmployeeMaster Where EmailId=@EmailId

	select EntryID,Created,'Week '+CONVERT(varchar(10), weeknumber) +' '+ CONVERT(varchar(10), EntryYear) as Period,(select dbo.GetDateFromWeekDay(EntryYear,weeknumber,1)) PeriodStart,TotalHours,StatusName  from TimesheetEntry Tse 
	inner Join TimeSheetStatuses tss on Tse.StatusID=tss.StatusID
	inner Join EmployeeMaster empmst on Tse.EmployeeID=empmst.EmployeeId
	inner Join TimeSheetUserProfiles tsu on tsu.UserId = empmst.EmployeeId
	Where Tse.StatusID = @StatusID And (manager =@ApproverId Or approver1=@ApproverId Or approver2=@ApproverId) order by Created desc  
END

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_getTimesheetSubmissionReport]
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
				LEFT JOIN Timesheet t ON ed.BhavnaEmployeeId = t.EmployeeID
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
				LEFT JOIN Timesheet t ON ed.BhavnaEmployeeId = t.EmployeeID
				LEFT JOIN TimeSheetStatus ts ON t.StatusId = ts.StatusID
				INNER JOIN EmployeeRoles er ON ed.BhavnaEmployeeId  = er.EmployeeId
					WHERE (t.ClientId = @Client) AND 
					(@TeamId = 0 OR t.TeamId = @TeamId) AND
							(t.Created >= @StartDate AND t.Created <= @EndDate)
							AND ( er.RoleId != 1 ) AND (@StatusId = 0 or t.StatusID = @StatusId)
					ORDER BY
				ed.EmployeeName desc;
		END
END

------------------------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE [dbo].[usp_getTimesheetSubmissionReportByClientAndTeam]
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
				DECLARE @RoleId INT;
				SELECT TOP(1) @Role=Roles.RoleName, @RoleId=Roles.RoleId, @Client= team.ClientId FROM EmployeeMaster 
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
					INNER JOIN EmployeeRoles er ON er.EmployeeId = ed.BhavnaEmployeeId
					WHERE (t.ClientId = @Client) AND 
					(@TeamId = 0 OR t.TeamId = @TeamId) AND
					(er.RoleId != 1) AND
					(t.WeekStartDate >= @StartDate AND t.WeekEndDate <= @EndDate)
					AND (@StausId = 0 or t.StatusID = @StausId);
		END
END

------------------------------------------------------------------------------------------------------------------------------------

ALTER     PROCEDURE [dbo].[usp_saveTimesheet]
    @HourlyData dbo.HourlyType READONLY,
	@EmailId varchar(200),
	@StatusId int,
	@Remarks NVARCHAR(255),
	@WeekStartDate datetime,
	@WeekEndDate datetime,	
	@OnBehalfTimesheetCreatedFor varchar(50)='',
	@OnBehalfTimesheetCreatedByEmail varchar(200)='',
	@TimesheetId int =0,
	@IsDeleted bit =0
AS
BEGIN
DECLARE @Counter INT = 1;
DECLARE @MaxCounter INT;

	With t As(
SELECT   ClientId, ROW_NUMBER() OVER (ORDER BY ClientId) AS Id FROM
    (SELECT DISTINCT ClientId FROM @HourlyData) Bse) select @MaxCounter = MAX(Id) from t

DECLARE @OnBehalfTimesheetCreatedByEmpId varchar(50);
DECLARE @EmployeeId varchar(50);

Select @EmployeeId=EmployeeId from EmployeeMaster Where EmailId=@EmailId
If(@OnBehalfTimesheetCreatedByEmail !='')
Begin
	Set @EmployeeId = @OnBehalfTimesheetCreatedFor
	Select @OnBehalfTimesheetCreatedByEmpId=EmployeeId from EmployeeMaster Where EmailId=@OnBehalfTimesheetCreatedByEmail	 
End

If(@TimesheetId !=0)
Begin
	Select @EmployeeId=EmployeeId,@StatusId=StatusId from Timesheet Where TimesheetId=@TimesheetId	 
End

If Not Exists(SELECT 1 FROM @HourlyData)
Begin
  Delete from TimesheetDetail where TimesheetId=@TimesheetId
   Delete from Timesheet where TimesheetId=@TimesheetId
End
 
WHILE @Counter <= @MaxCounter
BEGIN   
    DECLARE @ID INT, @ClientId INT;
		With t As(
SELECT   ClientId, ROW_NUMBER() OVER (ORDER BY ClientId) AS Id FROM
    (SELECT DISTINCT ClientId FROM @HourlyData) Ts) select  @ClientId= ClientId from t where Id=@Counter
 -------------------------------------------------
 SET NoCount on;
	DECLARE @InsertedTimesheetID INT;
	DECLARE @TotalHours float;
	DECLARE @TeamId int;
	

    Select @TeamId=tm.Id from TeamMaster tm Inner Join EmployeeDetails emp on tm.Id=emp.TeamId
	inner join EmployeeMaster em on em.EmployeeId=emp.BhavnaEmployeeId Where em.EmployeeId=@EmployeeId And tm.ClientId=@ClientId	
	SELECT @TotalHours=Sum(HourValue) FROM @HourlyData Where ClientId=@ClientId
	
	Merge into Timesheet as target
    USING (
        VALUES (		    
            @EmployeeID,
            @StatusId,
            @TotalHours,
            @Remarks,
            @WeekStartDate,
            @WeekEndDate,
            GETDATE(),
			@ClientId,
			@TeamId,
			@OnBehalfTimesheetCreatedByEmpId
        )
    ) AS source 
	(EmployeeID, StatusId, TotalHours, Remarks, WeekStartDate, WeekEndDate, Created,ClientId,TeamId,OnBehalfTimesheetCreatedBy)
   on target.WeekStartDate=source.WeekStartDate And
      target.WeekEndDate=source.WeekEndDate And
      target.EmployeeId=source.EmployeeId AND	  
	  target.ClientId=source.ClientId And
	  target.TeamId=source.TeamId	 
when matched then 
   update set 
   target.StatusId=Source.StatusId, 
   target.TotalHours=Source.TotalHours, 
   target.Remarks=Source.Remarks,    
   target.Modified=GETDATE()
when not matched then  
   Insert values(@EmployeeId,@ClientId,@TeamId,@TotalHours,@WeekStartDate,@WeekEndDate,null,null,GETDATE(),null,@Remarks,@StatusId,@OnBehalfTimesheetCreatedByEmpId);
   Select @InsertedTimesheetID= TimesheetId from Timesheet Where WeekStartDate=@WeekStartDate and WeekEndDate=@WeekEndDate and EmployeeId=@EmployeeId and ClientId=@ClientId	
	If Exists(Select 1 from TimesheetDetail where TimesheetId=@InsertedTimesheetID)
	begin
	  If @IsDeleted=1
		  Begin
		   Delete from TimesheetDetail where TimesheetId=@InsertedTimesheetID And TaskDescription in (Select TaskDescription from @HourlyData)
		   If Not Exists (Select 1 From TimesheetDetail where TimesheetId=@InsertedTimesheetID)
		     Begin
			     Delete from Timesheet where TimesheetId=@InsertedTimesheetID
			 End
		   Else 
		     Begin
			     Update Timesheet Set TotalHours =(Select Sum([Value]) from TimesheetDetail Where TimesheetId=@InsertedTimesheetID) Where TimesheetId=@InsertedTimesheetID
			 End
		  End
      Else
	  Begin
	   Delete from TimesheetDetail where TimesheetId=@InsertedTimesheetID
	  End
	end	
	If @IsDeleted=0
		Begin
			Insert into TimesheetDetail select @InsertedTimesheetID,CategoryId,SubCategoryId,TaskDescription,'HH',HourValue,(select dbo.GetDateOfWeek(@WeekStartDate,DayOfWeek)) from @HourlyData Where ClientId=@ClientId	
		End	
	Select @InsertedTimesheetID As TimesheeId
    -- Increment the counter
    SET @Counter = @Counter + 1;
END;
END
--------------------------------------------------------------------------------------------------------------------------------------------

ALTER   PROCEDURE [dbo].[usp_saveTimesheetV2]
    @HourlyData dbo.HourlyType READONLY,
    @ClientHoursTotal dbo.ClientWiseHoursTotal READONLY,
    @EmailId varchar(200),
    @StatusId int,
    @Remarks NVARCHAR(255),
    @WeekStartDate datetime,
    @WeekEndDate datetime,
    @OnBehalfTimesheetCreatedFor int = 0,
    @OnBehalfTimesheetCreatedByEmail varchar(200) = '',
    @TimesheetId int = 0    
AS
BEGIN
    DECLARE @EmployeeId VARCHAR(50);
    SELECT @EmployeeId = EmployeeId FROM EmployeeMaster WHERE EmailId = @EmailId;
    DECLARE @TimesheetIdToDelete INT;
    SELECT @TimesheetIdToDelete = ts.TimesheetId
    FROM Timesheet ts 
    INNER JOIN TimesheetDetail tsd ON ts.TimesheetId = tsd.TimesheetId 
    LEFT JOIN @HourlyData hd ON ts.ClientId = hd.ClientId 
    WHERE ts.WeekStartDate = @WeekStartDate AND WeekEndDate = @WeekEndDate 
    AND StatusId = @StatusId AND hd.ClientId IS NULL AND ts.EmployeeID = @EmployeeId;
    DELETE FROM TimesheetDetail WHERE id IN (
        SELECT tsd.Id 
        FROM Timesheet ts 
        INNER JOIN TimesheetDetail tsd ON ts.TimesheetId = tsd.TimesheetId 
        WHERE ts.WeekStartDate = @WeekStartDate AND WeekEndDate = @WeekEndDate 
        AND StatusId = @StatusId AND ts.EmployeeID = @EmployeeId
    );
    DELETE FROM Timesheet WHERE TimesheetId = @TimesheetIdToDelete;
    DECLARE @MaxCounter INT;
    WITH t AS (
        SELECT ClientId, ROW_NUMBER() OVER (ORDER BY ClientId) AS Id 
        FROM (SELECT ClientId FROM @ClientHoursTotal) Cws
    )
    SELECT @MaxCounter = MAX(Id) FROM t;
    DECLARE @OnBehalfTimesheetCreatedByEmpId varchar(50);
    IF (@OnBehalfTimesheetCreatedByEmail != '')
    BEGIN
        SET @EmployeeId = @OnBehalfTimesheetCreatedFor;
        SELECT @OnBehalfTimesheetCreatedByEmpId = EmployeeId FROM EmployeeMaster WHERE EmailId = @OnBehalfTimesheetCreatedByEmail;    
    END
    IF (@TimesheetId != 0)
    BEGIN
        SELECT @EmployeeId = EmployeeId, @StatusId = StatusId FROM Timesheet WHERE TimesheetId = @TimesheetId;    
    END
    IF NOT EXISTS (SELECT 1 FROM @HourlyData)
    BEGIN
        DELETE FROM TimesheetDetail WHERE TimesheetId = @TimesheetId;
        DELETE FROM Timesheet WHERE TimesheetId = @TimesheetId;
    END
    DECLARE @Counter INT = 1;
    WHILE @Counter <= @MaxCounter
    BEGIN   
        DECLARE @ID INT, @ClientId INT;  
		DECLARE @TotalHours float;
        WITH t AS (
            SELECT ClientId, TotalHours, ROW_NUMBER() OVER (ORDER BY ClientId) AS Id 
            FROM (SELECT ClientId, TotalHours FROM @ClientHoursTotal) Cws
        )
        SELECT @ClientId = ClientId, @TotalHours = TotalHours FROM t WHERE Id = @Counter;
        -------------------------------------------------
        SET NoCount on;
        DECLARE @InsertedTimesheetID INT;
        DECLARE @TeamId int;
        SELECT @TeamId = tm.Id 
        FROM TeamMaster tm 
        INNER JOIN EmployeeDetails emp ON tm.Id = emp.TeamId
        INNER JOIN EmployeeMaster em ON em.EmployeeId = emp.BhavnaEmployeeId 
        WHERE em.EmployeeId = @EmployeeId AND tm.ClientId = @ClientId;
		SELECT @TotalHours=TotalHours FROM @ClientHoursTotal Where ClientId=@ClientId
        IF NOT EXISTS (
            SELECT * FROM Timesheet 
            WHERE WeekStartDate = @WeekStartDate 
            AND WeekEndDate = @WeekEndDate 
            AND EmployeeId = @EmployeeId 
            AND ClientId = @ClientId
        )
        BEGIN
            INSERT INTO Timesheet (
                EmployeeID, ClientId, TeamId, TotalHours, WeekStartDate, WeekEndDate, Remarks, StatusId, OnBehalfTimesheetCreatedBy, Created
            )
            VALUES (
                @EmployeeId, @ClientId, @TeamId, @TotalHours, @WeekStartDate, @WeekEndDate, @Remarks, @StatusId, @OnBehalfTimesheetCreatedByEmpId, GETDATE()
            );
            SELECT @InsertedTimesheetID = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            UPDATE Timesheet 
            SET StatusId = @StatusId, 
                TotalHours = @TotalHours, 
                Remarks = @Remarks,    
                Modified = GETDATE()
            WHERE WeekStartDate = @WeekStartDate 
            AND WeekEndDate = @WeekEndDate 
            AND EmployeeId = @EmployeeId 
            AND ClientId = @ClientId;
            SELECT @InsertedTimesheetID = TimesheetId 
            FROM Timesheet 
            WHERE WeekStartDate = @WeekStartDate 
            AND WeekEndDate = @WeekEndDate 
            AND EmployeeId = @EmployeeId 
            AND ClientId = @ClientId;
        END
        INSERT INTO TimesheetDetail 
        SELECT @InsertedTimesheetID, CategoryId, SubCategoryId, TaskDescription, 'HH', HourValue, dbo.GetDateOfWeek(@WeekStartDate, DayOfWeek) 
        FROM @HourlyData 
        WHERE ClientId = @ClientId;
        SELECT @InsertedTimesheetID As TimesheeId;
        -------------------------------------------------
        -- Increment the counter
        SET @Counter = @Counter + 1;
    END;
END;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
ALTER PROCEDURE [dbo].[usp_UpdateTimeSheetStatusForApprover]
    @StatusId INT,
    @EmpIds NVARCHAR(MAX),
    @TimesheetIds NVARCHAR(MAX),
    @Remarks NVARCHAR(MAX),
    @ApproverEmailId VARCHAR(200)
AS
BEGIN
    DECLARE @query AS NVARCHAR(MAX)
    DECLARE @ApproverId VARCHAR(50)
    
    SELECT @ApproverId = EmployeeId
    FROM EmployeeMaster
    WHERE EmailId = @ApproverEmailId
 
    DECLARE @EmployeeRole VARCHAR(200)
    SELECT @EmployeeRole = r.RoleName
    FROM EmployeeRoles er
    INNER JOIN Roles r ON er.RoleId = r.RoleId
    WHERE er.EmployeeId = @ApproverId
 
	SET @EmpIds = REPLACE(@EmpIds, ' ', '');
	SET @TimesheetIds = REPLACE(@TimesheetIds, ' ', '');
 
    IF EXISTS (
        SELECT 1
        FROM EmployeeDetails
        WHERE BhavnaEmployeeId IN (SELECT VALUE FROM string_split(@EmpIds, ','))
        AND (TimesheetManagerId = @ApproverId OR TimesheetApproverId1 = @ApproverId OR TimesheetApproverId2 = @ApproverId)
    ) AND @EmployeeRole != 'Admin'
    BEGIN
        IF (@StatusId = 3 OR @StatusId = 4)
        BEGIN
            SET @query = '
            UPDATE ts
            SET StatusID = @StatusId,
                Remarks = @Remarks,
                Modified = GETDATE(),
                ApprovedDate = GETDATE()
            FROM EmployeeMaster empmst
            INNER JOIN timesheet ts ON empmst.EmployeeId = ts.EmployeeId
            INNER JOIN EmployeeDetails empD ON empD.BhavnaEmployeeId = empmst.EmployeeId
            WHERE empmst.EmployeeId != @ApproverId
            AND empmst.EmployeeId IN (SELECT DISTINCT value FROM string_split(@EmpIds, '',''))
            AND ts.TimesheetId IN (SELECT DISTINCT value FROM string_split(@TimesheetIds, '',''))
            AND (empD.TimesheetManagerId = @ApproverId OR empD.TimesheetApproverId1 = @ApproverId OR empD.TimesheetApproverId2 = @ApproverId)'
        END
    END
    ELSE
    BEGIN
        IF (@StatusId = 3 OR @StatusId = 4)
        BEGIN
            SET @query = '
            UPDATE ts
            SET StatusID = @StatusId,
                Remarks = @Remarks,
                Modified = GETDATE(),
                ApprovedDate = GETDATE()
            FROM EmployeeMaster empmst
            INNER JOIN timesheet ts ON empmst.EmployeeId = ts.EmployeeId
            INNER JOIN EmployeeDetails empD ON empD.BhavnaEmployeeId = empmst.EmployeeId
            WHERE empmst.EmployeeId IN (SELECT DISTINCT value FROM string_split(@EmpIds, '',''))
            AND ts.TimesheetId IN (SELECT DISTINCT value FROM string_split(@TimesheetIds, '',''))'
        END
    END
    EXEC sp_executesql @query,
        N'@StatusId INT, @Remarks NVARCHAR(MAX), @ApproverId VARCHAR(50), @EmpIds NVARCHAR(MAX), @TimesheetIds NVARCHAR(MAX)',
        @StatusId = @StatusId,
        @Remarks = @Remarks,
        @ApproverId = @ApproverId,
        @EmpIds = @EmpIds,
        @TimesheetIds = @TimesheetIds
END

--------------------------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_Eb_EditDeleteEmployee]
		@EmailId VARCHAR(200) = '',
		@EmployeeId VARCHAR = '',
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
			if(@EmployeeId = '' OR @action <= 0 OR @EmailId = '')
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
-------------------------------------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_Eb_GetEmployeeRole]
	@EmailId VARCHAR(200)
AS  
BEGIN


-- CHECK ROLE USING EMAILID
 IF @EmailId IS NOT NULL
 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @EmployeeId VARCHAR(50) = '';


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

-----------------------------------------------------------------------------------------------------------------------------------------------

USE [AutomationUAT]
GO
/****** Object:  StoredProcedure [dbo].[usp_Eb_GetProjectsByRole]    Script Date: 05/30/2024 7:25:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[usp_Eb_GetProjectsByRole]
	@EmailId VARCHAR(200)
AS  
BEGIN


-- CHECK ROLE USING EMAILID
 IF @EmailId IS NOT NULL
 BEGIN
  DECLARE @Role VARCHAR(100) = '';
  DECLARE @RoleId INT = 0;
  DECLARE @EmployeeRoleId INT = 0;
  DECLARE @EmployeeId VARCHAR(50) = '';
  DECLARE @RoleBasedProjectList TABLE (Id int);

SELECT TOP(1) @Role=Roles.RoleName,@EmployeeId = EmployeeMaster.EmployeeId, @EmployeeRoleId = EmployeeRoles.EmployeeRoleId, @RoleId = EmployeeRoles.RoleId FROM EmployeeMaster 
INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
WHERE EmployeeMaster.EmailId =  @EmailId


--FILTER RECORD USING ROLE
IF @Role <> '' AND @EmployeeId != ''
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


-----------------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_Eb_SaveEmployeeRole]
	@EmailId VARCHAR(200),
	@RoleId INT,
	@EmployeeId VARCHAR(50),
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

--------------------------------------------------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_Eb_SearchEmployees]
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
	DECLARE @EmployeeId VARCHAR(50) = '';
	DECLARE @RoleBasedProjectList TABLE (Id int);
	-- END ADDED FOR EMPLOYEE ROLE PROJECT BASED

 
	CREATE TABLE #ProjectDat(ProjectId int,ProjectName nvarchar(100));
	CREATE TABLE #tmpEmployees(RowNum INT, EmployeeId INT, EmployeeName VARCHAR(300), ProjectName VARCHAR(200), ProfilePictureUrl VARCHAR(200), Designation VARCHAR(100), EmailId varchar(100))

 
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
						SELECT		ROW_NUMBER() OVER ('+@OrderBy+'), EmployeeId, FullName, ProjectName, ProfilePictureUrl, dsgn.designation, emp.EmailId
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
 
	IF @Role <> '' AND @EmployeeId <> ''
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
	SELECT EmployeeId, EmployeeName, ProfilePictureUrl, Designation,EmailId FROM #tmpEmployees WHERE RowNum >= @StartIndex  AND  RowNum <= @EndIndex  
	SELECT @TotalPages [TotalPages], @TotalRecords [TotalRecords] 
END 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER  PROCEDURE [dbo].[usp_Eb_SearchEmployees1]
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
	DECLARE @EmployeeId VARCHAR(50) = '';
	DECLARE @RoleBasedProjectList TABLE (Id int);
	-- END ADDED FOR EMPLOYEE ROLE PROJECT BASED

 
	CREATE TABLE #ProjectDat(ProjectId int,ProjectName nvarchar(100));
	CREATE TABLE #tmpEmployees(RowNum INT, EmployeeId Varchar(50), EmployeeName VARCHAR(300), ProjectName VARCHAR(200), ProfilePictureUrl VARCHAR(200), Designation VARCHAR(100),ProjectId int, Interest varchar(200))

 
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
						SELECT		ROW_NUMBER() OVER ('+@OrderBy+'), EmployeeId, FullName, ProjectName, ProfilePictureUrl, dsgn.designation,ProjectId,HobbiesAndInterests
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
 
	IF @Role <> '' AND @EmployeeId <> ''
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
	SELECT RowNum, FullName as EmployeeName, Interest, vwEmp.* FROM #tmpEmployees tmp join vw_Eb_GetEmployeesDetailList vwEmp on tmp.EmployeeId=vwEmp.EmployeeId --WHERE RowNum >= @StartIndex  AND  RowNum <= @EndIndex  
   where  vwEmp.IsDeleted = 0 and vwEmp.IsActive = 1
	SELECT @TotalPages [TotalPages], @TotalRecords [TotalRecords] 
END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER    procedure [dbo].[usp_getTimesheetCategoryByEmployeeId] --'akash.maurya@bhavnacorp.com', 0
@emailId varchar(200),
@employeeIdParam varchar(50)
as
begin
declare @roleId int
declare @employeeId varchar(50)
If @employeeIdParam = ''
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
		SELECT 1000000 + ROW_NUMBER() over(order by TimeSheetCategoryID),* FROM TimeSheetCategory where [Function] ='Common' and 
		TimeSheetCategoryID IN (select Distinct TimeSheetCategoryID from TimeSheetSubcategory)
END;
end