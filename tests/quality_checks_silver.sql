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

