# System Architecture

## 🏗️ High-Level Architecture

The Vietnam Agriculture Data Warehouse is built using a modern data stack containerized with Docker. It follows the **ELT (Extract, Load, Transform)** pattern where data is loaded into the warehouse first and then transformed using dbt.

![Architecture Diagram](<!-- Insert Architecture Diagram Here -->)

## 🧩 Components

### 1. Orchestration: Apache Airflow
- **Role**: Manages the workflow scheduling and execution.
- **Implementation**: Airflow runs as a set of Docker containers (Scheduler, Webserver, Triggerer, etc.).
- **DAGs**: Defined in Python, utilizing the `cosmos` library to integrate dbt models as Airflow tasks.

### 2. Data Warehouse: PostgreSQL
- **Role**: Stores raw data and all transformed layers (Bronze, Silver, Gold).
- **Implementation**: A PostgreSQL 13 container serves as the central data repository.
- **Schemas**:
  - `raw_layer`: Landing zone for ingested data.
  - `bronze`, `silver`, `gold`: dbt-managed schemas for respective data layers.

### 3. Transformation: dbt (Data Build Tool)
- **Role**: Performs data transformation, testing, and documentation.
- **Implementation**:
  - **Development**: A dedicated `dbt_dev` container for manual CLI operations.
  - **Production**: Integrated into Airflow via `astronomer-cosmos`, allowing dbt models to run as individual tasks in the DAG.

### 4. Containerization: Docker & Docker Compose
- **Role**: Ensures consistent environments across development and production.
- **Services**: Defined in `docker-compose.yml`, orchestrating the interaction between Airflow, Postgres, and dbt.

## 📐 Data Architecture (Medallion)

The data flow follows the Medallion Architecture:

1.  **Raw Layer (Ingestion)**:
    - Data is loaded from CSV/Source files into the `raw_layer` schema in Postgres.
    - No transformations are applied here; it mirrors the source.

2.  **Bronze Layer (Raw Refined)**:
    - **Purpose**: Ingest raw data into dbt, basic type casting, and renaming.
    - **State**: Append-only (conceptually), raw history.

3.  **Silver Layer (Enriched)**:
    - **Purpose**: Clean, deduplicated, and standardized data.
    - **Transformations**: Handling NULLs, standardizing region names, unit conversions.

4.  **Gold Layer (Curated)**:
    - **Purpose**: Business-level aggregates and Star Schema for reporting.
    - **Models**: Fact tables (`fact_agriculture`) and Dimension tables (`dim_province`).
    - **Features**: Wide tables prepared for Machine Learning (`vietnam_agriculture_data`).
