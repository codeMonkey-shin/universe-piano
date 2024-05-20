# Step 1: Build the application
FROM node:18-alpine AS builder
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy all files and build the application
COPY . .
RUN npm run build

# Step 2: Serve the application
FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

# Copy the built application from the builder stage
COPY --from=builder /app ./

# Install only production dependencies
RUN npm install --only=production

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
