ALTER TABLE OrgColumns
DROP COLUMN IsVisible;

EXEC sp_rename 'OrgColumns.status', 'ColumnNumber', 'COLUMN';

-- =============================================
-- Author:	<Arpit verma>
-- Create date: <7/30/2024 12:50:46 AM>
-- Description:	<import excel of It hours and save data in EmployeeProductivity>
-- =============================================
/****** Object:  StoredProcedure [dbo].[usp_getITHoursDetail]   Script Date: 7/30/2024 12:50:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[usp_getITHoursDetail]
AS
BEGIN
    DECLARE @cols AS NVARCHAR(MAX), @query AS NVARCHAR(MAX), @query1 AS NVARCHAR(MAX); 
	DECLARE @searchPattern NVARCHAR(20) = 'No Dues';

    SELECT @cols = STUFF((SELECT ',' + QUOTENAME(ColumnName) 
                           FROM OrgColumns
                           GROUP BY ColumnName, OrgColumnId
                           ORDER BY OrgColumnId
                           FOR XML PATH(''), TYPE 
                         ).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SET @query = 'SELECT ' + @cols + '
	into #temp
                       FROM 
                      (SELECT RowId, ColumnValue, ColumnName
                       FROM OrgColumns column1
                       JOIN OrgMasterRecord master1 ON column1.ColumnNumber = master1.ColumnId) AS SourceTable
                  PIVOT
                  (
                      MAX(ColumnValue)
                      FOR ColumnName IN (' + @cols + ')
                  ) AS PivotTable;
				
				   
    INSERT INTO EmployeeITProductivity ([EmpId], [ITProductiveHours], [ITActiveHours], [startDate], [weekenddate])
    SELECT [Emp Code], [Productive time], [Active time], [Start date],[End date]
    FROM #temp where [Emp Code] NOT LIKE ''%' + @searchPattern + '%'';

    SELECT * FROM #temp;
    DROP TABLE #temp;';
    EXEC sp_executesql @query;
END

/****** Object:  StoredProcedure [dbo].[usp_getorgDetails]    Script Date: 7/26/2024 12:50:46 AM ******/--Arpit verma
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_getorgDetails]-- '2024-07-28 00:00:00.000', '2024-08-03 00:00:00.000'
  @startDate datetime,
  @endDate datetime
AS
BEGIN
    DECLARE @cols AS NVARCHAR(MAX), @query AS NVARCHAR(MAX), @query1 AS NVARCHAR(MAX);        

    SELECT @cols = STUFF((SELECT ',' + QUOTENAME(ColumnName) 
                           FROM OrgColumns
                           GROUP BY ColumnName, OrgColumnId
                           ORDER BY OrgColumnId
                           FOR XML PATH(''), TYPE 
                         ).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

    SET @query = 'SELECT ' + @cols + '
					   into #temp
                       FROM 
                      (SELECT RowId, ColumnValue, ColumnName
                       FROM OrgColumns column1
                       JOIN OrgMasterRecord master1 ON column1.ColumnNumber = master1.ColumnId) AS SourceTable
                  PIVOT
                  (
                      MAX(ColumnValue)
                      FOR ColumnName IN (' + @cols + ')
                  ) AS PivotTable;					

								WITH AggLeaves AS (    
										SELECT [Employee ID],SUM (cast([leave] as decimal(5,2))) AS AggLeave,Status FROM #temp where Status= ''Approved''
										GROUP BY [Employee ID],Status)
										
										UPDATE EmployeeITProductivity
										SET Leave = AggLeave
										FROM AggLeaves
										WHERE [EmpId] = CAST([Employee ID] as VARCHAR(MAX))
										select * From EmployeeITProductivity
										SELECT * FROM #temp;
										DROP TABLE #temp;										
					';
    EXEC sp_executesql @query;
END
