
DROP PROCEDURE [dbo].[usp_getReportByCategoryAndClient]
GO
/****** Object:  StoredProcedure [dbo].[usp_getReportByCategoryAndClient]    Script Date: 02-04-2024 17:21:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Richa Sharma>
-- Create date: <20-03-2024>
-- Description:	<CreTed to get report of all sub categories with all clients>
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[usp_getReportByCategoryAndClient]
(
    @CategoryId int,
    @ClientId int
)
AS
BEGIN
    DECLARE @columns NVARCHAR(MAX),
            @sql NVARCHAR(MAX);
IF @ClientId = 0
    SELECT @columns = STRING_AGG(QUOTENAME(ClientName), ',') FROM ClientMaster;
ELSE
    SELECT @columns = QUOTENAME(ClientName) FROM ClientMaster WHERE Id = @ClientId;

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
GO

/****** Object:  StoredProcedure [dbo].[usp_getskillsegmentscorereport_withcategories]    Script Date: 15-04-2024 17:06:00 ******/
DROP PROCEDURE [dbo].[usp_getskillsegmentscorereport_withcategories]
GO

/****** Object:  StoredProcedure [dbo].[usp_getskillsegmentscorereport_withcategories]    Script Date: 15-04-2024 17:06:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Suramit Pramanik>
-- Create date: <15-04-2024>
-- Description:	<CreTed to get skill segment score report with categories>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getskillsegmentscorereport_withcategories]

@categoryId int = null,
    @clientId int = null,
    @teamId int = null
AS
BEGIN
    SELECT
        c.CategoryName,
        s.SubCategoryName,
        SUM(CASE WHEN sm.EmployeeScore = 4 THEN 1 ELSE 0 END) AS Expert,
        SUM(CASE WHEN sm.EmployeeScore = 3 THEN 1 ELSE 0 END) AS Good,
        SUM(CASE WHEN sm.EmployeeScore = 2 THEN 1 ELSE 0 END) AS Average,
        SUM(CASE WHEN sm.EmployeeScore = 1 THEN 1 ELSE 0 END) AS NeedTraining,
        COUNT(*) AS GrandTotal
    INTO #tempData
    FROM SkillsMatrix sm
    JOIN EmployeeDetails ed ON sm.EmployeeId = ed.EmployeeId
    JOIN TeamMaster tm ON tm.Id = ed.TeamId
    JOIN ClientMaster cm ON cm.Id = tm.ClientId
    JOIN SubCategoryMaster s ON sm.SubCategoryId = s.Id
    JOIN CategoryMaster c ON s.CategoryId = c.Id
    WHERE (@teamId IS NULL OR tm.Id = @teamId)
        AND (@clientId IS NULL OR cm.Id = @clientId)
        AND (@categoryId IS NULL OR c.Id = @categoryId)
    GROUP BY c.CategoryName, s.SubCategoryName;

    SELECT
        CategoryName,
        SubCategoryName,
        ISNULL(Expert, 0) AS Expert,
        ISNULL(Good, 0) AS Good,
        ISNULL(Average, 0) AS Average,
        ISNULL(NeedTraining, 0) AS NeedTraining,
        ISNULL(Expert, 0) + ISNULL(Good, 0) + ISNULL(Average, 0) + ISNULL(NeedTraining, 0) AS GrandTotal
    FROM #tempData order by CategoryName desc;

    DROP TABLE IF EXISTS #tempData;
END;
GO

/****** Object:  StoredProcedure [dbo].[usp_getEmployeeScoreReportByCategoryClient]    Script Date: 26-04-2024 19:17:00 ******/
DROP PROCEDURE [dbo].[usp_getEmployeeScoreReportByCategoryClient]
GO

