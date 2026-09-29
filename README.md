# Si-Agent-Studio

**Local AI Agent Studio** — OpenClaw Gateway + OpenWebUI Integration for Windows

---

## ⚡ What is Si-Agent-Studio?

Si-Agent-Studio provides a **complete local setup** for:

1. **OpenClaw Gateway** — AI-agent control plane (port 18789)
   - WebSocket control interface
   - Built-in authentication
   - OpenAI-compatible API routes

2. **OpenWebUI** — Beautiful chat interface (port 3000)
   - Web-based conversation UI
   - Integrated with OpenClaw Gateway
   - Supports OpenAI API keys

---

## 📋 Prerequisites

Before starting, ensure you have:

- **Node.js v24.16+** or **v26.1+** — [Download](https://nodejs.org/)
- **npm** (comes with Node.js)
- **Docker Desktop** (for OpenWebUI) — [Download](https://www.docker.com/products/docker-desktop)
- **OpenAI API Key** (for AI models) — [Get key](https://platform.openai.com/api-keys)

### Quick Check
```bash
node --version    # Should show v24.x or v26.x
npm --version     # Should show 10.x or higher
docker --version  # Should show Docker version
```

---

## 🚀 Quick Start (4 Steps)

### Step 1: Setup Environment
```bash
Setup.bat
```

**What happens:**
- Creates config directories
- Verifies Node.js, npm, Docker
- Installs OpenClaw globally
- Creates configuration files

---

### Step 2: Configure Authentication
```bash
Configure Auth.bat
```

**What happens:**
- Generates secure authentication token
- Saves to `config/auth-token.txt`
- Sets `OPENCLAW_GATEWAY_TOKEN` in config

---

### Step 3: Add OpenAI API Key
```bash
Add API Key.bat
```

**What happens:**
- Prompts for your OpenAI API key
- Saves to `~/.openclaw/api-keys.env` (correct location)
- Available to OpenClaw Gateway

**Prompt:**
```
Enter your OpenAI API Key: sk-proj-xxxxxxxxxxxxxxxxxxxxx
```

---

### Step 4: Start Services
```bash
Start Si Agent.bat
```

**What happens:**
- Starts OpenClaw Gateway (port 18789)
- Starts OpenWebUI Docker container (port 3000)
- Both services run in background

---

## 🌐 Access Services

### OpenWebUI (Chat Interface)
```
http://localhost:3000
```
- Beautiful web-based chat interface
- Automatically connected to OpenClaw Gateway
- Uses your OpenAI API key
- Start chatting with AI models

### OpenClaw Control UI
```
http://localhost:18789/ui
```
- View active agents
- Monitor WebSocket connections
- Advanced control panel
- **Requires authentication token**

---

## 🛑 Stop Services

```bash
Stop Si Agent.bat
```

**What happens:**
- Stops OpenClaw Gateway process
- Stops OpenWebUI Docker container
- Graceful shutdown

---

## 📋 View Logs

```bash
View Logs.bat
```

**Log files location:**
- `logs/setup.log` — Setup/initialization logs
- `logs/gateway.log` — OpenClaw Gateway logs
- `logs/docker.log` — OpenWebUI Docker logs

---

## 🛠️ Configuration

### Main Config
```
config/agent.env
```
Contains:
- `OPENCLAW_PORT` — Gateway port (default: 18789)
- `OPENCLAW_GATEWAY_TOKEN` — Authentication token
- `OPENWEBUI_PORT` — Chat UI port (default: 3000)
- `ENABLE_AUTH` — Enable/disable authentication

### Docker Config
```
config/docker.env
```
Contains:
- `OPENAI_API_BASE_URL` — Points to OpenClaw Gateway
- `ENABLE_OPENAI_API` — Enable OpenAI-compatible routes
- `WEBUI_SECRET_KEY` — Session encryption key

### API Keys
```
~/.openclaw/api-keys.env
```
**Important:** This is in your Windows user home directory
- OpenClaw reads this file for API credentials
- Contains: `OPENAI_API_KEY=sk-...`
- Keep this file secure!

---

## 🔐 Security Notes

### Authentication Token
- Generated automatically in `Configure Auth.bat`
- Used to access OpenClaw Control UI
- Store safely, don't share

### API Key
- Saved in `~/.openclaw/api-keys.env`
- **Not** in the project directory (keeps it safe)
- Only readable by OpenClaw process
- Keep confidential

### Ports
- OpenClaw (18789) — **Requires authentication token**
- OpenWebUI (3000) — **No auth by default** (can be configured)

---

## 🐛 Troubleshooting

### "Node.js not found"
```bash
# Download Node.js v24+ or v26+
https://nodejs.org/

# Verify after install
node --version
npm --version
```

### "Docker not found"
```bash
# Download Docker Desktop
https://www.docker.com/products/docker-desktop

# Start Docker Desktop and verify
docker --version
```

### "API Key not configured"
```bash
# Make sure to run in order:
1. Setup.bat
2. Configure Auth.bat
3. Add API Key.bat
4. Start Si Agent.bat
```

### "Can't connect to gateway"
```bash
# Check if OpenClaw is running
tasklist | findstr "openclaw"

# Check gateway logs
type logs\gateway.log

# Restart services
Stop Si Agent.bat
Start Si Agent.bat
```

### "OpenWebUI won't start"
```bash
# Check Docker is running
docker ps

# Check Docker logs
type logs\docker.log

# Restart Docker container
docker-compose down
Start Si Agent.bat
```

---

## 📁 Project Structure

```
Si-Agent-Studio/
│
├─ Setup.bat                    ← Initialize everything
├─ Configure Auth.bat           ← Set authentication token
├─ Add API Key.bat              ← Add OpenAI API key
├─ Start Si Agent.bat           ← Start services
├─ Stop Si Agent.bat            ← Stop services
├─ View Logs.bat                ← View log files
│
├─ config/
│  ├─ agent.env                 ← Main configuration
│  ├─ auth-token.txt            ← Authentication token
│  ├─ docker.env                ← Docker environment
│  ├─ agent.env.example         ← Configuration template
│  └─ docker.env.example        ← Docker template
│
├─ logs/
│  ├─ setup.log                 ← Setup logs
│  ├─ gateway.log               ← Gateway logs
│  └─ docker.log                ← Docker logs
│
├─ data/
│  └─ (OpenWebUI conversations stored here)
│
├─ docker-compose.yml           ← Docker configuration
├─ package.json                 ← Project metadata
├─ README.md                    ← This file
└─ .gitignore                   ← Git ignore rules
```

---

## 🔄 Workflow

```
┌──────────────────────────────────────────────────────────┐
│  Windows Command Prompt                                  │
├──────────────────────────────────────────────────────────┤
│ C:\Si-Agent-Studio> Setup.bat                            │
│ ✓ Creates folders                                        │
│ ✓ Checks dependencies (Node.js, npm, Docker)             │
│ ✓ Installs OpenClaw globally                             │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ C:\Si-Agent-Studio> Configure Auth.bat                   │
│ ✓ Generates authentication token                         │
│ ✓ Saves to config/auth-token.txt                         │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ C:\Si-Agent-Studio> Add API Key.bat                      │
│ Enter API Key: sk-proj-xxxxxx                            │
│ ✓ Saves to ~/.openclaw/api-keys.env                      │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ C:\Si-Agent-Studio> Start Si Agent.bat                   │
│ ✓ OpenClaw Gateway running on :18789                     │
│ ✓ OpenWebUI running on :3000                             │
└────────────────────��─────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│  Web Browser                                             │
├──────────────────────────────────────────────────────────┤
│ http://localhost:3000                                    │
│ → OpenWebUI Chat Interface                               │
│ → Connected to OpenClaw Gateway                          │
│ → Ready to chat with AI                                  │
└──────────────────────────────────────────────────────────┘
```

---

## 🎯 First Time Setup (~5 minutes)

1. **Run Setup.bat** (2 mins)
   ```bash
   Setup.bat
   ```

2. **Run Configure Auth.bat** (10 seconds)
   ```bash
   Configure Auth.bat
   ```

3. **Run Add API Key.bat** (30 seconds)
   ```bash
   Add API Key.bat
   ```
   Paste your OpenAI API key when prompted

4. **Run Start Si Agent.bat** (1-2 mins for first Docker pull)
   ```bash
   Start Si Agent.bat
   ```

5. **Open Browser**
   ```
   http://localhost:3000
   ```
   Start chatting!

---

## 📚 Documentation References

- **OpenClaw**: https://github.com/openclawai/openclaw
- **OpenWebUI**: https://github.com/open-webui/open-webui
- **OpenAI API**: https://platform.openai.com/docs
- **Docker Desktop**: https://docs.docker.com/

---

## 💡 Tips & Tricks

### Change Ports
Edit `config/agent.env`:
```
OPENCLAW_PORT=9999      # Instead of 18789
OPENWEBUI_PORT=4000    # Instead of 3000
```
Then restart services.

### Change OpenAI Model
In OpenWebUI Settings → Model Selection
- gpt-4o
- gpt-4-turbo
- gpt-3.5-turbo
- (whatever your API key supports)

### View Control UI
```
http://localhost:18789/ui
```
Enter your authentication token when prompted.

### Access Gateway Directly
```bash
curl -X POST http://localhost:18789/v1/chat/completions \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"model": "gpt-4o", "messages": [{"role": "user", "content": "Hello"}]}'
```

---

## 🤝 Support

If you encounter issues:

1. **Check logs** → `View Logs.bat`
2. **Verify prerequisites** → Run `Setup.bat` again
3. **Restart services** → `Stop Si Agent.bat` → `Start Si Agent.bat`
4. **Review configuration** → Check `config/agent.env`

---

## 📄 License

MIT License — Free for personal and commercial use.

---

**Enjoy your local AI Agent Studio! 🚀**