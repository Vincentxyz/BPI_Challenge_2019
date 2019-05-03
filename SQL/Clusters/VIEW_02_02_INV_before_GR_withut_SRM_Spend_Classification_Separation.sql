CREATE VIEW PROM.CLUSTER_02_02_01_compliant_INV_before_GR_without_SRM_PR_Spend
AS 
SELECT *
FROM PROM.CLUSTER_02_02_compliant_INV_before_GR_without_SRM
WHERE _case_Spend_classification_text_ = 'PR';
Go

CREATE VIEW PROM.CLUSTER_02_02_02_compliant_INV_before_GR_without_SRM_NPR_Spend
AS 
SELECT *
FROM PROM.CLUSTER_02_02_compliant_INV_before_GR_without_SRM
WHERE _case_Spend_classification_text_ = 'NPR';
Go

CREATE VIEW PROM.CLUSTER_02_02_03_compliant_INV_before_GR_without_SRM_Other_Spend
AS 
SELECT *
FROM PROM.CLUSTER_02_02_compliant_INV_before_GR_without_SRM
WHERE _case_Spend_classification_text_ IN ('OTHER','');
Go