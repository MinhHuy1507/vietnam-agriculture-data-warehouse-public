-- models/silver/silver_soil.sql

WITH
    soil_calculations
    AS
    (
        SELECT *
        FROM {{ ref
    
    ('silver_base_soil_content') }}
),

soil_province AS
(
    SELECT
    province_name,
    land_cover_type,
    surface_elevation
FROM {{ ref
('bronze_soil') }}
)


SELECT
    ROW_NUMBER() OVER (ORDER BY p.province_name ASC) AS soil_id,
    p.province_name,
    p.land_cover_type,
    p.surface_elevation,

    s.avg_ndvi,
    s.soil_ph_level,
    s.soil_organic_carbon,
    s.soil_nitrogen_content,
    s.soil_sand_ratio,
    s.soil_clay_ratio

FROM soil_province p
    LEFT JOIN soil_calculations s
    ON p.province_name = s.province_name