
/****** Object:  StoredProcedure [dbo].[usp_gettrendlinedataemployee]    Script Date: 2/27/2024 12:05:44 PM ******/
DROP PROCEDURE [dbo].[usp_gettrendlinedataemployee]
GO
/****** Object:  StoredProcedure [dbo].[usp_getTeamListByEmailId]    Script Date: 2/27/2024 12:05:44 PM ******/
DROP PROCEDURE [dbo].[usp_getTeamListByEmailId]
GO
/****** Object:  StoredProcedure [dbo].[usp_getSkillsMatrixTablesByEmailId]    Script Date: 2/27/2024 12:05:44 PM ******/
DROP PROCEDURE [dbo].[usp_getSkillsMatrixTablesByEmailId]
GO
/****** Object:  StoredProcedure [dbo].[usp_getEmployeeRoleDetailByEmailId]    Script Date: 2/27/2024 12:05:44 PM ******/
DROP PROCEDURE [dbo].[usp_getEmployeeRoleDetailByEmailId]
GO
/****** Object:  StoredProcedure [dbo].[usp_getemployee_clientexpectedscore]    Script Date: 2/27/2024 12:05:44 PM ******/
DROP PROCEDURE [dbo].[usp_getemployee_clientexpectedscore]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboardshortcut]    Script Date: 2/27/2024 12:05:44 PM ******/
DROP PROCEDURE [dbo].[usp_dashboardshortcut]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData_teamwise]    Script Date: 2/27/2024 12:05:44 PM ******/
DROP PROCEDURE [dbo].[usp_dashboard_lineData_teamwise]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData_AI]    Script Date: 2/27/2024 12:05:44 PM ******/
DROP PROCEDURE [dbo].[usp_dashboard_lineData_AI]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData]    Script Date: 2/27/2024 12:05:44 PM ******/
DROP PROCEDURE [dbo].[usp_dashboard_lineData]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_data]    Script Date: 2/27/2024 12:05:44 PM ******/
DROP PROCEDURE [dbo].[usp_dashboard_data]
GO
/****** Object:  StoredProcedure [dbo].[usp_archive_process]    Script Date: 2/27/2024 12:05:44 PM ******/
DROP PROCEDURE [dbo].[usp_archive_process]
GO
/****** Object:  StoredProcedure [dbo].[usp_getCategoryMasterByClientScore]    Script Date: 5/10/2024 16:52:44 PM ******/
DROP PROCEDURE [dbo].[usp_getCategoryMasterByClientScore]
GO
/****** Object:  Table [dbo].[SkillsMatrix_Archive]    Script Date: 2/27/2024 12:05:44 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SkillsMatrix_Archive]') AND type in (N'U'))
DROP TABLE [dbo].[SkillsMatrix_Archive]
GO
GO
/****** Object:  Table [dbo].[SkillsMatrix_Archive]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SkillsMatrix_Archive](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NULL,
	[SubCategoryId] [int] NULL,
	[EmployeeScore] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[MatrixDate] [datetime] NULL,
 CONSTRAINT [PK_SkillsMatrix_Archive] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
GO
/****** Object:  StoredProcedure [dbo].[usp_archive_process]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_archive_process]
AS
BEGIN
	DECLARE @FirstDayOfLastMonth DATE = DATEADD(DAY, 1, EOMONTH(GETDATE(), -1));
	DECLARE @LastDayOfLastMonth DATE = EOMONTH(GETDATE(), -1);
	
	IF NOT EXISTS (SELECT 1 FROM SkillsMatrix_Archive WHERE MONTH(MatrixDate) =  MONTH(@LastDayOfLastMonth))
	BEGIN
			SELECT EmployeeId,SubCategoryId,EmployeeScore,CreatedOn,ModifiedOn into #temp from SkillsMatrix where Month(MatrixDate) =MONTH(GETDATE())
			
			INSERT INTO SkillsMatrix_Archive(EmployeeId,SubCategoryId,EmployeeScore,CreatedOn,ModifiedOn,MatrixDate) 
			SELECT EmployeeId,SubCategoryId,EmployeeScore,CreatedOn,ModifiedOn, @LastDayOfLastMonth from #temp


	END
	


	

END

GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_data]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 CREATE procedure [dbo].[usp_dashboard_data]
 as begin

create table #tempAverageScore(ClientName varchar(max), AverageScore numeric(36,2))
declare @clientid int
declare  @clientName varchar(max)
DECLARE db_cursor CURSOR FOR  
SELECT Id,ClientName FROM ClientMaster  --where ClientName='Mercell'
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @clientid  ,@clientName
WHILE @@FETCH_STATUS = 0   
BEGIN 
create table #tempClientScore(ClientName varchar(max),TeamName varchar(max), TeamId int, employeeId int, categoryId int,EmployeeTotalScore int,ClientExpectedScore int)

	   declare @teamId int,@teamName varchar(max)
	   DECLARE db_Teamcursor CURSOR FOR  
       SELECT Id,TeamName FROM TeamMaster where ClientId=@clientid
	   OPEN db_Teamcursor   
       FETCH NEXT FROM db_Teamcursor INTO @teamId,@teamName 
	   WHILE @@FETCH_STATUS = 0   
	   BEGIN
		   
		   
		 insert into #tempClientScore
		 exec usp_getemployee_clientexpectedscore @clientName,@teamName,@teamId

	       FETCH NEXT FROM db_Teamcursor INTO @teamId,@teamName
	   END
	   CLOSE db_Teamcursor   
	   DEALLOCATE db_Teamcursor
	   -- total expected score in technology of client
	  




	  
	  insert into #tempAverageScore
	  select @clientName as clientName,  sum(cast (percentage as numeric (36,2)))/ count(*) as AverageScore from (
	  SELECT teamid,count(distinct employeeid) employees, sum(EmployeeTotalScore) empScore,sum(ClientExpectedScore) clientExpectedScore, FORMAT((sum(EmployeeTotalScore) * 100.0/sum(ClientExpectedScore)),'N2') as percentage  FROM #tempClientScore  WHERE  EmployeeTotalScore < ClientExpectedScore 
	   group by teamid
	   ) t
		 
		-- select * from EmployeeDetails where TeamId =122 
	 
	  select * from #tempClientScore
	   drop table #tempClientScore
       FETCH NEXT FROM db_cursor INTO @clientid,@clientName  
END   

		CLOSE db_cursor   
		DEALLOCATE db_cursor
		
		 select * from #tempAverageScore
		 
		 --

  
  end
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboard_lineData]    (@clientId int)
as begin
With tmp as(select
ClientName,
TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [Automation].[dbo].[SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where cl.Id=@clientId group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MONTH(MatrixDate) = MONTH(GETDATE())) as t
            join
            (Select Row_number() over(order by CES desc) Popularity,Id from(SELECT 
            cat.Id,
            SUM(ClientExpectedScore) CES
            FROM 
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id 
            group by cat.Id) as t ) as t1 On t.CatId=t1.Id) 
			
--select
--ClientName,
--TeamName,
--EmployeeId,
--EmployeeName,
--CategoryName,
--ES [Employee Score],
--CES [Client Expected Score],
--EmployeeScorePercentage,
----[EmployeeScore1],
----MatrixDate,
--            case when Levels=1 then 'Trainer'
--             when Levels=2 then 'Expert'
--             when Levels=3 then 'Independent'
--             when Levels=4 then 'Beginner'
--             when Levels=5 then 'No Knowledge'
--            end as 'Current Status'
--            from tmp order by TeamName

select
ClientName,
TeamName,
CategoryName,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeid) employeeCount,
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage

--CES [Client Expected Score],
--EmployeeScorePercentage,
--[EmployeeScore1],
--MatrixDate,
            --case when Levels=1 then 'Trainer'
            -- when Levels=2 then 'Expert'
            -- when Levels=3 then 'Independent'
            -- when Levels=4 then 'Beginner'
            -- when Levels=5 then 'No Knowledge'
            --end as 'Current Status'
            from tmp  group by ClientName,TeamName,CategoryName  order by ClientName,TeamName		
end
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData_AI]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboard_lineData_AI]     (@clientId int)
as begin
With tmp as(select
ClientName,
TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [Automation].[dbo].[SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where cl.Id=@clientId group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MONTH(MatrixDate) = MONTH(GETDATE())) as t
            join
            (Select Row_number() over(order by CES desc) Popularity,Id from(SELECT 
            cat.Id,
            SUM(ClientExpectedScore) CES
            FROM 
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id 
            group by cat.Id) as t ) as t1 On t.CatId=t1.Id) 
			
select
ClientName,
TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES as [EmployeeScore],
CES [ClientExpectedScore],
EmployeeScorePercentage,
--[EmployeeScore1],
--MatrixDate,
            case when Levels=1 then 'Trainer'
             when Levels=2 then 'Expert'
             when Levels=3 then 'Independent'
             when Levels=4 then 'Beginner'
             when Levels=5 then 'No Knowledge'
            end as 'CurrentStatus'
            from tmp order by TeamName

	
end
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData_teamwise]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboard_lineData_teamwise]   (@clientId int, @teamName varchar(max))
as begin
-- exec [usp_dashboard_lineData_teamwise] 19, 'DataCollection'

With tmp as(select
ClientName,
TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [Automation].[dbo].[SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where cl.Id=@clientId group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MONTH(MatrixDate) = MONTH(GETDATE())) as t
            join
            (Select Row_number() over(order by CES desc) Popularity,Id from(SELECT 
            cat.Id,
            SUM(ClientExpectedScore) CES
            FROM 
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id 
            group by cat.Id) as t ) as t1 On t.CatId=t1.Id) 
			
--select
--ClientName,
--TeamName,
--EmployeeId,
--EmployeeName,
--CategoryName,
--ES [Employee Score],
--CES [Client Expected Score],
--EmployeeScorePercentage,
----[EmployeeScore1],
----MatrixDate,
--            case when Levels=1 then 'Trainer'
--             when Levels=2 then 'Expert'
--             when Levels=3 then 'Independent'
--             when Levels=4 then 'Beginner'
--             when Levels=5 then 'No Knowledge'
--            end as 'Current Status'
--            from tmp order by TeamName

select
EmployeeName,
CategoryName,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeid) employeeCount,
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage

--CES [Client Expected Score],
--EmployeeScorePercentage,
--[EmployeeScore1],
--MatrixDate,
            --case when Levels=1 then 'Trainer'
            -- when Levels=2 then 'Expert'
            -- when Levels=3 then 'Independent'
            -- when Levels=4 then 'Beginner'
            -- when Levels=5 then 'No Knowledge'
            --end as 'Current Status'
            from tmp where TeamName=@teamName  group by EmployeeName,TeamName,CategoryName  order by EmployeeName
end
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboardshortcut]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboardshortcut] @clientId int,  @signValueStart varchar(3), @signValueEnd varchar(3)
as
begin
declare @sql nvarchar(max);

With tmp as(select
			ClientName,
			TeamName,
			EmployeeId,
			EmployeeName,
			CategoryName,
			ES,CES,
			[EmployeeScore] EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [Automation].[dbo].[SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where cl.Id=@clientId group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MONTH(MatrixDate) = MONTH(GETDATE())) as t
            join
            (Select Row_number() over(order by CES desc) Popularity,Id from(SELECT 
            cat.Id,
            SUM(ClientExpectedScore) CES
            FROM 
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id 
            group by cat.Id) as t ) as t1 On t.CatId=t1.Id) 
			
		select * into #temp from tmp
		
		set @sql= 'SELECT
						EmployeeName,TeamName,
						Round(Sum(EmployeeScorePercentage)/Count(CategoryName),2) as EmployeeScorePercentage
						FROM #temp group by EmployeeName,TeamName Having Round(Sum(EmployeeScorePercentage)/Count(CategoryName),2) between cast( ' + @signValueStart  + ' as int) and cast( ' + @signValueEnd + ' as int)
						 order by EmployeeScorePercentage desc ';
		print @sql
		exec sp_executesql @sql
		drop table #temp
end
GO
/****** Object:  StoredProcedure [dbo].[usp_getemployee_clientexpectedscore]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
	CREATE procedure [dbo].[usp_getemployee_clientexpectedscore]  (@ClientName varchar(max), @TeamName varchar(max),@teamid int)
	as
	begin
		select * into #subcat from (
		select subcatm.TeamId, scm.CategoryId, sum(isnull(subcatm.ClientExpectedScore,0))  as clientScore
	from SubCategoryMapping subcatm 
	join SubCategoryMaster scm on subcatm.SubCategoryId = scm.Id 
	where TeamId=@teamid
	group by scm.CategoryId, subcatm.TeamId
	) as t
	
	
	--SELECT sm.EmployeeId, cat.Id as categoryId, sum(sm.EmployeeScore) as EmployeeTotalScore, (select clientScore from #subcat where TeamId=122 and CategoryId=cat.Id) as ClientExpectedScore
	--FROM dbo.SkillsMatrix sm 
 --        INNER JOIN dbo.SubCategoryMaster scm ON 
 --        sm.SubCategoryId=scm.Id
	--	 inner join CategoryMaster cat on cat.Id= scm.CategoryId
		
 --            WHERE sm.EmployeeId in (SELECT EmployeeId FROM dbo.EmployeeDetails  where TeamId=122
	--		 )  
 --         group by sm.EmployeeId, cat.Id
	--	  order by EmployeeId asc

    select * into #totalEmpScore from ( SELECT @ClientName as ClientName,@TeamName as TeamName, @teamid as TeamId, sm.EmployeeId, cat.Id as categoryId, sum(sm.EmployeeScore) as EmployeeTotalScore, (select isnull(clientScore,0) from #subcat where TeamId=@teamid and CategoryId=cat.Id) as ClientExpectedScore
	 FROM dbo.SkillsMatrix sm 
         INNER JOIN dbo.SubCategoryMaster scm ON 
         sm.SubCategoryId=scm.Id
		 inner join CategoryMaster cat on cat.Id= scm.CategoryId
		
             WHERE Month(sm.MatrixDate) = month(GETDATE()) and year(sm.MatrixDate) = year(getdate()) and sm.EmployeeId in (SELECT EmployeeId FROM dbo.EmployeeDetails  where TeamId=@teamid
			 )  
          group by sm.EmployeeId, cat.Id
		 
		  ) t
     
	 select ClientName,TeamName,TeamId,EmployeeId,categoryId,isnull(EmployeeTotalScore,0) EmployeeTotalScore,isnull(ClientExpectedScore,0) ClientExpectedScore from #totalEmpScore  order by EmployeeId
	-- select *  from #totalEmpScore where EmployeeTotalScore < ClientExpectedScore  order by EmployeeId 
	-- select count(*) * 100/count(EmployeeId)  from #totalEmpScore where EmployeeTotalScore < ClientExpectedScore  
	---- group by EmployeeId order by EmployeeId



	 drop table #subcat
	 drop table #totalEmpScore

	 end
GO
/****** Object:  StoredProcedure [dbo].[usp_getEmployeeRoleDetailByEmailId]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  StoredProcedure [dbo].[usp_getSkillsMatrixTablesByEmailId]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  StoredProcedure [dbo].[usp_getTeamListByEmailId]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  StoredProcedure [dbo].[usp_gettrendlinedataemployee]    Script Date: 2/27/2024 12:05:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_gettrendlinedataemployee]
(
@clientId int,
@teamId int,
@employeeId int
)
as 

begin
-- exec usp_gettrendlinedataemployee 19,122,4
with tmp as(select
ClientName,
TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [Automation].[dbo].[SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id 
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where cl.Id=@clientId 
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MONTH(MatrixDate) = MONTH(GETDATE())) as t
            join
            (Select Row_number() over(order by CES desc) Popularity,Id from(SELECT 
            cat.Id,
            SUM(ClientExpectedScore) CES
            FROM 
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id 
            group by cat.Id) as t ) as t1 On t.CatId=t1.Id

			union all

			select
ClientName,
TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [Automation].[dbo].[SkillsMatrix_Archive] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id 
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where cl.Id=@clientId 
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MatrixDate >= DATEADD(MONTH,-6,GETDATE())) as t
            join
            (Select Row_number() over(order by CES desc) Popularity,Id from(SELECT 
            cat.Id,
            SUM(ClientExpectedScore) CES
            FROM 
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id 
            group by cat.Id) as t ) as t1 On t.CatId=t1.Id 
			) 
--select
--ClientName,
--TeamName,
--EmployeeId,
--EmployeeName,
--CategoryName,
--ES [Employee Score],
--CES [Client Expected Score],
--EmployeeScorePercentage,
----[EmployeeScore1],
----MatrixDate,
--            case when Levels=1 then 'Trainer'
--             when Levels=2 then 'Expert'
--             when Levels=3 then 'Independent'
--             when Levels=4 then 'Beginner'
--             when Levels=5 then 'No Knowledge'
--            end as 'Current Status'
--            from tmp order by TeamName

select * from (select
ClientName,
TeamName,
CategoryName,
EmployeeName,
EmployeeId,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeid) employeeCount,
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage,
Format(MatrixDate,'MMM yyyy') as date

--CES [Client Expected Score],
--EmployeeScorePercentage,
--[EmployeeScore1],
--MatrixDate,
            --case when Levels=1 then 'Trainer'
            -- when Levels=2 then 'Expert'
            -- when Levels=3 then 'Independent'
            -- when Levels=4 then 'Beginner'
            -- when Levels=5 then 'No Knowledge'
            --end as 'Current Status'
            from tmp where EmployeeId=@employeeId   group by ClientName,TeamName,CategoryName,Format(MatrixDate,'MMM yyyy'),EmployeeName,EmployeeId) as t order by ClientName,TeamName,cast(date as datetime) asc

end
GO


CREATE PROCEDURE [dbo].[usp_GetEmployeeSkillNotAvailable]
@clientId int
As
begin
	create table #temp (EmployeeName varchar(200), TeamName varchar(200), employeeScorePercentage numeric (36,2))
	insert into #temp 
	exec usp_dashboardshortcut @clientId, 1,100

	select emp.EmployeeName, team.TeamName from EmployeeDetails emp join TeamMaster team on emp.TeamId= team.Id where EmployeeName
	not in  ( select EmployeeName from #temp ) and team.ClientId=@clientId
	drop table #temp

end

GO

DROP PROCEDURE IF EXISTS [dbo].[usp_insertskillmatrix]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_gettrendlinedataemployee]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_getSkillsMatrixTablesByEmailId]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_getorgDetails]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_GetEmployeeSkillNotAvailable]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_getemployee_clientexpectedscore]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_getClientSubCategoryExpectedScore_Dashboard]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_getClientSubCategoryExpectedScore]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_getClientMasterByEmployeeId]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_getApplicationAccessByEmailId]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboardshortcut]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboard_lineData_teamwise]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboard_lineData_AI]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboard_lineData]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboard_data]
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_archive_process]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_archive_process]
AS
BEGIN
	DECLARE @FirstDayOfLastMonth DATE = DATEADD(DAY, 1, EOMONTH(GETDATE(), -1));
	DECLARE @LastDayOfLastMonth DATE = EOMONTH(GETDATE(), -1);
	
	IF NOT EXISTS (SELECT 1 FROM SkillsMatrix_Archive WHERE MONTH(MatrixDate) =  MONTH(@LastDayOfLastMonth))
	BEGIN
			SELECT EmployeeId,SubCategoryId,EmployeeScore,CreatedOn,ModifiedOn into #temp from SkillsMatrix where Month(MatrixDate) =MONTH(@LastDayOfLastMonth)
			
			INSERT INTO SkillsMatrix_Archive(EmployeeId,SubCategoryId,EmployeeScore,CreatedOn,ModifiedOn,MatrixDate) 
			SELECT EmployeeId,SubCategoryId,EmployeeScore, GETDATE(),ModifiedOn, @LastDayOfLastMonth from #temp

			update  SkillsMatrix set MatrixDate= GETDATE()

	END
	



	

END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 CREATE procedure [dbo].[usp_dashboard_data]
 as begin

create table #tempAverageScore(ClientName varchar(max), AverageScore numeric(36,2))
declare @clientid int
declare  @clientName varchar(max)
DECLARE db_cursor CURSOR FOR  
SELECT Id,ClientName FROM ClientMaster  --where ClientName='Mercell'
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @clientid  ,@clientName
WHILE @@FETCH_STATUS = 0   
BEGIN 
create table #tempClientScore(ClientName varchar(max),TeamName varchar(max), TeamId int, employeeId int, categoryId int,EmployeeTotalScore int,ClientExpectedScore int)

	   declare @teamId int,@teamName varchar(max)
	   DECLARE db_Teamcursor CURSOR FOR  
       SELECT Id,TeamName FROM TeamMaster where ClientId=@clientid
	   OPEN db_Teamcursor   
       FETCH NEXT FROM db_Teamcursor INTO @teamId,@teamName 
	   WHILE @@FETCH_STATUS = 0   
	   BEGIN
		   
		   
		 insert into #tempClientScore
		 exec usp_getemployee_clientexpectedscore @clientName,@teamName,@teamId

	       FETCH NEXT FROM db_Teamcursor INTO @teamId,@teamName
	   END
	   CLOSE db_Teamcursor   
	   DEALLOCATE db_Teamcursor
	   -- total expected score in technology of client
	  




	  
	  insert into #tempAverageScore
	  select @clientName as clientName,  sum(cast (percentage as numeric (36,2)))/ count(*) as AverageScore from (
	  SELECT teamid,count(distinct employeeid) employees, sum(EmployeeTotalScore) empScore,sum(ClientExpectedScore) clientExpectedScore, FORMAT((sum(EmployeeTotalScore) * 100.0/sum(ClientExpectedScore)),'N2') as percentage  FROM #tempClientScore  WHERE  EmployeeTotalScore < ClientExpectedScore 
	   group by teamid
	   ) t
		 
		-- select * from EmployeeDetails where TeamId =122 
	 
	  select * from #tempClientScore
	   drop table #tempClientScore
       FETCH NEXT FROM db_cursor INTO @clientid,@clientName  
END   

		CLOSE db_cursor   
		DEALLOCATE db_cursor
		
		 select * from #tempAverageScore
		 
		 --

  
  end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboard_lineData]    (@clientId int)
as begin
With tmp as(select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage1,
 cast(FORMAT((cast(ES as decimal(5, 2))/ClientExpectedScore *100),'N2') as float) as EmployeeScorePercentage,

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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId = 0 or cl.Id=@clientId) group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
			
--select
--ClientName,
--TeamName,
--EmployeeId,
--EmployeeName,
--CategoryName,
--ES [Employee Score],
--CES [Client Expected Score],
--EmployeeScorePercentage,
----[EmployeeScore1],
----MatrixDate,
--            case when Levels=1 then 'Trainer'
--             when Levels=2 then 'Expert'
--             when Levels=3 then 'Independent'
--             when Levels=4 then 'Beginner'
--             when Levels=5 then 'No Knowledge'
--            end as 'Current Status'
--            from tmp order by TeamName

select
ClientName,
TeamName,
CategoryName,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeid) employeeCount,
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage

--CES [Client Expected Score],
--EmployeeScorePercentage,
--[EmployeeScore1],
--MatrixDate,
            --case when Levels=1 then 'Trainer'
            -- when Levels=2 then 'Expert'
            -- when Levels=3 then 'Independent'
            -- when Levels=4 then 'Beginner'
            -- when Levels=5 then 'No Knowledge'
            --end as 'Current Status'
            from tmp  group by ClientName,TeamName,CategoryName  order by ClientName,TeamName		
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboard_lineData_AI]     (@clientId int)
as begin
With tmp as(select
ClientName,
TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [Automation].[dbo].[SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where cl.Id=@clientId group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MONTH(MatrixDate) = MONTH(GETDATE())) as t
            join
            (Select Row_number() over(order by CES desc) Popularity,Id from(SELECT 
            cat.Id,
            SUM(ClientExpectedScore) CES
            FROM 
            SubCategoryMapping subM INNER JOIN TeamMaster tm on subM.TeamId= tm.Id
            INNER JOIN SubCategoryMaster sub ON subM.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id 
            group by cat.Id) as t ) as t1 On t.CatId=t1.Id) 
			
select
ClientName,
TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES as [EmployeeScore],
CES [ClientExpectedScore],
EmployeeScorePercentage,
--[EmployeeScore1],
--MatrixDate,
            case when Levels=1 then 'Trainer'
             when Levels=2 then 'Expert'
             when Levels=3 then 'Independent'
             when Levels=4 then 'Beginner'
             when Levels=5 then 'No Knowledge'
            end as 'CurrentStatus'
            from tmp order by TeamName

	
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboard_lineData_teamwise]   (@clientId int, @teamName varchar(max))
as begin
-- exec [usp_dashboard_lineData_teamwise] 19, 'DataCollection'

With tmp as(select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage1,
 cast(FORMAT((cast(ES as decimal(5, 2))/ClientExpectedScore *100),'N2') as float) as EmployeeScorePercentage,

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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId=0 or cl.Id=@clientId) group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage
from tmp where ((@clientId=0 and ClientName=@teamName) or TeamName=@teamName)  group by EmployeeName,TeamName,CategoryName  order by EmployeeName
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboardshortcut] @clientId int,  @signValueStart varchar(3), @signValueEnd varchar(4)
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
 cast(FORMAT((cast(ES as decimal(5, 2))/ClientExpectedScore *100),'N2') as float) as EmployeeScorePercentage,

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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where @clientId = 0 or cl.Id=@clientId group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
						Round(Sum(EmployeeScorePercentage)/Count(CategoryName),2) as EmployeeScorePercentage
						FROM #temp group by ClientName, EmployeeName,TeamName Having Round(Sum(EmployeeScorePercentage)/Count(CategoryName),2) between ' + @signValueStart  + '  and ' + @signValueEnd + '
						 order by EmployeeScorePercentage desc ';
		print @sql
		exec sp_executesql @sql
		drop table #temp
end

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [dbo].[usp_getApplicationAccessByEmailId] 'dhirajkumar@bhavnacorp.com'

CREATE PROCEDURE [dbo].[usp_getApplicationAccessByEmailId]
@EmailId VARCHAR(150)
AS
BEGIN

 BEGIN
 DECLARE @Role VARCHAR(100) = '';
 DECLARE @ClientId INT;
 DECLARE @TeamId INT;
 DECLARE @EmployeeId Int;
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


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_getClientSubCategoryExpectedScore] (
 @CategoryId int,
 @teamid int)
 as
 begin
create table #temp(ClientName varchar(max),TeamName varchar(max), TeamId int, SubcategoryName varchar(max), SubCategoryId int, categoryName varchar(max),ClientExpectedScore int)

declare @clientName varchar(max)
declare @teamName varchar(max)
select @clientName= cmaster.ClientName, @teamName= team.TeamName from ClientMaster cmaster join TeamMaster team on cmaster.Id = team.ClientId where team.Id=@teamid

insert into #temp(ClientName,TeamName,TeamId,SubcategoryName,SubCategoryId,categoryName,ClientExpectedScore)
SELECT @clientName,@teamName,@teamid, subcatMaster.SubCategoryName,subcatMaster.Id, catMaster.CategoryName, 
isnull((select ClientExpectedScore from SubCategoryMapping where SubCategoryId=subcatMaster.Id and TeamId=@teamid ),0) as ClientExpectedScore 
FROM SubCategoryMaster subcatMaster 
inner join CategoryMaster catMaster on catMaster.Id= subcatMaster.CategoryId
where 
(@CategoryId = 0 OR catMaster.Id = @CategoryId)
and SubCategoryName <> CategoryName

 
select * from #temp where ClientExpectedScore > 0
drop table #temp

end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getClientSubCategoryExpectedScore_Dashboard]  (
 @teamid int)
 as
 begin
create table #temp(ClientName varchar(max),TeamName varchar(max), TeamId int, SubcategoryName varchar(max), SubCategoryId int, categoryName varchar(max),ClientExpectedScore int)

declare @clientName varchar(max)
declare @teamName varchar(max)
select @clientName= cmaster.ClientName, @teamName= team.TeamName from ClientMaster cmaster join TeamMaster team on cmaster.Id = team.ClientId where team.Id=@teamid

insert into #temp(ClientName,TeamName,TeamId,SubcategoryName,SubCategoryId,categoryName,ClientExpectedScore)
SELECT @clientName,@teamName,@teamid, subcatMaster.SubCategoryName,subcatMaster.Id, catMaster.CategoryName, isnull((select ClientExpectedScore from SubCategoryMapping where SubCategoryId=subcatMaster.Id and TeamId=@teamid ),0) as ClientExpectedScore 
FROM SubCategoryMaster subcatMaster 
inner join CategoryMaster catMaster on catMaster.Id= subcatMaster.CategoryId
where  SubCategoryName <> CategoryName

 
select * from #temp where ClientExpectedScore >0
drop table #temp

end

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
	CREATE procedure [dbo].[usp_getemployee_clientexpectedscore]  (@ClientName varchar(max), @TeamName varchar(max),@teamid int)
	as
	begin
		select * into #subcat from (
		select subcatm.TeamId, scm.CategoryId, sum(isnull(subcatm.ClientExpectedScore,0))  as clientScore
	from SubCategoryMapping subcatm 
	join SubCategoryMaster scm on subcatm.SubCategoryId = scm.Id 
	where TeamId=@teamid
	group by scm.CategoryId, subcatm.TeamId
	) as t
	
	
	--SELECT sm.EmployeeId, cat.Id as categoryId, sum(sm.EmployeeScore) as EmployeeTotalScore, (select clientScore from #subcat where TeamId=122 and CategoryId=cat.Id) as ClientExpectedScore
	--FROM dbo.SkillsMatrix sm 
 --        INNER JOIN dbo.SubCategoryMaster scm ON 
 --        sm.SubCategoryId=scm.Id
	--	 inner join CategoryMaster cat on cat.Id= scm.CategoryId
		
 --            WHERE sm.EmployeeId in (SELECT EmployeeId FROM dbo.EmployeeDetails  where TeamId=122
	--		 )  
 --         group by sm.EmployeeId, cat.Id
	--	  order by EmployeeId asc

    select * into #totalEmpScore from ( SELECT @ClientName as ClientName,@TeamName as TeamName, @teamid as TeamId, sm.EmployeeId, cat.Id as categoryId, sum(sm.EmployeeScore) as EmployeeTotalScore, (select isnull(clientScore,0) from #subcat where TeamId=@teamid and CategoryId=cat.Id) as ClientExpectedScore
	 FROM dbo.SkillsMatrix sm 
         INNER JOIN dbo.SubCategoryMaster scm ON 
         sm.SubCategoryId=scm.Id
		 inner join CategoryMaster cat on cat.Id= scm.CategoryId
		
             WHERE Month(sm.MatrixDate) = month(GETDATE()) and year(sm.MatrixDate) = year(getdate()) and sm.EmployeeId in (SELECT EmployeeId FROM dbo.EmployeeDetails  where TeamId=@teamid
			 )  
          group by sm.EmployeeId, cat.Id
		 
		  ) t
     
	 select ClientName,TeamName,TeamId,EmployeeId,categoryId,isnull(EmployeeTotalScore,0) EmployeeTotalScore,isnull(ClientExpectedScore,0) ClientExpectedScore from #totalEmpScore  order by EmployeeId
	-- select *  from #totalEmpScore where EmployeeTotalScore < ClientExpectedScore  order by EmployeeId 
	-- select count(*) * 100/count(EmployeeId)  from #totalEmpScore where EmployeeTotalScore < ClientExpectedScore  
	---- group by EmployeeId order by EmployeeId



	 drop table #subcat
	 drop table #totalEmpScore

	 end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
CREATE PROCEDURE [dbo].[usp_GetEmployeeSkillNotAvailable] 
@clientId int
As
begin
	create table #temp (ClientName varchar(300),EmployeeName varchar(200), TeamName varchar(200), employeeScorePercentage numeric (36,2))
	insert into #temp 
	exec usp_dashboardshortcut @clientId, 0,1000

	select emp.EmployeeName, team.TeamName from EmployeeDetails emp join TeamMaster team on emp.TeamId= team.Id
	where EmployeeName
	not in  ( select EmployeeName from #temp ) and (@clientId =0 or team.ClientId=@clientId)
	drop table #temp

end

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_getorgDetails]
as
begin

DECLARE @cols AS NVARCHAR(MAX), @query AS NVARCHAR(MAX);

SELECT @cols = STUFF((SELECT ',' + QUOTENAME(ColumnName) 
                       FROM OrgColumns
                       GROUP BY ColumnName,OrgColumnId order by OrgColumnId
                       FOR XML PATH(''), TYPE 
                     ).value('.', 'NVARCHAR(MAX)') 
                ,1,1,'')	

SET @query = 'SELECT  ' + @cols + '
              FROM 
                  (SELECT RowId, ColumnValue, ColumnName
                  FROM OrgColumns column1 join OrgMasterRecord master1 on column1.OrgColumnId = master1.ColumnId) AS SourceTable
              PIVOT
              (
                  MAX(ColumnValue)
                  FOR ColumnName IN (' + @cols + ')
              ) AS PivotTable;'

			  print @query
EXEC sp_executesql @query;
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_gettrendlinedataemployee 0,0,0
CREATE procedure [dbo].[usp_gettrendlinedataemployee]
(
@clientId int,
@teamId int,
@employeeId int
)
as 

begin
-- exec usp_gettrendlinedataemployee 19,122,4
with tmp as(select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,

cast(FORMAT((cast(ES as decimal(5, 2))/ClientExpectedScore *100),'N2') as float) as EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id 
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId =0 or cl.Id=@clientId) and (@teamId =0 or tm.Id=@teamId) and (@employeeId =0 or emp.EmployeeId=@employeeId)
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
cast(FORMAT((cast(ES as decimal(5, 2))/ClientExpectedScore *100),'N2') as float) as EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [Automation].[dbo].[SkillsMatrix_Archive] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id 
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId =0 or cl.Id=@clientId) and (@teamId =0 or tm.Id=@teamId) and (@employeeId =0 or emp.EmployeeId=@employeeId)
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MatrixDate >= DATEADD(MONTH,-6,GETDATE())) as t
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
--select
--ClientName,
--TeamName,
--EmployeeId,
--EmployeeName,
--CategoryName,
--ES [Employee Score],
--CES [Client Expected Score],
--EmployeeScorePercentage,
----[EmployeeScore1],
----MatrixDate,
--            case when Levels=1 then 'Trainer'
--             when Levels=2 then 'Expert'
--             when Levels=3 then 'Independent'
--             when Levels=4 then 'Beginner'
--             when Levels=5 then 'No Knowledge'
--            end as 'Current Status'
--            from tmp order by TeamName

select * into #temp from (select
ClientName,
TeamName,
CategoryName,
EmployeeName,
EmployeeId,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeid) employeeCount,
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage,
Format(MatrixDate,'MMM yyyy') as date

--CES [Client Expected Score],
--EmployeeScorePercentage,
--[EmployeeScore1],
--MatrixDate,
            --case when Levels=1 then 'Trainer'
            -- when Levels=2 then 'Expert'
            -- when Levels=3 then 'Independent'
            -- when Levels=4 then 'Beginner'
            -- when Levels=5 then 'No Knowledge'
            --end as 'Current Status'
            from tmp   group by ClientName,TeamName,CategoryName,Format(MatrixDate,'MMM yyyy'),EmployeeName,EmployeeId) as t order by ClientName,TeamName,cast(date as datetime) asc


if @clientId =0 
begin
	select ClientName, Sum(AvgScorepercentage)/count(*) AvgScorepercentage, date from #temp
	group by ClientName,date order by ClientName,cast(date as datetime) asc
end

if (@clientId <>0 and @teamId=0) 
begin
	select ClientName, TeamName, Sum(AvgScorepercentage)/count(*) AvgScorepercentage, date from #temp
	
	group by ClientName,date,TeamName order by ClientName,TeamName, cast(date as datetime) asc
end

if (@teamId <> 0 and @employeeId=0) or  @employeeId <> 0 
begin
	select ClientName, TeamName, EmployeeName, Sum(AvgScorepercentage)/count(*) AvgScorepercentage, date from #temp
	group by ClientName,date,TeamName,EmployeeName order by ClientName,TeamName,EmployeeName, cast(date as datetime) asc
end

select * from #temp
drop table #temp
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_insertskillmatrix] (@tablename varchar(max), @teamFunction varchar(20))
as
begin


set nocount on
--select * from SkillmatrixCW3
--DECLARE @tableName NVARCHAR(255) = 'SkillmatrixCW3'
DECLARE @sql NVARCHAR(MAX)
 
-- Create a dynamic SQL statement to fetch values for each column
SET @sql =  'SELECT  COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = '''+@tablename+''''
	
 print @sql
-- Temporary table to store the result set
CREATE TABLE #TempTable (RowNum INT identity(1,1), ColumnName NVARCHAR(255), ColumnValue NVARCHAR(MAX))
create table #temptableCategory (RowNum INT identity(1,1), CategoryName NVARCHAR(255), TableRowId int)
create table #temptablesubCategory (RowNum INT identity(1,1), CategoryId int, SubCategoryName nvarchar(max),TableRowId int)

create table #company(RowNum INT identity(1,1), companyName varchar(max),TableRowId int,ColumnValue NVARCHAR(MAX))
create table #companyTeam(RowNum INT identity(1,1),CompanyId int, TeamName varchar(max),TableRowId int,ColumnValue NVARCHAR(MAX))
create table #companyTeamMember(RowNum INT identity(1,1),CompanyId int, TeamId int, MemberName varchar(max),TableRowId int,ColumnValue NVARCHAR(MAX))
create table #teamMemberScore(RowNum INT identity(1,1),CompanyId int, TeamId int,memberId int, subcategoryId int, score int,TableRowId int,ColumnValue NVARCHAR(MAX))

-- Insert data into the temporary table
INSERT INTO #TempTable (ColumnName)
EXEC sp_executesql @sql
 
DECLARE @rowCount INT = 1

DECLARE @recordCount INT
declare @sqlCommand nvarchar(max)
set @sqlCommand = N'SELECT @Output = count(*) FROM ' + @tablename
EXEC sp_executesql @sqlCommand , N'@Output INT OUTPUT',@Output = @recordCount OUTPUT




-- Iterate through rows
WHILE @rowCount <= @recordCount
BEGIN
    DECLARE @columnName NVARCHAR(255)
    DECLARE columnCursor CURSOR FOR
        SELECT ColumnName
        FROM #TempTable
        --WHERE RowNum = @rowCount
 
    OPEN columnCursor
    FETCH NEXT FROM columnCursor INTO @columnName 


    WHILE @@FETCH_STATUS = 0
    BEGIN
        create table #tablevalues(columnname nvarchar(max), TableRowId int)
		DECLARE @sqll NVARCHAR(MAX)
		declare @tablevalue nvarchar(max)
		declare @TablerowId nvarchar(max)
        -- Get the column value for the current row and column
     set @sqll=  'SELECT ' + @columnName + '
        ,F1 FROM ' + @tablename + '
        WHERE F1 = ' + cast(@rowCount as varchar)
		

        -- Process the column value
        --print @columnName + ': ' + @columnValue
		insert into #tablevalues (columnname,TableRowId)
        EXEC sp_executesql @sqll

		--select * from #tablevalues

		select top 1 @tablevalue = columnname, @TablerowId = TableRowId from #tablevalues
		
		drop table #tablevalues
		
       
	   -- category
	    if (@columnName ='F2' and isnull(@tablevalue,'') <> '' )
	     begin		 
		 
	        insert into #temptableCategory(CategoryName, TableRowId) select @tablevalue,@TablerowId
	     end

		

		-- sub category
		if (@columnName ='F3' and isnull(@tablevalue,'') <> '' and @rowCount >= 5 )
	     begin		 
		 
	        insert into #temptablesubCategory(CategoryId, SubCategoryName,TableRowId) select (SELECT max(RowNum)  FROM #temptableCategory where TableRowId <= @TablerowId ),   @tablevalue,@TablerowId
	     end

		-- company details

		IF ( cast(STUFF(@columnName, 1,1,'') as int) >3 )
		BEGIN
		  IF (@rowCount = 1)
		   BEGIN

		       IF (isnull(@tablevalue,'') <> '')
			   BEGIN
					insert into #company 
					select @tablevalue,@TablerowId,@columnName
				END
				--else
				--begin
				--insert into #company 
				--select (select top 1 companyName from #company order by RowNum desc), @TablerowId,@columnName
				--end
		   END

		   -- company team details
		    IF (@rowCount = 2)
		   BEGIN

		       IF (ISNULL(@tablevalue,'') <> '')
			   BEGIN
					INSERT INTO #companyTeam(CompanyId, TeamName ,TableRowId ,ColumnValue) 
					SELECT  (SELECT TOP 1 RowNum from #company where cast(STUFF(ColumnValue, 1,1,'') as int) <= cast(STUFF(@columnName, 1,1,'') as int) ), @tablevalue,@TablerowId,@columnName
				END	
				ELSE
				BEGIN
				declare @compName varchar(max)
				select @compName= Teamname from #companyTeam where RowNum = ( select max(RowNum) from #companyTeam where TeamName is not null)
					INSERT INTO #companyTeam(CompanyId, TeamName ,TableRowId ,ColumnValue) 
					SELECT  (SELECT MAX( RowNum) from #company where  CAST(STUFF(ColumnValue, 1,1,'') as int) <= CAST(STUFF(@columnName, 1,1,'') as int)), @compName,@TablerowId,@columnName
				END
		   END

		   IF (@rowCount =3)
		   BEGIN
		      IF (ISNULL(@tablevalue,'') <> '')
			   BEGIN
			       declare @teamId int
				   declare @companyId int
				   set @companyId= (SELECT max(RowNum) from #company where cast(STUFF(ColumnValue, 1,1,'') as int) <= cast(STUFF(@columnName, 1,1,'') as int) )
				   set @teamId= (select RowNum from #companyTeam where CompanyId=@companyId and ColumnValue= @columnName)
				   INSERT INTO #companyTeamMember(CompanyId, TeamId,MemberName ,TableRowId ,ColumnValue) 
				   SELECT @companyId,@teamId , @tablevalue,@TablerowId,@columnName
				END	 
		   END

		   IF (@rowCount >3)
		   BEGIN
		      IF (ISNULL(@tablevalue,'') <> '' and TRY_CONVERT(int,@tablevalue) is not null)
			   BEGIN
			       declare @teamId1 int
				   declare @companyId1 int
				   set @companyId1= (SELECT max(RowNum) from #company where cast(STUFF(ColumnValue, 1,1,'') as int) <= cast(STUFF(@columnName, 1,1,'') as int) )
				   set @teamId1= (select top 1 RowNum from #companyTeam where ColumnValue= @columnName)
				   declare @memberId int
				   set @memberId= (select top 1 RowNum from #companyTeamMember where ColumnValue= @columnName)
				   declare @subcategoryId int
				   set @subcategoryId = (select top 1 RowNum from #temptablesubCategory where TableRowId=@TablerowId)
				   INSERT INTO #teamMemberScore(CompanyId, TeamId,memberId,subcategoryId,score ,TableRowId ,ColumnValue) 
				   SELECT @companyId1,@teamId1 ,@memberId, @subcategoryId, @tablevalue,@TablerowId,@columnName
				END	 
		   END

			
		END






        FETCH NEXT FROM columnCursor INTO @columnName
    END
 
    CLOSE columnCursor
    DEALLOCATE columnCursor
     
    SET @rowCount = @rowCount + 1
END

select * into #finaloutput from (select team.TeamName, member.MemberName, category.CategoryName, subcategory.SubCategoryName, score.score from 
	#teamMemberScore score 
	join #temptablesubCategory subcategory 
	on score.subcategoryId= subcategory.RowNum 
	join #companyTeamMember member on member.RowNum= score.memberId
	join #companyTeam team on team.RowNum = score.TeamId
	join #temptableCategory category on category.RowNum= subcategory.CategoryId
where memberId is not null and category.CategoryName <> subcategory.SubCategoryName --and member.MemberName not in ('Client- Expected') and category.CategoryName <> subcategory.SubCategoryName
--order by member.MemberName
) a 

create table #finaloutputwithClient(TeamName varchar(max),MemberName varchar(max),CategoryName varchar(max), SubCategoryName varchar(max), ClientExpectedScore int, Score int)
insert into #finaloutputwithClient 
select TeamName,MemberName,CategoryName,SubCategoryName, 
		(select top 1  score from #finaloutput where SubCategoryName = a.SubCategoryName and TeamName = a.TeamName and CategoryName = a.CategoryName and MemberName= 'Client- Expected' ),
		a.score from  #finaloutput a

--select * from #finaloutputwithClient order by MemberName, CategoryName


-- Adding logic for insertion
--1 Category insertion  CategoryMaster and #temptableCategory
insert into CategoryMaster(CategoryFunction,CategoryName,CategoryDescription,CreatedOn,ModifiedOn)
select CategoryName,CategoryName,CategoryName,GETDATE(),GETDATE() from #temptableCategory where CategoryName <> 'Category' and CategoryName not in (select CategoryName from CategoryMaster)

--2. sub category

insert into SubCategoryMaster(CategoryId,SubCategoryName,SubCategoryDescription,CreatedOn,ModifiedOn)
SELECT catmaster.Id,subCategory.SubCategoryName,subCategory.SubCategoryName,GETDATE() ,GETDATE() 
	from
		#temptablesubCategory subCategory 
		join #temptableCategory category on subCategory.CategoryId= category.RowNum
		join CategoryMaster catmaster on catmaster.CategoryName=category.CategoryName
	where subCategory.SubCategoryName not in (select SubCategoryName from SubCategoryMaster)

-- 3. select * from [dbo].[ClientMaster] -- #company

 INSERT INTO ClientMaster (ClientName,ClientDescription,CreatedOn,ModifiedOn)
 SELECT companyName,companyName,GETDATE(),GETDATE() from #company where companyName not in (select ClientName from ClientMaster)

 --4. team master


  INSERT INTO TeamMaster (ClientId, TeamName, TeamDescription, CreatedOn, ModifiedOn)
  SELECT distinct master.Id,teammeber.TeamName,teammeber.TeamName, GETDATE(), GETDATE() 
  FROM #companyTeam teammeber 
  join #company comp on teammeber.CompanyId= comp.RowNum
  JOIN ClientMaster master ON master.ClientName = comp.companyName WHERE teammeber.TeamName NOT IN (SELECT TeamName from TeamMaster)

  

  -- 4. [dbo].[SubCategoryMapping]
  SELECT * FROM SubCategoryMapping 
  INSERT INTO SubCategoryMapping(TeamId,SubCategoryId,ClientExpectedScore,CreatedOn, ModifiedOn)
  SELECT distinct teamm.Id,subcategm.Id,client.ClientExpectedScore, GETDATE() , GETDATE()
  FROM #finaloutputwithClient client join TeamMaster teamm on client.TeamName= teamm.TeamName
  join SubCategoryMaster subcategm on subcategm.SubCategoryName=client.SubCategoryName
  where client.MemberName='Client- Expected'

-- 5. Employee details
DECLARE @ID INT;
SELECT @ID=ISNULL(MAX(EmployeeId),0) FROM dbo.EmployeeDetails

INSERT INTO EmployeeDetails (EmployeeId, EmployeeName, TeamId,Type)
SELECT distinct ROW_NUMBER() OVER(ORDER BY(SELECT 1))+ @ID, teammember.MemberName, teamm.Id,@teamFunction
from #companyTeamMember teammember JOIN #companyTeam compteam on teammember.TeamId= compteam.RowNum and compteam.CompanyId= teammember.CompanyId
join TeamMaster teamm on teamm.TeamName= compteam.TeamName
where teammember.MemberName NOT IN ('Client- Expected','Company- Expected')
and teammember.MemberName NOT IN (select EmployeeName from EmployeeDetails)

select * from #finaloutputwithClient

--6. [dbo].[SkillsMatrix]
INSERT INTO SkillsMatrix (EmployeeId, SubCategoryId,EmployeeScore,CreatedOn,ModifiedOn,MatrixDate)
SELECT distinct emp.EmployeeId,subcateg.Id,final.Score, GETDATE(),GETDATE(),GETDATE() 
FROM #finaloutputwithClient final join  EmployeeDetails emp on final.MemberName= emp.EmployeeName
JOIN SubCategoryMaster subcateg on subcateg.SubCategoryName = final.SubCategoryName 
where
NOT EXISTS 
(select 1 from SkillsMatrix where EmployeeId=emp.EmployeeId and SubCategoryId=subcateg.Id)














-- Drop the temporary table
DROP TABLE #TempTable

drop table #finaloutputwithClient
drop table #finaloutput

drop table #temptableCategory

drop table #temptablesubCategory
drop table #company
drop table #companyTeam
drop table #companyTeamMember
drop table #teamMemberScore 


end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetEmployeeSkillNotAvailable]    Script Date: 4/2/2024 12:14:20 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_GetEmployeeSkillNotAvailable]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboardshortcut]    Script Date: 4/2/2024 12:14:20 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboardshortcut]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData_teamwise]    Script Date: 4/2/2024 12:14:20 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboard_lineData_teamwise]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData]    Script Date: 4/2/2024 12:14:20 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboard_lineData]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_data]    Script Date: 4/2/2024 12:14:20 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboard_data]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_data]    Script Date: 4/2/2024 12:14:20 PM ******/
GO
 
 CREATE procedure [dbo].[usp_dashboard_data]
 as begin

