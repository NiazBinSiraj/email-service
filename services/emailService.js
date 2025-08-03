const nodemailer = require('nodemailer');

/**
 * Email Service
 * Handles email sending functionality using Gmail SMTP
 */
class EmailService {
  constructor() {
    this.transporter = null;
    this.isInitialized = false;
  }

  /**
   * Initialize Gmail SMTP transporter (lazy initialization)
   */
  initializeTransporter() {
    // Validate required environment variables
    if (!process.env.GMAIL_USER || !process.env.GMAIL_PASS) {
      throw new Error('Gmail credentials not configured. Please set GMAIL_USER and GMAIL_PASS environment variables.');
    }

    if (this.isInitialized) {
      return; // Already initialized
    }

    this.transporter = nodemailer.createTransport({
      service: 'gmail',
      host: 'smtp.gmail.com',
      port: 587,
      secure: false, // true for 465, false for other ports
      auth: {
        user: process.env.GMAIL_USER,
        pass: process.env.GMAIL_PASS
      },
      // Additional security options
      tls: {
        rejectUnauthorized: false
      }
    });

    this.isInitialized = true;
    console.log('📧 Gmail SMTP transporter initialized');
  }

  /**
   * Ensure transporter is initialized
   */
  ensureInitialized() {
    if (!this.isInitialized) {
      this.initializeTransporter();
    }
  }

  /**
   * Verify SMTP connection
   */
  async verifyConnection() {
    try {
      this.ensureInitialized();
      await this.transporter.verify();
      console.log('✅ SMTP connection verified');
      return true;
    } catch (error) {
      console.error('❌ SMTP connection failed:', error.message);
      throw error;
    }
  }

  /**
   * Send email
   * @param {Object} emailData - Email data object
   * @param {string|string[]} emailData.to - Recipient email(s)
   * @param {string} emailData.subject - Email subject
   * @param {string} emailData.message - Email message content
   * @param {string|string[]} emailData.cc - CC recipient(s) (optional)
   * @param {string|string[]} emailData.bcc - BCC recipient(s) (optional)
   * @returns {Promise<Object>} Email sending result
   */
  async sendEmail(emailData) {
    try {
      this.ensureInitialized();
      const { to, subject, message, cc, bcc } = emailData;

      // Prepare mail options
      const mailOptions = {
        from: {
          name: 'Email Service',
          address: process.env.GMAIL_USER
        },
        to: Array.isArray(to) ? to.join(', ') : to,
        subject: subject,
        text: message, // Plain text version
        html: this.formatHtmlMessage(message), // HTML version
        ...(cc && { cc: Array.isArray(cc) ? cc.join(', ') : cc }),
        ...(bcc && { bcc: Array.isArray(bcc) ? bcc.join(', ') : bcc })
      };

      // Send email
      const result = await this.transporter.sendMail(mailOptions);

      console.log('✅ Email sent successfully:', {
        messageId: result.messageId,
        recipients: to,
        subject: subject
      });

      return {
        messageId: result.messageId,
        accepted: result.accepted,
        rejected: result.rejected,
        response: result.response
      };

    } catch (error) {
      console.error('❌ Failed to send email:', error);
      throw error;
    }
  }

  /**
   * Format plain text message to HTML
   * @param {string} message - Plain text message
   * @returns {string} HTML formatted message
   */
  formatHtmlMessage(message) {
    // Convert line breaks to <br> tags and wrap in basic HTML structure
    const htmlMessage = message
      .replace(/\n/g, '<br>')
      .replace(/\r/g, '');

    return `
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <style>
            body {
              font-family: Arial, sans-serif;
              line-height: 1.6;
              color: #333;
              max-width: 600px;
              margin: 0 auto;
              padding: 20px;
            }
            .email-content {
              background: #f9f9f9;
              padding: 20px;
              border-radius: 5px;
              border-left: 4px solid #007bff;
            }
          </style>
        </head>
        <body>
          <div class="email-content">
            ${htmlMessage}
          </div>
        </body>
      </html>
    `;
  }

  /**
   * Test email functionality
   * @returns {Promise<boolean>} Test result
   */
  async testEmail() {
    try {
      await this.verifyConnection();
      
      const testEmailData = {
        to: process.env.GMAIL_USER, // Send to self for testing
        subject: 'Email Service Test',
        message: 'This is a test email to verify the email service is working correctly.'
      };

      await this.sendEmail(testEmailData);
      return true;
    } catch (error) {
      console.error('❌ Email test failed:', error);
      return false;
    }
  }
}

// Create and export singleton instance
const emailService = new EmailService();

module.exports = emailService;
