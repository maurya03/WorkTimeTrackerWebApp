USE [Automation]
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateTimeSheetStatusForApprover]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_UpdateTimeSheetStatusForApprover]
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateTimeSheetStatus]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_UpdateTimeSheetStatus]
GO
/****** Object:  StoredProcedure [dbo].[usp_getTimesheetCategoryByEmployeeId]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_getTimesheetCategoryByEmployeeId]
GO
/****** Object:  StoredProcedure [dbo].[usp_getTimesheetCategoryByEmployeeId]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_getEmployeeRoleDetailByEmailId]
GO
/****** Object:  StoredProcedure [dbo].[usp_saveTimesheet]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_saveTimesheet]
GO
/****** Object:  StoredProcedure [dbo].[usp_gettimesheetcategory]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_gettimesheetcategory]
GO
/****** Object:  StoredProcedure [dbo].[usp_getTimeSheetForApprover]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_getTimeSheetForApprover]
GO
/****** Object:  StoredProcedure [dbo].[GetAllEmployeeIds]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetAllEmployeeIds]
GO
/****** Object:  StoredProcedure [dbo].[usp_getTimesheetEmployee]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_getTimesheetEmployee]
GO
/****** Object:  StoredProcedure [dbo].[usp_getTimeSheetDetailByTimesheetId]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_getTimeSheetDetailByTimesheetId]
GO
/****** Object:  StoredProcedure [dbo].[usp_getTimesheetDataStatusWise]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_getTimesheetDataStatusWise]
GO
/****** Object:  StoredProcedure [dbo].[usp_getEmployeeProject]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_getEmployeeProject]
GO
/****** Object:  StoredProcedure [dbo].[UpdateTimesheetEmployeeDetails]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[UpdateTimesheetEmployeeDetails]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TimeSheetSubcategory]') AND type in (N'U'))
ALTER TABLE [dbo].[TimeSheetSubcategory] DROP CONSTRAINT IF EXISTS [FK__TimeSheet__TimeS__69FBBC1F]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TimesheetDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[TimesheetDetail] DROP CONSTRAINT IF EXISTS [FK_timesheetDetail_timesheetId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TimesheetDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[TimesheetDetail] DROP CONSTRAINT IF EXISTS [FK_timesheetDetail_sub_categoryId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TimesheetDetail]') AND type in (N'U'))
ALTER TABLE [dbo].[TimesheetDetail] DROP CONSTRAINT IF EXISTS [FK_timesheetDetail_categoryId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Timesheet]') AND type in (N'U'))
ALTER TABLE [dbo].[Timesheet] DROP CONSTRAINT IF EXISTS [FK_timesheetDetail_teamId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Timesheet]') AND type in (N'U'))
ALTER TABLE [dbo].[Timesheet] DROP CONSTRAINT IF EXISTS [FK_timesheetDetail_statusId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Timesheet]') AND type in (N'U'))
ALTER TABLE [dbo].[Timesheet] DROP CONSTRAINT IF EXISTS [FK_timesheet_OnBehalf_CreatedBy]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Timesheet]') AND type in (N'U'))
ALTER TABLE [dbo].[Timesheet] DROP CONSTRAINT IF EXISTS [FK_timesheet_employeeId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Timesheet]') AND type in (N'U'))
ALTER TABLE [dbo].[Timesheet] DROP CONSTRAINT IF EXISTS [FK_timesheet_clientId]
GO
/****** Object:  Table [dbo].[TimeSheetSubcategory]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP TABLE IF EXISTS [dbo].[TimeSheetSubcategory]
GO
/****** Object:  Table [dbo].[TimeSheetStatuses]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP TABLE IF EXISTS [dbo].[TimeSheetStatuses]
GO
/****** Object:  Table [dbo].[TimeSheetStatus]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP TABLE IF EXISTS [dbo].[TimeSheetStatus]
GO
/****** Object:  Table [dbo].[TimesheetDetail]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP TABLE IF EXISTS [dbo].[TimesheetDetail]
GO
/****** Object:  Table [dbo].[TimeSheetCategory]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP TABLE IF EXISTS [dbo].[TimeSheetCategory]
GO
/****** Object:  Table [dbo].[Timesheet]    Script Date: 3/12/2024 3:16:46 PM ******/
DROP TABLE IF EXISTS [dbo].[Timesheet]
GO
/****** Object:  Table [dbo].[Timesheet]    Script Date: 3/12/2024 3:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Timesheet](
	[TimesheetId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[ClientId] [int] NOT NULL,
	[TeamId] [int] NULL,
	[TotalHours] [decimal](5, 2) NULL,
	[WeekStartDate] [datetime] NOT NULL,
	[WeekEndDate] [datetime] NOT NULL,
	[ApprovedDate] [datetime] NULL,
	[SubmissionDate] [datetime] NULL,
	[Created] [datetime] NOT NULL,
	[Modified] [datetime] NULL,
	[Remarks] [nvarchar](max) NULL,
	[StatusId] [int] NOT NULL,
	[OnBehalfTimesheetCreatedBy] [int] NULL,
PRIMARY KEY CLUSTERED
(
	[TimesheetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimeSheetCategory]    Script Date: 3/12/2024 3:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimeSheetCategory](
	[TimeSheetCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[TimeSheetCategoryName] [nvarchar](255) NULL,
	[Function] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED
(
	[TimeSheetCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimesheetDetail]    Script Date: 3/12/2024 3:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimesheetDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TimesheetId] [int] NULL,
	[TimeSheetCategoryID] [int] NULL,
	[TimeSheetSubcategoryID] [int] NULL,
	[TaskDescription] [nvarchar](1000) NOT NULL,
	[TimesheetUnit] [nvarchar](10) NULL,
	[Value] [decimal](5, 2) NOT NULL,
	[Date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimeSheetStatus]    Script Date: 3/12/2024 3:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimeSheetStatus](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](30) NULL,
PRIMARY KEY CLUSTERED
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimeSheetStatuses]    Script Date: 3/12/2024 3:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimeSheetStatuses](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [varchar](30) NULL,
PRIMARY KEY CLUSTERED
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimeSheetSubcategory]    Script Date: 3/12/2024 3:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimeSheetSubcategory](
	[TimeSheetSubcategoryID] [int] IDENTITY(1,1) NOT NULL,
	[TimeSheetSubcategoryName] [nvarchar](255) NULL,
	[TimeSheetCategoryID] [int] NULL,
PRIMARY KEY CLUSTERED
(
	[TimeSheetSubcategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Timesheet] ON
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (359, 215, 20, 133, CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-03-10T00:00:00.000' AS DateTime), CAST(N'2024-03-16T00:00:00.000' AS DateTime), CAST(N'2024-03-12T12:27:09.147' AS DateTime), CAST(N'2024-03-12T09:36:28.147' AS DateTime), CAST(N'2024-03-12T09:32:38.997' AS DateTime), CAST(N'2024-03-12T12:27:09.147' AS DateTime), N'not correct', 3, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (360, 215, 20, 133, CAST(5.00 AS Decimal(5, 2)), CAST(N'2024-03-17T00:00:00.000' AS DateTime), CAST(N'2024-03-23T00:00:00.000' AS DateTime), NULL, CAST(N'2024-03-12T09:36:19.617' AS DateTime), CAST(N'2024-03-12T09:36:16.657' AS DateTime), CAST(N'2024-03-12T09:36:19.617' AS DateTime), N'', 2, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (361, 215, 20, 133, CAST(6.00 AS Decimal(5, 2)), CAST(N'2024-03-03T00:00:00.000' AS DateTime), CAST(N'2024-03-09T00:00:00.000' AS DateTime), NULL, CAST(N'2024-03-12T11:12:38.660' AS DateTime), CAST(N'2024-03-12T11:10:01.110' AS DateTime), CAST(N'2024-03-12T11:33:57.550' AS DateTime), N'', 1, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (362, 71, 19, 130, CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-03-10T00:00:00.000' AS DateTime), CAST(N'2024-03-16T00:00:00.000' AS DateTime), NULL, CAST(N'2024-03-12T11:19:12.540' AS DateTime), CAST(N'2024-03-12T11:19:06.090' AS DateTime), CAST(N'2024-03-12T11:19:12.540' AS DateTime), N'', 2, 70)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (363, 70, 19, 130, CAST(8.00 AS Decimal(5, 2)), CAST(N'2024-03-17T00:00:00.000' AS DateTime), CAST(N'2024-03-23T00:00:00.000' AS DateTime), NULL, CAST(N'2024-03-12T11:25:07.680' AS DateTime), CAST(N'2024-03-12T11:24:59.620' AS DateTime), CAST(N'2024-03-12T11:25:07.680' AS DateTime), N'', 2, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (364, 912, 20, 133, CAST(13.00 AS Decimal(5, 2)), CAST(N'2024-03-10T00:00:00.000' AS DateTime), CAST(N'2024-03-16T00:00:00.000' AS DateTime), NULL, CAST(N'2024-03-12T12:59:52.503' AS DateTime), CAST(N'2024-03-12T12:46:39.197' AS DateTime), CAST(N'2024-03-12T12:59:52.503' AS DateTime), N'', 2, NULL)
GO
INSERT [dbo].[Timesheet] ([TimesheetId], [EmployeeID], [ClientId], [TeamId], [TotalHours], [WeekStartDate], [WeekEndDate], [ApprovedDate], [SubmissionDate], [Created], [Modified], [Remarks], [StatusId], [OnBehalfTimesheetCreatedBy]) VALUES (365, 912, 19, NULL, CAST(5.00 AS Decimal(5, 2)), CAST(N'2024-03-10T00:00:00.000' AS DateTime), CAST(N'2024-03-16T00:00:00.000' AS DateTime), NULL, NULL, CAST(N'2024-03-12T13:09:29.457' AS DateTime), NULL, N'', 1, 100)
GO
SET IDENTITY_INSERT [dbo].[Timesheet] OFF
GO
SET IDENTITY_INSERT [dbo].[TimeSheetCategory] ON
GO
INSERT [dbo].[TimeSheetCategory] ([TimeSheetCategoryID], [TimeSheetCategoryName], [Function]) VALUES (1, N'Common', N'Common')
GO
INSERT [dbo].[TimeSheetCategory] ([TimeSheetCategoryID], [TimeSheetCategoryName], [Function]) VALUES (2, N'Engineering', N'Dev')
GO
INSERT [dbo].[TimeSheetCategory] ([TimeSheetCategoryID], [TimeSheetCategoryName], [Function]) VALUES (3, N'Quality', N'QA')
GO
INSERT [dbo].[TimeSheetCategory] ([TimeSheetCategoryID], [TimeSheetCategoryName], [Function]) VALUES (4, N'Finance', N'Fin')
GO
INSERT [dbo].[TimeSheetCategory] ([TimeSheetCategoryID], [TimeSheetCategoryName], [Function]) VALUES (5, N'HR', N'HR')
GO
INSERT [dbo].[TimeSheetCategory] ([TimeSheetCategoryID], [TimeSheetCategoryName], [Function]) VALUES (6, N'Training', N'')
GO
INSERT [dbo].[TimeSheetCategory] ([TimeSheetCategoryID], [TimeSheetCategoryName], [Function]) VALUES (7, N'IT', N'IT')
GO
INSERT [dbo].[TimeSheetCategory] ([TimeSheetCategoryID], [TimeSheetCategoryName], [Function]) VALUES (8, N'MGMT', N'MGMT')
GO
INSERT [dbo].[TimeSheetCategory] ([TimeSheetCategoryID], [TimeSheetCategoryName], [Function]) VALUES (9, N'Marketing', N'Marketing')
GO
INSERT [dbo].[TimeSheetCategory] ([TimeSheetCategoryID], [TimeSheetCategoryName], [Function]) VALUES (10, N'OPS', N'OPS')
GO
INSERT [dbo].[TimeSheetCategory] ([TimeSheetCategoryID], [TimeSheetCategoryName], [Function]) VALUES (11, N'TA', N'TA')
GO
SET IDENTITY_INSERT [dbo].[TimeSheetCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[TimesheetDetail] ON
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (1, 359, 1, 16, N'fdg', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (2, 359, 1, 16, N'fdg', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (3, 359, 1, 16, N'dfg', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (4, 359, 1, 16, N'dfg', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (5, 360, 1, 16, N'fdf', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (6, 360, 1, 16, N'fdf', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-03-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (7, 360, 1, 16, N'gfh', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (13, 361, 1, 16, N'Prev1', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (14, 361, 1, 16, N'Prev3', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-04T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (15, 361, 1, 16, N'Prev3', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-05T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (16, 362, 3, 12, N'R1', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-03-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (17, 362, 3, 12, N'R1', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-03-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (18, 362, 3, 12, N'R1', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-03-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (19, 362, 1, 16, N'R2', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (20, 362, 1, 16, N'R2', N'HH', CAST(3.00 AS Decimal(5, 2)), CAST(N'2024-03-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (21, 363, 1, 18, N'Next', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (22, 363, 1, 18, N'Next', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-18T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (23, 363, 3, 13, N'Next2', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-17T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (24, 363, 3, 13, N'Next2', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-19T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (42, 364, 2, 1, N'Add1 ', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-03-10T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (43, 364, 2, 1, N'Add1 ', N'HH', CAST(1.00 AS Decimal(5, 2)), CAST(N'2024-03-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (44, 364, 2, 1, N'Add1 ', N'HH', CAST(2.00 AS Decimal(5, 2)), CAST(N'2024-03-13T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (45, 364, 1, 16, N'Add 3', N'HH', CAST(4.00 AS Decimal(5, 2)), CAST(N'2024-03-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (46, 364, 1, 16, N'Add 3', N'HH', CAST(5.00 AS Decimal(5, 2)), CAST(N'2024-03-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[TimesheetDetail] ([Id], [TimesheetId], [TimeSheetCategoryID], [TimeSheetSubcategoryID], [TaskDescription], [TimesheetUnit], [Value], [Date]) VALUES (47, 365, 1, 16, N'Add', N'HH', CAST(5.00 AS Decimal(5, 2)), CAST(N'2024-03-10T00:00:00.000' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[TimesheetDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[TimeSheetStatus] ON
GO
INSERT [dbo].[TimeSheetStatus] ([StatusID], [StatusName]) VALUES (1, N'Draft')
GO
INSERT [dbo].[TimeSheetStatus] ([StatusID], [StatusName]) VALUES (2, N'Pending')
GO
INSERT [dbo].[TimeSheetStatus] ([StatusID], [StatusName]) VALUES (3, N'Rejected')
GO
INSERT [dbo].[TimeSheetStatus] ([StatusID], [StatusName]) VALUES (4, N'Approved')
GO
SET IDENTITY_INSERT [dbo].[TimeSheetStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[TimeSheetStatuses] ON
GO
INSERT [dbo].[TimeSheetStatuses] ([StatusID], [StatusName]) VALUES (1, N'Draft')
GO
INSERT [dbo].[TimeSheetStatuses] ([StatusID], [StatusName]) VALUES (2, N'Pending')
GO
INSERT [dbo].[TimeSheetStatuses] ([StatusID], [StatusName]) VALUES (3, N'Rejected')
GO
INSERT [dbo].[TimeSheetStatuses] ([StatusID], [StatusName]) VALUES (4, N'Approved')
GO
SET IDENTITY_INSERT [dbo].[TimeSheetStatuses] OFF
GO
SET IDENTITY_INSERT [dbo].[TimeSheetSubcategory] ON
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (1, N'Dev Coding', 2)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (2, N'Dev Unit Testing', 2)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (3, N'Dev Code Review', 2)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (4, N'Dev Defect Fixing', 2)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (5, N'Dev Dataset Refresh and Domo Sync', 2)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (6, N'Dev Deployment/Re-run/Re-migration', 2)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (7, N'Dev Map Build', 2)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (8, N'Dev Map Configuration', 2)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (9, N'Dev Hypercare/Go Live', 2)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (10, N'Dev New Map', 2)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (11, N'Data Preparation and Consolidation', NULL)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (12, N'QA Analysis(Grooming)', 3)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (13, N'QA Manual Test Case Creation/Updation', 3)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (14, N'QA Manual Test Case Execution', 3)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (15, N'QA Framework Development &amp; Maintenance', 3)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (16, N'Technical Meeting', 1)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (17, N'Non Technical Meetings', 1)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (18, N'Client Meetings', 1)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (19, N'Hiring Meetings', 1)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (20, N'Sprint Review', 1)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (21, N'Retrospective', 1)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (22, N'Training Attended - Technical', 1)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (23, N'Training Attended - Non Technical', 1)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (24, N'Training Imparted', 1)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (25, N'Self Learning', 1)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (26, N'Reports', 1)
GO
INSERT [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID], [TimeSheetSubcategoryName], [TimeSheetCategoryID]) VALUES (27, N'It Return ', 4)
GO
SET IDENTITY_INSERT [dbo].[TimeSheetSubcategory] OFF
GO
ALTER TABLE [dbo].[Timesheet]  WITH CHECK ADD  CONSTRAINT [FK_timesheet_clientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[ClientMaster] ([Id])
GO
ALTER TABLE [dbo].[Timesheet] CHECK CONSTRAINT [FK_timesheet_clientId]
GO
ALTER TABLE [dbo].[Timesheet]  WITH CHECK ADD  CONSTRAINT [FK_timesheet_employeeId] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeId])
GO
ALTER TABLE [dbo].[Timesheet] CHECK CONSTRAINT [FK_timesheet_employeeId]
GO
ALTER TABLE [dbo].[Timesheet]  WITH CHECK ADD  CONSTRAINT [FK_timesheet_OnBehalf_CreatedBy] FOREIGN KEY([OnBehalfTimesheetCreatedBy])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeId])
GO
ALTER TABLE [dbo].[Timesheet] CHECK CONSTRAINT [FK_timesheet_OnBehalf_CreatedBy]
GO
ALTER TABLE [dbo].[Timesheet]  WITH CHECK ADD  CONSTRAINT [FK_timesheetDetail_statusId] FOREIGN KEY([StatusId])
REFERENCES [dbo].[TimeSheetStatus] ([StatusID])
GO
ALTER TABLE [dbo].[Timesheet] CHECK CONSTRAINT [FK_timesheetDetail_statusId]
GO
ALTER TABLE [dbo].[Timesheet]  WITH CHECK ADD  CONSTRAINT [FK_timesheetDetail_teamId] FOREIGN KEY([TeamId])
REFERENCES [dbo].[TeamMaster] ([Id])
GO
ALTER TABLE [dbo].[Timesheet] CHECK CONSTRAINT [FK_timesheetDetail_teamId]
GO
ALTER TABLE [dbo].[TimesheetDetail]  WITH CHECK ADD  CONSTRAINT [FK_timesheetDetail_categoryId] FOREIGN KEY([TimeSheetCategoryID])
REFERENCES [dbo].[TimeSheetCategory] ([TimeSheetCategoryID])
GO
ALTER TABLE [dbo].[TimesheetDetail] CHECK CONSTRAINT [FK_timesheetDetail_categoryId]
GO
ALTER TABLE [dbo].[TimesheetDetail]  WITH CHECK ADD  CONSTRAINT [FK_timesheetDetail_sub_categoryId] FOREIGN KEY([TimeSheetSubcategoryID])
REFERENCES [dbo].[TimeSheetSubcategory] ([TimeSheetSubcategoryID])
GO
ALTER TABLE [dbo].[TimesheetDetail] CHECK CONSTRAINT [FK_timesheetDetail_sub_categoryId]
GO
ALTER TABLE [dbo].[TimesheetDetail]  WITH CHECK ADD  CONSTRAINT [FK_timesheetDetail_timesheetId] FOREIGN KEY([TimesheetId])
REFERENCES [dbo].[Timesheet] ([TimesheetId])
GO
ALTER TABLE [dbo].[TimesheetDetail] CHECK CONSTRAINT [FK_timesheetDetail_timesheetId]
GO
ALTER TABLE [dbo].[TimeSheetSubcategory]  WITH CHECK ADD FOREIGN KEY([TimeSheetCategoryID])
REFERENCES [dbo].[TimeSheetCategory] ([TimeSheetCategoryID])
GO
/****** Object:  StoredProcedure [dbo].[usp_getEmployeeProject]    Script Date: 3/28/2024 10:46:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR Alter PROCEDURE [dbo].[usp_getEmployeeProject]
@EmailId varchar(200)
As
Begin
DECLARE @EmpId int
    Select @EmpId=EmployeeId from EmployeeMaster Where EmailId=@EmailId

  Select ClientId AS ProjectId,ClientName from EmployeeDetails empD inner join EmployeeMaster empM on  empD.BhavnaEmployeeId=empM.EmployeeId
  inner join TeamMaster tm on tm.Id=empD.TeamId
  inner join ClientMaster cli on cli.Id=tm.ClientId
  where empM.EmailId=@EmailId


End

GO

/****** Object:  StoredProcedure [dbo].[usp_getTimesheetDataStatusWise_Admin]    Script Date: 05-05-2024 18:06:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR Alter PROCEDURE [dbo].[usp_getTimesheetDataStatusWise_Admin]
   @StatusID int,
  @StartDate datetime,
  @EndDate datetime,
  @SkipRows int,
  @EmpId int,
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

GO

/****** Object:  StoredProcedure [dbo].[usp_getTimesheetDataStatusWise_Manager]    Script Date: 05-05-2024 18:07:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR Alter PROCEDURE [dbo].[usp_getTimesheetDataStatusWise_Manager]
  @StatusID int,
  @StartDate datetime,
  @EndDate datetime,
  @SkipRows int,
  @EmpId int,
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

GO


/****** Object:  StoredProcedure [dbo].[usp_getTimesheetDataStatusWise_Employee]    Script Date: 05-05-2024 18:06:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR Alter PROCEDURE [dbo].[usp_getTimesheetDataStatusWise_Employee]
  @StatusID int,
  @SkipRows int,
  @EmpId int,
  @TakeRows int,
  @SearchedText varchar(50)
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
	and empM.FullName  LIKE '%'+@SearchedText+'%'
	order by Tse.Created desc
	OFFSET @SkipRows ROWS
   FETCH NEXT @TakeRows ROWS ONLY;
END

GO

/****** Object:  StoredProcedure [dbo].[usp_getTimesheetDataStatusWise]    Script Date: 3/29/2024 2:32:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR Alter PROCEDURE [dbo].[usp_getTimesheetDataStatusWise]
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
    DECLARE @EmpId int
    Select @EmpId=EmployeeId from EmployeeMaster Where EmailId=@EmailId
	DECLARE @EmployeeRole varchar(200)
	DECLARE @TakeRows int= 10
	Select @EmployeeRole=r.RoleName from EmployeeRoles er  inner join Roles r on er.RoleId=r.RoleId where er.EmployeeId = @EmpId

	create table #tempEmployeeData(TimesheetId int,CreatedDate datetime, ApprovedDate datetime, WeekStartDate datetime, WeekEndDate datetime,
	SubmissionDate datetime,TotalCount int, StatusName varchar(30), Remarks nvarchar(max), EmployeeId int,
	ClientName varchar(400),TotalHours decimal, EmployeeName varchar(200),
	 EmailId varchar(200))

  IF @StatusID=1 OR @IsApproverPending=1
  OR @EmployeeRole = 'Employee'
  OR (@EmployeeRole='Admin' AND (@StatusID = 3 OR @StatusID = 4 OR @StatusID = 2) AND @ShowSelfRecordsToggle=1)
  OR (@EmployeeRole='Reporting_Manager' AND (@StatusID = 3 OR @StatusID = 4) AND @ShowSelfRecordsToggle=1)
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



CREATE OR ALTER   PROCEDURE [dbo].[usp_DeleteTimesheetDetails] -- 'mohit.nautiyal@bhavnacorp.com',0,'2024-04-07','2024-04-13',0,215
  @TimesheetIds NVARCHAR(MAX) = ''
AS
BEGIN
 DECLARE @DeletedHours decimal(5, 2);
 DECLARE @TimesheetId INT;
 select @DeletedHours =sum([Value]) from TimesheetDetail Where Id in (select value from string_split(@TimesheetIds, ','))
 select @TimesheetId=TimesheetId from TimesheetDetail Where Id in (select value from string_split(@TimesheetIds, ','))
 delete from TimesheetDetail where Id in (select value from string_split(@TimesheetIds, ','))
 If Exists (Select 1 from Timesheet ts Inner Join TimesheetDetail tsd on ts.TimesheetId=tsd.TimesheetId where ts.TimesheetId = @TimesheetId)
  Begin
   update Timesheet set TotalHours=TotalHours-@DeletedHours Where TimesheetId=@TimesheetId
  End
Else
  Begin
   Delete From Timesheet Where TimesheetId=@TimesheetId
  End
END
GO
/****** Object:  StoredProcedure [dbo].[usp_getTimeSheetDetailByTimesheetId]    Script Date: 3/12/2024 3:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[usp_getTimeSheetDetailByTimesheetId]    Script Date: 4/22/2024 1:44:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER  PROCEDURE [dbo].[usp_getTimeSheetDetailByTimesheetId] --'mohit.nautiyal@bhavnacorp.com',0,'2024-03-31','2024-04-07',0,215
  @EmailId AS varchar(200),
  @TimesheetId int= 0,
  @StartDate datetime=Null,
  @EndDate datetime=NUll,
  @IsBehalf bit =0,
  @SelectedEmployeeIdForBehalf AS int = 0,
  @ClientId AS int = 0
AS
BEGIN

   DECLARE @EmpId int
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
GO

/****** Object:  StoredProcedure [dbo].[usp_getTimesheetEmployee]    Script Date: 4/3/2024 5:24:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_getTimesheetEmployee
CREATE OR Alter  PROCEDURE [dbo].[usp_getTimesheetEmployee]
@EmailId VARCHAR(150),
@ProjectId int=0
AS
BEGIN
SET NOCOUNT ON
 IF @EmailId IS NOT NULL

 BEGIN
 DECLARE @Role VARCHAR(100);
 DECLARE @EmployeeId int;

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

GO
/****** Object:  StoredProcedure [dbo].[usp_getTimeSheetForApprover]    Script Date: 3/12/2024 3:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[usp_getTimeSheetForApprover]
  @StatusID int,
  @EmailId AS varchar(200)
AS
BEGIN
    DECLARE @ApproverId int
   Select @ApproverId=EmployeeId from EmployeeMaster Where EmailId=@EmailId

	select EntryID,Created,'Week '+CONVERT(varchar(10), weeknumber) +' '+ CONVERT(varchar(10), EntryYear) as Period,(select dbo.GetDateFromWeekDay(EntryYear,weeknumber,1)) PeriodStart,TotalHours,StatusName  from TimesheetEntry Tse
	inner Join TimeSheetStatuses tss on Tse.StatusID=tss.StatusID
	inner Join EmployeeMaster empmst on Tse.EmployeeID=empmst.EmployeeId
	inner Join TimeSheetUserProfiles tsu on tsu.UserId = empmst.EmployeeId
	Where Tse.StatusID = @StatusID And (manager =@ApproverId Or approver1=@ApproverId Or approver2=@ApproverId) order by Created desc
END
GO
/****** Object:  StoredProcedure [dbo].[usp_saveTimesheet]    Script Date: 3/29/2024 12:00:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Or Alter   PROCEDURE [dbo].[usp_saveTimesheet]
    @HourlyData dbo.HourlyType READONLY,
	@EmailId varchar(200),
	@StatusId int,
	@Remarks NVARCHAR(255),
	@WeekStartDate datetime,
	@WeekEndDate datetime,
	@OnBehalfTimesheetCreatedFor int=0,
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

DECLARE @OnBehalfTimesheetCreatedByEmpId int;
DECLARE @EmployeeId int;

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
 -------------------------------------------------
    -- Increment the counter
    SET @Counter = @Counter + 1;
END;
END
GO
--Create Or Alter PROCEDURE [dbo].[usp_getEmailForUnsubmittedTimesheet]
--@WeekStartDate datetime,
--@WeekEndDate datetime
--AS
--BEGIN
-- Select EmailId from Timesheet tm Inner Join EmployeeMaster empM on tm.EmployeeID=empM.EmployeeId Where WeekStartDate =@WeekStartDate And WeekEndDate=@WeekEndDate And StatusId=1
--End

CREATE OR ALTER   PROCEDURE [dbo].[usp_getEmailForUnsubmittedTimesheet]  --'2024-05-05', '2024-05-11'
@WeekStartDate datetime,
@WeekEndDate datetime
AS
BEGIN
(Select EmailId from Timesheet tm
Inner Join EmployeeMaster empM on tm.EmployeeID=empM.EmployeeId
Where WeekStartDate =@WeekStartDate And WeekEndDate=@WeekEndDate And StatusId=1)
UNION
(select distinct EmailId from EmployeeMaster where
EmployeeId in (select distinct BhavnaEmployeeId from EmployeeDetails)
and EmployeeId not in (select EmployeeID from Timesheet where WeekStartDate=@WeekStartDate
And WeekEndDate=@WeekEndDate))
End

GO

Create PROCEDURE [dbo].[usp_submitTimesheetAndGetEmails]
@WeekStartDate datetime,
@WeekEndDate datetime
AS
BEGIN
 Select EmailId from Timesheet tm Inner Join EmployeeMaster empM on tm.EmployeeID=empM.EmployeeId Where  WeekStartDate =@WeekStartDate And WeekEndDate=@WeekEndDate And StatusId=1
 Update Timesheet set StatusId=2 where WeekStartDate =@WeekStartDate And WeekEndDate=@WeekEndDate And StatusId=1
End
GO
CREATE TYPE [dbo].[EmailAndWeekList] AS TABLE(
	[EmailId] [varchar](300) NOT NULL,
	[WeekStartDate] [DateTime] NOT NULL,
	[WeekEndDate] [DateTime] NOT NULL
)
GO

/****** Object:  StoredProcedure [dbo].[usp_getManagerEmails]    Script Date: 4/3/2024 5:27:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[usp_getManagerEmails]
@EmailAndWeekList dbo.EmailAndWeekList READONLY
AS
BEGIN
 Select (Select EmailId from EmployeeMaster where EmployeeId= empD.TimesheetManagerId) ManagerEmailId,empM.FullName,tm.WeekStartDate,tm.WeekEndDate from @EmailAndWeekList emailList Inner join EmployeeMaster empM on emailList.EmailId=empM.EmailId
 Inner join EmployeeDetails empD on empD.BhavnaEmployeeId=empM.EmployeeId
 Inner join Timesheet tm on empM.EmployeeId=tm.EmployeeID And emailList.WeekStartDate=tm.WeekStartDate And emailList.WeekEndDate=tm.WeekEndDate
 Inner join TeamMaster teamM on teamM.Id=tm.TeamId  And teamM.Id=empD.TeamId
End

GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateTimeSheetStatus]    Script Date: 3/12/2024 3:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UpdateTimesheetEmployeeDetails --UpdateTimesheetEmployeeDetails
CREATE OR ALTER PROCEDURE [dbo].[UpdateTimesheetEmployeeDetails]
(
@EmployeeId INT,
@ManagerId INT,
@FirstApproverId INT,
@SecondApproverId INT,
@TeamId INT
)

AS
BEGIN
	UPDATE EmployeeDetails
	SET TimesheetManagerId = @ManagerId,
	    TimesheetApproverId1 = @FirstApproverId,
        TimesheetApproverId2 = @SecondApproverId
        WHERE EmployeeId = @EmployeeId
		AND TeamId = @TeamId;
END;
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateTimeSheetStatus]    Script Date: 4/1/2024 1:02:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdateTimeSheetStatus]    Script Date: 4/1/2024 1:02:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_UpdateTimeSheetStatus -- usp_updateTimeSheetStatus

CREATE OR Alter  PROCEDURE [dbo].[usp_UpdateTimeSheetStatus]
@statusId AS int,
@EmployeeEmailId AS varchar(200),
@StartDate Datetime,
@EndDate Datetime,
@TimesheetId int,
@OnBehlfEmpId int=0
AS
BEGIN
   DECLARE @query  AS NVARCHAR(MAX)
   DECLARE @EmpId int
   Select @EmpId=EmployeeId from EmployeeMaster WHERE EmailId=@EmployeeEmailId
   If(@OnBehlfEmpId !=0)
   Begin
     Set @EmpId =@OnBehlfEmpId
   End
    IF(@statusId=1 OR @statusId=2 OR @statusId=3)
	 BEGIN
	 update ts Set StatusID= @statusId,Modified=GETDATE(),SubmissionDate=GETDATE() from EmployeeMaster empmst
			Inner Join timesheet ts on empmst.EmployeeId= ts.EmployeeId
			Inner join EmployeeDetails empDet on empDet.BhavnaEmployeeId= empmst.EmployeeId And empDet.TeamId=ts.TeamId
			Inner join TeamMaster tm on tm.Id =empDet.TeamId
			Inner join ClientMaster cli on cli.Id =ts.ClientId
			Where (@TimesheetId = 0 And ts.WeekStartDate=@StartDate And ts.WeekEndDate<=@EndDate AND ts.EmployeeID=@EmpId And ts.StatusId !=4) OR (@TimesheetId !=0 And ts.TimesheetId=@TimesheetId)
	 END
execute(@query)
END
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateTimeSheetStatusForApprover]    Script Date: 4/1/2024 12:58:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--usp_UpdateTimeSheetStatusForApprover -- usp_updateTimeSheetStatusForApprover
CREATE OR Alter PROCEDURE [dbo].[usp_UpdateTimeSheetStatusForApprover]
@StatusId AS int,
@EmpIds AS NVARCHAR(MAX),
@TimesheetIds AS NVARCHAR(MAX),
@Remarks AS NVARCHAR(MAX),
@ApproverEmailId AS varchar(200)
AS
BEGIN
   DECLARE @query  AS NVARCHAR(MAX)
   DECLARE @ApproverId int
   Select @ApproverId=EmployeeId from EmployeeMaster WHERE EmailId=@ApproverEmailId
	DECLARE @EmployeeRole varchar(200)
	Select @EmployeeRole=r.RoleName from EmployeeRoles er  inner join Roles r on er.RoleId=r.RoleId where er.EmployeeId = @ApproverId
   IF EXISTS(SELECT 1 from EmployeeDetails WHERE BhavnaEmployeeId in (select value from string_split(@EmpIds, ',')) and ( TimesheetManagerId=@ApproverId or TimesheetApproverId1 =@ApproverId or TimesheetApproverId2=@ApproverId))
   BEGIN
     IF (@statusId=3 OR @statusId=4)
	 BEGIN
	  set @query = 'update ts Set StatusID= '+ cast(@statusId as varchar) +', Remarks='''+@Remarks+''',Modified = GETDATE(),ApprovedDate= GETDATE() from EmployeeMaster empmst
				Inner Join timesheet ts on empmst.EmployeeId= ts.EmployeeId
				Inner join EmployeeDetails empD on empD.BhavnaEmployeeId = empmst.EmployeeId
				where empmst.employeeId !=  @Param  and empmst.employeeId in (' + @empIds + ') and TimesheetId in (' + @TimesheetIds + ') and (TimesheetManagerId ='+ cast(@ApproverId as varchar) +' Or TimesheetApproverId1='+ cast(@ApproverId as varchar) +' Or TimesheetApproverId2='+ cast(@ApproverId as varchar) +')'
	 END
   END
   ELSE
   BEGIN
    IF (@statusId=3 OR @statusId=4)
	 BEGIN
	  set @query = 'update ts Set StatusID= '+ cast(@statusId as varchar) +', Remarks='''+@Remarks+''',Modified = GETDATE(),ApprovedDate= GETDATE() from EmployeeMaster empmst
				Inner Join timesheet ts on empmst.EmployeeId= ts.EmployeeId
				Inner join EmployeeDetails empD on empD.BhavnaEmployeeId = empmst.EmployeeId
				where
				empmst.employeeId in (' + @empIds + ') and TimesheetId in (' + @TimesheetIds + ')'
	 END
   END
execute sp_executesql @query,N'@Param INT',@Param=@ApproverId
END

GO

/****** Object:  StoredProcedure [dbo].[usp_gettimesheetcategory]    Script Date: 3/18/2024 5:44:55 PM ******/
--CREATE procedure [dbo].[usp_gettimesheetcategory] (@emailId varchar(200))
--as
--begin

