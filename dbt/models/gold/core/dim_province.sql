WITH province AS (
SELECT
    *
FROM {{ ref('silver_province') }}
),
soil AS (
SELECT
    *
FROM {{ ref('silver_soil') }}
)

SELECT
    p.province_id,
    p.province_name,
    p.latitude,
    p.longitude,

    s.surface_elevation,
    s.land_cover_type,
    s.avg_ndvi,
    s.soil_ph_level,
    s.soil_organic_carbon,
    s.soil_nitrogen_content,
    s.soil_sand_ratio,
    s.soil_clay_ratio
FROM province p
LEFT JOIN soil s
    ON p.province_name = s.province_name