/*
This script creates tables in the 'bronze' schema, dropping exisisting tables if they already exsist
*/

IF OBJECT_ID ('bronze.kids_screen_time', 'U') IS NOT NULL
	DROP TABLE bronze.kids_screen_time;

CREATE TABLE bronze.kids_screen_time (
	age INT,
	gender NVARCHAR(50),
	avg_daily_screen_time_hr FLOAT,
	primary_device NVARCHAR(50),
	exceeded_recommended_limit NVARCHAR(50),
	educational_to_recreational_ratio FLOAT,
	health_impacts NVARCHAR(50),
	urban_or_rural NVARCHAR(50)
);
