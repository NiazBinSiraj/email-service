# Email Service API Test Script
# This script demonstrates the functionality of the Email Service API

Write-Host "Testing Email Service API" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

# Load environment variables from .env file
Write-Host "Loading configuration from .env file..." -ForegroundColor Cyan
if (Test-Path ".env") {
    $envVars = @{}
    Get-Content ".env" | ForEach-Object {
        if ($_ -and !$_.StartsWith("#") -and $_.Contains("=")) {
            $parts = $_ -split "=", 2
            if ($parts.Length -eq 2) {
                $key = $parts[0].Trim()
                $value = $parts[1].Trim()
                # Remove quotes if present
                $value = $value -replace '^"(.*)"$', '$1'
                $value = $value -replace "^'(.*)'$", '$1'
                $envVars[$key] = $value
            }
        }
    }
    
    $testEmail = $envVars["GMAIL_USER"]
    if (-not $testEmail) {
        Write-Host "❌ GMAIL_USER not found in .env file" -ForegroundColor Red
        Write-Host "   Please ensure your .env file contains GMAIL_USER=your-email@gmail.com" -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "✅ Using test email: $testEmail" -ForegroundColor Green
} else {
    Write-Host "❌ .env file not found" -ForegroundColor Red
    Write-Host "   Please create a .env file with GMAIL_USER=your-email@gmail.com" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Test 1: Health Check
Write-Host "1. Testing Health Check..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri 'http://localhost:3000/health' -Method GET
    Write-Host "✅ Health Check Passed" -ForegroundColor Green
    Write-Host "   Status: $($health.status)" -ForegroundColor Cyan
    Write-Host "   Environment: $($health.environment)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Health Check Failed: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 2: Valid Email
Write-Host "2. Testing Valid Email Sending..." -ForegroundColor Yellow
try {
    $body = @{
        to = $testEmail
        subject = 'Test Email from API Test Script'
        message = 'This is a test email sent from the PowerShell test script. The Email Service API is working correctly!'
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
    Write-Host "✅ Email Sent Successfully" -ForegroundColor Green
    Write-Host "   Message ID: $($result.data.messageId)" -ForegroundColor Cyan
    Write-Host "   From: $($result.data.from)" -ForegroundColor Cyan
    Write-Host "   Name: $($result.data.name)" -ForegroundColor Cyan
    Write-Host "   Recipients: $($result.data.recipients)" -ForegroundColor Cyan
    Write-Host "   Subject: $($result.data.subject)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Email Sending Failed: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 3: Invalid Email Validation
Write-Host "3. Testing Email Validation (Invalid Email)..." -ForegroundColor Yellow
try {
    $body = @{
        to = 'invalid-email-address'
        subject = 'Test'
        message = 'This should fail validation'
    } | ConvertTo-Json
    
    Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
    Write-Host "❌ Validation Should Have Failed" -ForegroundColor Red
} catch {
    if ($_.Exception.Message -like "*400*") {
        Write-Host "✅ Email Validation Working Correctly" -ForegroundColor Green
        Write-Host "   Correctly rejected invalid email address" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Unexpected Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}
Write-Host ""

# Test 4: Missing Required Field
Write-Host "4. Testing Required Field Validation (Missing Subject)..." -ForegroundColor Yellow
try {
    $body = @{
        to = 'test@example.com'
        message = 'Missing subject field'
    } | ConvertTo-Json
    
    Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
    Write-Host "❌ Validation Should Have Failed" -ForegroundColor Red
} catch {
    if ($_.Exception.Message -like "*400*") {
        Write-Host "✅ Required Field Validation Working Correctly" -ForegroundColor Green
        Write-Host "   Correctly rejected missing subject field" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Unexpected Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}
Write-Host ""

# Test 5: Multiple Recipients
Write-Host "5. Testing Multiple Recipients..." -ForegroundColor Yellow
try {
    $body = @{
        to = @($testEmail)
        cc = @($testEmail)
        subject = 'Test Email with CC'
        message = 'This email tests multiple recipients with CC functionality.'
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
    Write-Host "✅ Multiple Recipients Email Sent Successfully" -ForegroundColor Green
    Write-Host "   Message ID: $($result.data.messageId)" -ForegroundColor Cyan
    Write-Host "   From: $($result.data.from)" -ForegroundColor Cyan
    Write-Host "   Name: $($result.data.name)" -ForegroundColor Cyan
    Write-Host "   Recipients: $($result.data.recipients)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Multiple Recipients Failed: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 6: Custom From Address
Write-Host "6. Testing Custom From Address..." -ForegroundColor Yellow
try {
    $body = @{
        to = $testEmail
        from = 'custom.sender@example.com'
        subject = 'Test Email with Custom From Address'
        message = 'This email tests the custom from address functionality. The sender should appear as custom.sender@example.com.'
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
    Write-Host "✅ Custom From Address Email Sent Successfully" -ForegroundColor Green
    Write-Host "   Message ID: $($result.data.messageId)" -ForegroundColor Cyan
    Write-Host "   From: $($result.data.from)" -ForegroundColor Cyan
    Write-Host "   Name: $($result.data.name)" -ForegroundColor Cyan
    Write-Host "   Recipients: $($result.data.recipients)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Custom From Address Failed: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 7: Custom Name Parameter
Write-Host "7. Testing Custom Name Parameter..." -ForegroundColor Yellow
try {
    $body = @{
        to = $testEmail
        name = 'Custom Business Name'
        subject = 'Test Email with Custom Name'
        message = 'This email tests the custom name functionality. The sender name should appear as "Custom Business Name".'
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
    Write-Host "✅ Custom Name Email Sent Successfully" -ForegroundColor Green
    Write-Host "   Message ID: $($result.data.messageId)" -ForegroundColor Cyan
    Write-Host "   From: $($result.data.from)" -ForegroundColor Cyan
    Write-Host "   Name: $($result.data.name)" -ForegroundColor Cyan
    Write-Host "   Recipients: $($result.data.recipients)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Custom Name Failed: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 8: Custom From Address and Name
Write-Host "8. Testing Custom From Address and Name..." -ForegroundColor Yellow
try {
    $body = @{
        to = $testEmail
        from = 'support@mybusiness.com'
        name = 'My Business Support'
        subject = 'Test Email with Custom From and Name'
        message = 'This email tests both custom from address and name functionality. The sender should appear as "My Business Support" with the email address support@mybusiness.com.'
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
    Write-Host "✅ Custom From and Name Email Sent Successfully" -ForegroundColor Green
    Write-Host "   Message ID: $($result.data.messageId)" -ForegroundColor Cyan
    Write-Host "   From: $($result.data.from)" -ForegroundColor Cyan
    Write-Host "   Name: $($result.data.name)" -ForegroundColor Cyan
    Write-Host "   Recipients: $($result.data.recipients)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Custom From and Name Failed: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "API Testing Complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
