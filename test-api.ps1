# Email Service API Test Script
# This script demonstrates the functionality of the Email Service API

Write-Host "🧪 Testing Email Service API" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
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
        to = 'niaz9767@gmail.com'
        subject = 'Test Email from API Test Script'
        message = 'This is a test email sent from the PowerShell test script. The Email Service API is working correctly!'
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
    Write-Host "✅ Email Sent Successfully" -ForegroundColor Green
    Write-Host "   Message ID: $($result.data.messageId)" -ForegroundColor Cyan
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
        to = @('niaz9767@gmail.com')  # Using array for multiple recipients
        cc = @('niaz9767@gmail.com')
        subject = 'Test Email with CC'
        message = 'This email tests multiple recipients with CC functionality.'
    } | ConvertTo-Json
    
    $result = Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
    Write-Host "✅ Multiple Recipients Email Sent Successfully" -ForegroundColor Green
    Write-Host "   Message ID: $($result.data.messageId)" -ForegroundColor Cyan
    Write-Host "   Recipients: $($result.data.recipients)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Multiple Recipients Failed: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "🎉 API Testing Complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
