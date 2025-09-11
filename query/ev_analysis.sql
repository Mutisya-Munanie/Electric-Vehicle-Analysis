-- Number of rows
SELECT COUNT(*) FROM ev_analysis.electric_vehicles;
-- 20 rows output
SELECT * FROM ev_analysis.electric_vehicles LIMIT 20;

-- CHECK COLUMNS
SHOW COLUMNS FROM electric_vehicles;

-- CHECKING FOR NULLS AND MISSING VALUES
USE ev_analysis;

SELECT 
    SUM(CASE WHEN vin IS NULL OR vin = '' THEN 1 ELSE 0 END) AS vin_missing,
    SUM(CASE WHEN county IS NULL OR county = '' THEN 1 ELSE 0 END) AS county_missing,
    SUM(CASE WHEN city IS NULL OR city = '' THEN 1 ELSE 0 END) AS city_missing,
    SUM(CASE WHEN state IS NULL OR state = '' THEN 1 ELSE 0 END) AS state_missing,
    SUM(CASE WHEN postal_code IS NULL OR postal_code = '' THEN 1 ELSE 0 END) AS postal_code_missing,
    SUM(CASE WHEN model_year IS NULL THEN 1 ELSE 0 END) AS model_year_missing,
    SUM(CASE WHEN make IS NULL OR make = '' THEN 1 ELSE 0 END) AS make_missing,
    SUM(CASE WHEN model IS NULL OR model = '' THEN 1 ELSE 0 END) AS model_missing,
    SUM(CASE WHEN electric_vehicle_type IS NULL OR electric_vehicle_type = '' THEN 1 ELSE 0 END) AS ev_type_missing,
    SUM(CASE WHEN cafv_eligibility IS NULL OR cafv_eligibility = '' THEN 1 ELSE 0 END) AS cafv_missing,
    SUM(CASE WHEN electric_range IS NULL THEN 1 ELSE 0 END) AS range_missing,
    SUM(CASE WHEN base_msrp IS NULL THEN 1 ELSE 0 END) AS msrp_missing,
    SUM(CASE WHEN legislative_district IS NULL OR legislative_district = '' THEN 1 ELSE 0 END) AS district_missing,
    SUM(CASE WHEN dol_vehicle_id IS NULL THEN 1 ELSE 0 END) AS dol_id_missing,
    SUM(CASE WHEN vehicle_location IS NULL OR vehicle_location = '' THEN 1 ELSE 0 END) AS location_missing,
    SUM(CASE WHEN electric_utility IS NULL OR electric_utility = '' THEN 1 ELSE 0 END) AS utility_missing,
    SUM(CASE WHEN census_tract_2020 IS NULL OR census_tract_2020 = '' THEN 1 ELSE 0 END) AS tract_missing
FROM electric_vehicles;

-- OPTED TO LEAVE THE MISSING VALUES AS THEY ARE BECAUSE THEY ARE NOT MANY FOR THE ANALYSIS TO BE BETTER AND REALISTIC


-- CHECKING FOR DUPLICATES

SELECT COUNT(*) - COUNT(DISTINCT 
    CONCAT_WS('|',
        vin, county, city, state, postal_code,
        model_year, make, model, electric_vehicle_type,
        cafv_eligibility, electric_range, base_msrp,
        legislative_district, dol_vehicle_id,
        vehicle_location, electric_utility, census_tract_2020
    )
) AS duplicate_rows
FROM electric_vehicles;

-- EDA
-- -- 1. TOTAL NO OF EVS REGISTERED
SELECT COUNT(*) AS total_evs
FROM electric_vehicles;

-- -- 2. EV ADOPTION OVER THE YEARS
SELECT model_year, COUNT(*) AS ev_count
FROM electric_vehicles
WHERE model_year IS NOT NULL
GROUP BY model_year
ORDER BY model_year DESC;
-- ORDER BY ev_count DESC;

-- -- 3. TOP 10 BRANDS
SELECT make, COUNT(*) AS brand_count
FROM electric_vehicles
WHERE make IS NOT NULL AND make <> ''
GROUP BY make
ORDER BY brand_count DESC
LIMIT 10;

-- -- 4. TOP 10 MODELS
SELECT model, COUNT(*) AS model_count
FROM electric_vehicles
WHERE model IS NOT NULL AND model <> ''
GROUP BY model
ORDER BY model_count DESC
LIMIT 10;

-- -- 5. DISRIBUTION OF EV TYPES
SELECT electric_vehicle_type, COUNT(*) AS type_count
FROM electric_vehicles
WHERE electric_vehicle_type IS NOT NULL AND electric_vehicle_type <> ''
GROUP BY electric_vehicle_type
ORDER BY type_count DESC;

-- -- 6. AVERAGE ELECTRIC RANGE
SELECT AVG(electric_range) AS avg_range_in_miles
FROM electric_vehicles
WHERE electric_range IS NOT NULL;

-- -- 7. TOP 5 LONGEST RANGE MODELS
SELECT model, electric_range
FROM electric_vehicles
WHERE electric_range IS NOT NULL
ORDER BY electric_range DESC
LIMIT 5;

-- --8. TOP 5 SHORTEST RANGE MODELS
SELECT model, electric_range
FROM electric_vehicles
WHERE electric_range IS NOT NULL
ORDER BY electric_range ASC
LIMIT 5;

-- -- 9. DISTRIBUTION OF EVS ACROSS COUNTRIES
SELECT county, COUNT(*) AS ev_count
FROM electric_vehicles
WHERE county IS NOT NULL AND county <> ''
GROUP BY county
ORDER BY ev_count DESC;

-- -- 10.  DISTRIBUTION OF EVS ACROSS CITIES-TOP 20
SELECT city, COUNT(*) AS ev_count
FROM electric_vehicles
WHERE city IS NOT NULL AND city <> ''
GROUP BY city
ORDER BY ev_count DESC
LIMIT 20;  

-- -- 11. VARIATION IN CHARGING REQUIREMENTS
SELECT cafv_eligibility, COUNT(*) AS ev_count
FROM electric_vehicles
WHERE cafv_eligibility IS NOT NULL AND cafv_eligibility <> ''
GROUP BY cafv_eligibility
ORDER BY ev_count DESC;

-- -- 12. EV ADOPTION BY UTILITY PROVIDER
SELECT electric_utility, COUNT(*) AS ev_count
FROM electric_vehicles
WHERE electric_utility IS NOT NULL AND electric_utility <> ''
GROUP BY electric_utility
ORDER BY ev_count DESC
LIMIT 20;   -- Top 20 providers

-- -- 13. AVERAGE BASE MSRP BY BRAND 
SELECT make, AVG(base_msrp) AS avg_msrp, COUNT(*) AS ev_count
FROM electric_vehicles
WHERE base_msrp IS NOT NULL AND make IS NOT NULL AND make <> ''
GROUP BY make
HAVING COUNT(*) > 50   -- filter to brands with enough vehicles
ORDER BY avg_msrp DESC;


-- -- 14. ELECTRIC RANGE STATISTICS
SELECT 
    MIN(electric_range) AS min_range,
    MAX(electric_range) AS max_range,
    AVG(electric_range) AS avg_range
FROM electric_vehicles
WHERE electric_range IS NOT NULL;

-- -- 15.EVS BY LEGISLATIVE DISTRICT
SELECT legislative_district, COUNT(*) AS ev_count
FROM electric_vehicles
WHERE legislative_district IS NOT NULL AND legislative_district <> ''
GROUP BY legislative_district
ORDER BY ev_count DESC;






















