FROM node:24-alpine

WORKDIR /app

# Install pnpm globally
RUN npm install -g pnpm

# Copy package manifests first to optimize cache layers
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install

# Copy application source files
COPY . .

# Generate Prisma Client models
RUN pnpm run prisma:generate

# Build the TypeScript production files
RUN pnpm run build

# Expose the internal container port
EXPOSE 8000

# Set default execution command
CMD ["pnpm", "start"]
