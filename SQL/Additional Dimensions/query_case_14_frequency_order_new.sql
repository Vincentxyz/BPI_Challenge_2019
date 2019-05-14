/* 
Calculate frequency of oders by the group(_case_Sub_spend_area_text_,_case_Vendor_,case_Document_Type_) within 1 month
*/

DROP TABLE IF EXISTS [DIM].[frequency_order_new];
Go

SELECT A._case_concept_name_
,A._case_Sub_spend_area_text_,
		A._case_Vendor_,
		A._case_Document_Type_,
	   COUNT(DISTINCT AA._case_concept_name_) AS [frequency_equal_order_less_than_one_month_before]

INTO [DIM].[case_frequency_order]

FROM [PROM].[Event_Log_All] A, [PROM].[Event_Log_All] AA
		where  A._case_Sub_spend_area_text_=AA._case_Sub_spend_area_text_
		AND A._case_Vendor_=AA._case_Vendor_
		AND  A._case_Document_Type_=AA._case_Document_Type_
		AND A._case_Document_Type_ = AA._case_Document_Type_
		and A._event_time_timestamp_ between DATEADD(dd,-30,AA._event_time_timestamp_) and AA._event_time_timestamp_
GROUP BY 
	   A._case_concept_name_, A._case_Sub_spend_area_text_,A._case_Vendor_,A._case_Document_Type_
