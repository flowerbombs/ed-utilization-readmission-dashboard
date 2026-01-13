#Author: Keri W.
#Date: 12 January 2026

#Sanity check in preparation of a left join between ED_Stays_Summary and ED_Revistis_Summary on stay_id and
first_stay_id.
SELECT COUNT(first_stay_id) AS first_stay_id_counts
	FROM ED_Revisits_Summary;

#Create ED_Encounter_Analytics view by using a left join on views ED_Stays_Summary, ED_Revisits_Summary, 
and ED_Primary_Diagnosis on primary key stay_id. ED_Encounter_Analytics represents one row per ED stay, 
enriched with revisit metrics and primary diagnosis information when available, and is intended for analytics
and dashboard reporting. 
CREATE OR ALTER VIEW ED_Encounter_Analytics AS
SELECT
  ED_Stays_Summary.stay_id,
  ED_Stays_Summary.subject_id,
  ED_Stays_Summary.intime,
  ED_Stays_Summary.outtime,
  ED_Stays_Summary.ed_los_minutes,
  ED_Stays_Summary.gender,
  ED_Stays_Summary.race,
  ED_Stays_Summary.arrival_transportation,
  ED_Stays_Summary.disposition,
  ED_Stays_Summary.acuity,
  ED_Stays_Summary.chiefcomplaint,
  ED_Stays_Summary.pain_score,
  ED_Stays_Summary.temperature,
  ED_Stays_Summary.triage_heart_rate, 
  ED_Stays_Summary.respiratory_rate,
  ED_Stays_Summary.oxygen_saturation,
  ED_Stays_Summary.systolic_bp,
  ED_Stays_Summary.diastolic_bp,
  ED_Stays_Summary.pain,
  ED_Revisits_Summary.next_ed_intime,
  ED_Revisits_Summary.days_to_next_ed_visit,
  ED_Revisits_Summary.total_future_ed_visits,
  ED_Revisits_Summary.revisit_72hr_flag,
  ED_Revisits_Summary.revisit_7day_flag,
  ED_Primary_Diagnosis_Summary.icd_code,
  ED_Primary_Diagnosis_Summary.icd_title
  
FROM ED_Stays_Summary 
LEFT JOIN  ED_Revisits_Summary ON ED_Stays_Summary.stay_id =  ED_Revisits_Summary.stay_id
LEFT JOIN  ED_Primary_Diagnosis_Summary ON ED_Stays_Summary.stay_id = ED_Primary_Diagnosis_Summary.stay_id;

#Counting total rows for data validation with output included. 
SELECT
	COUNT(*) AS total_rows
FROM ED_Revisits_Summary;

total_rows
68936

#Checking all columns in ED_Encounter_Analytics for nulls to compare nulls before database creation with output included. 
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql = STRING_AGG(
    'SUM(CASE WHEN ' + QUOTENAME(COLUMN_NAME) + ' IS NULL THEN 1 ELSE 0 END) AS ' + QUOTENAME('null_' + COLUMN_NAME),
    ', '
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ED_Encounter_Analytics';

SET @sql = 'SELECT COUNT(*) AS total_rows, ' + @sql + ' FROM ED_Encounter_Analytics;';
EXEC sp_executesql @sql;

null_temperature	null_triage_heart_rate	null_respiratory_rate	null_oxygen_saturation	null_systolic_bp	null_diastolic_bp	null_pain	
6661	               5234	                       5970	                    5986	               5390	               5542	           3635	
null_next_ed_intime	       null_days_to_next_ed_visit        null_pain_score    
47101                                 47101                       6708
null_acuity            total_rows
2098                     68936

#Comparing five specific stay_id's from ED_Stays and ED_Encounter_Analytics for data validation. 
SELECT*
FROM ED_Stays
WHERE stay_id = 30000012 OR stay_id = 38112554 OR 
stay_id = 32642808 OR stay_id = 38221815 OR stay_id
= 35217179;

SELECT*
FROM ED_Encounter_Analytics
WHERE stay_id = 30000012 OR stay_id = 38112554 OR 
stay_id = 32642808 OR stay_id = 38221815 OR stay_id
= 35217179;
