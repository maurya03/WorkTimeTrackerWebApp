
CREATE OR ALTER PROCEDURE [dbo].[usp_Eb_GetChartRecord]
@FilterBy VARCHAR(200),
@StartDate DATETIME NULL,
@EndDate DATETIME NULL
AS  
BEGIN
IF @StartDate IS NULL
SELECT @StartDate = CONVERT(DATETIME, DATEADD(MONTH, -1, CONVERT(DATE, GETDATE())))

IF @EndDate IS NULL
SELECT @StartDate = GETDATE();

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

GO