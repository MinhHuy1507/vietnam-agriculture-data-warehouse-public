SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['season']) }} as season_id,
    season as season_name
FROM {{ ref('silver_agriculture') }}