-- Filter table -  the cases which have event 'Cancel Goods Receipt' or 'Cancel Invoice Receipt'

SELECT DISTINCT _case_concept_name_
INTO stg.cancel_receipt_cases
FROM PROM.Event_log_All
where
_event_concept_name_ in ('Cancel Goods Receipt','Cancel Invoice Receipt');