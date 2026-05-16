---
category: devops
description: Telegram Gateway configuration, diagnostics, and troubleshooting for Hermes Agent. Covers .env setup, gateway lifecycle, polling conflicts, user authorization, and log analysis.
name: telegram-gateway-config
---

# Telegram Gateway Config

Skills and procedures for managing the Hermes Agent Telegram Gateway integration.

## Setup

1. Create a bot via [@BotFather](https://t.me/BotFather) and get the token.
2. Add your token to `~/.hermes/.env`:
   ```env
   TELEGRAM_BOT_TOKEN=your_token_here
   ```
3. Find your user ID via [@userinfobot](https://t.me/userinfobot).
4. Configure the home channel and authorized users:
   ```bash
   hermes config set telegram.home_channel <your_id>
   hermes config set telegram.allowed_chats <your_id>
   ```

## Lifecycle Management

### Start/Restart
```bash
systemctl --user restart hermes-gateway
```

### Check Logs
```bash
journalctl --user -u hermes-gateway -f
```

### Stop
```bash
systemctl --user stop hermes-gateway
```

## Troubleshooting & Pitfalls

### Common Error: Forbidden
**Error**: `telegram.error.Forbidden: Forbidden: the bot can't send messages to the bot`
**Cause**: The `telegram.home_channel` in `config.yaml` is likely set to the Bot's own User ID instead of the owner's ID.
**Fix**: Verify the owner's Telegram ID (e.g., via @userinfobot) and update `config.yaml`:
```bash
hermes config set telegram.home_channel <YOUR_USER_ID>
hermes config set telegram.allowed_chats <YOUR_USER_ID>
```

### Common Error: HTTP 404 (Google Gemini)
**Error**: `Gemini returned HTTP 404: models/gemini-1.5-flash is not found`
**Cause**: Provider configuration mismatch or missing model prefix in native SDK mode.
**Fix**: 
1. Ensure `model.provider` is `google`.
2. Try adding/removing the `models/` prefix:
```bash
# Try with prefix
hermes config set model.model models/gemini-1.5-flash
# Or without
hermes config set model.model gemini-1.5-flash
```

### State Desync after Model Switch
The `hermes-gateway` service (via Systemd) does NOT automatically pick up CLI config changes until restarted.
**Action**: Always restart after changing models or providers:
```bash
systemctl --user restart hermes-gateway
```

### Context Snapshot Mismatch
If switching from a local model (Ollama) to a cloud model (Google), the cached context compression might be incompatible.
**Action**: Clear the cache if you see `BadRequest` errors immediately after a model switch:
```bash
rm -rf ~/.hermes/cache/compression/*
```
