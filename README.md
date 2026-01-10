# Unity Build Template

This repository contains GitHub Actions workflows for building Unity WebGL games for the STAN platform.

## 🎯 Purpose

- Builds Unity games from R2 storage
- Deploys to Cloudflare Pages
- No Unity files stored in Git!

## 🔧 Setup

### 1. Repository Secrets

Add these secrets to your repository:

**R2 Configuration:**
- `R2_ACCESS_KEY`: Your R2 access key
- `R2_SECRET_KEY`: Your R2 secret key
- `R2_ENDPOINT`: `https://<account-id>.r2.cloudflarestorage.com`
- `R2_BUCKET`: `stan-assets`

**Unity License:**
- `UNITY_LICENSE`: Your Unity license file content
- `UNITY_EMAIL`: Your Unity account email
- `UNITY_PASSWORD`: Your Unity account password

**Cloudflare Pages:**
- `CLOUDFLARE_API_TOKEN`: Your CF API token
- `CLOUDFLARE_ACCOUNT_ID`: Your CF account ID

**STAN Backend:**
- `STAN_BACKEND_URL`: `https://stan-backend.stanleyisaac134.workers.dev`
- `STAN_API_KEY`: Your STAN API key

### 2. Workflow Trigger

The workflow is triggered via API:

```bash
curl -X POST \
  https://api.github.com/repos/StaNLink-Inc/unity-build-template/actions/workflows/build-unity-webgl.yml/dispatches \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "ref": "main",
    "inputs": {
      "project_id": "proj_abc123",
      "r2_path": "projects/proj_abc123",
      "game_name": "My Awesome Game"
    }
  }'
```

## 📊 Build Process

1. **Download** Unity project from R2 (2 min)
2. **Build** WebGL with Unity (5-10 min)
3. **Deploy** to CF Pages (1 min)
4. **Notify** STAN backend
5. **Cleanup** all files

## 🎮 Result

Game deployed to: `https://{project_id}.stan-games.pages.dev`

## 💰 Cost

- GitHub Actions: **FREE** (2000 min/month)
- Cloudflare Pages: **FREE** (unlimited)

Total: **$0/month** 🎉
