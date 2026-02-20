# Voice-WebBuilder-Agent

Talk to a voice AI agent on stage — and watch it build a website live.

## How it works

```
Voice Agent (ElevenLabs)
    ↓ webhook POST /modify-website
Local Pipeline (Flask + ngrok)
    ↓ Anthropic API → generates HTML
    ↓ git push
Vercel (auto-deploy from main)
    ↓
Live website updated in ~30 seconds
```

1. **Voice agent** (ElevenLabs) collects event info from the presenter
2. On command ("Build!"), it sends a webhook with full content description
3. **Pipeline server** receives the payload, calls Anthropic API to generate HTML
4. The generated page is pushed to GitHub → Vercel auto-deploys
5. Photos can be uploaded from phone via `/upload` endpoint

## Project structure

```
Voice-WebBuilder-Agent/
├── site/                  ← Vercel root directory
│   ├── index.html         ← generated page (or placeholder)
│   └── photos/            ← uploaded event photos
├── pipeline/              ← local-only pipeline (not served by Vercel)
│   ├── webhook-server.py  ← Flask server (port 5555)
│   ├── modify-site.py     ← Anthropic API call + git push
│   ├── start.sh           ← one-command start (server + ngrok)
│   ├── reset.sh           ← restore placeholder page
│   ├── agent-prompt.md    ← voice agent system prompt
│   └── .env.example       ← API key template
├── docs/                  ← additional documentation
├── .gitignore
└── README.md
```

## Quick start

### 1. Clone and configure

```bash
git clone https://github.com/martinmajsawicki/Voice-WebBuilder-Agent.git
cd Voice-WebBuilder-Agent/pipeline
cp .env.example .env
# Edit .env — add your ANTHROPIC_API_KEY
```

### 2. Install dependencies

```bash
pip install flask anthropic
# Install ngrok: https://ngrok.com/download
```

### 3. Connect Vercel

1. Go to [vercel.com/new](https://vercel.com/new)
2. Import this repo
3. Set **Root Directory** to `site`
4. Framework: "Other"
5. Deploy

### 4. Run the pipeline

```bash
cd pipeline
./start.sh
```

This starts the webhook server + ngrok tunnel. Copy the ngrok URL and paste it into your ElevenLabs agent tool configuration.

### 5. Configure ElevenLabs agent

See `pipeline/agent-prompt.md` for the complete system prompt and tool schema.

## Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/modify-website` | POST | Called by voice agent — triggers page generation |
| `/upload` | GET | Photo upload page (mobile-friendly) |
| `/upload` | POST | Receives photo files |
| `/photos-list` | GET | List uploaded photos (JSON) |
| `/status` | GET | Check if generation is running |
| `/trigger` | GET | Manual trigger (fallback) |

## Requirements

- Python 3.10+
- [Anthropic API key](https://console.anthropic.com/)
- [ngrok](https://ngrok.com/) (free tier works)
- [ElevenLabs](https://elevenlabs.io/) account (for the voice agent)
- [Vercel](https://vercel.com/) account (for auto-deploy)
