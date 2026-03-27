
USE master;
GO

-- Drop and recreate database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'KidsData')
BEGIN
  ALTER DATABASE KidsData SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE KidsData;
END;
GO 

--Create database
CREATE DATABASE KidsData;
GO
  
USE KidsData;
GO

--Create schemas
CREATE SCHEMA bronze;
GO
  
CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO
