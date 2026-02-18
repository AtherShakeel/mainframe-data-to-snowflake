# Mainframe Modernization Data Pipeline (IICS + Azure + Snowflake)

This repository contains end-to-end data pipeline implementations that demonstrate enterprise patterns for moving data from source systems to Snowflake.

## Pipelines

### 01 - MySQL → IICS → Azure Blob → Snowflake (Snowpipe + Streams/Tasks)

**Path:** `pipelines/01_mysql_iics_json_demo/`

Highlights:

- IICS connects to MYSQL database to get the data
- IICS mapping uses transformations like hierarchy builder to build JSON
- IICS then writes JSON files to Azure Blob Storage
- Snowflake external stage + Snowpipe auto-ingest using Azure Event Grid
- RAW layer (VARIANT) landing
- Incremental processing with Streams + Tasks
- MERGE-based upsert into CURATED tables
- Dedupe strategy based on latest LOAD_TS

## Repo Structure

- `pipelines/` – individual pipelines with their own Snowflake/IICS/Azure assets
- `architecture_diagrams/` – architecture images/diagrams
- `shared/` – shared monitoring scripts and templates

## Security Notes

No secrets are committed to GitHub.

- Azure SAS tokens must be injected at runtime (env vars / CI secrets)
- Never commit credentials in SQL files

## Next Pipeline (Planned)

- VSAM/Copybook (EBCDIC, COMP-3, OCCURS, REDEFINES) → IICS → Azure → Snowflake
