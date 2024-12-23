USE [Automation]
GO

ALTER TABLE [dbo].[ApplicationMaster] DROP CONSTRAINT [DF_ApplicationMaster_CanDelete]
GO

ALTER TABLE [dbo].[ApplicationMaster] DROP CONSTRAINT [DF_ApplicationMaster_CanEdit]
GO

ALTER TABLE [dbo].[ApplicationMaster] DROP CONSTRAINT [DF_ApplicationMaster_CanView]
GO

/****** Object:  Table [dbo].[ApplicationMaster]    Script Date: 2/28/2024 6:53:18 PM ******/
DROP TABLE IF EXISTS [dbo].[ApplicationMaster]
GO

/****** Object:  Table [dbo].[ApplicationMaster]    Script Date: 2/28/2024 6:53:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ApplicationMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationName] [varchar](250) NULL,
	[ApplicationDescription] [varchar](1000) NULL,
	[RoleId] [int] NULL,
	[ApplicationPath] [varchar](250) NULL,
	[CanView] [bit] NOT NULL,
	[CanEdit] [bit] NOT NULL,
	[CanDelete] [bit] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ApplicationMaster] ADD  CONSTRAINT [DF_ApplicationMaster_CanView]  DEFAULT ((1)) FOR [CanView]
GO

ALTER TABLE [dbo].[ApplicationMaster] ADD  CONSTRAINT [DF_ApplicationMaster_CanEdit]  DEFAULT ((0)) FOR [CanEdit]
GO

ALTER TABLE [dbo].[ApplicationMaster] ADD  CONSTRAINT [DF_ApplicationMaster_CanDelete]  DEFAULT ((0)) FOR [CanDelete]
GO


USE [Automation]
GO

ALTER TABLE [dbo].[ApplicationPageEmpMapping] DROP CONSTRAINT [DF_ApplicationPageEmpMapping_CanEdit]
GO

ALTER TABLE [dbo].[ApplicationPageEmpMapping] DROP CONSTRAINT [DF_ApplicationPageEmpMapping_CanView]
GO

/****** Object:  Table [dbo].[ApplicationPageEmpMapping]    Script Date: 2/28/2024 6:58:34 PM ******/
DROP TABLE If exists [dbo].[ApplicationPageEmpMapping]
GO

/****** Object:  Table [dbo].[ApplicationPageEmpMapping]    Script Date: 2/28/2024 6:58:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ApplicationPageEmpMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PageId] [int] NOT NULL,
	[EmpId] [int] NOT NULL,
	[EmailId] [varchar](250) NOT NULL,
	[CanView] [bit] NOT NULL,
	[CanEdit] [bit] NOT NULL,
	[CanDelete] [bit] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ApplicationPageEmpMapping] ADD  CONSTRAINT [DF_ApplicationPageEmpMapping_CanView]  DEFAULT ((1)) FOR [CanView]
GO

ALTER TABLE [dbo].[ApplicationPageEmpMapping] ADD  CONSTRAINT [DF_ApplicationPageEmpMapping_CanEdit]  DEFAULT ((1)) FOR [CanEdit]
GO


USE [Automation]
GO

/****** Object:  Table [dbo].[ApplicationPageMaster]    Script Date: 2/28/2024 6:59:53 PM ******/
DROP TABLE If Exists [dbo].[ApplicationPageMaster]
GO

/****** Object:  Table [dbo].[ApplicationPageMaster]    Script Date: 2/28/2024 6:59:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ApplicationPageMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationId] [int] NOT NULL,
	[ModuleName] [varchar](250) NOT NULL,
	[ModuleDescription] [varchar](1000) NULL
) ON [PRIMARY]
GO


USE [Automation]
GO

/****** Object:  StoredProcedure [dbo].[usp_getApplicationAccessByEmailId]    Script Date: 2/28/2024 7:00:56 PM ******/
DROP PROCEDURE If Exists [dbo].[usp_getApplicationAccessByEmailId]
GO

/****** Object:  StoredProcedure [dbo].[usp_getApplicationAccessByEmailId]    Script Date: 2/28/2024 7:00:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--exec [dbo].[usp_getApplicationAccessByEmailId] 'dhirajkumar@bhavnacorp.com'

CREATE OR ALTER   PROCEDURE [dbo].[usp_getApplicationAccessByEmailId]
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
where ER.RoleId= @RoleId and AM.canView=1 and
EM.EmailId=@EmailId



END
END


GO


