/* 
Calculate frequency of oders by the group(_case_Sub_spend_area_text_,_case_Vendor_,case_Document_Type_) within 1 month
*/

SELECT YEAR(A._event_time_timestamp_) AS year,
	   MONTH(A._event_time_timestamp_) AS month,	
		A._case_Sub_spend_area_text_,
		A._case_Vendor_,
		A._case_Document_Type_,
	   COUNT(DISTINCT A.[_case_Purchasing_Document_]) AS [FREQ ORDER]

INTO [DIM].[frequency_order]

FROM [PROM].[Event_Log_All] A, [PROM].[Event_Log_All] AA
		where  A._case_Sub_spend_area_text_=AA._case_Sub_spend_area_text_
		AND A._case_Vendor_=AA._case_Vendor_
		AND  A._case_Document_Type_=AA._case_Document_Type_
		and YEAR(AA._event_time_timestamp_)=YEAR(A._event_time_timestamp_) 
		and MONTH(AA._event_time_timestamp_)=MONTH(A._event_time_timestamp_) 
GROUP BY 
       YEAR(A._event_time_timestamp_),
       MONTH(A._event_time_timestamp_),
	   A._case_Sub_spend_area_text_,A._case_Vendor_,A._case_Document_Type_
