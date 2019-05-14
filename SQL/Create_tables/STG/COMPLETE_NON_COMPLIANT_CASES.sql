-- Complete non compliant cases (other than Consignment category)
Select distinct _case_concept_name_
INTO stg.cases_not_consignment_but_complete
from stg.event_table
where _case_concept_name_ in (Select _case_concept_name_
from [stg].[case_compliance]
where is_compliant=0  and _case_item_category_!='Consignment')
and _event_concept_name_ like 'Clear Invoice'


-- Complete non compliant cases ( Consignment category)
Select distinct _case_concept_name_
INTO stg.cases_consignment_but_complete
from stg.event_table
where _case_concept_name_ in (Select _case_concept_name_
from [stg].[case_compliance]
where is_compliant=0  and _case_item_category_='Consignment')
and _event_concept_name_ like 'Record Goods Receipt'

--
ALTER TABLE [stg].[case_compliance]
ADD is_complete int;

-- ALl compliant cases as complete
UPDATE [stg].[case_compliance] SET is_complete=1
WHERE is_compliant=1
GO

-- 
UPDATE [stg].[case_compliance] SET is_complete=1
WHERE _case_concept_name_ in (Select _case_concept_name_
from [stg].[cases_not_consignment_but_complete])
GO
--
UPDATE [stg].[case_compliance] SET is_complete=1
WHERE _case_concept_name_ in (Select _case_concept_name_
from [stg].[cases_consignment_but_complete])
GO

-- 
UPDATE [stg].[case_compliance] SET is_complete=0
WHERE is_complete IS NULL
GO

UPDATE [stg].[case_compliance] SET is_complete=0
WHERE _case_item_category_='3-way match, invoice after GR' 
and Sum_IR<Sum_GR  
and _case_concept_name_
IN (Select  _case_concept_name_ from stg.cases_not_consignment_but_complete)
GO

UPDATE [stg].[case_compliance] SET is_complete=0
WHERE _case_item_category_='3-way match, invoice before GR' 
and Deviation <> 0 
and _case_concept_name_
IN (Select  _case_concept_name_ from stg.cases_not_consignment_but_complete)
GO