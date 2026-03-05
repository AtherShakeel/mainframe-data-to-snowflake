# Azure Notes (Pipeline 01)

- Storage account: atheriicsstorage
- Container: iics-data
- Event Grid subscription: BlobCreated → Storage Queue (for Snowpipe notifications)

Security:

- Do not store SAS tokens in Git.
- Tokens should be injected at runtime.