create table #tempAverageScore(ClientName varchar(max), AverageScore numeric(36,2))
declare @clientid int
declare  @clientName varchar(max)
DECLARE db_cursor CURSOR FOR  
SELECT Id,ClientName FROM ClientMaster  --where ClientName='Mercell'
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @clientid  ,@clientName
WHILE @@FETCH_STATUS = 0   
BEGIN 
create table #tempClientScore(ClientName varchar(max),TeamName varchar(max), TeamId int, employeeId int, categoryId int,EmployeeTotalScore int,ClientExpectedScore int)

	   declare @teamId int,@teamName varchar(max)
	   DECLARE db_Teamcursor CURSOR FOR  
       SELECT Id,TeamName FROM TeamMaster where ClientId=@clientid
	   OPEN db_Teamcursor   
       FETCH NEXT FROM db_Teamcursor INTO @teamId,@teamName 
	   WHILE @@FETCH_STATUS = 0   
	   BEGIN
		   
		   
		 insert into #tempClientScore
		 exec usp_getemployee_clientexpectedscore @clientName,@teamName,@teamId

	       FETCH NEXT FROM db_Teamcursor INTO @teamId,@teamName
	   END
	   CLOSE db_Teamcursor   
	   DEALLOCATE db_Teamcursor
	   -- total expected score in technology of client
	  




	  
	  insert into #tempAverageScore
	  select @clientName as clientName,  sum(cast (percentage as numeric (36,2)))/ count(*) as AverageScore from (
	  SELECT teamid,count(distinct employeeid) employees, sum(EmployeeTotalScore) empScore,sum(ClientExpectedScore) clientExpectedScore, FORMAT((sum(EmployeeTotalScore) * 100.0/sum(ClientExpectedScore)),'N2') as percentage  FROM #tempClientScore  WHERE  EmployeeTotalScore < ClientExpectedScore 
	   group by teamid
	   ) t
		 
		-- select * from EmployeeDetails where TeamId =122 
	 
	  select * from #tempClientScore
	   drop table #tempClientScore
       FETCH NEXT FROM db_cursor INTO @clientid,@clientName  
