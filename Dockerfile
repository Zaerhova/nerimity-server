FROM node:24-alpine AS builder
WORKDIR /app
RUN npm install -g pnpm@latest
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --no-frozen-lockfile --ignore-scripts
COPY . .
RUN pnpm run prisma:generate

# 1. Run the build
RUN pnpm run build

# 2. Check where the files went (This helps us debug if it fails again)
RUN ls -R dist || ls -R build || ls -R out

# --- Stage 2: Runtime ---
FROM node:24-alpine
WORKDIR /app

# 3. Copy everything from the builder to ensure we don't miss hidden files
COPY --from=builder /app/dist ./dist
# If Nerimity uses a "build" folder instead, change the line above to:
# COPY --from=builder /app/build ./dist

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 8000

# 4. Use a more flexible start command
CMD ["node", "dist/index.js"]