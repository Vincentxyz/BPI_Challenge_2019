SELECT *
INTO stg.NEW_case_table_filtered
FROM stg.case_table
WHERE _case_concept_name_ NOT IN (SELECT DISTINCT _case_concept_name_ FROM stg.excluded_cases);
Go

CREATE INDEX NEW_ix_case_table_filtered
ON stg.NEW_case_table_filtered (_case_concept_name_)