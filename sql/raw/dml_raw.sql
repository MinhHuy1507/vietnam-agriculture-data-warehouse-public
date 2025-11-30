TRUNCATE TABLE raw.agriculture;

COPY raw.agriculture
(year, region, commodity, season, area_thousand_ha, yield_ta_per_ha, production_thousand_tonnes)
FROM '/data/raw/agriculture.csv'
DELIMITER ','
CSV HEADER;

TRUNCATE TABLE raw.province;
COPY raw.province
(province_name, latitude, longitude)
FROM '/data/raw/province.csv'
DELIMITER ','
CSV HEADER;

TRUNCATE TABLE raw.climate;
COPY raw.climate
(year, province_name, latitude, longitude, t2m, t2m_min, t2m_max, prectotcorr, allsky_sfc_sw_dwn, rh2m, ws2m, ps, t2mwet, ts)
FROM '/data/raw/climate.csv'
DELIMITER ','
CSV HEADER;

TRUNCATE TABLE raw.soil;
COPY raw.soil
(elevation, landcover, lat, lon, ndvi_mean_1995_2024, province_name, soil_clay, soil_nitrogen, soil_ph, soil_sand, soil_soc)
FROM '/data/raw/soil.csv'
DELIMITER ','
CSV HEADER;