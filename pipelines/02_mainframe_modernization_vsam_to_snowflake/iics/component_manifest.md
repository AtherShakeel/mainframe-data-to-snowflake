# IICS Components Manifest
This manifest provides a detailed inventory of all Informatica Intelligent Cloud Services (IICS) objects used in the VSAM Modernization pipeline.


| Component Type | Name | Description |
| :--- | :--- | :--- |
| **Connection** | `AZURE_MAINFRAME` | Microsoft Azure Blob Storage V3 connection used as the landing zone for VSAM batch files. |
| **Connection** | `SF_MF_DEV` | Snowflake Data Cloud connection for quering audit tables data. |
| **File Listener** | `fl_customers_landing_new` | Monitors the container root for incoming .dat batch files to trigger the pipeline. |
| **Taskflow** | `tf_process_customers_main` | Orchestrates the end-to-end event-driven logic, including ingestion and audit checks. |
| **MappingTask** | `mt_Lnd_to_Stg_Mainframe_Customer_Migration` | Executable task that runs the Mainframe migration logic. |
| **Mapping** | `m_Lnd_to_Stg_Mainframe_Customer_Migration` | Core logic using ISM Model to parse Copybook and split Header/Detail records. |
| **MappingTask** | `mt_audit_check` | Executable task for capturing operational status from Snowflake. |
| **Mapping** | `m_audit_check` | Logic to read and pass $$IO_Status using persistent variables. |
| **Intelligent Structure Model(ISM)** | `ISM_Mainframe_Customers_New` | COBOL Copybook parser handling complex REDEFINES and OCCURS clauses.|
| **Fixed-Width File Format** | `FW_MFREC_169` | Record layout definition (169 bytes) for the incoming VSAM file. |
