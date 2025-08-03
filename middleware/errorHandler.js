/**
 * Global error handling middleware
 * Handles all unhandled errors in the application
 */
const errorHandler = (err, req, res, next) => {
  console.error('🚨 Unhandled error:', {
    message: err.message,
    stack: err.stack,
    url: req.originalUrl,
    method: req.method,
    ip: req.ip,
    userAgent: req.get('User-Agent'),
    timestamp: new Date().toISOString()
  });

  // Default error response
  let error = {
    status: 'error',
    message: 'Internal server error',
    code: 'INTERNAL_ERROR'
  };

  // Handle specific error types
  if (err.name === 'ValidationError') {
    error.message = 'Validation error';
    error.code = 'VALIDATION_ERROR';
    error.details = err.message;
    return res.status(400).json(error);
  }

  if (err.name === 'CastError') {
    error.message = 'Invalid data format';
    error.code = 'INVALID_FORMAT';
    return res.status(400).json(error);
  }

  if (err.code === 'ECONNREFUSED') {
    error.message = 'Service temporarily unavailable';
    error.code = 'SERVICE_UNAVAILABLE';
    return res.status(503).json(error);
  }

  if (err.type === 'entity.parse.failed') {
    error.message = 'Invalid JSON payload';
    error.code = 'INVALID_JSON';
    return res.status(400).json(error);
  }

  if (err.type === 'entity.too.large') {
    error.message = 'Request payload too large';
    error.code = 'PAYLOAD_TOO_LARGE';
    return res.status(413).json(error);
  }

  // Include error details in development environment
  if (process.env.NODE_ENV !== 'production') {
    error.stack = err.stack;
    error.details = err.message;
  }

  // Send error response
  res.status(err.status || 500).json(error);
};

/**
 * Handle 404 errors for undefined routes
 */
const notFoundHandler = (req, res) => {
  res.status(404).json({
    status: 'error',
    message: `Route ${req.originalUrl} not found`,
    code: 'ROUTE_NOT_FOUND',
    availableEndpoints: [
      'GET /health',
      'POST /api/v1/send-email'
    ]
  });
};

/**
 * Async error wrapper
 * Wraps async route handlers to catch errors automatically
 */
const asyncHandler = (fn) => {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

module.exports = {
  errorHandler,
  notFoundHandler,
  asyncHandler
};
