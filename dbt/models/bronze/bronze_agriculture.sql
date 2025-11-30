/*agriculture bronze table

year varchar,
region varchar,
commodity varchar,
season varchar,
area_thousand_ha varchar,
yield_ta_per_ha varchar,
production_thousand_tonnes varchar
*/
SELECT
    year,
    region,
    commodity,
    season,
    CAST(area_thousand_ha AS FLOAT) AS area_thousand_ha,
    CAST(yield_ta_per_ha AS FLOAT) AS yield_ta_per_ha,
    CAST(production_thousand_tonnes AS FLOAT) AS production_thousand_tonnes
FROM {{ source
('raw_layer', 'agriculture') }}