END   

		CLOSE db_cursor   
		DEALLOCATE db_cursor
		
		 select * from #tempAverageScore
		 
		 --

  
  end
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData]    Script Date: 4/2/2024 12:14:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboard_lineData]    (@clientId int, @functionType varchar(5))
as begin
With tmp as(select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage1,
 cast(FORMAT((cast(ES as decimal(5, 2))/ClientExpectedScore *100),'N2') as float) as EmployeeScorePercentage,

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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId = 0 or cl.Id=@clientId) 
			AND (@functionType ='All' or emp.Type=@functionType)
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
			
--select
--ClientName,
--TeamName,
--EmployeeId,
--EmployeeName,
--CategoryName,
--ES [Employee Score],
--CES [Client Expected Score],
--EmployeeScorePercentage,
----[EmployeeScore1],
----MatrixDate,
--            case when Levels=1 then 'Trainer'
--             when Levels=2 then 'Expert'
--             when Levels=3 then 'Independent'
--             when Levels=4 then 'Beginner'
--             when Levels=5 then 'No Knowledge'
--            end as 'Current Status'
--            from tmp order by TeamName

select
ClientName,
TeamName,
CategoryName,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeid) employeeCount,
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage

--CES [Client Expected Score],
--EmployeeScorePercentage,
--[EmployeeScore1],
--MatrixDate,
            --case when Levels=1 then 'Trainer'
            -- when Levels=2 then 'Expert'
            -- when Levels=3 then 'Independent'
            -- when Levels=4 then 'Beginner'
            -- when Levels=5 then 'No Knowledge'
            --end as 'Current Status'
            from tmp  group by ClientName,TeamName,CategoryName  order by ClientName,TeamName		
