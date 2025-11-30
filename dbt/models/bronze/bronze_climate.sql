/*
bronze climate table
year varchar,
province_name varchar,
latitude varchar,
longitude varchar,
t2m varchar,
t2m_min varchar,
t2m_max varchar,
prectotcorr varchar,
allsky_sfc_sw_dwn varchar,
rh2m varchar,
ws2m varchar,
ps varchar,
t2mwet varchar,
ts varchar
avg_temperature,min_temperature,max_temperature,surface_temperature,wet_bulb_temperature,precipitation,solar_radiation,relative_humidity,wind_speed,surface_pressure
*/
SELECT
    year,
    province_name,
    CAST(latitude AS FLOAT) AS latitude,
    CAST(longitude AS FLOAT) AS longitude,
    CAST(t2m AS FLOAT) AS avg_temperature,
    CAST(t2m_min AS FLOAT) AS min_temperature,
    CAST(t2m_max AS FLOAT) AS max_temperature,
    CAST(ts AS FLOAT) AS surface_temperature,
    CAST(t2mwet AS FLOAT) AS wet_bulb_temperature,
    CAST(prectotcorr AS FLOAT) AS precipitation,
    CAST(allsky_sfc_sw_dwn AS FLOAT) AS solar_radiation,
    CAST(rh2m AS FLOAT) AS relative_humidity,
    CAST(ws2m AS FLOAT) AS wind_speed,
    CAST(ps AS FLOAT) AS surface_pressure
FROM {{ source
('raw_layer', 'climate') }}