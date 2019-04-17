CREATE View PTP.case_table_INV_after_GR
as
Select * from [PTP].[case_table]
where _case_GR_Based_Inv__Verif__ like 'true%' and _case_Goods_Receipt_ like 'true%'
GO