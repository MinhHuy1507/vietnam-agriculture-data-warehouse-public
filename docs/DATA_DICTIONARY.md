# Data Dictionary

## 📚 Overview
This document details the data structures across the Raw, Bronze, Silver, and Gold layers of the warehouse.

## 🧱 Raw Layer (Ingestion)
This layer contains the raw data ingested directly from source files (CSV) into PostgreSQL. All columns are typically ingested as `varchar` to prevent initial load failures.

| Table Name | Description | Columns |
|------------|-------------|---------|
| `raw.agriculture` | Raw agricultural production data. | `year`, `region`, `commodity`, `season`, `area_thousand_ha`, `yield_ta_per_ha`, `production_thousand_tonnes` |
| `raw.climate` | Raw climate indicators. | `year`, `province_name`, `latitude`, `longitude`, `t2m`, `t2m_min`, `t2m_max`, `prectotcorr`, `allsky_sfc_sw_dwn`, `rh2m`, `ws2m`, `ps`, `t2mwet`, `ts` |
| `raw.province` | Province reference data. | `province_name`, `latitude`, `longitude` |
| `raw.soil` | Soil composition and characteristics. | `elevation`, `landcover`, `lat`, `lon`, `ndvi_mean_1995_2024`, `province_name`, `soil_clay`, `soil_nitrogen`, `soil_ph`, `soil_sand`, `soil_soc` |

## 🥉 Bronze Layer (Raw Refined)
This layer performs initial renaming of columns to user-friendly names and casts data types (e.g., `varchar` to `float`).

| Table Name | Description | Columns (Renamed & Casted) |
|------------|-------------|----------------------------|
| `bronze.bronze_agriculture` | Casts numeric columns to FLOAT. | `year`, `region`, `commodity`, `season`, `area_thousand_ha`, `yield_ta_per_ha`, `production_thousand_tonnes` |
| `bronze.bronze_climate` | Renames scientific codes to readable names and casts to FLOAT. | `year`, `province_name`, `latitude`, `longitude`, `avg_temperature` (t2m), `min_temperature` (t2m_min), `max_temperature` (t2m_max), `surface_temperature` (ts), `wet_bulb_temperature` (t2mwet), `precipitation` (prectotcorr), `solar_radiation` (allsky_sfc_sw_dwn), `relative_humidity` (rh2m), `wind_speed` (ws2m), `surface_pressure` (ps) |
| `bronze.bronze_province` | Casts coordinates to FLOAT. | `province_name`, `latitude`, `longitude` |
| `bronze.bronze_soil` | Renames soil attributes and casts to FLOAT. | `province_name`, `land_cover_type` (landcover), `surface_elevation` (elevation), `avg_ndvi` (ndvi_mean_1995_2024), `soil_ph_level` (soil_ph), `soil_organic_carbon` (soil_soc), `soil_nitrogen_content` (soil_nitrogen), `soil_sand_ratio` (soil_sand), `soil_clay_ratio` (soil_clay) |

## 🥈 Silver Layer (Cleaned)
This layer applies business logic, standardization, and advanced transformations.

| Table Name | Transformations Applied | Columns |
|------------|-------------------------|---------|
| `silver.silver_agriculture` | 1. **Region Standardization**: Maps raw region names to standard names.<br>2. **Region Level**: Adds `region_level` (1: Province, 2: Region, 3: Country).<br>3. **Unit Conversion**: Adjusts units for specific commodities (e.g., sweet potato, sugarcane, groundnut).<br>4. **ID Generation**: Generates `agriculture_id` based on year, region_name, region_level, commodity, and season.<br>5. **Null Handling**: Calculates yield from production/area when yield is null but area and production are non-zero. | `agriculture_id`, `year`, `region_name`, `region_level`, `commodity`, `season`, `area_thousand_ha`, `production_thousand_tonnes`, `yield_ta_per_ha` |
| `silver.silver_climate` | 1. **Rounding**: Rounds all climate metrics to 2 decimal places.<br>2. **ID Generation**: Generates `climate_id` based on year and province. | `climate_id`, `year`, `province_name`, `latitude`, `longitude`, `avg_temperature`, `min_temperature`, `max_temperature`, `surface_temperature`, `wet_bulb_temperature`, `precipitation`, `solar_radiation`, `relative_humidity`, `wind_speed`, `surface_pressure` |
| `silver.silver_province` | 1. **ID Generation**: Generates `province_id` based on province name. | `province_id`, `province_name`, `latitude`, `longitude` |
| `silver.silver_soil` | 1. **Scaling**: Scales down raw values (e.g., pH / 10, NDVI / 1000) to correct units.<br>2. **ID Generation**: Generates `soil_id`.<br>3. **Join**: Combines base soil content with province elevation data. | `soil_id`, `province_name`, `land_cover_type`, `surface_elevation`, `avg_ndvi`, `soil_ph_level`, `soil_organic_carbon`, `soil_nitrogen_content`, `soil_sand_ratio`, `soil_clay_ratio` |

## 🥇 Gold Layer (Analytics)
Star Schema and Analytical Features.

### Dimension Tables
| Table Name | Description |
|------------|-------------|
| `dim_province` | Master list of provinces including geographic and soil attributes. |
| `dim_commodity` | Master list of agricultural commodities (crops/livestock). |
| `dim_season` | Master list of farming seasons. |

### Fact Tables
| Table Name | Description | Granularity |
|------------|-------------|-------------|
| `fact_agriculture` | Agricultural performance metrics. | Per Year, Per Region, Per Commodity, Per Season. |
| `fact_climate` | Climate observations. | Per Year, Per Province. |

### Feature Tables (ML Ready)
| Table Name | Description |
|------------|-------------|
| `vietnam_agriculture_data` | **Wide Table**. Consolidates Agriculture, Climate, and Soil data into a single view for correlation analysis and machine learning modeling. |
