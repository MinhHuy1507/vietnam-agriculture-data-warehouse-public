/*bronze province table*/

SELECT
    province_name,
    CAST(latitude AS FLOAT) AS latitude,
    CAST(longitude AS FLOAT) AS longitude
FROM
    {{ source
('raw_layer', 'province') }}