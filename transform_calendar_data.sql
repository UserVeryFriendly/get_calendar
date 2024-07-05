-- DROP PROCEDURE nsi.transform_calendar_data();

CREATE OR REPLACE PROCEDURE nsi.transform_calendar_data()
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    INSERT INTO nsi.dict_calendar (
        full_date,
        yw,
        dow_int,
        dow_name,
        y,
        quarter,
        m,
        d,
        description,
        dayoff,
        short_day
    )
    SELECT
        full_date,
        NULL AS yw,
        CASE
            WHEN dow_name = 'пн' THEN 1
            WHEN dow_name = 'вт' THEN 2
            WHEN dow_name = 'ср' THEN 3
            WHEN dow_name = 'чт' THEN 4
            WHEN dow_name = 'пт' THEN 5
            WHEN dow_name = 'сб' THEN 6
            WHEN dow_name = 'вс' THEN 7
            ELSE NULL
        END AS dow_int,
        dow_name,
        EXTRACT(YEAR FROM full_date) AS y,
        EXTRACT(QUARTER FROM full_date) AS quarter,
        EXTRACT(MONTH FROM full_date) AS m,
        EXTRACT(DAY FROM full_date) AS d,
        description,
        CASE
            WHEN description LIKE '%ыходн%' or description like '%праздник%' THEN TRUE
            ELSE FALSE
        END AS dayoff,
        CASE
            WHEN description LIKE '%окращен%' THEN TRUE
            ELSE FALSE
        END AS short_day
        from nsi.dict_calendar_raw;
    COMMIT;
END;
$procedure$
;
