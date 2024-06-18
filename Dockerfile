FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json package-lock.json* ./
RUN npm ci # Use npm ci for deterministic installs

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build the Next.js app
RUN npm run build

# Production image, copy all the files and run next
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs


# Set the correct permission for prerender cache
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
# COPY --from=builder --chown=nextjs:nodejs /app/dist/apps/portal/.next/ ./.next
COPY --from=builder --chown=nextjs:nodejs /app/dist/apps/portal/.next/standalone ./.next
COPY --from=builder --chown=nextjs:nodejs /app/dist/apps/portal/.next/static ./.next/dist/apps/portal/.next/static
COPY --from=builder --chown=nextjs:nodejs /app/apps/portal/public .next/apps/portal/public

# COPY --from=builder --chown=nextjs:nodejs /app/public ./public

USER nextjs

EXPOSE 3200

ENV PORT 3200

# server.js is created by next build from the standalone output
# https://nextjs.org/docs/pages/api-reference/next-config-js/outputs
CMD HOSTNAME="0.0.0.0" node .next/apps/portal/server.js
