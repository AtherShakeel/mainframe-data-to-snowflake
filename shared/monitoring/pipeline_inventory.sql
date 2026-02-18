-- =====================================================
-- Pipeline Inventory & Health Check
-- Purpose: Operational visibility for Snowflake pipelines
-- =====================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE WH_IISC;
USE DATABASE IICS_DB;

-- =====================================================
-- 1. Warehouses
-- =====================================================
SELECT
    warehouse_name,
    state,
    size,
    auto_suspend,
    auto_resume
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSES
WHERE warehouse_name = 'WH_IISC'
ORDER BY warehouse_name;


-- =====================================================
-- 2. External Stages
-- =====================================================
SHOW STAGES IN DATABASE IICS_DB;


-- =====================================================
-- 3. Snowpipes
-- =====================================================
SHOW PIPES IN DATABASE IICS_DB;


-- =====================================================
-- 4. Snowpipe Load History (last 1 hour)
-- =====================================================
SELECT
    PIPE_NAME,
    FILE_NAME,
    STATUS,
    LAST_LOAD_TIME,
    ROW_COUNT,
    ERROR_COUNT
FROM TABLE(
    INFORMATION_SCHEMA.COPY_HISTORY(
        TABLE_NAME=>'RAW.USERS_JSON',
        START_TIME=>DATEADD('HOUR', -1, CURRENT_TIMESTAMP())
    )
)
ORDER BY LAST_LOAD_TIME DESC;


-- =====================================================
-- 5. Streams (Backlog Check)
-- =====================================================
SHOW STREAMS IN DATABASE IICS_DB;

-- Check if stream has pending data
SELECT
    SYSTEM$STREAM_HAS_DATA('RAW.USERS_JSON_STM') AS STREAM_HAS_PENDING_DATA;


-- =====================================================
-- 6. Tasks
-- =====================================================
SHOW TASKS IN DATABASE IICS_DB;


-- =====================================================
-- 7. Task Execution History (last 1 hour)
-- =====================================================
SELECT
    NAME,
    STATE,
    SCHEDULED_TIME,
    COMPLETED_TIME,
    ERROR_MESSAGE
FROM TABLE(
    INFORMATION_SCHEMA.TASK_HISTORY(
        SCHEDULED_TIME_RANGE_START => DATEADD('HOUR', -1, CURRENT_TIMESTAMP())
    )
)
WHERE NAME = 'USERS_UPSERT_TASK'
ORDER BY SCHEDULED_TIME DESC;


-- =====================================================
-- 8. Recent Errors (Account level)
-- =====================================================
SELECT
    EVENT_TIMESTAMP,
    EVENT_TYPE,
    OBJECT_NAME,
    ERROR_MESSAGE
FROM SNOWFLAKE.ACCOUNT_USAGE.EVENTS
WHERE EVENT_TIMESTAMP > DATEADD('HOUR', -1, CURRENT_TIMESTAMP())
ORDER BY EVENT_TIMESTAMP DESC;