--declare @function varchar(500)
--set @function= (select top 1 type from EmployeeDetails where TeamId= (select TeamId from EmployeeMaster where EmailId=@emailId) )


--SELECT  200 + ROW_NUMBER() over(order by TimeSheetCategoryID), * FROM TimeSheetCategory where  [Function]=@function
--union
--SELECT 1000000 + ROW_NUMBER() over(order by TimeSheetCategoryID),* FROM TimeSheetCategory where [Function] <> @function

--end

CREATE OR ALTER procedure [dbo].[usp_gettimesheetcategory] --'viraja.vittala@bhavnacorp.com'
(@emailId varchar(200))
as
begin

declare @employeeId int
set @employeeId = (select employeeId from EmployeeMaster where EmailId=@emailId)
declare @function varchar(500)
set @function=(select top 1 type from EmployeeDetails where bhavnaEmployeeId=@employeeId)


SELECT  200 + ROW_NUMBER() over(order by TimeSheetCategoryID), * FROM TimeSheetCategory where  [Function]=@function
union
SELECT 1000000 + ROW_NUMBER() over(order by TimeSheetCategoryID),* FROM TimeSheetCategory where [Function] <> @function

end

GO


/****** Object:  StoredProcedure [dbo].[GetAllEmployeeIds]    Script Date: 3/29/2024 9:57:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAllEmployeeIds]
As
BEGIN
	SELECT EmployeeId
	FROM EmployeeMaster
END;


/****** Object:  StoredProcedure [dbo].[usp_getClientMasterByEmployeeId]    Script Date: 3/28/2024 8:58:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[usp_getClientMasterByEmployeeId] --'test02@bhavnacorp.com'
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
ELSE IF (@Role = 'Reporting_Manager')
BEGIN
			set @sql='SELECT * FROM ClientMaster where Id  = '+ cast(@ClientId as varchar(20))


END
ELSE IF (@Role = 'EMPLOYEE')
	BEGIN
		    set @sql='SELECT distinct client.* FROM ClientMaster client
						INNER join TeamMaster team on client.Id= team.ClientId
						WHERE  team.Id is not null and client.Id  = '+ cast( @ClientId as varchar)


END
EXECUTE 	sp_executesql @sql
END
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[usp_getEmployeeRoleDetailByEmailId] --'Viraja.Vittala@bhavnacorp.com'
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
 declare @EmployeeName varchar(max)=''


 SELECT TOP(1) @TeamId=EmployeeDetails.TeamId, @Role=Roles.RoleName, @EmployeeId=EmployeeMaster.EmployeeId,
 @RoleId = Roles.RoleId,@ClientId = TeamMaster.ClientId, @EmployeeName = EmployeeMaster.FullName
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
		 @RoleId = Roles.RoleId, @EmployeeName = EmployeeMaster.FullName
		 FROM EmployeeMaster
		 INNER JOIN EmployeeRoles ON EmployeeRoles.EmployeeId = EmployeeMaster.EmployeeId
		 INNER JOIN Roles ON Roles.RoleId = EmployeeRoles.RoleId
		 WHERE EmployeeMaster.EmailId  = @EmailId;
	END
	END
	END

	SELECT @RoleId AS RoleId, @TeamId AS TeamId, @Role AS RoleName, @EmployeeId AS EmployeeId, @ClientId AS ClientId, @EmployeeName as EmployeeName

END

GO
-----------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[usp_getTimesheetCategoryByEmployeeId]    Script Date: 4/09/2024 9:06:28 PM Author: Akash Maurya ******/
GO

