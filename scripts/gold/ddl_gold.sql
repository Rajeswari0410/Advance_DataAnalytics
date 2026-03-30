--create object - view	
CREATE VIEW gold.dim_kids AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY age, gender, primary_device, health_impacts, urban_or_rural) AS kid_key, --PK
	age,
	gender,
	primary_device,
	health_impacts,
	urban_or_rural
FROM silver.kids_screen_time;

--create object - facts
CREATE VIEW gold.fact_kids AS
SELECT 
	dk.kid_key,
	kst.avg_daily_screen_time_hr,
	kst.exceeded_recommended_limit,
	kst.educational_to_recreational_ratio
FROM silver.kids_screen_time kst
LEFT JOIN gold.dim_kids dk
ON kst.age = dk.age
 AND kst.gender = dk.gender
 AND kst.primary_device = dk.primary_device
 AND kst.health_impacts = dk.health_impacts
 AND kst.urban_or_rural = dk.urban_or_rural;
