# R2 Bucket Configuration for Stan

## 🎯 Two Buckets Setup

You have 2 R2 buckets for raw materials:

### 1. `stan-templates` Bucket
**Purpose**: Store complete Unity project templates (.unitypackage files)
**Access**: Public (via R2 dev URL)
**Content**: Full game templates that can be cloned

### 2. `stan-assets` Bucket  
**Purpose**: Store individual assets (3D models, audio, sprites, etc.)
**Access**: Public (via R2 dev URL)
**Content**: Ripped assets from templates or uploaded individual files

---

## 🔧 Cloudflare Dashboard Setup

### Step 1: Add Custom Domains to Buckets (RECOMMENDED)

#### For `stan-templates`:
```bash
1. Go to: Cloudflare Dashboard → R2 → stan-templates
2. Click "Settings" tab
3. Scroll to "Custom Domains"
4. Click "Connect Domain"
5. Enter: stantemplates.cloud.stanlink.online
6. Click "Continue" and follow DNS setup
7. Wait for DNS propagation (usually 5-10 minutes)
8. Your templates will be available at: https://stantemplates.cloud.stanlink.online
```

#### For `stan-assets`:
```bash
1. Go to: Cloudflare Dashboard → R2 → stan-assets
2. Click "Settings" tab
3. Scroll to "Custom Domains"
4. Click "Connect Domain"
5. Enter: stanassets.cloud.stanlink.online
6. Click "Continue" and follow DNS setup
7. Wait for DNS propagation (usually 5-10 minutes)
8. Your assets will be available at: https://stanassets.cloud.stanlink.online
```

**Benefits of Custom Domains:**
- ✅ Unlimited bandwidth (no rate limits)
- ✅ Professional branding
- ✅ Better performance with Cloudflare CDN
- ✅ No user limits (dev URLs are restricted)
- ✅ Custom caching and security rules

---

### Step 2: Enable Public Access (Required)

Even with custom domains, you need to enable public access:

#### For `stan-templates`:
```bash
1. Go to: Cloudflare Dashboard → R2 → stan-templates
2. Click "Settings" tab
3. Scroll to "Public Access"
4. Click "Allow Access"
5. (Optional) Note the dev URL as backup: https://pub-xxxxx.r2.dev
```

#### For `stan-assets`:
```bash
1. Go to: Cloudflare Dashboard → R2 → stan-assets
2. Click "Settings" tab
3. Scroll to "Public Access"
4. Click "Allow Access"
5. (Optional) Note the dev URL as backup: https://pub-yyyyy.r2.dev
```

---

## 🔑 GitHub Secrets Configuration

Add these secrets to your `unity-build-template` repository:

```bash
Repository → Settings → Secrets and variables → Actions → New repository secret
```

### Required Secrets:

1. **R2_ACCESS_KEY**
   - Your Cloudflare R2 Access Key ID
   - Get from: Cloudflare Dashboard → R2 → Manage R2 API Tokens

2. **R2_SECRET_KEY**
   - Your Cloudflare R2 Secret Access Key
   - Get from: Same place as above

3. **R2_ENDPOINT**
   - Format: `https://<account-id>.r2.cloudflarestorage.com`
   - Get account ID from: Cloudflare Dashboard → R2 (in URL)

4. **STAN_TEMPLATES_PUBLIC_URL** (RECOMMENDED)
   - Your custom domain for templates
   - Example: `https://stantemplates.cloud.stanlink.online`
   - Fallback: `https://pub-xxxxx.r2.dev` (dev URL)

5. **STAN_ASSETS_PUBLIC_URL** (RECOMMENDED)
   - Your custom domain for assets
   - Example: `https://stanassets.cloud.stanlink.online`
   - Fallback: `https://pub-yyyyy.r2.dev` (dev URL)

6. **STAN_BACKEND_URL**
   - Your backend URL for Vectorize notifications
   - Example: `https://stan-backend.stanleyisaac134.workers.dev`

7. **STAN_API_KEY**
   - API key for backend authentication
   - Generate a secure random string

---

## 📋 Workflow Usage Examples

### Example 1: Upload Template from Public URL
```yaml
# Trigger workflow manually with these inputs:
mode: template
source_url: https://example.com/racing-game.unitypackage
asset_type: racing
rip_template: true
description: "Racing game template with car physics"
```

