SELECT
    province_name,
    ROUND((avg_ndvi / 1000.0)
::NUMERIC, 4) AS avg_ndvi,
    ROUND
((soil_ph_level / 10.0)::NUMERIC, 1) AS soil_ph_level,
    ROUND
((soil_organic_carbon / 100.0)::NUMERIC, 2) AS soil_organic_carbon,
    ROUND
((soil_nitrogen_content / 1000.0)::NUMERIC, 4) AS soil_nitrogen_content,
    ROUND
((soil_sand_ratio / 10.0)::NUMERIC, 1) AS soil_sand_ratio,
    ROUND
((soil_clay_ratio / 10.0)::NUMERIC, 1) AS soil_clay_ratio
FROM {{ ref
('bronze_soil') }}