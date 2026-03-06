# DNF5 JSON Output Examples

This document provides examples of JSON output format for DNF5 commands that support the `--json` flag.

## History Commands

### `dnf5 history list --json`

Lists transactions in JSON format:

```json
{
  "transactions": [
    {
      "id": 123,
      "command_line": "dnf install vim",
      "start_time": "2024-01-15 10:30:00",
      "end_time": "2024-01-15 10:32:15",
      "user_id": 0,
      "status": "OK",
      "releasever": "40",
      "altered_count": 5
    },
    {
      "id": 122,
      "command_line": "dnf update",
      "start_time": "2024-01-14 15:20:10",
      "end_time": "2024-01-14 15:25:30",
      "user_id": 1000,
      "status": "OK",
      "releasever": "40",
      "altered_count": 12
    }
  ]
}
```

### `dnf5 history info --json`

Shows detailed transaction information:

**Single Transaction:**
```json
{
  "transaction": {
    "id": 123,
    "start_time": "2024-01-15 10:30:00",
    "end_time": "2024-01-15 10:32:15",
    "rpmdb_version_begin": "abc123def456",
    "rpmdb_version_end": "def456ghi789",
    "user_id": 0,
    "user_name": "0 (root)",
    "status": "OK",
    "releasever": "40",
    "description": "dnf install vim",
    "comment": "",
    "packages": [
      {
        "nevra": "vim-enhanced-9.0.1234-1.fc40.x86_64",
        "action": "Install",
        "reason": "User",
        "repository": "fedora"
      },
      {
        "nevra": "vim-common-9.0.1234-1.fc40.x86_64",
        "action": "Install",
        "reason": "Dependency",
        "repository": "fedora"
      }
    ],
    "groups": [],
    "environments": []
  }
}
```

**Multiple Transactions:**
```json
{
  "transactions": [
    {
      "id": 123,
      "start_time": "2024-01-15 10:30:00",
      "end_time": "2024-01-15 10:32:15",
      "rpmdb_version_begin": "abc123def456",
      "rpmdb_version_end": "def456ghi789",
      "user_id": 0,
      "user_name": "0 (root)",
      "status": "OK",
      "releasever": "40",
      "description": "dnf install vim",
      "comment": "",
      "packages": [...],
      "groups": [],
      "environments": []
    }
  ]
}
```

**Empty Results:**
```json
{
  "transactions": []
}
```

## Other Commands with JSON Support

### `dnf5 advisory list --json`
### `dnf5 advisory info --json`
### `dnf5 repo list --json`
### `dnf5 repo info --json`

See respective command documentation for JSON format details.

## JSON Output Guarantees

- All commands with `--json` flag will **always** output valid JSON
- Empty results return appropriate empty structures (e.g., `{"transactions": []}`)
- Error conditions are handled gracefully within JSON structure
- Field names and structure remain consistent across versions
