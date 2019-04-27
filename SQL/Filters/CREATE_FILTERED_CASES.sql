USE ProMi;
Go

CREATE TABLE stg.filtered_cases (
	"_case_concept_name_" NVARCHAR(100)
	, "exclusion_reason" NVARCHAR(100)
);
Go

-- Add timeframe exlusions
INSERT INTO stg.filtered_cases
SELECT DISTINCT
_case_concept_name_,
'Case not in extraction timeframe'
FROM stg.event_table
WHERE YEAR(_event_time_timestamp_) < 2018
OR _event_time_timestamp_ > '2019-01-28';
Go

DELETE FROM stg.filtered_cases WHERE exclusion_reason <> 'Incomplete case (no payment)';
Go

-- Add cases without payment (incomplete cases)
INSERT INTO stg.filtered_cases
SELECT DISTINCT
_case_concept_name_,
'Incomplete case (no payment)'
FROM stg.case_table
WHERE _case_concept_name_ NOT IN 
(select DISTINCT _case_concept_name_ FROM stg.event_table
WHERE _event_concept_name_ = 'Clear Invoice')
AND _case_Item_Category_ <> 'Consignment';
Go


CREATE INDEX ix_filtered_cases ON stg.filtered_cases(_case_concept_name_);
Go