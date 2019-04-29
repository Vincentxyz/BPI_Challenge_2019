DELETE FROM stg.excluded_cases WHERE exclusion_reason <> 'Incomplete case (no payment)';
Go

-- Add cases without payment (incomplete cases)
INSERT INTO stg.excluded_cases
SELECT DISTINCT
_case_concept_name_,
'Incomplete case (no payment)'
FROM stg.case_table
WHERE _case_concept_name_ NOT IN 
(select DISTINCT _case_concept_name_ FROM stg.event_table
WHERE _event_concept_name_ = 'Clear Invoice')
AND _case_Item_Category_ <> 'Consignment';
Go