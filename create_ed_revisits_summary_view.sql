#Author: Keri W. 
#Date: 08 January 2026

#Creates a base table (view) of Emergency Department revisit behavior. The view uses a self join of ED_Stays
table that evaluates future visits for the same patient. MIN is used to create column next_ed_intime, DATEDIFF 
is used to create column days_to_next_ed_visit, and COUNT is used to create column total_future_ed_visits. 
CREATE VIEW ED_Revisits_Summary AS
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
