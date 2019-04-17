CCREATE VIEW PTP.case_table AS 
SELECT *
FROM stg.case_table
WHERE _case_concept_name_ NOT IN (SELECT DISTINCT _case_concept_name_ FROM stg.filtered_cases);
Go