end
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData_teamwise]    Script Date: 4/2/2024 12:14:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboard_lineData_teamwise]   (@clientId int, @teamName varchar(max),@functionType varchar(20))
as begin
-- exec [usp_dashboard_lineData_teamwise] 19, 'DataCollection'

With tmp as(select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage1,
 cast(FORMAT((cast(ES as decimal(5, 2))/ClientExpectedScore *100),'N2') as float) as EmployeeScorePercentage,

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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId=0 or cl.Id=@clientId) 
			and (@functionType ='All' or emp.Type=@functionType)
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage
from tmp where ((@clientId=0 and ClientName=@teamName) or TeamName=@teamName)  group by EmployeeName,TeamName,CategoryName  order by EmployeeName
end
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboardshortcut]    Script Date: 4/2/2024 12:14:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboardshortcut] @clientId int,  @signValueStart varchar(3), @signValueEnd varchar(4),@functionType varchar(20) ='All'
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
 cast(FORMAT((cast(ES as decimal(5, 2))/ClientExpectedScore *100),'N2') as float) as EmployeeScorePercentage,

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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id
			where (@clientId = 0 or cl.Id=@clientId ) and (@functionType ='All' or emp.Type=@functionType)
			
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
						Round(Sum(EmployeeScorePercentage)/Count(CategoryName),2) as EmployeeScorePercentage
						FROM #temp group by ClientName, EmployeeName,TeamName Having Round(Sum(EmployeeScorePercentage)/Count(CategoryName),2) between ' + @signValueStart  + '  and ' + @signValueEnd + '
						 order by EmployeeScorePercentage desc ';
		print @sql
		exec sp_executesql @sql
		drop table #temp
