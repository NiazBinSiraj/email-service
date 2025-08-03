const express = require('express');
const { sendEmail } = require('../controllers/emailController');
const { validateEmailRequest } = require('../middleware/validation');

const router = express.Router();

/**
 * @route   POST /api/v1/send-email
 * @desc    Send email via Gmail SMTP
 * @access  Public (with rate limiting)
 * @body    { to, subject, message, cc?, bcc? }
 */
router.post('/send-email', validateEmailRequest, sendEmail);

module.exports = router;
