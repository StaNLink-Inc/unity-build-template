# R2 Quick Setup Card 🚀

## 📦 Two Buckets

```
stan-templates/          stan-assets/
├── racing/             ├── library/
│   └── base.pkg        │   ├── models/
├── platformer/         │   ├── audio/
│   └── base.pkg        │   ├── sprites/
└── puzzle/             │   └── ripped/
    └── base.pkg        │       ├── racing/
                        │       └── platformer/
```

## ⚡ Quick Setup (5 minutes)

### 1. Add Custom Domains (RECOMMENDED)
```
Cloudflare Dashboard → R2 → stan-templates → Settings → Custom Domains
Add: stantemplates.cloud.stanlink.online

Cloudflare Dashboard → R2 → stan-assets → Settings → Custom Domains
Add: stanassets.cloud.stanlink.online

Wait 5-10 minutes for DNS propagation
```

### 2. Enable Public Access
```
Cloudflare Dashboard → R2 → stan-templates → Settings → Public Access → Allow
Cloudflare Dashboard → R2 → stan-assets → Settings → Public Access → Allow
```

### 3. Get URLs
```
stan-templates: https://stantemplates.cloud.stanlink.online
stan-assets:    https://stanassets.cloud.stanlink.online

Backup dev URLs (optional):
stan-templates: https://pub-xxxxx.r2.dev
stan-assets:    https://pub-yyyyy.r2.dev
```

### 3. Add GitHub Secrets
```
unity-build-template → Settings → Secrets → Actions

Required:
- R2_ACCESS_KEY
- R2_SECRET_KEY  
- R2_ENDPOINT (https://<account-id>.r2.cloudflarestorage.com)

Recommended:
- STAN_TEMPLATES_PUBLIC_URL (https://stantemplates.cloud.stanlink.online)
- STAN_ASSETS_PUBLIC_URL (https://stanassets.cloud.stanlink.online)
- STAN_BACKEND_URL
- STAN_API_KEY
```

### 4. Test Access
```bash
# Windows
set R2_ACCESS_KEY=your-key
set R2_SECRET_KEY=your-secret
set R2_ENDPOINT=https://your-account.r2.cloudflarestorage.com
test-r2-access.bat

# Linux/Mac
export R2_ACCESS_KEY=your-key
export R2_SECRET_KEY=your-secret
export R2_ENDPOINT=https://your-account.r2.cloudflarestorage.com
./test-r2-access.sh
```

## 🎯 Workflow Usage

### Upload Template
```yaml
mode: template
source_url: https://example.com/game.unitypackage
asset_type: racing
rip_template: true
```
**Result:** 
- `stan-templates/racing/base.unitypackage` ✅
- `stan-assets/library/ripped/racing/*` ✅
- Available at: https://stantemplates.cloud.stanlink.online/racing/base.unitypackage

### Upload Single Asset
```yaml
mode: asset-single
source_url: https://example.com/model.fbx
asset_type: models
```
**Result:**
- `stan-assets/library/models/asset_<timestamp>` ✅

### Rip Existing Template
```yaml
mode: asset-rip
source_url: racing/base.unitypackage
asset_type: racing-assets
```
**Result:**
- `stan-assets/library/ripped/racing-assets/*` ✅

## 🔍 Troubleshooting

| Error | Solution |
|-------|----------|
| URL rejected | Use R2 dev URL (https://pub-xxx.r2.dev) |
| Access Denied | Enable public access in bucket settings |
| Bucket not found | Check bucket names: `stan-templates`, `stan-assets` |
| Invalid credentials | Verify R2_ACCESS_KEY and R2_SECRET_KEY |

## 💰 Cost

- Storage: $0.015/GB/month
- Operations: ~$5/million writes
- Egress: **FREE!** 🎉

**Example:** 600GB storage + 1M downloads = **$9/month**

## 📚 Full Docs

See `R2_BUCKET_SETUP.md` for complete guide with examples!
