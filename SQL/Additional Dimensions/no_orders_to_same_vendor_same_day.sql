DROP TABLE IF EXISTS DIM.case_number_of_orders_created_same_day_and_vendor;
Go

SELECT YEAR(_event_time_timestamp_) AS creation_year,
MONTH(_event_time_timestamp_) AS creation_month,
DAY(_event_time_timestamp_)  AS creation_day,
_case_Vendor_,
COUNT(_case_Purchasing_Document_) AS number_of_orders
INTO #no_orders_per_day
FROM PROM.Event_Log_All
WHERE _event_concept_name_ = 'Create Purchase Order Item'
GROUP BY YEAR(_event_time_timestamp_),
MONTH(_event_time_timestamp_),
DAY(_event_time_timestamp_),
_case_Vendor_

SELECT _case_concept_name_, 
ISNULL(number_of_orders,0) AS number_of_orders_created_same_day_and_vendor
INTO DIM.case_number_of_orders_created_same_day_and_vendor
FROM PROM.Event_log_All A
LEFT JOIN #no_orders_per_day B
ON YEAR(A._event_time_timestamp_) = B.creation_year
AND MONTH(A._event_time_timestamp_) = B.creation_month
AND DAY(A._event_time_timestamp_) = B.creation_day
AND A._case_Vendor_ = B._case_Vendor_
GROUP BY _case_concept_name_,_event_concept_name_, creation_year, creation_month, creation_day, A._case_Vendor_, number_of_orders
HAVING _event_concept_name_ = 'Create Purchase Order Item'