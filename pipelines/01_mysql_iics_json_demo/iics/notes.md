# IICS Notes (Pipeline 01)

- Source: MySQL
- Mapping: transforms + Hierarchy Builder to produce JSON
- Target: Azure Blob write (JSON file output)
- Key learnings:
  - RAW stores VARIANT
  - CURATED parses `DATA:"Output"` and flattens columns
