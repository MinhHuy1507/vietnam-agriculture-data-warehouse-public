SELECT
    {{ dbt_utils.generate_surrogate_key(['s.year', 's.province_name']) }} as fact_climate_key,
    
    p.province_id,
    s.year,
    
    s.avg_temperature,
    s.min_temperature,
    s.max_temperature,
    s.surface_temperature,
    s.wet_bulb_temperature,
    s.precipitation,
    s.solar_radiation,
    s.relative_humidity,
    s.wind_speed,
    s.surface_pressure

FROM {{ ref('silver_climate') }} s
LEFT JOIN {{ ref('dim_province') }} p ON s.province_name = p.province_name