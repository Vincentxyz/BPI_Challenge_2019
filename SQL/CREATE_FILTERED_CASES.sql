USE ProMi;
Go

CREATE TABLE stg.filtered_cases (
	"_case_concept_name_" NVARCHAR(100)
	, "exclusion_reason" NVARCHAR(100)
)

-- Add timeframe exlusions
INSERT INTO stg.filtered_cases
SELECT 
_case_concept_name_,
'Case not in extraction timeframe'
FROM stg.event_table
WHERE YEAR(_event_time_timestamp_) < 2018
OR _event_time_timestamp_ > '2019-01-28'



CREATE INDEX ix_filtered_cases ON stg.case_table (_case_concept_name_);
Go