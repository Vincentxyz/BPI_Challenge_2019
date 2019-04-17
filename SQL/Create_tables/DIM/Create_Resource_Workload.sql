/****** Object:  Table [stg].[event_table]    Script Date: 4/17/2019 3:23:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DIM].[resource_load](
	
	[_event_User_] [nvarchar](100) NULL,
	
	[_event_time_timestamp_] [datetime] NULL,
	[_eventID__] [bigint] NOT NULL,
	[task_load] [bigint] NOT NULL
 )
GO


