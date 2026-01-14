# Unity Build Template for STAN

This repository contains GitHub Actions workflows for building Unity WebGL games created by STAN AI.

## 🎯 Features

- **Automated Unity WebGL Builds**: Triggered via workflow_dispatch from STAN backend
- **Ad Injection**: Automatically injects Adsterra monetization for free-tier games
- **Domain Lockdown**: Games only run on `*.stanlink.online` and `*.stanl.ink` domains
- **R2 Deployment**: Builds deployed to Cloudflare R2 bucket `stan-games`

## 🔧 Setup

### Repository Secrets

**R2 Configuration:**
- `R2_ACCESS_KEY`: Your R2 access key
- `R2_SECRET_KEY`: Your R2 secret key
- `R2_ENDPOINT`: `https://<account-id>.r2.cloudflarestorage.com`

**Unity License:**
- `UNITY_EMAIL`: Your Unity account email
- `UNITY_PASSWORD`: Your Unity account password

**STAN Backend:**
- `STAN_BACKEND_URL`: `https://stan-backend.stanleyisaac134.workers.dev`
- `STAN_API_KEY`: Your STAN API key

## 📊 Build Process

1. **Download** Unity project from R2 `stan-projects` bucket
2. **Build** WebGL using Unity Builder (game-ci/unity-builder@v4)
3. **Inject Ads** - Adsterra script added to `index.html`
4. **Deploy** to R2 `stan-games/{slug}/` folder
5. **Notify** STAN backend of completion
6. **Cleanup** all temporary files

## 🔒 Security Features

### Domain Lockdown
- **StanSecurity.cs**: Injected by CodingAgent into every game
- **StanBridge.jslib**: WebGL plugin for URL verification
- Games check if hosted on authorized domains (`stanlink.online` or `stanl.ink`)
- Unauthorized hosting redirects to `https://games.stanlink.online`

### Ad Injection
- `inject-ads.js` runs post-build
- Adsterra Social Bar script injected into `index.html`
- Free-tier games monetized automatically

## 🎮 Deployment

Games are accessible at: **`https://games.stanlink.online/{slug}`**

Example: `https://games.stanlink.online/efootball`

## 💰 Cost

- GitHub Actions: **FREE** (2000 min/month)
- Cloudflare R2: **FREE** (10GB storage)

Total: **$0/month** 🎉