end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetEmployeeSkillNotAvailable]    Script Date: 4/2/2024 12:14:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetEmployeeSkillNotAvailable] 
@clientId int,
@functionType varchar(20)
As
begin
	create table #temp (ClientName varchar(300),EmployeeName varchar(200), TeamName varchar(200), employeeScorePercentage numeric (36,2))
	insert into #temp 
	exec usp_dashboardshortcut @clientId, 0,1000

	select emp.EmployeeName, team.TeamName from EmployeeDetails emp join TeamMaster team on emp.TeamId= team.Id
	where EmployeeName
	not in  ( select EmployeeName from #temp ) and (@clientId =0 or team.ClientId=@clientId)
	AND (@functionType ='All' or emp.Type=@functionType)
	drop table #temp

end
GO
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_getClientMasterByEmployeeId]
/****** Object:  StoredProcedure [dbo].[usp_getClientMasterByEmployeeId]    Script Date: 4/4/2024 4:01:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
ELSE IF (@Role = 'Reporting_Manager' OR @Role = 'Approver')
BEGIN
			set @sql='SELECT * FROM ClientMaster where Id  = '+ cast( @ClientId as varchar)

 
 
END
ELSE IF (@Role = 'EMPLOYEE')
	BEGIN
		    set @sql='SELECT client.* FROM ClientMaster client
						INNER join TeamMaster team on client.Id= team.ClientId 
						WHERE  team.Id is not null and client.Id  = '+ cast( @ClientId as varchar)

 
END
 
EXECUTE 	sp_executesql @sql
END
END

go
DROP PROCEDURE IF EXISTS [dbo].[usp_gettrendlinedataemployee]
GO
CREATE procedure [dbo].[usp_gettrendlinedataemployee]
(
@clientId int,
@teamId int,
@employeeId int,
@functionType varchar(50)
)
as 

begin
-- exec usp_gettrendlinedataemployee 19,122,4
with tmp as(select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,

Round(cast((cast(ES as decimal(5, 2))/ClientExpectedScore *100) as float),2) as EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  and (@functionType ='All' or emp.Type=@functionType)
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id   
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId =0 or cl.Id=@clientId) and (@teamId =0 or tm.Id=@teamId) and (@employeeId =0 or emp.EmployeeId=@employeeId)
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
Round(cast((cast(ES as decimal(5, 2))/ClientExpectedScore *100) as float),2) as EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [Automation].[dbo].[SkillsMatrix_Archive] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId  and (@functionType ='All' or emp.Type=@functionType)
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id 
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId =0 or cl.Id=@clientId) and (@teamId =0 or tm.Id=@teamId) and (@employeeId =0 or emp.EmployeeId=@employeeId)
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MatrixDate >= DATEADD(MONTH,-6,GETDATE())) as t
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
--select
--ClientName,
--TeamName,
--EmployeeId,
--EmployeeName,
--CategoryName,
--ES [Employee Score],
--CES [Client Expected Score],
--EmployeeScorePercentage,
----[EmployeeScore1],
----MatrixDate,
--            case when Levels=1 then 'Trainer'
--             when Levels=2 then 'Expert'
--             when Levels=3 then 'Independent'
--             when Levels=4 then 'Beginner'
--             when Levels=5 then 'No Knowledge'
--            end as 'Current Status'
--            from tmp order by TeamName

select * into #temp from (select
ClientName,
TeamName,
CategoryName,
EmployeeName,
EmployeeId,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeid) employeeCount,
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage,
Format(MatrixDate,'MMM yyyy') as date

--CES [Client Expected Score],
--EmployeeScorePercentage,
--[EmployeeScore1],
--MatrixDate,
            --case when Levels=1 then 'Trainer'
            -- when Levels=2 then 'Expert'
            -- when Levels=3 then 'Independent'
            -- when Levels=4 then 'Beginner'
            -- when Levels=5 then 'No Knowledge'
            --end as 'Current Status'
            from tmp   group by ClientName,TeamName,CategoryName,Format(MatrixDate,'MMM yyyy'),EmployeeName,EmployeeId) as t order by ClientName,TeamName,cast(date as datetime) asc


if @clientId =0 
begin
	select ClientName, Sum(AvgScorepercentage)/count(*) AvgScorepercentage, date from #temp
	group by ClientName,date order by ClientName,cast(date as datetime) asc
end

if ((@clientId <>0 and @teamId=0) or (@clientId <>0 and @teamId<>0 and @employeeId=0)) 
begin
	select ClientName, TeamName, Sum(AvgScorepercentage)/count(*) AvgScorepercentage, date from #temp
	
	group by ClientName,date,TeamName order by ClientName,TeamName, cast(date as datetime) asc
end

if (@teamId <> 0 and @employeeId<> 0) 
begin
	select ClientName, TeamName, EmployeeName, Sum(AvgScorepercentage)/count(*) AvgScorepercentage, date from #temp
	group by ClientName,date,TeamName,EmployeeName order by ClientName,TeamName,EmployeeName, cast(date as datetime) asc
end

select * from #temp
drop table #temp
end
GO

GO
ALTER TABLE EmployeeDetails add BhavnaEmployeeId int
GO
/****** Object:  StoredProcedure [dbo].[usp_AddModifyEmployeeData]    Script Date: 4/5/2024 4:12:54 PM ******/
SET ANSI_NULLS ON
GO
DROP PROCEDURE IF EXISTS [dbo].[usp_AddModifyEmployeeData]
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_AddModifyEmployeeData]
(
@EmployeeId int,
@FullName varchar(200),
@teamId int,
@emailId varchar(200)
)
AS
BEGIN
	DECLARE @ClientId int
	IF NOT EXISTS (select 1 from EmployeeMaster where EmployeeId=@EmployeeId)
	BEGIN
		
		SET @ClientId=(select ClientId from TeamMaster where Id=@teamId)
		INSERT INTO EmployeeMaster(EmployeeId,FullName,ProjectId,TeamId,EmailId) VALUES (@EmployeeId,@FullName,@ClientId,@teamId,@emailId)
	END
	ELSE
	BEGIN
		
		SET @ClientId=(select ClientId from TeamMaster where Id=@teamId)
		UPDATE EmployeeMaster SET FullName =@FullName ,ProjectId=@ClientId,TeamId=@teamId, EmailId=@emailId WHERE EmployeeId=@EmployeeId
	END
