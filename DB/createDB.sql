USE [Toets]
GO
/****** Object:  Table [dbo].[Students]    Script Date: 04/13/2012 14:44:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students](
	[LastName] [nvarchar](255) NULL,
	[FirstName] [nvarchar](255) NULL,
	[Class] [nvarchar](255) NULL,
	[Id] [nvarchar](255) NULL,
	[Department] [nvarchar](255) NULL,
	[Photo] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Quiz_Summary]    Script Date: 04/13/2012 14:44:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quiz_Summary](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[quiz_id] [int] NULL,
	[lastmodified] [datetime] NULL,
	[network_id] [nvarchar](50) NULL,
	[status] [nvarchar](50) NULL,
	[raw_score] [nvarchar](50) NULL,
	[passing_score] [nvarchar](50) NULL,
	[max_score] [nvarchar](50) NULL,
	[min_score] [nvarchar](50) NULL,
	[time] [nvarchar](50) NULL,
	[class] [nvarchar](50) NULL,
 CONSTRAINT [PK_Quiz_Summary] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Quiz_Detail]    Script Date: 04/13/2012 14:44:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quiz_Detail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[summary_id] [int] NOT NULL,
	[lastmodified] [datetime] NULL,
	[timestamp] [datetime] NULL,
	[score] [nvarchar](50) NULL,
	[interaction_id] [nvarchar](50) NULL,
	[objective_id] [nvarchar](50) NULL,
	[interaction_type] [nvarchar](50) NULL,
	[student_response] [nvarchar](max) NULL,
	[result] [nvarchar](50) NULL,
	[weight] [nvarchar](50) NULL,
	[latency] [nvarchar](50) NULL,
	[question] [nvarchar](max) NULL,
 CONSTRAINT [PK_Quiz_Detail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Quiz]    Script Date: 04/13/2012 14:44:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quiz](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[quizname] [nvarchar](100) NULL,
 CONSTRAINT [PK_Quiz] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwSummary]    Script Date: 04/13/2012 14:44:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwSummary]
AS
SELECT     dbo.Quiz_Summary.ID AS qsId, dbo.Quiz_Summary.quiz_id, dbo.Quiz_Summary.lastmodified, dbo.Quiz_Summary.network_id, dbo.Quiz_Summary.status, 
                      dbo.Quiz_Summary.raw_score, dbo.Quiz_Summary.passing_score, dbo.Quiz_Summary.max_score, dbo.Quiz_Summary.min_score, dbo.Quiz_Summary.time, 
                      dbo.Students.LastName, dbo.Students.FirstName, dbo.Students.Id AS StudentId, dbo.Students.Department, dbo.Students.Photo, dbo.Quiz.quizname, 
                      dbo.Quiz_Summary.class AS CurrentClass, dbo.Students.Class
FROM         dbo.Quiz_Summary INNER JOIN
                      dbo.Students ON dbo.Quiz_Summary.network_id = 'DOMAIN\' + dbo.Students.Id INNER JOIN
                      dbo.Quiz ON dbo.Quiz_Summary.quiz_id = dbo.Quiz.ID
GO
CREATE VIEW [dbo].[vwDetails]
AS
SELECT     dbo.Quiz.ID AS quizId, dbo.Quiz_Detail.ID, dbo.Quiz_Detail.summary_id, dbo.Quiz_Detail.lastmodified, dbo.Quiz_Detail.timestamp, dbo.Quiz_Detail.score, 
                      dbo.Quiz_Detail.interaction_id, dbo.Quiz_Detail.objective_id, LEFT(SUBSTRING(dbo.Quiz_Detail.objective_id, 9, 5), LEN(dbo.Quiz_Detail.objective_id) - 10) 
                      AS questionNum, dbo.Quiz_Detail.interaction_type, dbo.Quiz_Detail.student_response, dbo.Quiz_Detail.result, dbo.Quiz_Detail.weight, dbo.Quiz_Detail.latency, 
                      dbo.Quiz_Detail.question, dbo.Quiz_Summary.raw_score, dbo.Quiz.quizname, dbo.Students.LastName, dbo.Students.FirstName, dbo.Students.Class, 
                      dbo.Students.Id AS StudentId, dbo.Students.Photo, dbo.Quiz_Summary.class AS CurrentClass
FROM         dbo.Quiz INNER JOIN
                      dbo.Quiz_Summary ON dbo.Quiz.ID = dbo.Quiz_Summary.quiz_id INNER JOIN
                      dbo.Quiz_Detail ON dbo.Quiz_Summary.ID = dbo.Quiz_Detail.summary_id INNER JOIN
                      dbo.Students ON dbo.Quiz_Summary.network_id = 'DOMAIN\' + dbo.Students.Id
GO
