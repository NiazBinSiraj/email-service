const { body } = require('express-validator');

/**
 * Email request validation middleware
 * Validates incoming email data using express-validator
 */
const validateEmailRequest = [
  // Validate 'to' field
  body('to')
    .notEmpty()
    .withMessage('Recipient email address is required')
    .custom((value) => {
      // Handle both string and array inputs
      const emails = Array.isArray(value) ? value : [value];
      
      // Check if all emails are valid
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      const invalidEmails = emails.filter(email => !emailRegex.test(email));
      
      if (invalidEmails.length > 0) {
        throw new Error(`Invalid email address(es): ${invalidEmails.join(', ')}`);
      }
      
      // Limit number of recipients to prevent abuse
      if (emails.length > 50) {
        throw new Error('Maximum 50 recipients allowed per request');
      }
      
      return true;
    }),

  // Validate 'subject' field
  body('subject')
    .notEmpty()
    .withMessage('Email subject is required')
    .isLength({ min: 1, max: 200 })
    .withMessage('Subject must be between 1 and 200 characters')
    .trim()
    .escape(),

  // Validate 'message' field
  body('message')
    .notEmpty()
    .withMessage('Email message is required')
    .isLength({ min: 1, max: 10000 })
    .withMessage('Message must be between 1 and 10,000 characters')
    .trim(),

  // Validate optional 'cc' field
  body('cc')
    .optional()
    .custom((value) => {
      if (value !== undefined && value !== null && value !== '') {
        const emails = Array.isArray(value) ? value : [value];
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const invalidEmails = emails.filter(email => !emailRegex.test(email));
        
        if (invalidEmails.length > 0) {
          throw new Error(`Invalid CC email address(es): ${invalidEmails.join(', ')}`);
        }
        
        if (emails.length > 20) {
          throw new Error('Maximum 20 CC recipients allowed');
        }
      }
      return true;
    }),

  // Validate optional 'bcc' field
  body('bcc')
    .optional()
    .custom((value) => {
      if (value !== undefined && value !== null && value !== '') {
        const emails = Array.isArray(value) ? value : [value];
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const invalidEmails = emails.filter(email => !emailRegex.test(email));
        
        if (invalidEmails.length > 0) {
          throw new Error(`Invalid BCC email address(es): ${invalidEmails.join(', ')}`);
        }
        
        if (emails.length > 20) {
          throw new Error('Maximum 20 BCC recipients allowed');
        }
      }
      return true;
    })
];

module.exports = {
  validateEmailRequest
};
