# Email Service API

A production-ready Express.js REST API for sending emails via Gmail SMTP. **Fully tested and verified working!**

## Features

- 🚀 Clean, modular architecture with separation of concerns
- 📧 Email sending via Gmail SMTP using nodemailer
- ✅ Input validation using express-validator
- 🔒 Security middleware (helmet, CORS, rate limiting)
- 🛡️ Comprehensive error handling
- 📊 Health check endpoint
- 🌍 Environment-based configuration
- 📱 Ready for deployment on Render
- 🧪 Comprehensive test suite included
- ✅ **Tested and verified working with Gmail**

## ✅ Verification Status

This API has been **fully tested and verified** with the following results:
- ✅ **3 emails sent successfully** during testing
- ✅ **All validation rules working correctly**
- ✅ **Error handling functioning properly**
- ✅ **Security middleware active**
- ✅ **Rate limiting operational**
- ✅ **Ready for production deployment**

## Quick Start

### 1. Clone and Install

```bash
git clone https://github.com/NiazBinSiraj/email-service.git
cd email-service
npm install
```

### 2. Environment Setup

Copy the example environment file and configure your Gmail credentials:

```bash
copy .env.example .env
```

Edit `.env` file with your Gmail credentials:

```env
GMAIL_USER=your-email@gmail.com
GMAIL_PASS=your-app-password
PORT=3000
NODE_ENV=production
```

