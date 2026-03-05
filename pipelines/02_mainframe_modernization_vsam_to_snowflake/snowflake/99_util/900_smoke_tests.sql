--EXT: “How do I read Azure?”
--RAW: “What arrived?”
--CURATED: “What’s the usable final dataset?”
--OPS: “Did it work? What failed? What do I tell IICS?”

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE WH_MF_MODERNIZATION_DEV;
USE DATABASE MF_MODERNIZATION_DEV_DB;

--------------------------------------------------
-- 1. Azure files visible?
--------------------------------------------------
LIST @EXT.STG_AZ_MF_DEV_CUSTOMERS_PROCESSED;

--------------------------------------------------
-- 2. RAW counts (Snowpipe check)
--------------------------------------------------
SELECT 'RAW_HEADER' T, COUNT(*) FROM RAW.RAW_CUS_HEADER_V
UNION ALL
SELECT 'RAW_DETAIL', COUNT(*) FROM RAW.RAW_CUS_DETAIL_V
UNION ALL
SELECT 'RAW_TRAILER', COUNT(*) FROM RAW.RAW_CUS_TRAILER_V;

--------------------------------------------------
-- 3. CURATED counts (Task check)
--------------------------------------------------
SELECT 'CUR_HEADER' T, COUNT(*) FROM CURATED.CUS_HEADER
UNION ALL
SELECT 'CUR_DETAIL', COUNT(*) FROM CURATED.CUS_DETAIL
UNION ALL
SELECT 'CUR_TRAILER', COUNT(*) FROM CURATED.CUS_TRAILER;

--------------------------------------------------
-- 4. Latest pipeline status (Audit)
--------------------------------------------------
SELECT *
FROM OPS.ETL_AUDIT_RUN
ORDER BY START_TS DESC
LIMIT 5;

--------------------------------------------------
-- 5. Task history (last 1 hour)
--------------------------------------------------
SELECT NAME, STATE, COMPLETED_TIME, ERROR_MESSAGE
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
    SCHEDULED_TIME_RANGE_START => DATEADD('hour', -1, CURRENT_TIMESTAMP())
))
WHERE NAME = 'TSK_CURATE_CUSTOMERS_ALL'
ORDER BY SCHEDULED_TIME DESC;