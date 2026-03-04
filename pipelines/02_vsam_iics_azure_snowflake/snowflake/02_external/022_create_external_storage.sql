-- 022_create_external_stage_customers.sql
-- ENV: DEV
-- Purpose: External stage to Azure processed customers folder

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE WH_MF_MODERNIZATION_DEV;
USE DATABASE MF_MODERNIZATION_DEV_DB;
USE SCHEMA EXT;

CREATE OR REPLACE STAGE STG_AZ_MF_DEV_CUSTOMERS_PROCESSED
  URL = 'azure://<YOUR_AZURE_STORAGE_ACCOUNT>.blob.core.windows.net/mainframe-data/processed/mainframe/customers/'
  STORAGE_INTEGRATION = AZ_INT_MF_DEV_BLOB
  FILE_FORMAT = FF_JSON_STD;

-- Smoke test
LIST @STG_AZ_MF_DEV_CUSTOMERS_PROCESSED;