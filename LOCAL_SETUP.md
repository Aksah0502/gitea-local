# Gitea Local Setup

## Environment

- OS: Windows
- Go: 1.27.0
- Node.js: 22.x
- npm: 11.x
- pnpm: 10.x+
- Git
- Make
- GCC/G++
- MSYS2 UCRT64
- SQLite

## Build

Gitea was built from source without Docker using:

```bash
TAGS="bindata sqlite sqlite_unlock_notify" make build