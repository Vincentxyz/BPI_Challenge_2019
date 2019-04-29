USE ProMi;
Go

CREATE TABLE stg.excluded_cases (
	"_case_concept_name_" NVARCHAR(100)
	, "exclusion_reason" NVARCHAR(100)
);
Go


CREATE INDEX ix_filtered_cases ON stg.filtered_cases(_case_concept_name_);
Go