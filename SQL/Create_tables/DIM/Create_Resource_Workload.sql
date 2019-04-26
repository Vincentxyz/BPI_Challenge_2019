/****** Object:  Table [DIM].[resource_load]    Script Date: 4/26/2019 1:38:37 PM ******/
DROP TABLE [DIM].[resource_load]
GO

/****** Object:  Table [DIM].[resource_load]    Script Date: 4/26/2019 1:38:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DIM].[RESOURCE_WORKLOAD](
	[_eventID__] [bigint] NOT NULL,
	[_event_User_] [nvarchar](100) NULL,
	[_event_time_timestamp_] [datetime] NULL,
	[_case_concept_name_] nvarchar(100) NULL,
	[_event_concept_name_] nvarchar(100) NULL,
	[task_load_past_two_days] [bigint] NOT NULL,
	[task_load_past_seven_days] [bigint] NOT NULL
) ON [PRIMARY]
GO


