# Sample Postman Collection for Email Service API

## Collection: Email Service API

### 1. Health Check
```
GET http://localhost:3000/health
```

### 2. Send Simple Email
```
POST http://localhost:3000/api/v1/send-email
Content-Type: application/json

{
  "to": "recipient@example.com",
  "subject": "Test Email from API",
  "message": "Hello! This is a test email sent from the Email Service API."
}
```

### 3. Send Email with Multiple Recipients
```
POST http://localhost:3000/api/v1/send-email
Content-Type: application/json

{
  "to": ["recipient1@example.com", "recipient2@example.com"],
  "subject": "Test Email to Multiple Recipients",
  "message": "This email is being sent to multiple recipients."
}
```

### 4. Send Email with CC and BCC
```
POST http://localhost:3000/api/v1/send-email
Content-Type: application/json

{
  "to": "primary@example.com",
  "cc": "cc@example.com",
  "bcc": "bcc@example.com",
  "subject": "Email with CC and BCC",
  "message": "This email includes CC and BCC recipients."
}
```

### 5. Validation Error Example (Missing Subject)
```
POST http://localhost:3000/api/v1/send-email
Content-Type: application/json

{
  "to": "recipient@example.com",
  "message": "This will fail because subject is missing"
}
```

### 6. Validation Error Example (Invalid Email)
```
POST http://localhost:3000/api/v1/send-email
Content-Type: application/json

{
  "to": "invalid-email",
  "subject": "Test",
  "message": "This will fail due to invalid email format"
}
```

## Deployment Instructions for Render

1. **Push to GitHub**: Push your code to a GitHub repository
2. **Connect to Render**: 
   - Go to https://render.com
   - Create new Web Service
   - Connect your GitHub repository
3. **Configure Build Settings**:
   - Build Command: `npm install`
   - Start Command: `npm start`
4. **Set Environment Variables**:
   - GMAIL_USER: your-email@gmail.com
   - GMAIL_PASS: your-app-password
   - NODE_ENV: production
5. **Deploy**: Click "Create Web Service"

## Gmail App Password Setup

1. Enable 2-Factor Authentication on your Gmail account
2. Go to Google Account settings
3. Navigate to Security > App passwords
4. Generate a new app password for "Mail"
5. Use this app password (not your regular password) in GMAIL_PASS
