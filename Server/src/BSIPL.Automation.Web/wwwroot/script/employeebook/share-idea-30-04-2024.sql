IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'ShareIdeaQuestions')
BEGIN
CREATE TABLE [dbo].[ShareIdeaQuestions]
(
Id INT NOT NULL Identity(1,1) CONSTRAINT pk_ShareIdeaQuestions_Id PRIMARY KEY,
Question VARCHAR(500) NOT NULL,
CreatedDate datetime NOT NULL CONSTRAINT default_ShareIdeaQuestions_CreatedDate DEFAULT GETDATE(),
UpdatedDate datetime NULL,
IsActive int NOT NULL CONSTRAINT default_ShareIdeaQuestions_IsActive DEFAULT 1
)
END

GO

IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'ShareIdeaCategory')
BEGIN
CREATE TABLE dbo.ShareIdeaCategory
(
Id INT NOT NULL Identity(1,1) CONSTRAINT pk_ShareIdeaCategory_Id PRIMARY KEY,
Category VARCHAR(100) NOT NULL,
CreatedDate DATETIME NOT NULL CONSTRAINT default_ShareIdeaCategory_CreatedDate DEFAULT GETDATE(),
UpdatedDate DATETIME NULL,
CreatedById VARCHAR(100) NULL,
UpdatedById VARCHAR(100) NULL,
IsActive INT NOT NULL CONSTRAINT default_ShareIdeaCategory_IsActive DEFAULT 1,
)
END

GO

IF NOT EXISTS (SELECT * FROM Automation.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = N'dbo'  AND TABLE_NAME = N'ShareIdeaAnswer')
BEGIN
CREATE TABLE [dbo].[ShareIdeaAnswer]
(
Id INT NOT NULL Identity(1,1) CONSTRAINT pk_ShareIdeaAnswer_Id PRIMARY KEY,
QuestionId INT NOT NULL CONSTRAINT fk_ShareIdeaAnswer_ShareIdeaQuestions_QuestionId FOREIGN KEY REFERENCES ShareIdeaQuestions(Id),
CategoryId INT NOT NULL CONSTRAINT fk_ShareIdeaAnswer_ShareIdeaCategory_CategoryId FOREIGN KEY REFERENCES ShareIdeaCategory(Id),
EmployeeId VARCHAR(200) NOT NULL CONSTRAINT fk_ShareIdeaAnswer_EmployeeMaster_EmployeeId FOREIGN KEY REFERENCES EmployeeMaster(EmployeeId),
ShareIdeaId Guid NOT NULL,
Answer VARCHAR(5000) NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT default_ShareIdeaAnswer_CreatedDate DEFAULT GETDATE(),
[UpdatedDate] [datetime] NULL,
[IsActive] [int] NOT NULL CONSTRAINT default_ShareIdeaAnswer_IsActive DEFAULT 1
)
END



GO



CREATE TYPE [dbo].[QuestionsAnswer] AS TABLE(
	[QuestionId] [int] NOT NULL,
	[Answer] [varchar](500) NOT NULL	
)
GO


CREATE OR ALTER PROCEDURE [dbo].[usp_Crud_SharedIdea]
@EmailId VARCHAR(200) = '',
@Action INT = 0,
@QuestionAnswer QuestionsAnswer READONLY,
@CategoryId INT = 0
AS
BEGIN
IF @EmailId IS NOT NULL --1
BEGIN
DECLARE @EmployeeId VARCHAR(200) = '';
DECLARE @ShareIdeaId uniqueidentifier = NULL;
SELECT @EmployeeId = EmployeeId from EmployeeMaster where EmailId = @EmailId;
IF (@Action = 1 AND @EmployeeId <> '' AND @CategoryId > 0 ) -- INSERT RECORD
BEGIN
SET @ShareIdeaId = NEWID();
INSERT INTO ShareIdeaAnswer(QuestionId, EmployeeId, Answer, CategoryId, ShareIdeaId)
SELECT QuestionId, @EmployeeId, Answer, @CategoryId, @ShareIdeaId FROM @QuestionAnswer;
END
ELSE IF (@Action = 2) -- GET RECORDS
BEGIN
SELECT * FROM vw_GetEmployeeShareIdea;
END
ELSE
BEGIN
SELECT @Response = 2; --Error Occured EMAIL ID NULL
return;
END
END
GO

CREATE OR ALTER VIEW [dbo].[vw_GetEmployeeShareIdea] AS
SELECT shareQ.Id AS QuestionId, 
shareA.Id AS ShareIdeaAnswerId,
shareA.Answer,
Em.EmployeeId,
Em.EmailId,
Em.FullName,
category.Id AS CategoryId,
category.Category,
Question FROM ShareIdeaQuestions AS shareQ
INNER JOIN ShareIdeaAnswer AS shareA ON shareQ.Id = shareA.QuestionId
INNER JOIN ShareIdeaCategory AS category ON shareA.CategoryId = category.Id
INNER JOIN EmployeeMaster AS Em ON shareA.EmployeeId = Em.EmployeeId
GO


CREATE OR ALTER VIEW [dbo].[vw_GetShareIdeaCategoryWithCounts] AS
with cte as  
   (  
     SELECT CategoryId, ShareIdeaId AS QuestionsCount
  FROM [Automation].[dbo].[ShareIdeaAnswer] GROUP BY CategoryId, ShareIdeaId
    )  
 
SELECT CategoryId, (SELECT Category FROM ShareIdeaCategory WHERE Id = CategoryId) AS Category, COUNT(CategoryId) AS IdeaCounts FROM cte GROUP BY CategoryId;

GO



CREATE OR ALTER VIEW [dbo].[vw_GetShareIdeaEmployeeRecords]
AS
SELECT shidea.*, em.FullName, em.EmailId, sic.Category from [dbo].[ShareIdeaAnswer] shidea
JOIN EmployeeMaster em on em.EmployeeId = shidea.EmployeeId
JOIN ShareIdeaCategory sic on sic.Id = shidea.CategoryId
GO