# R2 Public URL Setup Guide

## 🎯 Problem
GitHub Actions workflow fails with "URL rejected: Malformed input" when trying to download from signed R2 URLs.

## ✅ Solution Options

### Option 1: Use R2 Dev Subdomain (Recommended)
Enable public access via `dev.cloudflare.com` subdomain:

```bash
# In Cloudflare Dashboard:
1. Go to R2 > stan-assets bucket
2. Settings > Public Access
3. Enable "Allow Access" 
4. Copy the dev URL: https://pub-xxxxx.r2.dev

# Your workflow can now use:
source_url: https://pub-xxxxx.r2.dev/library/sprites/player.png
```

**Pros:**
- ✅ No authentication needed
- ✅ Direct HTTP access
- ✅ Works with curl/wget
- ✅ Fast CDN delivery

**Cons:**
- ⚠️ Publicly accessible (anyone with URL can download)
- ⚠️ Need to manage access via bucket policies

---

### Option 2: Use Custom Domain with Public Access
Map a custom domain to your R2 bucket:

```bash
# In Cloudflare Dashboard:
1. R2 > stan-assets > Settings > Custom Domains
2. Add domain: assets.stan.link
3. Enable public access

# Your workflow can now use:
source_url: https://assets.stan.link/library/sprites/player.png
```

**Pros:**
- ✅ Branded URLs
- ✅ No authentication needed
- ✅ CDN delivery
- ✅ Professional appearance

**Cons:**
- ⚠️ Requires domain setup
- ⚠️ Publicly accessible

---

### Option 3: Use R2 Path (Private, Authenticated)
Keep buckets private and use AWS CLI with credentials:

```bash
# Your workflow uses:
source_url: library/sprites/player.png  # Just the path, no URL

# Workflow automatically uses AWS CLI with secrets:
# - R2_ACCESS_KEY
# - R2_SECRET_KEY
# - R2_ENDPOINT
```

**Pros:**
- ✅ Secure (not public)
- ✅ Fine-grained access control
- ✅ No URL signing complexity

**Cons:**
- ⚠️ Requires AWS CLI setup
- ⚠️ Slightly slower (auth overhead)

---

## 🚀 Recommended Setup

### For Templates (stan-templates bucket):
**Use Option 1 (R2 Dev URL)** - Templates are meant to be shared

```bash
1. Enable public access on stan-templates
2. Get dev URL: https://pub-xxxxx.r2.dev
3. Add to GitHub Secrets: R2_TEMPLATES_PUBLIC_URL
4. Use in workflow: $R2_TEMPLATES_PUBLIC_URL/racing/base.unitypackage
```

### For Assets (stan-assets bucket):
**Use Option 3 (Private Path)** - Keep assets secure

```bash
1. Keep stan-assets private
2. Use path-only in workflow: library/sprites/player.png
3. Workflow uses AWS CLI with secrets
```

---

## 🔧 Updated Workflow Usage

### Public URL (Templates):
```yaml
workflow_dispatch:
  inputs:
    source_url:
      description: 'Public URL or R2 path'
      # Example: https://pub-xxxxx.r2.dev/racing/base.unitypackage
```

### Private Path (Assets):
```yaml
workflow_dispatch:
  inputs:
    source_url:
      description: 'Public URL or R2 path'
      # Example: library/sprites/player.png (no https://)
```

---

## 🎯 What Changed in Workflow

### Before (Broken):
```bash
# Tried to use signed URLs - FAILED
curl -L "$SIGNED_URL" -o raw_data/incoming
# Error: URL rejected: Malformed input
```

### After (Fixed):
```bash
# Detects URL type automatically:

# If no http:// prefix → Use AWS CLI (private)
if [[ "$SOURCE_URL" != http* ]]; then
  aws s3 cp s3://stan-assets/$SOURCE_URL raw_data/incoming

# If r2.dev or r2.cloudflarestorage.com → Direct curl (public)
elif [[ "$SOURCE_URL" == *"r2.dev"* ]]; then
  curl -L -f "$SOURCE_URL" -o raw_data/incoming

# Otherwise → Public URL
else
  curl -L -f "$SOURCE_URL" -o raw_data/incoming
fi
```

---

## 📋 Setup Checklist

- [ ] Enable public access on stan-templates bucket
- [ ] Get R2 dev URL for stan-templates
- [ ] Add `R2_PUBLIC_URL` to GitHub Secrets (optional)
- [ ] Keep stan-assets private
- [ ] Test workflow with public template URL
- [ ] Test workflow with private asset path

---

## 🧪 Testing

### Test Public URL:
```bash
# Trigger workflow with:
mode: template
source_url: https://pub-xxxxx.r2.dev/racing/base.unitypackage
asset_type: racing
```

### Test Private Path:
```bash
# Trigger workflow with:
mode: asset-single
source_url: library/sprites/player.png
asset_type: sprites
```

---

## 💡 Pro Tip

For maximum flexibility, use this pattern:

```bash
# Templates: Public dev URL
https://pub-xxxxx.r2.dev/racing/base.unitypackage

# Assets: Private path
library/sprites/player.png

# External: Any public URL
https://example.com/asset.zip
```

The workflow now handles all three automatically! 🎉
