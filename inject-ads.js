const fs = require('fs');
const path = require('path');

// Adsterra ad codes
const ADSTERRA_POPUNDER = `
<!-- Adsterra Popunder -->
<script src="https://pl28495311.effectivegatecpm.com/46/4e/3c/464e3cde8ee004c8444b4c53af1c0b72.js"></script>
`;

const ADSTERRA_SOCIAL_BAR = `
<!-- Adsterra Social Bar -->
<script src="https://pl28495265.effectivegatecpm.com/c2/a3/01/c2a301a8c7d21f09d1f08b64184fb098.js"></script>
`;

const STAN_WATERMARK = `
<!-- Stan Watermark (Free Tier) -->
<div id="stan-watermark" style="position: fixed; bottom: 10px; right: 10px; z-index: 9999;">
    <a href="https://games.stanlink.online" target="_blank" 
       style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
              color: white; padding: 8px 16px; border-radius: 20px; 
              text-decoration: none; font-family: Arial, sans-serif; 
              font-size: 14px; font-weight: bold; box-shadow: 0 4px 15px rgba(0,0,0,0.2);">
        🎮 Play on Stan
    </a>
</div>
`;

const STAN_ANALYTICS = `
<!-- Stan Analytics -->
<script>
(function() {
    const projectId = '{{PROJECT_ID}}';
    const domain = window.location.hostname;
    
    // Phone home
    fetch('https://api.stanlink.online/track', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ projectId, domain, timestamp: Date.now() })
    }).catch(() => {});
    
    // Track playtime every 30 seconds
    setInterval(() => {
        fetch('https://api.stanlink.online/track/playtime', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ projectId, domain })
        }).catch(() => {});
    }, 30000);
})();
</script>
`;

function injectAds() {
    const indexPath = path.join(__dirname, 'build', 'WebGL', 'WebGL', 'index.html');
    
    if (!fs.existsSync(indexPath)) {
        console.error('❌ index.html not found at:', indexPath);
        process.exit(1);
    }
    
    let html = fs.readFileSync(indexPath, 'utf8');
    
    // Read project metadata
    const projectMetaPath = path.join(__dirname, 'UnityProject', 'stan-project.json');
    let isPaid = false;
    let projectId = 'unknown';
    
    if (fs.existsSync(projectMetaPath)) {
        const meta = JSON.parse(fs.readFileSync(projectMetaPath, 'utf8'));
        isPaid = meta.isPaid === true || meta.isPaid === 'true';
        projectId = meta.projectId || 'unknown';
    }
    
    console.log(`📊 Project: ${projectId}, Paid: ${isPaid}`);
    
    // Inject Stan Analytics (always)
    const analyticsCode = STAN_ANALYTICS.replace('{{PROJECT_ID}}', projectId);
    html = html.replace('</head>', `${analyticsCode}\n</head>`);
    
    // Inject Adsterra ads (ALWAYS - for all users)
    console.log('💰 Injecting Adsterra ads');
    
    // Inject popunder ad in <head>
    html = html.replace('</head>', `${ADSTERRA_POPUNDER}\n</head>`);
    
    // Inject social bar in <body>
    html = html.replace('</body>', `${ADSTERRA_SOCIAL_BAR}\n</body>`);
    
    // Inject Stan watermark (free tier only)
    if (!isPaid) {
        console.log('🎨 Injecting Stan watermark (free tier)');
        html = html.replace('</body>', `${STAN_WATERMARK}\n</body>`);
    } else {
        console.log('✨ Premium user - no watermark');
    }
    
    // Write modified HTML
    fs.writeFileSync(indexPath, html, 'utf8');
    console.log('✅ Ads and analytics injected successfully');
}

// Run
try {
    injectAds();
} catch (error) {
    console.error('❌ Failed to inject ads:', error);
    process.exit(1);
}
