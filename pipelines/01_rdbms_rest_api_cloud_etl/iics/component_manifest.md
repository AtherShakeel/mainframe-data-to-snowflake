# IICS Components Manifest
This manifest provides a detailed inventory of all Informatica Intelligent Cloud Services (IICS) objects used in the rdbms_rest_api_cloud_rtl pipeline.


| Component Type | Name | Description |
| :--- | :--- | :--- |
| **Connection** | `MYSQL_LOCAL` | Source connection for local MySQL database containing user and transactional data.. |
| **Connection** | `AZURE_BLOB` | Target connection for Microsoft Azure Blob Storage (Landing Zone) for JSON files. |
| **Connection** | `BS_PostUser` | RESTv2 connection to the JSONPLACEHOLDER external API for user data synchronization. |
| **Hierarchical Schema** | `user_payload_schema` | Defines the nested structure (Root > Address > Geo) for JSON generation via Hierarchy Builder.  |
| **Business Service** | `BS_PostUser` | Web Service object that encapsulates the REST API operation (POST) for the mapping. |
| **MappingTask** | `mt_user_to_azure_blob` | Orchestrates the batch ingestion flow from MySQL to Azure Landing Zone.  |
| **MappingTask** | `mt_user_post_rest_api` | Orchestrates the operational sync flow to the external REST endpoint. |
| **Mapping** | `m_user_to_azure_blob` | Contains the logic for Hierarchy Builder, PK/FK linking, and file generation. |
| **Mapping** | `m_user_post_rest_api` | Contains the logic for Joiners, Web Service Consumer, and API response auditing. |