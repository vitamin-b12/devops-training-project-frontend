FROM node:18.20-alpine3.20 AS builder

WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm install --legacy-peer-deps

COPY public/ public/
COPY src/ src/

RUN REACT_APP_API_ROOT=__BACKEND_API_URL__ npm run build

FROM nginx:1.27-alpine AS runtime

LABEL maintainer="devops-training"
LABEL application="mock-ecommerce-frontend"

RUN apk upgrade --no-cache && \
    rm /etc/nginx/conf.d/default.conf && \
    rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/build /usr/share/nginx/html

COPY ./docker/nginx.conf.template /etc/nginx/templates/default.conf.template

COPY ./docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=30s \
  CMD wget -qO- http://localhost/health || exit 1

ENTRYPOINT ["/entrypoint.sh"]