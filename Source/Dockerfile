# Use Node.js Alpine image for smaller size
FROM node:18-alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy application code
COPY server_app.js .

# Expose port (will be overridden by environment variable)
EXPOSE 3001

# Start the application
CMD ["node", "server_app.js"]
