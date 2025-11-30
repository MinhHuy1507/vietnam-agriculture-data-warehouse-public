WITH
    source_data
    AS
    (
        SELECT *
        FROM {{ ref
    
    ('bronze_agriculture') }}
),

region_map AS
(
    SELECT *
FROM {{ ref
('region_mapping') }}
)

SELECT
    CAST(REGEXP_REPLACE(s.year, '[^0-9]', '', 'g') AS INTEGER) AS year,
    COALESCE(m.standard_name, s.region) AS region_name,

    s.commodity,
    s.season,
    s.area_thousand_ha,
    s.production_thousand_tonnes,
    s.yield_ta_per_ha

FROM source_data s
    LEFT JOIN region_map m ON s.region = m.source_name