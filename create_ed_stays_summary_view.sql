#Author: Keri W. 
#Date: 07 January 2025

#Creates a base table (view) with columns from ED_Stays and Triage_Assesments using a 
left join. DATEDIFF is used to create column ed_los_minutes from intime and outtime. 

CREATE VIEW ED_STAYS_SUMMARY AS
SELECT
	ED_Stays.stay_id,
	ED_Stays.subject_id,
	ED_Stays.intime,
	ED_Stays.outtime,
	DATEDIFF(MINUTE, ED_Stays.intime, ED_Stays.outtime) AS ed_los_minutes,
	ED_Stays.disposition,
	Triage_Assessments.acuity,
	Triage_Assessments.chiefcomplaint,
	Triage_Assessments.pain_score
FROM ED_Stays
LEFT JOIN Triage_Assessments
	ON ED_Stays.stay_id = Triage_Assessments.stay_id;
