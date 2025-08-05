const { validationResult } = require('express-validator');
const emailService = require('../services/emailService');

/**
 * Send email controller
 * Handles email sending requests with proper validation and error handling
 */
const sendEmail = async (req, res) => {
  try {
    // Check for validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        status: 'error',
        message: 'Validation failed',
        errors: errors.array().map(err => ({
          field: err.path,
          message: err.msg,
          value: err.value
        }))
      });
    }

    const { to, subject, message, cc, bcc, from, name } = req.body;

    // Prepare email data
    const emailData = {
      to: Array.isArray(to) ? to : [to],
      subject,
      message,
      ...(cc && { cc: Array.isArray(cc) ? cc : [cc] }),
      ...(bcc && { bcc: Array.isArray(bcc) ? bcc : [bcc] }),
      ...(from && { from }),
      ...(name && { name })
    };

    // Send email using email service
    const result = await emailService.sendEmail(emailData);

    // Return success response
    res.status(200).json({
      status: 'success',
      message: 'Email sent successfully',
      data: {
        messageId: result.messageId,
        from: emailData.from || process.env.GMAIL_USER,
        name: emailData.name || 'Email Service',
        recipients: emailData.to.length,
        subject: emailData.subject,
        sentAt: new Date().toISOString()
      }
    });

  } catch (error) {
    console.error('❌ Email sending error:', error);

    // Handle specific email service errors
    if (error.code === 'EAUTH') {
      return res.status(401).json({
        status: 'error',
        message: 'Email authentication failed. Please check SMTP credentials.',
        code: 'AUTH_ERROR'
      });
    }

    if (error.code === 'ECONNECTION') {
      return res.status(503).json({
        status: 'error',
        message: 'Unable to connect to email server. Please try again later.',
        code: 'CONNECTION_ERROR'
      });
    }

    if (error.responseCode === 550) {
      return res.status(400).json({
        status: 'error',
        message: 'Invalid recipient email address.',
        code: 'INVALID_RECIPIENT'
      });
    }

    // Generic server error
    res.status(500).json({
      status: 'error',
      message: 'Internal server error occurred while sending email',
      code: 'INTERNAL_ERROR'
    });
  }
};

module.exports = {
  sendEmail
};