END
IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'EmployeeType')
BEGIN
CREATE TABLE dbo.EmployeeType (
    Id int identity(1,1),
    Function_Type varchar(30)
);

SET IDENTITY_INSERT [dbo].[EmployeeType] ON 

INSERT [dbo].[EmployeeType] ([Id], [Function_Type]) VALUES (1, N'Dev')

INSERT [dbo].[EmployeeType] ([Id], [Function_Type]) VALUES (2, N'QA')
INSERT [dbo].[EmployeeType] ([Id], [Function_Type]) VALUES (3, N'Fin')

INSERT [dbo].[EmployeeType] ([Id], [Function_Type]) VALUES (4, N'HR')
INSERT [dbo].[EmployeeType] ([Id], [Function_Type]) VALUES (5, N'IT')

INSERT [dbo].[EmployeeType] ([Id], [Function_Type]) VALUES (6, N'MGMT')
INSERT [dbo].[EmployeeType] ([Id], [Function_Type]) VALUES (7, N'Marketing')

INSERT [dbo].[EmployeeType] ([Id], [Function_Type]) VALUES (8, N'TA')
INSERT [dbo].[EmployeeType] ([Id], [Function_Type]) VALUES (9, N'Common')


SET IDENTITY_INSERT [dbo].[EmployeeType] OFF


