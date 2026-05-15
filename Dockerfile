FROM node:24-alpine

WORKDIR /app

# Copy all files
COPY . .

# Use npm to bypass the pnpm security blocks
RUN npm install --legacy-peer-deps

# Generate the Prisma client
RUN npx prisma generate

# Build the project
RUN npm run build

EXPOSE 8000

CMD ["npm", "run", "start"]