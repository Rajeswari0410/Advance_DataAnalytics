/* Stored procedure for loading silver layer: (Bronze -> Silver)
This SP performs the ETL process to load the silver schema tables from the bronze schema.
1. Truncates silver tables
2. Inserts transformed and cleansed data from bronze into silver tables.
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		PRINT '============================================'
		PRINT 'Loading SILVER Layer'
		PRINT '============================================'
		
		SET @start_time = GETDATE();
		PRINT '>> TRUNCATE silver.kids_screen_time'
		TRUNCATE TABLE silver.kids_screen_time;

		PRINT '>> Insert silver.kids_screen_time'
		INSERT INTO silver.kids_screen_time (
			age,
			gender,
			avg_daily_screen_time_hr,
			primary_device,
			exceeded_recommended_limit,
			educational_to_recreational_ratio,
			health_impacts,
			urban_or_rural)

		SELECT 
		age,
		CASE WHEN UPPER(TRIM(gender)) IN ('F', 'FEMALE') THEN 'Female'
			 WHEN UPPER(TRIM(gender)) IN ('MALE','M') THEN 'Male'
			 ELSE 'Unknown'
		END AS gender,
		avg_daily_screen_time_hr,
		CASE UPPER(TRIM(primary_device))
			WHEN 'TV' THEN 'Television'
			WHEN 'SMARTPHONE' THEN 'Smartphone'
			WHEN 'LAPTOP' THEN 'Laptop'
			WHEN 'TABLET' THEN 'Tablet'
			ELSE 'Unknown'
		END AS primary_device,
		CASE WHEN UPPER(TRIM(exceeded_recommended_limit)) IN ('TRUE','T') THEN 'True'
			ELSE 'False'
		END AS exceeded_recommended_limit,
		educational_to_recreational_ratio,
		CASE WHEN LEFT(health_impacts, 1) = '"' AND RIGHT(SUBSTRING(CONCAT(TRIM(health_impacts),' ', TRIM(urban_or_rural)), 0, LEN(CONCAT(TRIM(health_impacts),' ', TRIM(urban_or_rural)))-5), 1) = '"' 
				THEN 
				CASE
					WHEN UPPER(SUBSTRING(health_impacts, 2, LEN(health_impacts) - 1)) LIKE 'P%' THEN 'Poor Sleep'
					WHEN UPPER(SUBSTRING(health_impacts, 2, LEN(health_impacts) - 1)) LIKE 'E%' THEN 'Eye Strain'
					WHEN UPPER(SUBSTRING(health_impacts, 2, LEN(health_impacts) - 1)) LIKE 'A%' THEN 'Anxiety'
					WHEN UPPER(SUBSTRING(health_impacts, 2, LEN(health_impacts) - 1)) LIKE 'O%' THEN 'Obesity Risk'
				ELSE 'None'
				END
			ELSE
				CASE WHEN health_impacts LIKE 'P%' THEN 'Poor Sleep'
					WHEN health_impacts LIKE 'E%' THEN 'Eye Strain'
					WHEN health_impacts LIKE 'A%' THEN 'Anxiety'
					WHEN health_impacts LIKE 'O%' THEN 'Obesity Risk'
				ELSE 'None'
				END
		END AS health_impacts,
		CASE UPPER(SUBSTRING(CONCAT(health_impacts,' ', urban_or_rural), LEN(CONCAT(health_impacts,' ', urban_or_rural))-4, 5))
			WHEN 'RURAL' THEN 'Rural'
			WHEN 'URBAN' THEN 'Urban'
			ELSE 'Unknown'
		END AS urban_or_rural
		FROM bronze.kids_screen_time;

		SET @end_time = GETDATE();
		PRINT '!!!Load Duration: ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + ' seconds';
		-- SELECT * FROM silver.kids_screen_time;
	END TRY
	BEGIN CATCH 
		PRINT '==========================================='
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error Message' + CAST (ERROR_MESSAGE() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT '==========================================='
	END CATCH
END

-- Usage: EXEC silver.load_silver
