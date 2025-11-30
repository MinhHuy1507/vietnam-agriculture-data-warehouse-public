select
    ROW_NUMBER() OVER (ORDER BY year, province_name ASC) AS climate_id,
    year,
    province_name,
    latitude,
    longitude,
    ROUND(avg_temperature::NUMERIC, 2) AS avg_temperature,
    ROUND(min_temperature::NUMERIC, 2) AS min_temperature,
    ROUND(max_temperature::NUMERIC, 2) AS max_temperature,
    ROUND(surface_temperature::NUMERIC, 2) AS surface_temperature,
    ROUND(wet_bulb_temperature::NUMERIC, 2) AS wet_bulb_temperature,
    ROUND(precipitation::NUMERIC, 2) AS precipitation,
    ROUND(solar_radiation::NUMERIC, 2) AS solar_radiation,
    ROUND(relative_humidity::NUMERIC, 2) AS relative_humidity,
    ROUND(wind_speed::NUMERIC, 2) AS wind_speed,
    ROUND(surface_pressure::NUMERIC, 2) AS surface_pressure
from {{ ref
('bronze_climate') }}