/****** Object:  StoredProcedure [dbo].[usp_getEmployeeScoreReportByCategoryClient]    Script Date: 26-04-2024 19:17:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Chetna Upadhyay>
-- Create date: <26-04-2024>
-- Description:	<Created to get employee score percentage report with categories>
-- =============================================
CREATE OR ALTER PROCEDURE usp_getEmployeeScoreReportByCategoryClient (
    @CategoryId INT,
    @ClientId INT,
    @TeamId INT,
    @ReportType INT,
	@FunctionType INT
)
AS
BEGIN

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
		FunctionType VARCHAR(MAX),
    );
    INSERT INTO #temp (
        ClientName,
        TeamName,
        TeamId,
        SubcategoryName,
        SubCategoryId,
        CategoryName,
        ClientExpectedScore,
        EmployeeName,
        EmployeeScore,
        EmployeeScorePercentage,
        EmployeeScoreByCategory,
		FunctionType
    )
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
        CASE
            WHEN scm.ClientExpectedScore <> 0 THEN CAST(ROUND((ISNULL(CAST(matrix.EmployeeScore AS FLOAT), 0) / CAST(scm.ClientExpectedScore AS FLOAT)) * 100, 2) AS DECIMAL(10, 2))
            ELSE 0
        END AS EmployeeScorePercentage,
        CASE
            WHEN scm.ClientExpectedScore <> 0 THEN
                COALESCE(CAST(ROUND(AVG((CAST(matrix.EmployeeScore AS FLOAT) / CAST(scm.ClientExpectedScore AS FLOAT)) * 100 ) OVER (PARTITION BY emp.BhavnaEmployeeId, catMaster.Id), 2) AS DECIMAL(10, 2)),0)
            ELSE
                0
        END AS EmployeeScoreByCategory,
		empType.Function_Type AS FunctionType
    FROM
        TeamMaster team
    INNER JOIN
        ClientMaster cmaster ON cmaster.Id = team.ClientId
    INNER JOIN
        SubCategoryMaster subcatMaster ON 1 = 1 -- Dummy condition for all subcategories
    INNER JOIN
        CategoryMaster catMaster ON catMaster.Id = subcatMaster.CategoryId
    LEFT JOIN
        SubCategoryMapping scm ON scm.SubCategoryId = subcatMaster.Id AND scm.TeamId = team.Id
    LEFT JOIN
        SkillsMatrix matrix ON matrix.SubCategoryId = subcatMaster.Id
    LEFT JOIN
        EmployeeDetails emp ON emp.EmployeeId = matrix.EmployeeId AND emp.TeamId = team.Id
	LEFT JOIN
		EmployeeType empType ON empType.Id = emp.Type
    WHERE
        (@CategoryId = 0 OR catMaster.Id = @CategoryId)
        AND (@ClientId = 0 OR cmaster.Id = @ClientId)
        AND (@TeamId = 0 OR team.Id = @TeamId)
		AND (@FunctionType = 0 OR empType.Id = @FunctionType)
        AND subcatMaster.SubCategoryName <> catMaster.CategoryName
        AND ISNULL(scm.ClientExpectedScore, 0) <> 0
		AND emp.EmployeeName IS NOT NULL
    IF @ReportType = 0
    BEGIN
        DECLARE @pivotColumns NVARCHAR(MAX);
        SELECT @pivotColumns = STRING_AGG(QUOTENAME(EmployeeName), ', ') WITHIN GROUP (ORDER BY EmployeeName)
        FROM (
            SELECT DISTINCT EmployeeName
            FROM #temp
        ) AS Employees;
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = '
            SELECT
                CategoryName,
                SubCategoryName,
                ClientExpectedScore,
                ' + @pivotColumns + '
            FROM (
                SELECT
                    CategoryName,
                    SubCategoryName,
                    ClientExpectedScore,
                    EmployeeName,
                    EmployeeScorePercentage
                FROM
                    #temp
            ) AS SourceTable
            PIVOT (
                MAX(EmployeeScorePercentage) FOR EmployeeName IN (' + @pivotColumns + ')
            ) AS PivotTable;
        ';
        EXEC sp_executesql @sql;
    END;
    ELSE IF @ReportType = 1
    BEGIN
        DECLARE @pivotColumn NVARCHAR(MAX);
        SELECT @pivotColumn = STRING_AGG(QUOTENAME(CategoryName), ', ') WITHIN GROUP (ORDER BY CategoryName)
        FROM (
            SELECT DISTINCT CategoryName
            FROM #temp
        ) AS Categories;
        DECLARE @sql1 NVARCHAR(MAX);
        SET @sql1 = '
            SELECT
				ClientName,
				TeamName,
                EmployeeName,
				FunctionType,
                ' + @pivotColumn + '
            FROM (
                SELECT
					ClientName,
					TeamName,
                    EmployeeName,
					FunctionType,
                    CategoryName,
                    EmployeeScoreByCategory
                FROM
                    #temp
            ) AS SourceTable
            PIVOT (
                MAX(EmployeeScoreByCategory) FOR CategoryName IN (' + @pivotColumn + ')
            ) AS PivotTable
            ORDER BY ClientName;
        ';
        EXEC sp_executesql @sql1;
    END;
    DROP TABLE #temp;
END;
GO

-- =============================================
-- Author:		<Akash Maurya>
-- Create date: <5/22/2024>
-- Description:	<Table to store status of execution of usp_archive_process store procedure.>
-- =============================================
CREATE TABLE ArchiveProcessLog (
Id INT IDENTITY(1,1) PRIMARY KEY,
Month DATETIME NOT NULL,
Status VARCHAR(100) NOT NULL
);

-- =============================================
-- Author:		<Akash Maurya>
-- Create date: <5/22/2024>
-- Description:	<Save or update the log of execution of usp_archive_process store procedure.>
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[SaveOrUpdateArchiveProcessLog]
    @month DATETIME,
    @status NVARCHAR(100)
AS
BEGIN
    -- Check if the record for the given month already exists
    IF EXISTS (SELECT 1 FROM ArchiveProcessLog WHERE Month = @month)
    BEGIN
        -- Update existing record
        UPDATE ArchiveProcessLog
        SET Status = @Status
        WHERE Month = @month;
    END
    ELSE
    BEGIN
        -- Insert new record
        INSERT INTO ArchiveProcessLog (Month, Status)
        VALUES (@month, @status);
    END
END;

-- =============================================
-- Author:		<Akash Maurya>
-- Create date: <6/5/2024>
-- Description:	<Get the list of Employee details based on Team Id or get the all list of employee from EmployeeMaster table.>
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	        select * from EmployeeMaster
	    END
End