USE [AutomationUAT]
GO
/****** Object:  StoredProcedure [dbo].[usp_getTimesheetCategoryByEmployeeId]    Script Date: 4/30/2024 5:28:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER  procedure [dbo].[usp_getTimesheetCategoryByEmployeeId] --'test01@bhavnacorp.com', 0
@emailId varchar(200),
@employeeIdParam int
as
begin
declare @roleId int
declare @employeeId int
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
		SELECT 1000000 + ROW_NUMBER() over(order by TimeSheetCategoryID),* FROM TimeSheetCategory where [Function] = ('Common') and
		TimeSheetCategoryID IN (select Distinct TimeSheetCategoryID from TimeSheetSubcategory)
END;
end
GO

CREATE TYPE [dbo].[ClientWiseHoursTotal] AS TABLE(
	[ClientId] [int] NOT NULL,
	[TotalHours] [decimal](5, 2) NOT NULL
)
GO
CREATE OR ALTER    PROCEDURE [dbo].[usp_saveTimesheetV2]
    @HourlyData dbo.HourlyType READONLY,
    @ClientHoursTotal dbo.ClientWiseHoursTotal READONLY,
	@EmailId varchar(200),
	@StatusId int,
	@Remarks NVARCHAR(255),
	@WeekStartDate datetime,
	@WeekEndDate datetime,
	@OnBehalfTimesheetCreatedFor int=0,
	@OnBehalfTimesheetCreatedByEmail varchar(200)='',
	@TimesheetId int =0
AS
BEGIN
DECLARE @Counter INT = 1;
DECLARE @MaxCounter INT;

DECLARE @TimesheetIdTodelete INT;

Select @TimesheetIdTodelete =ts.TimesheetId from Timesheet ts
Inner join TimesheetDetail tsd On ts.TimesheetId=tsd.TimesheetId Left Join @HourlyData hd On ts.ClientId=hd.ClientId Where ts.WeekStartDate=@WeekStartDate And WeekEndDate=@WeekEndDate And StatusId=@StatusId And hd.ClientId Is null

Delete from TimesheetDetail Where id in(Select tsd.Id from Timesheet ts
inner join
TimesheetDetail tsd On ts.TimesheetId=tsd.TimesheetId Where ts.WeekStartDate=@WeekStartDate And WeekEndDate=@WeekEndDate And StatusId=@StatusId);

Delete from Timesheet Where TimesheetId =@TimesheetIdTodelete;

	With t As(
SELECT   ClientId, ROW_NUMBER() OVER (ORDER BY ClientId) AS Id FROM
    (SELECT ClientId FROM @ClientHoursTotal) Cws) Select @MaxCounter= MAX(Id) from t

DECLARE @OnBehalfTimesheetCreatedByEmpId int;
DECLARE @EmployeeId int;

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
SELECT   ClientId,TotalHours, ROW_NUMBER() OVER (ORDER BY ClientId) AS Id FROM
    (SELECT ClientId,TotalHours FROM @ClientHoursTotal) Cws) Select @ClientId= ClientId from t where Id=@Counter
 -------------------------------------------------
 SET NoCount on;
	DECLARE @InsertedTimesheetID INT;
	DECLARE @TotalHours float;
	DECLARE @TeamId int;


    Select @TeamId=tm.Id from TeamMaster tm Inner Join EmployeeDetails emp on tm.Id=emp.TeamId
	inner join EmployeeMaster em on em.EmployeeId=emp.BhavnaEmployeeId Where em.EmployeeId=@EmployeeId And tm.ClientId=@ClientId
	SELECT @TotalHours=TotalHours FROM @ClientHoursTotal Where ClientId=@ClientId

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
    Insert into TimesheetDetail select @InsertedTimesheetID,CategoryId,SubCategoryId,TaskDescription,'HH',HourValue,(select dbo.GetDateOfWeek(@WeekStartDate,DayOfWeek)) from @HourlyData Where ClientId=@ClientId

	Select @InsertedTimesheetID As TimesheeId
 -------------------------------------------------
    -- Increment the counter
    SET @Counter = @Counter + 1;
END;
END
GO

CREATE OR ALTER PROCEDURE usp_getemployeeapprovalAssigned --9,1
@clientid int,
@teamId int
AS
BEGIN

		SELECT distinct desig.designation, emp.FullName as EmployeeName , emp.EmployeeId from EmployeeMaster emp
		join EbDesignation desig on emp.DesignationId= desig.Id
		WHERE designation like '%Manager%'
		ORDER BY emp.FullName

		SELECT distinct desig.designation, emp.FullName  as EmployeeName , emp.EmployeeId from EmployeeMaster emp
		join EbDesignation desig on emp.DesignationId= desig.Id
		join EmployeeDetails detail on detail.BhavnaEmployeeId = emp.EmployeeId
		WHERE (designation like '%lead%' or designation like '%architect%' or designation like '%Engineer-II%' or designation like '%Manager%')  and   detail.TeamId = @teamId
		ORDER BY emp.FullName
END
GO

CREATE OR ALTER PROCEDURE [dbo].[UpdateTimesheetEmployeeDetail]
(
@EmployeeId INT,
@ManagerId INT,
@FirstApproverId INT,
@SecondApproverId INT,
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[GetEmployeeDetailsByTeamId](
  @TeamId INT
)
AS
BEGIN
  SELECT t2.EmployeeId, t1.TeamId, t1.EmployeeName, t1.TimesheetManagerId, t1.TimesheetApproverId1, t1.TimesheetApproverId2
  FROM EmployeeDetails t1
  INNER JOIN EmployeeMaster t2
ON t1.BhavnaEmployeeId = t2.EmployeeId
  WHERE t1.TeamId = @TeamId
  ORDER BY t1.EmployeeName;
END;
GO

-- =============================================
-- Author:  <Chetna Upadhyay>
-- Create date: <7/9/2024>
-- Description: <Get list of soft delete employees>
-- =============================================
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