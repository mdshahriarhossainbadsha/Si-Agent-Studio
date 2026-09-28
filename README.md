# Si-Agent-Studio

Local AI Agent Studio for OpenClaw and OpenWebUI with no-code Windows batch setup.

## Overview

This project provides a simple local setup for running an AI agent interface with:
- OpenClaw gateway
- OpenWebUI dashboard
- API key management from Windows batch scripts
- Local logs and sessions
- Easy start/stop/install workflow

## Quick start

1. Run `Setup.bat`
2. Run `Add API Key.bat`
3. Run `Start Si Agent.bat`

Open your browser at:
- http://localhost:3000

## Files to run in order

- `Setup.bat` — first run; installs dependencies and prepares folders
- `Add API Key.bat` — add your AI provider keys
- `Start Si Agent.bat` — launches OpenClaw and OpenWebUI

## Supporting files

- `View Log.bat` — view live logs
- `Uninstall.bat` — remove local setup
- `docker-compose.yml` — OpenWebUI Docker configuration
- `package.json` — Node.js dependency setup
- `README-Bangla.md` — Bangla guide
- `config/agent.env.example` — sample environment file

## Requirements

- Windows 10/11
- Node.js LTS
- Docker Desktop
- Git (recommended)

## Important

Do not commit your real API keys to GitHub. The generated `config/agent.env` file should remain local only.

## Project structure

```text
Si-Agent-Studio/
├─ Setup.bat
├─ Add API Key.bat
├─ Start Si Agent.bat
├─ View Log.bat
├─ Uninstall.bat
├─ docker-compose.yml
├─ package.json
├─ .gitignore
├─ README.md
├─ README-Bangla.md
├─ config/
│  ├─ agent.env.example
│  └─ agent.env
├─ logs/
├─ data/
└─ ...
```

## License

This project is provided as-is for local development and personal use.
