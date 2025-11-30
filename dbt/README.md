# Vietnam Agriculture Data Warehouse - dbt Project

## 📋 Overview
This dbt project transforms Vietnam's agricultural data following the Medallion Architecture (Bronze → Silver → Gold). The objective is to build a clean, consistent data warehouse ready for analytics or Machine Learning models.

## 🏗️ Directory Structure

```
models/
├── bronze/          # Raw data ingestion (1:1 with source)
├── silver/          # Cleaned & Standardized data
│   ├── base/        # Intermediate cleaning steps
├── gold/            # Business & Analytics layer
│   ├── core/        # Dimension tables
│   ├── business/    # Fact tables
│   └── features/    # Wide tables for ML/Analytics
```

## 🌟 Layer Details

### 1. Bronze Layer (Raw Data)
This layer contains views/tables that read directly from the raw data source (raw layer), performing basic column renaming and data type casting.

| File | Purpose |
|------|----------|
| `_sources.yml` | Defines the `raw_layer` data source and its component tables. |
| `bronze_agriculture.sql` | Ingests raw agricultural data, casts numeric types for area, yield, and production. |
| `bronze_climate.sql` | Ingests raw climate data, selects columns for temperature, precipitation, humidity, etc. |
| `bronze_province.sql` | Ingests province data and geographic coordinates (latitude, longitude). |
| `bronze_soil.sql` | Ingests soil data, casts soil indicators (pH, salinity, composition, etc.). |

### 2. Silver Layer (Cleaned Data)
This layer performs data cleaning, handles NULL values, standardizes region names, and calculates derived metrics.

**Main Directory:**
| File | Purpose |
|------|----------|
| `silver_agriculture.sql` | Cleaned agriculture table. Adds regional hierarchy logic (`region_level`) to distinguish between regions/areas/whole country. |
| `silver_climate.sql` | Cleaned climate table. Rounds climate metrics (to 2 decimal places), adds `climate_id`. |
| `silver_province.sql` | Cleaned province table. Adds `province_id` as the primary key. |
| `silver_soil.sql` | Cleaned soil table. Combines information from base and bronze tables, adds `soil_id`. |

**`base/` Directory (Intermediate):**
| File | Purpose |
|------|----------|
| `base/agriculture/silver_base_agri_cleansing.sql` | Cleans the `year` column, standardizes region names (`region_name`) using the mapping table (`region_mapping`). |
| `base/soil/silver_base_soil_content.sql` | Standardizes soil metrics (divides by scaling factors 10, 100, 1000...) to convert to correct measurement units. |

### 3. Gold Layer (Analytics Ready)
This layer organizes data into a Star Schema and feature tables for in-depth analysis.

**Core (Dimensions):**
| File | Purpose |
|------|----------|
| `core/dim_commodity.sql` | Dimension for crops/livestock. Creates `commodity_id` from the name. |
| `core/dim_province.sql` | Dimension for provinces. Combines geographic info (`silver_province`) and soil info (`silver_soil`) into a single table. |
| `core/dim_season.sql` | Dimension for seasons. Creates `season_id` from the season name. |

**Business (Facts):**
| File | Purpose |
|------|----------|
| `business/fact_agriculture.sql` | Fact table for agricultural production. Connects to Dimensions (`province`, `commodity`, `season`) via IDs. Contains metrics: area, production, yield. |
| `business/fact_climate.sql` | Fact table for climate by year and province. Connects to `dim_province`. Contains detailed climate metrics. |

**Features (Analytical/ML):**
| File | Purpose |
|------|----------|
| `features/vietnam_agriculture_data.sql` | Consolidated table (Wide Table) joining all data: Agriculture + Climate + Soil. Used as input for forecasting models or multi-dimensional correlation analysis. |

## 🚀 Running Instructions

To run the entire project:
```bash
dbt run
```

To run a specific layer:
```bash
dbt run --select bronze
dbt run --select silver
dbt run --select gold
```

To run a specific model and its children:
```bash
dbt run --select +fact_agriculture
```

## 📚 Project Documentation

To view detailed documentation about models, lineage, and descriptions:

1. **Generate Documentation:**
   ```bash
   dbt docs generate
   ```

2. **View Documentation (Local):**
   ```bash
   dbt docs serve
   ```
   Access: `http://localhost:8080`

3. **View Documentation (Docker):**
   If running via Docker Compose:
   ```bash
   # 1. Access the container
   docker exec -it dbt_dev /bin/bash

   # 2. Generate documentation
   dbt docs generate

   # 3. Start the server
   dbt docs serve
   ```
   Access: `http://localhost:8580/` (configured in docker-compose.yml)
