SELECT
    {{ dbt_utils.generate_surrogate_key(['s.year', 's.region_name', 's.commodity', 's.season']) }} as fact_agri_key,
    
    s.year,
    s.region_name,
    s.region_level,
    -- Foreign Keys (Nối với Dim)
    p.province_id,
    c.commodity_id,
    se.season_id,


    -- Metrics (Số liệu)
    s.area_thousand_ha,
    s.production_thousand_tonnes,
    s.yield_ta_per_ha

FROM {{ ref('silver_agriculture') }} s
LEFT JOIN {{ ref('dim_province') }} p ON s.region_name = p.province_name
LEFT JOIN {{ ref('dim_commodity') }} c ON s.commodity = c.commodity_name
LEFT JOIN {{ ref('dim_season') }} se ON s.season = se.season_name