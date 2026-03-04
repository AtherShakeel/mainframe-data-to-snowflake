# Technical Troubleshooting & Design Decisions

### 1. IICS Parameter Visibility Issue

- **Problem**: Standard `String` type In-Out parameters were not visible in the MCT (Mapping Task) when using Azure Blob V3.
- **Solution**: Parameters were re-defined as **Data-Object** types. This allowed the Taskflow to successfully capture the Snowflake Audit Status.

### 2. Path Resolution & Listener Stability

- **Problem**: Landing files in deep sub-folders caused `Object Not Found` errors in the IICS File Listener.
- **Solution**: Implemented **Root-Level Landing**. Files land at the container root to ensure 100% trigger reliability, then are moved to `/process` or `/archive` via AzCopy.

### 3. Synchronous Audit Feedback

- **Mechanism**: The Taskflow waits for a specific Mapping Task that queries `OPS.ETL_AUDIT_RUN`.
- **Result**: If Snowflake returns 'FAILED', the Taskflow branches to an error-handling path instead of silently finishing.
