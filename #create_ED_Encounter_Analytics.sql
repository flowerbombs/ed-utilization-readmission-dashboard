#Create ED_Encounter_Analytics view by using a left join on views ED_Stays_Summary, ED_Revisits_Summary, and ED_Primary_Diagnosis on primary key
stay_id. ED_Encounter_Analytics represents one row per ED stay, enriched with revisit metrics and primary diagnosis information when available,
and is intended for analytics and dashboard reporting. 
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
  ED_Primary_Diagnosis.icd_code,
  ED_Primary_Diagnosis.icd_title
  
FROM ED_Stays_Summary 
LEFT JOIN  ED_Revisits_Summary ON ED_Stays_Summary.stay_id =  ED_Revisits_Summary.stay_id
LEFT JOIN  ED_Primary_Diagnosis ON ED_Stays_Summary.stay_id = ED_Primary_Diagnosis.stay_id;
