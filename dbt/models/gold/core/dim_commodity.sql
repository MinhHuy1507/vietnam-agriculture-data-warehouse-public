SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['commodity']) }} as commodity_id,
    commodity as commodity_name
FROM {{ ref('silver_agriculture') }}