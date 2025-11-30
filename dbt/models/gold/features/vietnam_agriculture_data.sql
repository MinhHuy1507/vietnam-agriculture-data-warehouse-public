WITH agri AS (
    SELECT * FROM {{ ref('fact_agriculture') }}
),
climate AS (
    SELECT * FROM {{ ref('fact_climate') }}
),
province_soil AS (
    SELECT * FROM {{ ref('dim_province') }}
),
commodity AS (
    SELECT * FROM {{ ref('dim_commodity') }}
),
season AS (
    SELECT * FROM {{ ref('dim_season') }}
)

SELECT
    -- 1. Thông tin định danh
    a.year,
    ps.province_name,
    com.commodity_name,
    se.season_name,

    -- 2. Feature tĩnh (Đất đai - Từ Dim Province)
    ps.surface_elevation,
    ps.avg_ndvi,
    ps.soil_ph_level,
    ps.soil_organic_carbon,
    ps.soil_nitrogen_content,
    ps.soil_sand_ratio,
    ps.soil_clay_ratio,

    -- 3. Feature động (Khí hậu - Từ Fact Climate)
    c.avg_temperature,
    c.min_temperature,
    c.max_temperature,
    c.surface_temperature,
    c.wet_bulb_temperature,
    c.precipitation,
    c.solar_radiation,
    c.relative_humidity,
    c.wind_speed,
    c.surface_pressure,

    -- 4. Target / Label (Mục tiêu dự đoán - Từ Fact Agri)
    a.area_thousand_ha,
    a.production_thousand_tonnes,
    a.yield_ta_per_ha

FROM agri a
LEFT JOIN climate c 
    ON a.province_id = c.province_id 
    AND a.year = CAST(c.year AS INTEGER)
LEFT JOIN province_soil ps 
    ON a.province_id = ps.province_id
LEFT JOIN commodity com 
    ON a.commodity_id = com.commodity_id
LEFT JOIN season se
    ON a.season_id = se.season_id