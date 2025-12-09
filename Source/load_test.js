/**
 * Load Testing Script for Load Balancer Demo
 * Sends multiple requests and analyzes the distribution
 */

const http = require('http');

// Configuration
const LOAD_BALANCER_URL = 'http://localhost';
const LOAD_BALANCER_PORT = 80;
const NUM_REQUESTS = 20;
const DELAY_MS = 100; // Delay between requests

// Stats tracking
const stats = {
  totalRequests: 0,
  successfulRequests: 0,
  failedRequests: 0,
  serverDistribution: {},
  responseTimes: [],
  errors: []
};

/**
 * Send a single HTTP request
 */
function sendRequest(requestNumber) {
  return new Promise((resolve, reject) => {
    const startTime = Date.now();

    const options = {
      hostname: 'localhost',
      port: LOAD_BALANCER_PORT,
      path: '/',
      method: 'GET'
    };

    const req = http.request(options, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        const endTime = Date.now();
        const responseTime = endTime - startTime;

        try {
          const response = JSON.parse(data);
          const serverName = response.server || 'Unknown';

          // Update stats
          stats.totalRequests++;
          stats.successfulRequests++;
          stats.responseTimes.push(responseTime);

          // Track server distribution
          if (!stats.serverDistribution[serverName]) {
            stats.serverDistribution[serverName] = 0;
          }
          stats.serverDistribution[serverName]++;

          console.log(`✅ Request ${requestNumber}: ${serverName} (${responseTime}ms)`);
          resolve(response);
        } catch (error) {
          console.error(`❌ Request ${requestNumber}: Failed to parse response`);
          stats.failedRequests++;
          stats.errors.push({ request: requestNumber, error: error.message });
          reject(error);
        }
      });
    });

    req.on('error', (error) => {
      stats.totalRequests++;
      stats.failedRequests++;
      stats.errors.push({ request: requestNumber, error: error.message });
      console.error(`❌ Request ${requestNumber}: ${error.message}`);
      reject(error);
    });

    req.end();
  });
}

/**
 * Run load test
 */
async function runLoadTest() {
  console.log('='.repeat(60));
  console.log('🚀 LOAD BALANCER TEST');
  console.log('='.repeat(60));
  console.log(`Target: ${LOAD_BALANCER_URL}:${LOAD_BALANCER_PORT}`);
  console.log(`Number of requests: ${NUM_REQUESTS}`);
  console.log(`Delay between requests: ${DELAY_MS}ms`);
  console.log('='.repeat(60));
  console.log('');

  const startTime = Date.now();

  // Send requests sequentially with delay
  for (let i = 1; i <= NUM_REQUESTS; i++) {
    try {
      await sendRequest(i);
      if (i < NUM_REQUESTS) {
        await new Promise(resolve => setTimeout(resolve, DELAY_MS));
      }
    } catch (error) {
      // Continue even if request fails
    }
  }

  const endTime = Date.now();
  const totalTime = endTime - startTime;

  // Print results
  printResults(totalTime);
}

/**
 * Print test results
 */
function printResults(totalTime) {
  console.log('\n');
  console.log('='.repeat(60));
  console.log('📊 TEST RESULTS');
  console.log('='.repeat(60));

  // Overall stats
  console.log('\n📈 Overall Statistics:');
  console.log(`  Total requests: ${stats.totalRequests}`);
  console.log(`  Successful: ${stats.successfulRequests}`);
  console.log(`  Failed: ${stats.failedRequests}`);
  console.log(`  Total time: ${totalTime}ms`);
  console.log(`  Requests/sec: ${(stats.successfulRequests / (totalTime / 1000)).toFixed(2)}`);

  // Response time stats
  if (stats.responseTimes.length > 0) {
    const avgResponseTime = stats.responseTimes.reduce((a, b) => a + b, 0) / stats.responseTimes.length;
    const minResponseTime = Math.min(...stats.responseTimes);
    const maxResponseTime = Math.max(...stats.responseTimes);

    console.log('\n⏱️  Response Time:');
    console.log(`  Average: ${avgResponseTime.toFixed(2)}ms`);
    console.log(`  Min: ${minResponseTime}ms`);
    console.log(`  Max: ${maxResponseTime}ms`);
  }

  // Server distribution
  console.log('\n🖥️  Server Distribution:');
  const totalSuccessful = stats.successfulRequests;

  Object.entries(stats.serverDistribution)
    .sort((a, b) => b[1] - a[1])
    .forEach(([server, count]) => {
      const percentage = ((count / totalSuccessful) * 100).toFixed(1);
      const bar = '█'.repeat(Math.round(count / 2));
      console.log(`  ${server.padEnd(12)}: ${count.toString().padStart(3)} requests (${percentage}%) ${bar}`);
    });

  // Errors
  if (stats.errors.length > 0) {
    console.log('\n⚠️  Errors:');
    stats.errors.forEach(err => {
      console.log(`  Request ${err.request}: ${err.error}`);
    });
  }

  console.log('\n' + '='.repeat(60));
}

// Run the test
runLoadTest().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});