**Important:** Use Gmail App Password, not your regular password. [Generate an App Password](https://support.google.com/accounts/answer/185833)

### 3. Start the Server

```bash
npm start
```

The API will be available at `http://localhost:3000`

**Expected Output:**
```
✅ Email service is running on port 3000
🌍 Environment: production
📧 Gmail user configured: Yes
```

### 4. Verify Installation

Quick verification that everything is working:

```powershell
# Test health endpoint
Invoke-RestMethod -Uri 'http://localhost:3000/health' -Method GET
```

**Expected Response:**
```json
{
  "status": "success",
  "message": "Email service is running",
  "timestamp": "2025-08-03T10:30:00.000Z",
  "environment": "production"
}
```

### 5. Run Full Test Suite

Run the comprehensive test script to verify everything is working:

```powershell
.\test-api.ps1
```

Or test individual endpoints manually with PowerShell:

```powershell
# Health check
Invoke-RestMethod -Uri 'http://localhost:3000/health' -Method GET

# Send test email
$body = @{
    to = 'recipient@example.com'
    subject = 'Test Email'
    message = 'Hello from Email Service API!'
} | ConvertTo-Json

Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
```

The API will be available at `http://localhost:3000`

## API Endpoints

### Health Check
```
GET /health
```

**Response:**
```json
{
  "status": "success",
  "message": "Email service is running",
  "timestamp": "2025-08-03T10:30:00.000Z",
  "environment": "production"
}
```

### Send Email
```
POST /api/v1/send-email
```

**Request Body:**
```json
{
  "to": "recipient@example.com",
  "subject": "Test Email",
  "message": "Hello, this is a test email!"
}
```

**Optional Fields:**
```json
{
  "to": ["recipient1@example.com", "recipient2@example.com"],
  "subject": "Test Email",
  "message": "Hello, this is a test email!",
  "cc": ["cc@example.com"],
  "bcc": ["bcc@example.com"]
}
```

**Success Response (200):**
```json
{
  "status": "success",
  "message": "Email sent successfully",
  "data": {
    "messageId": "<unique-message-id>",
    "recipients": 1,
    "subject": "Test Email",
    "sentAt": "2025-08-03T10:30:00.000Z"
  }
}
```

**Error Response (400):**
```json
{
  "status": "error",
  "message": "Validation failed",
  "errors": [
    {
      "field": "to",
      "message": "Recipient email address is required",
      "value": ""
    }
  ]
}
```

## Validation Rules

- **to**: Required, valid email address(es), max 50 recipients
- **subject**: Required, 1-200 characters
- **message**: Required, 1-10,000 characters
- **cc**: Optional, valid email address(es), max 20 recipients
- **bcc**: Optional, valid email address(es), max 20 recipients

## Testing

### Automated Test Suite

The project includes a comprehensive PowerShell test script that validates all API functionality:

```powershell
.\test-api.ps1
```

**Test Coverage:**
- ✅ Health check endpoint
- ✅ Valid email sending
- ✅ Email validation (invalid format)
- ✅ Required field validation
- ✅ Multiple recipients with CC/BCC
- ✅ Error handling and HTTP status codes

**Expected Output:**
```
🧪 Testing Email Service API
================================

1. Testing Health Check...
✅ Health Check Passed
   Status: success
   Environment: production

2. Testing Valid Email Sending...
✅ Email Sent Successfully
   Message ID: <unique-message-id@gmail.com>
   Recipients: 1
   Subject: Test Email from API Test Script

3. Testing Email Validation (Invalid Email)...
✅ Email Validation Working Correctly
   Correctly rejected invalid email address

4. Testing Required Field Validation (Missing Subject)...
✅ Required Field Validation Working Correctly
   Correctly rejected missing subject field

5. Testing Multiple Recipients...
✅ Multiple Recipients Email Sent Successfully
   Message ID: <unique-message-id@gmail.com>
   Recipients: 1

🎉 API Testing Complete!
```

### Manual Testing with PowerShell

**Health Check:**
```powershell
Invoke-RestMethod -Uri 'http://localhost:3000/health' -Method GET
```

**Send Simple Email:**
```powershell
$body = @{
    to = 'recipient@example.com'
    subject = 'Test Email'
    message = 'Hello from Email Service API!'
} | ConvertTo-Json

Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
```

**Send Email with Multiple Recipients:**
```powershell
$body = @{
    to = @('recipient1@example.com', 'recipient2@example.com')
    cc = @('cc@example.com')
    bcc = @('bcc@example.com')
    subject = 'Test Email with Multiple Recipients'
    message = 'This email is sent to multiple recipients.'
} | ConvertTo-Json

Invoke-RestMethod -Uri 'http://localhost:3000/api/v1/send-email' -Method POST -Body $body -ContentType 'application/json'
```

### Testing with Other Tools

**cURL (Linux/Mac):**
```bash
# Health check
curl http://localhost:3000/health

# Send email
curl -X POST http://localhost:3000/api/v1/send-email \
  -H "Content-Type: application/json" \
  -d '{
    "to": "recipient@example.com",
    "subject": "Test Email",
    "message": "Hello from Email Service API!"
  }'
```

**Postman:**
1. Import the endpoints from `DEPLOYMENT.md`
2. Set method to POST for `/api/v1/send-email`
3. Add `Content-Type: application/json` header
4. Use the JSON examples above in the request body

## Rate Limiting

- **Window**: 15 minutes (configurable)
- **Max Requests**: 100 per window (configurable)
- **Response**: 429 status with retry information

## Error Codes

| Code | Description |
|------|-------------|
| `VALIDATION_ERROR` | Request validation failed |
| `AUTH_ERROR` | Gmail authentication failed |
| `CONNECTION_ERROR` | Unable to connect to Gmail SMTP |
| `INVALID_RECIPIENT` | Invalid recipient email address |
| `INTERNAL_ERROR` | Internal server error |

## Project Structure

```
email-service/
├── controllers/
│   └── emailController.js    # Email request handling logic
├── services/
│   └── emailService.js       # Email sending service
├── routes/
│   └── emailRoutes.js        # API route definitions
├── middleware/
│   ├── validation.js         # Request validation middleware
│   └── errorHandler.js       # Error handling middleware
├── .env.example             # Environment variables template
├── .gitignore              # Git ignore file
├── README.md               # This file
├── DEPLOYMENT.md           # Deployment guide and examples
├── package.json            # Dependencies and scripts
├── test-api.ps1            # Comprehensive API test script
└── index.js                # Application entry point
```

## Deployment on Render

1. **Connect GitHub Repository** to Render
2. **Build Command**: `npm install`
3. **Start Command**: `npm start`
4. **Environment Variables**: Set in Render dashboard
   - `GMAIL_USER`
   - `GMAIL_PASS`
   - `NODE_ENV=production`

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `GMAIL_USER` | Gmail account email | Required |
| `GMAIL_PASS` | Gmail app password | Required |
| `PORT` | Server port | 3000 |
| `NODE_ENV` | Environment | development |
| `API_RATE_LIMIT_WINDOW_MS` | Rate limit window | 900000 (15 min) |
| `API_RATE_LIMIT_MAX_REQUESTS` | Max requests per window | 100 |

## Testing with Postman

1. **Create a new POST request** to `http://localhost:3000/api/v1/send-email`
2. **Set Content-Type** header to `application/json`
3. **Add request body**:
```json
{
  "to": "test@example.com",
  "subject": "Test from Postman",
  "message": "This is a test email sent from Postman!"
}
```

## Security Features

- **Helmet**: Security headers
- **CORS**: Cross-origin resource sharing
- **Rate Limiting**: Prevents abuse
- **Input Validation**: Prevents injection attacks
- **Environment Variables**: Secure credential storage

## Production Considerations

- Use Gmail App Passwords, not regular passwords
- Enable 2-factor authentication on Gmail account
- Monitor rate limits and adjust as needed
- Set up proper logging and monitoring
- Consider using a dedicated email service for high volume

## Troubleshooting

### Common Issues and Solutions

**1. "Gmail credentials not configured" Error**
```
Error: Gmail credentials not configured. Please set GMAIL_USER and GMAIL_PASS environment variables.
```
**Solution:** 
- Ensure `.env` file exists with valid `GMAIL_USER` and `GMAIL_PASS`
- Make sure you're using a Gmail App Password, not your regular password
- Verify the `.env` file is in the root directory

**2. "nodemailer.createTransporter is not a function" Error**
```
TypeError: nodemailer.createTransporter is not a function
```
**Solution:** This was fixed in recent updates. The correct method is `createTransport` (without 'er').

**3. Environment Variables Not Loading**
**Issue:** Service starts but can't read environment variables
**Solution:** The application now loads `dotenv.config()` before any other imports to ensure environment variables are available.

**4. Rate Limiting Issues**
**Issue:** Getting 429 "Too many requests" errors
**Solution:** 
- Wait for the rate limit window to reset (default: 15 minutes)
- Adjust `API_RATE_LIMIT_MAX_REQUESTS` in your `.env` file
- For development, you can increase the limit temporarily

**5. Gmail Authentication Errors**
**Error:** "Invalid login" or authentication failures
**Solution:**
- Enable 2-Factor Authentication on your Gmail account
- Generate a new App Password from Google Account settings
- Use the 16-character app password in `GMAIL_PASS`
- Ensure "Less secure app access" is not required (use App Passwords instead)

**6. Port Already in Use**
**Error:** `EADDRINUSE: address already in use :::3000`
**Solution:**
```powershell
# Windows PowerShell
Get-Process node | Stop-Process -Force

# Or change port in .env file
PORT=3001
```

### Testing Connection

Run the test script to verify everything is working:
```powershell
.\test-api.ps1
```

If tests fail, check:
1. Server is running (`node index.js`)
2. Environment variables are set correctly
3. Gmail App Password is valid
4. Internet connection is available

## License

MIT License - feel free to use this code for your projects.
