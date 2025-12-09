/**
 * Simple Node.js server for Load Balancer Demo
 * Each server instance will respond with its unique identifier
 */

const express = require('express');
const app = express();

// Get port from environment variable or default
const PORT = process.env.PORT || 3001;
const SERVER_ID = process.env.SERVER_ID || '1';
const SERVER_COLOR = process.env.SERVER_COLOR || 'blue';

// Counter for tracking requests
let requestCount = 0;

// Middleware to log requests
app.use((req, res, next) => {
  requestCount++;
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] Request #${requestCount} received on Server ${SERVER_ID}`);
  next();
});

// Main endpoint
app.get('/', (req, res) => {
  const response = {
    server: `Server ${SERVER_ID}`,
    port: PORT,
    color: SERVER_COLOR,
    requestNumber: requestCount,
    timestamp: new Date().toISOString(),
    hostname: require('os').hostname(),
    message: `Response from Server ${SERVER_ID} (Port ${PORT})`
  };

  res.json(response);
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    server: `Server ${SERVER_ID}`,
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// Stats endpoint
app.get('/stats', (req, res) => {
  res.json({
    server: `Server ${SERVER_ID}`,
    totalRequests: requestCount,
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    timestamp: new Date().toISOString()
  });
});

// Simulate slow response (for testing Least Connections)
app.get('/slow', (req, res) => {
  const delay = parseInt(req.query.delay) || 3000;
  setTimeout(() => {
    res.json({
      server: `Server ${SERVER_ID}`,
      message: `Delayed response after ${delay}ms`,
      timestamp: new Date().toISOString()
    });
  }, delay);
});

// Start server
app.listen(PORT, () => {
  console.log('='.repeat(50));
  console.log(`🚀 Server ${SERVER_ID} is running!`);
  console.log(`📍 Port: ${PORT}`);
  console.log(`🎨 Color: ${SERVER_COLOR}`);
  console.log(`⏰ Started at: ${new Date().toISOString()}`);
  console.log('='.repeat(50));
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log(`\n🛑 Server ${SERVER_ID} shutting down gracefully...`);
  process.exit(0);
});
