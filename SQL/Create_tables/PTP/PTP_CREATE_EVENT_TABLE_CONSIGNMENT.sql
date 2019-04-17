/****** Object:  View [PTP].[event_table_Consignment]    Script Date: 4/17/2019 2:40:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [PTP].[event_table_Consignment]
AS SELECT *
FROM PTP.event_table
WHERE event_table._case_concept_name_ IN 
(SELECT _case_concept_name_ FROM PTP.case_table_Consignment)
GO


