![Snowflake](https://img.shields.io/badge/Snowflake-Cloud%20Data%20Platform-blue?logo=snowflake)
![Azure](https://img.shields.io/badge/Azure-Cloud-0078D4?logo=microsoft-azure)
![Informatica](https://img.shields.io/badge/Informatica-IICS-orange)
![Data%20Engineering](https://img.shields.io/badge/Domain-Data%20Engineering-success)
![Mainframe](https://img.shields.io/badge/Focus-Mainframe%20Modernization-red)
![Architecture](https://img.shields.io/badge/Pattern-RAW%20to%20CURATED-brightgreen)
![Deployment](https://img.shields.io/badge/Version%20Control-Git-black)


<p align="center">
  <img src="./architecture/repo_overview.png" width="900" alt="Project Architecture Overview">
</p>

# Mainframe Modernization Data Pipelines (IICS + Azure + Snowflake)

This repository showcases **end-to-end cloud data pipelines built for modernizing legacy and relational data sources into Snowflake** using **Informatica Intelligent Cloud Services (IICS)** and **Azure Blob Storage**.

The pipelines demonstrate enterprise ingestion patterns including **event-driven processing, Snowpipe auto-ingestion, Streams/Tasks-based transformations, and RAW → CURATED data architecture**.

The primary focus of this project is **mainframe data modernization**, where complex **VSAM copybook datasets containing REDEFINES and OCCURS structures are parsed using the IICS IMS model and transformed into analytics-ready Snowflake tables**.

Each pipeline in this repository represents a real-world enterprise integration scenario and includes **IICS mappings, Snowflake SQL assets, Azure storage integration, and monitoring scripts**.

# Architecture Overview

Common architecture pattern used across pipelines:

_Source System_
→ IICS Extraction / Transformation
→ Azure Blob Storage (Landing Zone)
→ Snowpipe Auto-Ingest
→ Snowflake RAW Layer
→ Streams + Tasks Processing
→ Curated Tables
→ Monitoring & Audit

# Pipelines

### 01 - MySQL → IICS → Azure Blob → Snowflake (Snowpipe + Streams/Tasks)

### Path: pipelines/01_mysql_iics_json_demo/

_Highlights:_

IICS connects to MySQL database to extract data

IICS mapping uses transformations like Hierarchy Builder to create JSON

JSON files are written to Azure Blob Storage

Snowflake external stage + Snowpipe auto-ingest loads files into RAW tables

RAW layer uses VARIANT columns for semi-structured ingestion

Streams + Tasks enable incremental transformations

MERGE-based upsert loads curated relational tables

Deduplication strategy based on latest LOAD_TS

### 02 - VSAM → IICS → Azure Blob → Snowflake (Mainframe Modernization)

# Path: pipelines/02_vsam_iics_azure_snowflake/

This pipeline demonstrates mainframe modernization patterns for migrating complex VSAM copybook data structures into Snowflake.

_Highlights:_

VSAM batch file ingestion using IICS file listener

Parsing complex copybooks containing REDEFINES and OCCURS

IICS IMS model used to normalize hierarchical structures

Data split into Header / Detail / Trailer datasets

Files written to Azure Blob process container

Snowpipe automatically loads data into RAW Snowflake tables

Streams + Tasks + Stored Procedures transform data into curated structures

End-to-end pipeline monitoring using OPS.ETL_AUDIT_RUN audit table

IICS polls Snowflake audit table to determine pipeline success/failure

### Repository Structure

architecture/
high_level_arch.png

pipelines/
01_mysql_iics_json_demo/
02_vsam_iics_azure_snowflake/

shared/
monitoring/

# Each pipeline contains:

_azure/_ → storage setup and configuration
_iics/_ → exported IICS mappings and taskflows
_snowflake/_ → SQL scripts for stages, pipes, streams, tasks
_docs/_ → architecture notes and pipeline design
_sample_data/_ → test datasets and copybooks

# Security Notes

No credentials or secrets are stored in this repository.

Sensitive configurations such as:

Azure storage credentials

Snowflake account parameters

IICS connection details

must be supplied through environment variables or secure configuration management.

# Technologies Used

Mainframe VSAM Data
Informatica Intelligent Cloud Services (IICS)
Azure Blob Storage
Snowflake Data Cloud
Snowpipe Auto-Ingest
Snowflake Streams & Tasks
SQL Data Transformation
Git Version Control

# Purpose of This Repository

This project demonstrates enterprise data engineering patterns used in mainframe modernization initiatives, including:

Legacy data extraction and parsing

Cloud-based ingestion pipelines

Automated transformation workflows

Scalable Snowflake warehouse architecture

End-to-end pipeline monitoring and auditability
