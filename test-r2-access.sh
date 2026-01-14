#!/bin/bash

# R2 Bucket Test Script
# Tests access to both stan-templates and stan-assets buckets

echo "🧪 Testing R2 Bucket Access..."
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not installed. Install with: pip install awscli"
    exit 1
fi

# Check for required environment variables
if [ -z "$R2_ACCESS_KEY" ] || [ -z "$R2_SECRET_KEY" ] || [ -z "$R2_ENDPOINT" ]; then
    echo "❌ Missing required environment variables:"
    echo "   Set R2_ACCESS_KEY, R2_SECRET_KEY, and R2_ENDPOINT"
    echo ""
    echo "Example:"
    echo "  export R2_ACCESS_KEY='your-access-key'"
    echo "  export R2_SECRET_KEY='your-secret-key'"
    echo "  export R2_ENDPOINT='https://your-account-id.r2.cloudflarestorage.com'"
    exit 1
fi

# Configure AWS CLI
echo "🔧 Configuring AWS CLI..."
aws configure set aws_access_key_id $R2_ACCESS_KEY
aws configure set aws_secret_access_key $R2_SECRET_KEY
aws configure set default.region auto

echo "✅ AWS CLI configured"
echo ""

# Test stan-templates bucket
echo "📦 Testing stan-templates bucket..."
if aws s3 ls s3://stan-templates/ --endpoint-url $R2_ENDPOINT > /dev/null 2>&1; then
    echo "✅ stan-templates bucket accessible"
    echo "   Contents:"
    aws s3 ls s3://stan-templates/ --endpoint-url $R2_ENDPOINT | head -10
else
    echo "❌ Cannot access stan-templates bucket"
    echo "   Make sure the bucket exists and credentials are correct"
fi

echo ""

# Test stan-assets bucket
echo "📦 Testing stan-assets bucket..."
if aws s3 ls s3://stan-assets/ --endpoint-url $R2_ENDPOINT > /dev/null 2>&1; then
    echo "✅ stan-assets bucket accessible"
    echo "   Contents:"
    aws s3 ls s3://stan-assets/ --endpoint-url $R2_ENDPOINT | head -10
else
    echo "❌ Cannot access stan-assets bucket"
    echo "   Make sure the bucket exists and credentials are correct"
fi

echo ""
echo "🎉 Test complete!"
echo ""
echo "Next steps:"
echo "1. Enable public access on both buckets in Cloudflare Dashboard"
echo "2. Get the R2 dev URLs (https://pub-xxxxx.r2.dev)"
echo "3. Add GitHub secrets to unity-build-template repository"
echo "4. Test the ingestion workflow"
