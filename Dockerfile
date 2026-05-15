FROM node:24-alpine

WORKDIR /app

# Install pnpm globally
RUN npm install -g pnpm

# 1. Copy package files and the Prisma folder (Crucial!)
COPY package.json pnpm-lock.yaml* .npmrc ./
COPY prisma ./prisma/

# 2. Tell pnpm to allow scripts for the specific packages it's complaining about
RUN pnpm config set allowed-hosts ghcr.io
RUN pnpm install --no-frozen-lockfile --only-allow-trusted-dependencies

# 3. If it still blocks them, this command forces the approval of all current dependencies
RUN pnpm approve-builds && pnpm install --no-frozen-lockfile

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
#run