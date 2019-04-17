/****** Object:  View [PTP].[case_table_Consignment]    Script Date: 4/17/2019 2:39:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE View [PTP].[case_table_Consignment]
as
Select * from [PTP].[case_table]
where _case_GR_Based_Inv__Verif__ like 'false%' and _case_Goods_Receipt_ like 'true%' and _case_Item_Type_ like 'Consignment%'
GO


