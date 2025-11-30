drop schema IF EXISTS raw
CASCADE;
create schema raw;

-- Table: raw.agriculture
drop table IF EXISTS raw.agriculture;
create table raw.agriculture
(
    year varchar,
    region varchar,
    commodity varchar,
    season varchar,
    area_thousand_ha varchar,
    yield_ta_per_ha varchar,
    production_thousand_tonnes varchar
);

-- Table: raw.province
drop table IF EXISTS raw.province;
create table raw.province
(
    province_name varchar,
    latitude varchar,
    longitude varchar
);

-- Table: raw.climate
drop table IF EXISTS raw.climate;
create table raw.climate
(
    year varchar,
    province_name varchar,
    latitude varchar,
    longitude varchar,
    t2m varchar,
    t2m_min varchar,
    t2m_max varchar,
    prectotcorr varchar,
    allsky_sfc_sw_dwn varchar,
    rh2m varchar,
    ws2m varchar,
    ps varchar,
    t2mwet varchar,
    ts varchar
);

-- Table: raw.soil
drop table IF EXISTS raw.soil;
create table raw.soil
(
    elevation varchar,
    landcover varchar,
    lat varchar,
    lon varchar,
    ndvi_mean_1995_2024 varchar,
    province_name varchar,
    soil_clay varchar,
    soil_nitrogen varchar,
    soil_ph varchar,
    soil_sand varchar,
    soil_soc varchar
);
