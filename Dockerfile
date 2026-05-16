FROM node:24-alpine AS builder

WORKDIR /app

# 1. Install pnpm
RUN npm install -g pnpm@latest

# 2. Copy dependency files
COPY package.json pnpm-lock.yaml* ./

# 3. Force pnpm to allow the build scripts for Prisma/Bcrypt
# This configures it JUST for this container build

# 4. Install dependencies
RUN pnpm install --no-frozen-lockfile --ignore-scripts

# 5. Copy the rest of the code
COPY . .

RUN DATABASE_URL="postgresql://user:pass@localhost:5432/db" pnpm run prisma:generate


# 7. Build the project
RUN pnpm run build

RUN ls -R dist || ls -R build || ls -R out

# --- Stage 2: Runtime ---
FROM node:24-alpine
WORKDIR /app

# Only copy what is needed to run the app to keep it small
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 8000

CMD ["node", "dist/index.js"]