END


GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[dbo].[EmployeeDetails]') 
         AND name = 'Type'
)
ALTER TABLE [dbo].[EmployeeDetails]
ADD 
	Type Int

GO
ALTER TABLE EmployeeDetails ALTER  column Type Int
GO
UPDATE EmployeeDetails SET Type= empType.Id
FROM EmployeeDetails emp join EmployeeType empType on emp.Type = empType.Function_Type

GO
/****** Object:  StoredProcedure [dbo].[usp_gettrendlinedataemployee]    Script Date: 4/9/2024 2:38:04 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_gettrendlinedataemployee]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboardshortcut]    Script Date: 4/9/2024 2:38:04 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboardshortcut]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData_teamwise]    Script Date: 4/9/2024 2:38:04 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboard_lineData_teamwise]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData]    Script Date: 4/9/2024 2:38:04 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboard_lineData]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_data]    Script Date: 4/9/2024 2:38:04 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_dashboard_data]
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_data]    Script Date: 4/9/2024 2:38:04 PM ******/
 
 CREATE procedure [dbo].[usp_dashboard_data]
 as begin

create table #tempAverageScore(ClientName varchar(max), AverageScore numeric(36,2))
declare @clientid int
declare  @clientName varchar(max)
DECLARE db_cursor CURSOR FOR  
SELECT Id,ClientName FROM ClientMaster  --where ClientName='Mercell'
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @clientid  ,@clientName
WHILE @@FETCH_STATUS = 0   
BEGIN 
create table #tempClientScore(ClientName varchar(max),TeamName varchar(max), TeamId int, employeeId int, categoryId int,EmployeeTotalScore int,ClientExpectedScore int)

	   declare @teamId int,@teamName varchar(max)
	   DECLARE db_Teamcursor CURSOR FOR  
       SELECT Id,TeamName FROM TeamMaster where ClientId=@clientid
	   OPEN db_Teamcursor   
       FETCH NEXT FROM db_Teamcursor INTO @teamId,@teamName 
	   WHILE @@FETCH_STATUS = 0   
	   BEGIN
		   
		   
		 insert into #tempClientScore
		 exec usp_getemployee_clientexpectedscore @clientName,@teamName,@teamId

	       FETCH NEXT FROM db_Teamcursor INTO @teamId,@teamName
	   END
	   CLOSE db_Teamcursor   
	   DEALLOCATE db_Teamcursor
	   -- total expected score in technology of client
	  




	  
	  insert into #tempAverageScore
	  select @clientName as clientName,  sum(cast (percentage as numeric (36,2)))/ count(*) as AverageScore from (
	  SELECT teamid,count(distinct employeeid) employees, sum(EmployeeTotalScore) empScore,sum(ClientExpectedScore) clientExpectedScore, FORMAT((sum(EmployeeTotalScore) * 100.0/sum(ClientExpectedScore)),'N2') as percentage  FROM #tempClientScore  WHERE  EmployeeTotalScore < ClientExpectedScore 
	   group by teamid
	   ) t
		 
		-- select * from EmployeeDetails where TeamId =122 
	 
	  select * from #tempClientScore
	   drop table #tempClientScore
       FETCH NEXT FROM db_cursor INTO @clientid,@clientName  
END   

		CLOSE db_cursor   
		DEALLOCATE db_cursor
		
		 select * from #tempAverageScore
		 
		 --

  
  end
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData]    Script Date: 4/9/2024 2:38:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboard_lineData]    (@clientId int, @functionType varchar(5))
as begin
With tmp as(select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage1,
 cast(FORMAT((cast(ES as decimal(5, 2))/ClientExpectedScore *100),'N2') as float) as EmployeeScorePercentage,

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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId
			INNER JOIN EmployeeType empType ON emp.Type= empType.Id
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId = 0 or cl.Id=@clientId) 
			AND (@functionType ='All' or empType.Function_Type=@functionType)
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
			
--select
--ClientName,
--TeamName,
--EmployeeId,
--EmployeeName,
--CategoryName,
--ES [Employee Score],
--CES [Client Expected Score],
--EmployeeScorePercentage,
----[EmployeeScore1],
----MatrixDate,
--            case when Levels=1 then 'Trainer'
--             when Levels=2 then 'Expert'
--             when Levels=3 then 'Independent'
--             when Levels=4 then 'Beginner'
--             when Levels=5 then 'No Knowledge'
--            end as 'Current Status'
--            from tmp order by TeamName

