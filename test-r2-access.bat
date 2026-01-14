@echo off
REM R2 Bucket Test Script for Windows
REM Tests access to both stan-templates and stan-assets buckets

echo 🧪 Testing R2 Bucket Access...
echo.

REM Check if AWS CLI is installed
where aws >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ AWS CLI not installed. Install with: pip install awscli
    exit /b 1
)

REM Check for required environment variables
if "%R2_ACCESS_KEY%"=="" (
    echo ❌ Missing R2_ACCESS_KEY environment variable
    echo.
    echo Set with: set R2_ACCESS_KEY=your-access-key
    exit /b 1
)

if "%R2_SECRET_KEY%"=="" (
    echo ❌ Missing R2_SECRET_KEY environment variable
    echo.
    echo Set with: set R2_SECRET_KEY=your-secret-key
    exit /b 1
)

if "%R2_ENDPOINT%"=="" (
    echo ❌ Missing R2_ENDPOINT environment variable
    echo.
    echo Set with: set R2_ENDPOINT=https://your-account-id.r2.cloudflarestorage.com
    exit /b 1
)

REM Configure AWS CLI
echo 🔧 Configuring AWS CLI...
aws configure set aws_access_key_id %R2_ACCESS_KEY%
aws configure set aws_secret_access_key %R2_SECRET_KEY%
aws configure set default.region auto

echo ✅ AWS CLI configured
echo.

REM Test stan-templates bucket
echo 📦 Testing stan-templates bucket...
aws s3 ls s3://stan-templates/ --endpoint-url %R2_ENDPOINT% >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ stan-templates bucket accessible
    echo    Contents:
    aws s3 ls s3://stan-templates/ --endpoint-url %R2_ENDPOINT%
) else (
    echo ❌ Cannot access stan-templates bucket
    echo    Make sure the bucket exists and credentials are correct
)

echo.

REM Test stan-assets bucket
echo 📦 Testing stan-assets bucket...
aws s3 ls s3://stan-assets/ --endpoint-url %R2_ENDPOINT% >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ stan-assets bucket accessible
    echo    Contents:
    aws s3 ls s3://stan-assets/ --endpoint-url %R2_ENDPOINT%
) else (
    echo ❌ Cannot access stan-assets bucket
    echo    Make sure the bucket exists and credentials are correct
)

echo.
echo 🎉 Test complete!
echo.
echo Next steps:
echo 1. Enable public access on both buckets in Cloudflare Dashboard
echo 2. Get the R2 dev URLs (https://pub-xxxxx.r2.dev)
echo 3. Add GitHub secrets to unity-build-template repository
echo 4. Test the ingestion workflow

pause
