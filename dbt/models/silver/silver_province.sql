SELECT
    ROW_NUMBER() OVER (ORDER BY province_name ASC) AS province_id,
    province_name,
    latitude,
    longitude
FROM {{ ref
('bronze_province') }}