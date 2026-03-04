# IICS Components Manifest
This manifest provides a detailed inventory of all Informatica Intelligent Cloud Services (IICS) objects used in the VSAM Modernization pipeline.


| Component Type | Name | Description |
| :--- | :--- | :--- |
| **Connection** | `AZURE_MAINFRAME` | Microsoft Azure Blob Storage V3 Connection. |
| **Connection** | `SF_MF_DEV` | Snowflake Data Cloud Connection. |
| **File Listener** | `fl_customers_landing_new` | Monitors Container Root for `.dat` files. |
| **Taskflow** | `tf_process_customers_main` | Orchestrates the end-to-end event-driven logic. |
| **MappingTask** | `mt_Lnd_to_Stg_Mainframe_Customer_Migration` | Uses IMS Model to parse Copybook and split Header/Detail. |
| **MappingTask** | `mt_audit_check` | Captures `$$IO_Status` from Snowflake Audit Table. |
| **Mapping** | `m_Lnd_to_Stg_Mainframe_Customer_Migration` | Uses IMS Model to parse Copybook and split Header/Detail. |
| **Mapping** | `m_audit_check` | Captures `$$IO_Status` from Snowflake Audit Table. |
| **Intelligent Structure Model(ISM)** | `ISM_Mainframe_Customers_New` | Using the COBOL Copybook, it parses and normalizes the landing
|   VSAM batch file having data structured in complex REDEFINES and OCCURS clauses.|
| **Fixed-Width File Format** | `FW_MFREC_169` | File format for the incoming VSAM batch file. |