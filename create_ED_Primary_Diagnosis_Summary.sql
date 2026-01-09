#Author: Keri W.
#Date: 08 January 2025

#Creating ED_Primary_Diagnosis view with columns, stay_icd, icd_code, and icd_title, from table Diagnoses. 
The columns selected are filtered to only include rows where seq_num equals 1. 
CREATE VIEW ED_Primary_Diagnosis AS
SELECT
    stay_id,
    icd_code,
    icd_title
FROM Diagnoses
WHERE seq_num = 1;
