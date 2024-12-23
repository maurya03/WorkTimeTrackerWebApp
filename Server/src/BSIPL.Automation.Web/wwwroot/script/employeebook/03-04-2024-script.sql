
USE [Automation]
GO

IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'usp_Eb_GetChartRecord'
            AND type = 'P'
      )

DROP PROCEDURE dbo.usp_Eb_GetChartRecord

GO

CREATE PROCEDURE [dbo].[usp_Eb_GetChartRecord]
@FilterBy VARCHAR(200)
AS  
BEGIN
IF @FilterBy = 'MONTHLY'
BEGIN
SELECT COUNT(*) AS LoginCount, DATENAME(MONTH, DATEADD(MONTH, -1, CreatedDate))  AS Label from Logger where LogFrom = 'EmployeeBook' AND Description Like '%logged in to the Employeebook.%'
GROUP BY DATENAME(MONTH, DATEADD(MONTH, -1, CreatedDate));
END
ELSE IF  @FilterBy = 'WEEKLY'
BEGIN
SELECT COUNT(*) AS LoginCount, DATEPART(WEEK, CAST(CreatedDate AS DATE)) AS Label from Logger where LogFrom = 'EmployeeBook' AND Description Like '%logged in to the Employeebook.%'
GROUP BY DATEPART(WEEK, CAST(CreatedDate AS DATE));
END
ELSE
BEGIN
SELECT COUNT(*) AS LoginCount, CAST(CreatedDate AS DATE) AS Label from Logger where LogFrom = 'EmployeeBook' AND Description Like '%logged in to the Employeebook.%'
GROUP BY CAST(CreatedDate AS DATE);
END


SELECT COUNT(*) AS ActiveEmployeeCount FROM EmployeeMaster WHERE IsActive =1 and IsDeleted = 0 and IsEmployeeBookAllowed = 1;

SELECT COUNT(*) AS DailyEmployeeLoginCount FROM Logger where LogFrom = 'EmployeeBook' AND Description Like '%logged in to the Employeebook.%' AND CAST(CreatedDate as Date) = CAST(GETDATE() as Date);

END