select
ClientName,
TeamName,
CategoryName,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeid) employeeCount,
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage

--CES [Client Expected Score],
--EmployeeScorePercentage,
--[EmployeeScore1],
--MatrixDate,
            --case when Levels=1 then 'Trainer'
            -- when Levels=2 then 'Expert'
            -- when Levels=3 then 'Independent'
            -- when Levels=4 then 'Beginner'
            -- when Levels=5 then 'No Knowledge'
            --end as 'Current Status'
            from tmp  group by ClientName,TeamName,CategoryName  order by ClientName,TeamName		
end
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboard_lineData_teamwise]    Script Date: 4/9/2024 2:38:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboard_lineData_teamwise]   (@clientId int, @teamName varchar(max),@functionType varchar(20))
as begin
-- exec [usp_dashboard_lineData_teamwise] 19, 'DataCollection'

With tmp as(select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,
[EmployeeScore] EmployeeScorePercentage1,
 cast(FORMAT((cast(ES as decimal(5, 2))/ClientExpectedScore *100),'N2') as float) as EmployeeScorePercentage,

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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId
			INNER JOIN EmployeeType empType ON emp.Type= empType.Id
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId=0 or cl.Id=@clientId) 
			and (@functionType ='All' or empType.Function_Type=@functionType)
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage
from tmp where ((@clientId=0 and ClientName=@teamName) or TeamName=@teamName)  group by EmployeeName,TeamName,CategoryName  order by EmployeeName
end
GO
/****** Object:  StoredProcedure [dbo].[usp_dashboardshortcut]    Script Date: 4/9/2024 2:38:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_dashboardshortcut] @clientId int,  @signValueStart varchar(3), @signValueEnd varchar(4),@functionType varchar(20) ='All'
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
 cast(FORMAT((cast(ES as decimal(5, 2))/ClientExpectedScore *100),'N2') as float) as EmployeeScorePercentage,

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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MONTH(MatrixDate) MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId
			INNER JOIN EmployeeType empType ON emp.Type= empType.Id
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id
			where (@clientId = 0 or cl.Id=@clientId ) and (@functionType ='All' or empType.Function_Type=@functionType)
			
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MONTH(MatrixDate) having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
						Round(Sum(EmployeeScorePercentage)/Count(CategoryName),2) as EmployeeScorePercentage
						FROM #temp group by ClientName, EmployeeName,TeamName Having Round(Sum(EmployeeScorePercentage)/Count(CategoryName),2) between ' + @signValueStart  + '  and ' + @signValueEnd + '
						 order by EmployeeScorePercentage desc ';
		print @sql
		exec sp_executesql @sql
		drop table #temp
end
GO
/****** Object:  StoredProcedure [dbo].[usp_gettrendlinedataemployee]    Script Date: 4/9/2024 2:38:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_gettrendlinedataemployee 0,0,0,'All'
CREATE procedure [dbo].[usp_gettrendlinedataemployee]
(
@clientId int,
@teamId int,
@employeeId int,
@functionType varchar(50)
)
as 

begin
-- exec usp_gettrendlinedataemployee 19,122,4
with tmp as(select
ClientName,
t.TeamName,
EmployeeId,
EmployeeName,
CategoryName,
ES,CES,

Round(cast((cast(ES as decimal(5, 2))/ClientExpectedScore *100) as float),2) as EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [SkillsMatrix] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId 
			INNER JOIN EmployeeType empType ON empType.Id = emp.Type   and (@functionType ='All' or empType.Function_Type=@functionType)
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id   
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId =0 or cl.Id=@clientId) and (@teamId =0 or tm.Id=@teamId) and (@employeeId =0 or emp.EmployeeId=@employeeId)
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MONTH(MatrixDate) = MONTH(GETDATE())) as t
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
Round(cast((cast(ES as decimal(5, 2))/ClientExpectedScore *100) as float),2) as EmployeeScorePercentage,
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
            ClientName,TeamName,emp.EmployeeId,EmployeeName,CategoryName,cat.Id CatId,
            SUM(EmployeeScore) ES,SUM(ClientExpectedScore) CES,
            cast(FORMAT((cast(SUM(EmployeeScore) as decimal(5, 2))/SUM(ClientExpectedScore)*100),'N2') as float) [EmployeeScore],
			(cast(SUM(EmployeeScore) as decimal(5, 2))/(count(*)*5))*100 [EmployeeScore1],MatrixDate
            FROM [Automation].[dbo].[SkillsMatrix_Archive] empSkill 
            INNER JOIN EmployeeDetails emp ON empSkill.EmployeeId=emp.EmployeeId
			INNER JOIN EmployeeType empType ON empType.Id = emp.Type   and (@functionType ='All' or empType.Function_Type=@functionType)
            INNER JOIN SubCategoryMaster sub ON empSkill.SubCategoryId=sub.Id
            INNER JOIN CategoryMaster cat ON cat.Id=sub.CategoryId
            INNER JOIN TeamMaster tm ON emp.TeamId=tm.Id 
            INNER JOIN SubCategoryMapping subM on subM.TeamId= tm.Id AND subM.SubCategoryId=empSkill.SubCategoryId
            INNER JOIN ClientMaster cl ON tm.ClientId=cl.Id where (@clientId =0 or cl.Id=@clientId) and (@teamId =0 or tm.Id=@teamId) and (@employeeId =0 or emp.EmployeeId=@employeeId)
			group by cat.Id,EmployeeName,CategoryName,ClientName,TeamName,emp.EmployeeId,MatrixDate having MatrixDate >= DATEADD(MONTH,-6,GETDATE())) as t
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
--select
--ClientName,
--TeamName,
--EmployeeId,
--EmployeeName,
--CategoryName,
--ES [Employee Score],
--CES [Client Expected Score],
--EmployeeScorePercentage,
----[EmployeeScore1],
----MatrixDate,
--            case when Levels=1 then 'Trainer'
--             when Levels=2 then 'Expert'
--             when Levels=3 then 'Independent'
--             when Levels=4 then 'Beginner'
--             when Levels=5 then 'No Knowledge'
--            end as 'Current Status'
--            from tmp order by TeamName

select * into #temp from (select
ClientName,
TeamName,
CategoryName,
EmployeeName,
EmployeeId,
sum(EmployeeScorePercentage) as employeeScore,
count(distinct employeeid) employeeCount,
cast(sum(EmployeeScorePercentage) / count(distinct employeeid) as numeric (36,2)) AvgScorepercentage,
Format(MatrixDate,'MMM yyyy') as date

--CES [Client Expected Score],
--EmployeeScorePercentage,
--[EmployeeScore1],
--MatrixDate,
            --case when Levels=1 then 'Trainer'
            -- when Levels=2 then 'Expert'
            -- when Levels=3 then 'Independent'
            -- when Levels=4 then 'Beginner'
            -- when Levels=5 then 'No Knowledge'
            --end as 'Current Status'
            from tmp   group by ClientName,TeamName,CategoryName,Format(MatrixDate,'MMM yyyy'),EmployeeName,EmployeeId) as t order by ClientName,TeamName,cast(date as datetime) asc


if @clientId =0 
begin
	select ClientName, Sum(AvgScorepercentage)/count(*) AvgScorepercentage, date from #temp
	group by ClientName,date order by ClientName,cast(date as datetime) asc
end

if ((@clientId <>0 and @teamId=0) or (@clientId <>0 and @teamId<>0 and @employeeId=0)) 
begin
	select ClientName, TeamName, Sum(AvgScorepercentage)/count(*) AvgScorepercentage, date from #temp
	
	group by ClientName,date,TeamName order by ClientName,TeamName, cast(date as datetime) asc
end

if (@teamId <> 0 and @employeeId<> 0) 
begin
	select ClientName, TeamName, EmployeeName, Sum(AvgScorepercentage)/count(*) AvgScorepercentage, date from #temp
	group by ClientName,date,TeamName,EmployeeName order by ClientName,TeamName,EmployeeName, cast(date as datetime) asc
end

select * from #temp
drop table #temp
end
GO


/****** Object:  StoredProcedure [dbo].[usp_getClientMasterByEmployeeId]    Script Date: 09-05-2024 16:50:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getCategoryMasterByClientScore]
@TeamId int,
@IsWithScore bit=0
AS
BEGIN
SET NOCOUNT ON;

DECLARE @sql Nvarchar(max);

IF (@IsWithScore =0)
	BEGIN
		SELECT * FROM CategoryMaster
	END
ELSE
	BEGIN
		select distinct catMaster.* from CategoryMaster catMaster 
		inner join SubCategoryMaster subcatMaster 
		on catMaster.id = subcatMaster.CategoryId
		inner join SubCategoryMapping subcatMap
		on subcatMaster.id = subcatMap.SubCategoryId
		where subcatMaster.id is not null 
		and subcatMap.ClientExpectedScore > 0
		and subcatMap.TeamId = @TeamId
	END


END
Go


DROP PROCEDURE IF EXISTS [dbo].[usp_AddModifyEmployeeData]
/****** Object:  StoredProcedure [dbo].[usp_AddModifyEmployeeData]    Script Date: 22-05-2024 11:44:31 ******/
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Suramit Pramanik>
-- Create date: <22-05-2024>
-- Description:	<Create for Add and Modify Employee Data>
-- =============================================
CREATE procedure [dbo].[usp_AddModifyEmployeeData]
(
@EmployeeId int,
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
GO


-- exec usp_getCategoryMasterByClientScore 1, 1
