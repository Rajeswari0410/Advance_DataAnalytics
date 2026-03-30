SELECT * FROM bronze.kids_screen_time;

SELECT age, gender,
CONCAT(health_impacts,' ', urban_or_rural) AS health_location
FROM bronze.kids_screen_time;

--trailing spaces
SELECT age, gender,
CONCAT(health_impacts,' ', urban_or_rural) AS health_location
FROM bronze.kids_screen_time
WHERE TRIM(CONCAT(health_impacts,' ', urban_or_rural)) != CONCAT(health_impacts,' ', urban_or_rural);

--extract urban or rural
SELECT age, gender,
SUBSTRING(CONCAT(health_impacts,' ', urban_or_rural), LEN(CONCAT(health_impacts,' ', urban_or_rural))-4, 5)  AS loc
FROM bronze.kids_screen_time;

--extract health
SELECT age, gender,
SUBSTRING(CONCAT(health_impacts,' ', urban_or_rural), 0, LEN(CONCAT(health_impacts,' ', urban_or_rural))-5)  AS health
FROM bronze.kids_screen_time;

--remove apostrophies in health -> final transformation
SELECT age, gender,
CASE WHEN LEFT(health, 1) = '"' AND RIGHT(health, 1) = '"' THEN SUBSTRING(health, 2, LEN(health) - 2)
	ELSE health
END AS health,
place
FROM (
	SELECT age, gender,
	SUBSTRING(CONCAT(health_impacts,' ', urban_or_rural), 0, LEN(CONCAT(health_impacts,' ', urban_or_rural))-5)  AS health,
	SUBSTRING(CONCAT(health_impacts,' ', urban_or_rural), LEN(CONCAT(health_impacts,' ', urban_or_rural))-4, 5)  AS place
	FROM bronze.kids_screen_time
)t;

-- Distinct age
SELECT DISTINCT age
FROM bronze.kids_screen_time;

-- Check for out-of-range: age
SELECT 
age
FROM bronze.kids_screen_time
WHERE age < 3 OR age > 18 OR age IS NULL;

-- Distinct gender
SELECT DISTINCT gender
FROM bronze.kids_screen_time;

-- Trailing spaces: gender
SELECT gender
FROM bronze.kids_screen_time
WHERE gender != TRIM(gender);

-- Distinct avg_daily_screen_time_hr
SELECT DISTINCT avg_daily_screen_time_hr
FROM bronze.kids_screen_time;

-- null value check: avg_daily_screen_time_hr
SELECT avg_daily_screen_time_hr
FROM bronze.kids_screen_time
WHERE avg_daily_screen_time_hr IS NULL OR avg_daily_screen_time_hr > 24;

-- Distinct primary_device
SELECT DISTINCT primary_device
FROM bronze.kids_screen_time;

-- Trailing spaces: primary_device
SELECT primary_device
FROM bronze.kids_screen_time
WHERE primary_device != TRIM(primary_device);

-- Distinct exceeded_recommended_limit
SELECT DISTINCT exceeded_recommended_limit
FROM bronze.kids_screen_time;

-- Trailing spaces: exceeded_recommended_limit
SELECT exceeded_recommended_limit
FROM bronze.kids_screen_time
WHERE exceeded_recommended_limit != TRIM(exceeded_recommended_limit);

-- Distinct educational_to_recreational_ratio
SELECT DISTINCT educational_to_recreational_ratio
FROM bronze.kids_screen_time;

-- null value check: educational_to_recreational_ratio
SELECT educational_to_recreational_ratio
FROM bronze.kids_screen_time

--silver layer check
SELECT 
DISTINCT health_impacts
FROM silver.kids_screen_time;

SELECT 
DISTINCT urban_or_rural
FROM silver.kids_screen_time;

SELECT health_impacts
FROM silver.kids_screen_time
WHERE TRIM(health_impacts) != health_impacts;
WHERE educational_to_recreational_ratio IS NULL OR educational_to_recreational_ratio > 1 OR educational_to_recreational_ratio <= 0;