**What happens:**
1. Downloads from public URL
2. Saves to `stan-templates/racing/base.unitypackage`
3. Rips assets to `stan-assets/library/ripped/racing/`
4. Notifies backend for Vectorize indexing

---

### Example 2: Upload Template from Custom Domain
```yaml
mode: template
source_url: https://stantemplates.cloud.stanlink.online/temp/uploaded-template.unitypackage
asset_type: platformer
rip_template: true
description: "2D platformer template"
```

**What happens:**
1. Downloads from custom domain (fast, unlimited bandwidth)
2. Saves to `stan-templates/platformer/base.unitypackage`
3. Rips assets to `stan-assets/library/ripped/platformer/`

---

### Example 3: Upload Single Asset
```yaml
mode: asset-single
source_url: https://example.com/player-model.fbx
asset_type: models
description: "Player character 3D model"
```

**What happens:**
1. Downloads the file
2. Saves to `stan-assets/library/models/asset_<timestamp>`
3. Notifies backend for indexing

---

### Example 4: Rip Assets from Existing Template
```yaml
mode: asset-rip
source_url: library/templates/racing/base.unitypackage
asset_type: racing-assets
description: "Extract all assets from racing template"
```

**What happens:**
1. Uses AWS CLI to download from private path
2. Extracts all assets
3. Saves to `stan-assets/library/ripped/racing-assets/`

---

## 🎯 Bucket Structure After Ingestion

### stan-templates/
```
racing/
  └── base.unitypackage
platformer/
  └── base.unitypackage
puzzle/
  └── base.unitypackage
```

### stan-assets/
```
library/
  ├── models/
  │   ├── asset_1234567890
  │   └── asset_1234567891
  ├── audio/
  │   ├── asset_1234567892
  │   └── asset_1234567893
  └── ripped/
      ├── racing/
      │   ├── Models/
      │   │   └── Car.fbx
      │   └── Audio/
      │       └── engine.wav
      └── platformer/
          └── Sprites/
              └── player.png
```

---

## 🚀 Quick Start Commands

### Get Your R2 Account ID:
```bash
# From Cloudflare Dashboard URL when viewing R2:
# https://dash.cloudflare.com/<account-id>/r2/overview
```

### Test AWS CLI Access:
```bash
aws configure set aws_access_key_id YOUR_ACCESS_KEY
aws configure set aws_secret_access_key YOUR_SECRET_KEY
aws configure set default.region auto

# List templates
aws s3 ls s3://stan-templates/ --endpoint-url https://<account-id>.r2.cloudflarestorage.com

# List assets
aws s3 ls s3://stan-assets/library/ --endpoint-url https://<account-id>.r2.cloudflarestorage.com
```

---

## 🔍 Troubleshooting

### Issue: "URL rejected: Malformed input"
**Solution**: Make sure you're using the R2 dev URL (https://pub-xxxxx.r2.dev) not a signed URL

### Issue: "Access Denied"
**Solution**: 
1. Check that public access is enabled on the bucket
2. Verify R2_ACCESS_KEY and R2_SECRET_KEY are correct
3. Make sure R2_ENDPOINT includes your account ID

### Issue: "Bucket not found"
**Solution**: 
1. Verify bucket names are exactly `stan-templates` and `stan-assets`
2. Check that buckets exist in your Cloudflare account
3. Ensure you're using the correct account

---

## 💡 Pro Tips

1. **Use Public URLs for Templates**: Enable public access so AI can directly download templates without authentication

2. **Keep Assets Private**: Use AWS CLI with credentials for asset uploads to maintain security

3. **Organize by Type**: Use descriptive asset_type names like `racing`, `platformer`, `models`, `audio`

4. **Enable CORS**: If accessing from browser, add CORS rules in bucket settings

5. **Monitor Usage**: Check R2 dashboard for storage and bandwidth usage

---

## 📊 Cost Estimate

R2 Pricing (as of 2024):
- Storage: $0.015/GB/month
- Class A Operations (writes): $4.50/million
- Class B Operations (reads): $0.36/million
- Egress: FREE! 🎉

**Example Monthly Cost:**
- 100 GB templates: $1.50
- 500 GB assets: $7.50
- 1M downloads: $0.36
- **Total: ~$10/month** for unlimited egress! 🚀
