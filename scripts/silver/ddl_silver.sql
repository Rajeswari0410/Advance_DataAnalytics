/* Create Silver Tables
This script creates tables in the 'silver' schema, droppping exsisting tables if they already exist.
To re-define the DDL structure of 'Bronze' Tables
*/

/*
This script creates tables in the 'silver' schema, dropping exisisting tables if they already exist
Adding meta data like create date, updated date, source system, file location.
*/

IF OBJECT_ID ('silver.kids_screen_time', 'U') IS NOT NULL
	DROP TABLE silver.kids_screen_time;

CREATE TABLE silver.kids_screen_time (
	age INT,
	gender NVARCHAR(50),
	avg_daily_screen_time_hr FLOAT,
	primary_device NVARCHAR(50),
	exceeded_recommended_limit NVARCHAR(50),
	educational_to_recreational_ratio FLOAT,
	health_impacts NVARCHAR(50),
	urban_or_rural NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
