-- Context first (readability)
USE ROLE ACCOUNTADMIN;                     -- or any other role you want
USE WAREHOUSE WH_IISC;                     -- optional here, but fine

-- Create database + schemas safely
CREATE DATABASE IF NOT EXISTS IICS_DB;

CREATE SCHEMA IF NOT EXISTS IICS_DB.RAW;
CREATE SCHEMA IF NOT EXISTS IICS_DB.CURATED;


