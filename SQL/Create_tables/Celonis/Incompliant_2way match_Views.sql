CREATE VIEW CELONIS.event_table_03_incompliant
AS
select T1.*
from stg.event_table_filtered T1
where _case_concept_name_ in 
(select  _case_concept_name_ from stg.case_compliance where is_complete=0 and 
_case_item_category_='2-way match')

CREATE VIEW CELONIS.case_table_03_incompliant
AS
select T1.*
from stg.case_table_filtered T1
where _case_concept_name_ in 
(select  _case_concept_name_ from stg.case_compliance where is_complete=0 and 
_case_item_category_='2-way match')