# Use Node.js LTS version
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apk add --no-cache \
    postgresql-client \
    python3 \
    make \
    g++ \
    jpeg-dev \
    cairo-dev \
    giflib-dev \
    pango-dev \
    libtool \
    autoconf \
    automake

# Install app dependencies
# Copy package.json and package-lock.json files
COPY package*.json ./
COPY backend/package*.json ./backend/

# Install dependencies
RUN npm run install:all

# Copy app source
COPY . .

# Create necessary directories
RUN mkdir -p logs uploads backups

# Set environment variables
ENV NODE_ENV=production
ENV PORT=5000

# Expose port
EXPOSE 5000

# Start the application
CMD ["npm", "start"]

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:5000/health || exit 1

# Build-time metadata
LABEL maintainer="Your Name <your.email@example.com>" \
      version="1.0.0" \
      description="Point of Sales System"

# Best practices
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Volume for persistent data
VOLUME ["/app/uploads", "/app/logs", "/app/backups"]

# Multi-stage build for production
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY backend/package*.json ./backend/

RUN npm run install:all --production

COPY . .

# Production image
FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app ./

# Install only production dependencies
RUN npm ci --only=production

# Set environment to production
ENV NODE_ENV=production

# Create app user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Start the application
CMD ["npm", "start"]