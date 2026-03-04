-- 020_create_storage_integration.sql
-- ENV: DEV
-- Purpose: Snowflake ↔ Azure trust (Storage Integration)

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE WH_MF_MODERNIZATION_DEV;
USE DATABASE MF_MODERNIZATION_DEV_DB;
USE SCHEMA EXT;

CREATE OR REPLACE STORAGE INTEGRATION AZ_INT_MF_DEV_BLOB
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = (
    'azure://<YOUR_AZURE_STORAGE_ACCOUNT>.blob.core.windows.net/mainframe-data/processed/mainframe/customers/'
  )
  AZURE_TENANT_ID = '<YOUR_AZURE_ENTRA_ID>';

-- Required for Azure-side setup (consent + app name)
DESC STORAGE INTEGRATION AZ_INT_MF_DEV_BLOB;