FROM node:20-slim AS build-svelte
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /builder
COPY . .
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm run -r build

FROM golang:1.23-bookworm AS build-go
WORKDIR /builder
COPY . .
COPY --from=build-svelte /builder/dist ./dist
RUN go build -ldflags='-w -s -extldflags "-static"' -a -o web

FROM debian:bookworm-slim AS final
WORKDIR /app
COPY --from=build-svelte /builder/dist ./dist
COPY --from=build-go /builder/web .
COPY entrypoint.sh .

RUN chmod +x entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["./entrypoint.sh"]