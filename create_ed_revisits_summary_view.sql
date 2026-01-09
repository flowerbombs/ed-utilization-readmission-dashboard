#Author: Keri W. 
#Date: 08 January 2026

#Creates a base table (view) of Emergency Department revisit behavior. The view uses a self join of ED_Stays
table that evaluates future visits for the same patient. MIN is used to create column next_ed_intime, DATEDIFF 
is used to create column days_to_next_ed_visit, and COUNT is used to create column total_future_ed_visits. 
CREATE OR ALTER VIEW ED_Revisits_Summary AS
SELECT
    ED_Stays_1.stay_id AS first_stay_id,
    ED_Stays_1.subject_id,
    ED_Stays_1.intime AS first_intime,
    ED_Stays_1.outtime AS first_outtime,
    ED_Stays_1.disposition AS first_disposition,

    MIN(ED_Stays_2.intime) AS next_ed_intime,
    DATEDIFF(
        DAY,
        ED_Stays_1.outtime,
        MIN(ED_Stays_2.intime)
    ) AS days_to_next_ed_visit,

    COUNT(ED_Stays_2.stay_id) AS total_future_ed_visits

FROM ED_Stays ED_Stays_1
LEFT JOIN ED_Stays  ED_Stays_2
    ON  ED_Stays_1.subject_id =  ED_Stays_2.subject_id
    AND ED_Stays_2.intime >  ED_Stays_1.outtime

GROUP BY
    ED_Stays_1.stay_id,
    ED_Stays_1.subject_id,
    ED_Stays_1.intime,
    ED_Stays_1.outtime,
    ED_Stays_1.disposition; 

# Edits the ED_Revisits_Summary view to include short-term ED revisit risk flags. The view evaluates future
ED visits for the same patient using a self-join on ED_Stays. DATEDIFF(HOUR) is used with 
ED_Stays_1.outtime and the earliest subsequent ED visit (MIN(ED_Stays_2.intime)) to derive a 72-hour ED 
revisit flag (revisit_72hr_flag). DATEDIFF(DAY) is used with the same fields to derive a 7-day ED revisit 
flag(revisit_7day_flag). Both flags are binary indicators (0/1) based on whether the next ED visit occurs 
within the specified time window.
CREATE OR ALTER VIEW ED_Revisits_Summary AS
SELECT
    ED_Stays_1.stay_id AS first_stay_id,
    ED_Stays_1.subject_id,
    ED_Stays_1.intime AS first_intime,
    ED_Stays_1.outtime AS first_outtime,
    ED_Stays_1.disposition AS first_disposition,

    MIN(ED_Stays_2.intime) AS next_ed_intime,

    DATEDIFF(
        DAY,
        ED_Stays_1.outtime,
        MIN(ED_Stays_2.intime)
    ) AS days_to_next_ed_visit,

    COUNT(ED_Stays_2.stay_id) AS total_future_ed_visits,

    CASE
        WHEN DATEDIFF(
            HOUR,
            ED_Stays_1.outtime,
            MIN(ED_Stays_2.intime)
        ) <= 72 THEN 1
        ELSE 0
    END AS revisit_72hr_flag,

    CASE
        WHEN DATEDIFF(
            DAY,
            ED_Stays_1.outtime,
            MIN(ED_Stays_2.intime)
        ) <= 7 THEN 1
        ELSE 0
    END AS revisit_7day_flag

FROM ED_Stays ED_Stays_1
LEFT JOIN ED_Stays ED_Stays_2
    ON ED_Stays_1.subject_id = ED_Stays_2.subject_id
    AND ED_Stays_2.intime > ED_Stays_1.outtime

GROUP BY
    ED_Stays_1.stay_id,
    ED_Stays_1.subject_id,
    ED_Stays_1.intime,
    ED_Stays_1.outtime,
    ED_Stays_1.disposition;

#Selecting column, revisit_72hr_flag, from ED_Revisits_Summary view to count the binary values. Output 
included.
SELECT
    revisit_72hr_flag,
    COUNT(*) AS visit_count
FROM ED_Revisits_Summary
GROUP BY
    revisit_72hr_flag;

#revisit_72hr_flag   visit_count
0                     68842
1                       94
    
#Selecting column, revisit_7day_flag, from ED_Revisits_Summary view to count the binary values. Output 
included.
SELECT
    revisit_7day_flag,
    COUNT(*) AS visit_count
FROM ED_Revisits_Summary
GROUP BY
    revisit_7day_flag;

revisit_7day_flag    visit_count
0                      68258
1                       678

#ED_Revisits_Summary view row count
SELECT COUNT(*) AS total_ed_visits
FROM ED_Revisits_Summary;

#Checking For Impossible Values. This selects all rows from ED_Revisits_Summary where there is a 72 hour
flag and no 7 day revisit. 
SELECT *
FROM ED_Revisits_Summary
WHERE revisit_72hr_flag = 1
  AND revisit_7day_flag = 0;

