#Author: Keri W. 
#Date: 07 January 2025

#Creates a base table (view) with columns from ED_Stays and Triage_Assesments using a 
left join. DATEDIFF is used to create column ed_los_minutes from intime and outtime. 
CREATE VIEW ED_Stays_Summary AS
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

#Selecting top 20 rows to inspect new view, ED_Stays_Summary
SELECT TOP 20*
FROM ED_Stays_Summary;

#Counting total rows from ED_Stays_Summary view 
SELECT COUNT(*) AS total_rows
FROM ED_Stays_Summary;

#Null count for columns acuity, pain_score, and ed_los for ED_Stays_Summary view
SELECT
    SUM(CASE WHEN acuity IS NULL THEN 1 ELSE 0 END) AS null_acuity,
    SUM(CASE WHEN pain_score IS NULL THEN 1 ELSE 0 END) AS null_pain_score,
    SUM(CASE WHEN ed_los_minutes IS NULL THEN 1 ELSE 0 END) AS null_ed_los
FROM ED_Stays_Summary;

#Altering ED_Stays_Summary by adding columns, gender, race, arrival transport, from ED_Stays and columns
temperature, heartrate, resprate, o2sat, sbp, dbp from Triage_Assessments. 
CREATE OR ALTER VIEW ED_Stays_Summary AS
SELECT
	ED_Stays.stay_id,
	ED_Stays.subject_id,
	ED_Stays.intime,
	ED_Stays.outtime,
	DATEDIFF(MINUTE, ED_Stays.intime, ED_Stays.outtime) AS ed_los_minutes,
	ED_Stays.gender,
	ED_Stays.race,
	ED_Stays.arrival_transport AS arrival_transportation,
	ED_Stays.disposition,
	Triage_Assessments.acuity,
	Triage_Assessments.chiefcomplaint,
	Triage_Assessments.pain_score,
	Triage_Assessments.temperature,
	Triage_Assessments.heartrate AS triage_heart_rate,
	Triage_Assessments.resprate AS respiratory_rate,
	Triage_Assessments.o2sat AS oxygen_saturation,
	Triage_Assessments.sbp AS systolic_bp,
	Triage_Assessments.dbp AS diastolic_bp.
	Triage_Assessments.pain
FROM ED_Stays
LEFT JOIN Triage_Assessments
	ON ED_Stays.stay_id = Triage_Assessments.stay_id;

