/*
elevation varchar,
landcover varchar,
lat varchar,
lon varchar,
ndvi_mean_1995_2024 varchar,
province_name varchar,
soil_clay varchar,
soil_nitrogen varchar,
soil_ph varchar,
soil_sand varchar,
soil_soc varchar
province_name,surface_elevation,avg_ndvi,soil_ph_level,soil_organic_carbon,soil_nitrogen_content,soil_sand_ratio,soil_clay_ratio    
*/

SELECT
    province_name,
    CAST(landcover AS FLOAT) AS land_cover_type,
    CAST(elevation AS FLOAT) AS surface_elevation,
    CAST(ndvi_mean_1995_2024 AS FLOAT) AS avg_ndvi,
    CAST(soil_ph AS FLOAT) AS soil_ph_level,
    CAST(soil_soc AS FLOAT) AS soil_organic_carbon,
    CAST(soil_nitrogen AS FLOAT) AS soil_nitrogen_content,
    CAST(soil_sand AS FLOAT) AS soil_sand_ratio,
    CAST(soil_clay AS FLOAT) AS soil_clay_ratio
FROM {{ source
('raw_layer', 'soil') }}