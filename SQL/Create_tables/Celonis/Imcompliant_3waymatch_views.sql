CREATE VIEW CELONIS.case_table_01_incompliant
AS
select T1.*
from stg.case_table_filtered T1
where _case_concept_name_ in 
(select  _case_concept_name_
--,is_complete,is_compliant
 from stg.case_compliance 
where is_complete=0 
and 
_case_item_category_='3-way match, invoice after GR')



CREATE VIEW CELONIS.event_table_01_incompliant
AS
select T1.*
from stg.event_table_filtered T1
where _case_concept_name_ in 
(select  _case_concept_name_ from 
CELONIS.case_table_01_incompliant)