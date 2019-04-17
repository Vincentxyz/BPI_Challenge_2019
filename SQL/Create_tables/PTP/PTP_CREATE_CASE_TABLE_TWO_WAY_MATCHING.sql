CREATE View PTP.case_table_two_way_matching 
as
Select * from [PTP].[case_table]
where _case_GR_Based_Inv__Verif__ = 'false' and _case_Goods_Receipt_ = 'false'
GO