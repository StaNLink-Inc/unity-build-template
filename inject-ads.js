const fs = require('fs');
const path = require('path');

const indexPath = path.join(__dirname, 'build/WebGL/WebGL/index.html');
const adScript = `
<!-- Stan AI Monetization -->
<script type='text/javascript' src='//pl24602802.profitablecpmrate.com/c0/c8/0e/c0c80e8e8f8e8e8e8e8e8e8e8e8e8e8e.js'></script>
<script>
window.triggerStanAd = function() {
  console.log("Stan Ad Triggered");
};
</script>
`;

let htmlContent = fs.readFileSync(indexPath, 'utf8');
htmlContent = htmlContent.replace('</body>', adScript + '</body>');
fs.writeFileSync(indexPath, htmlContent);
console.log("✅ Injected Stan Monetization");
