/****** Object:  Table [DIM].[RESOURCE_WORKLOAD]    Script Date: 4/26/2019 2:21:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DIM].[MISSING_MATERIAL_INFO] (
	[_eventID__] [bigint] NOT NULL,
	[_case_concept_name_] [nvarchar](100) NULL,
	[_event_concept_name_] [nvarchar](100) NULL,
	[is_material_missing] INT NULL,
	[_case_Spend_area_text_] nvarchar(100) NULL,
    [_case_Sub_spend_area_text_] nvarchar(100) NULL,
	[_case_Spend_classification_text_] nvarchar(100) NULL
) ON [PRIMARY]
GO


