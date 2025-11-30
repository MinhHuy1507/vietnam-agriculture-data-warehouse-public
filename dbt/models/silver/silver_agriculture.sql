WITH
    cleansed_data
    AS
    (
        SELECT *
        FROM {{ ref
    
    
    
    ('silver_base_agri_cleansing') }}
),
metric_calculated AS
(
    SELECT
    year,
    region_name,

    CASE 
        WHEN region_name IN (
            'Dong bang song Hong', 
            'Bac Trung Bo va Duyen hai mien Trung', 
            'Dong Nam Bo', 
            'Tay Nguyen', 
            'Dong bang song Cuu Long', 
            'Trung du va mien nui phia Bac'
        ) THEN 2
        WHEN region_name = 'Ca Nuoc' THEN 3
        ELSE 1 
    END AS region_level,

    commodity,
    season,

    CASE
        WHEN commodity = 'sweet_potato' AND year >= 2018 THEN area_thousand_ha / 1000.0
        WHEN commodity = 'sugarcane' THEN area_thousand_ha / 1000.0
        WHEN commodity = 'groundnut' THEN area_thousand_ha / 1000.0
        ELSE area_thousand_ha
    END AS area_thousand_ha,

    CASE
        WHEN commodity = 'groundnut' THEN production_thousand_tonnes / 1000.0
        ELSE production_thousand_tonnes
    END AS production_thousand_tonnes,

    yield_ta_per_ha
FROM cleansed_data
)

-- Tính lại Yield dựa trên Area và Production mới
SELECT
    ROW_NUMBER() OVER (ORDER BY year, region_level, region_name, commodity, season) AS agriculture_id,
    year,
    region_name,
    region_level,
    commodity,
    season,
    area_thousand_ha,
    production_thousand_tonnes,

    -- 7. Tính lại Yield 
    -- Công thức: (Production / Area) * 10
    CASE
        WHEN area_thousand_ha > 0 AND production_thousand_tonnes IS NOT NULL THEN 
            ROUND(((production_thousand_tonnes / area_thousand_ha) * 10)::NUMERIC, 4)
        ELSE yield_ta_per_ha
    END AS yield_ta_per_ha

FROM metric_calculated
ORDER BY year, region_name, commodity, season