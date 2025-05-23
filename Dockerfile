# Stage 1 - Build
FROM node:18-slim AS builder

# Set workdir
WORKDIR /app

# Copy only package.json and lock file first to install deps using cache
COPY package*.json ./

# Install only production deps
RUN npm ci --omit=dev

# Copy source files
COPY . .

# Stage 2 - Run
FROM node:18-slim

# Add non-root user
RUN useradd -m appuser

WORKDIR /app

# Copy from builder
COPY --from=builder /app .

# Use non-root user
USER appuser

# Expose port (adjust based on app)
EXPOSE 3000

# Start app
CMD ["node", "index.js"]

