/* Stored procedure for loading bronze layer:
This SP loads dat into the 'Bronze' schema from external csv files.
It performs:
  1. Truncates the bronze tables before loading data
  2. Uses the 'BULK INSERT' command to load data from csv files to bronze tables.
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		PRINT '============================================'
		PRINT 'Loading Bronze Layer'
		PRINT '============================================'

		SET @start_time = GETDATE();
		PRINT '>> Truncating table:kids_screen_time'
		TRUNCATE TABLE bronze.kids_screen_time;

		PRINT '	Inserting data into: cust_info'
		BULK INSERT bronze.kids_screen_time -- entire csv loading not row wise
		FROM 'C:\Users\Rajeswari\Downloads\screen_time_of_kids_in_india.txt'
		WITH (
			FIRSTROW = 2, -- Ignore header
			FIELDTERMINATOR = ',', --delimiter
			TABLOCK -- to lock the table while loading the data
		);
		SET @end_time = GETDATE();
		PRINT '!!!Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-----------------';
	END TRY
	BEGIN CATCH 
		PRINT '==========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + CAST (ERROR_MESSAGE() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT '==========================================='
	END CATCH
END

/* Usage Example:
EXEC bronze.load_bronze;
*/

-- SELECT * FROM bronze.kids_screen_time;
