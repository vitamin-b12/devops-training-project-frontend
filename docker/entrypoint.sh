#!/bin/sh
set -e

# If BACKEND_API_URL is set, embed it directly into the built JS files.
# If not set, clear the placeholder so the app uses relative /api/ paths,
# which Nginx will proxy to the backend (configured below).
if [ -n "${BACKEND_API_URL}" ]; then
    echo "Configuring API URL: ${BACKEND_API_URL}"
    find /usr/share/nginx/html -name "*.js" -exec \
        sed -i "s|__BACKEND_API_URL__|${BACKEND_API_URL}|g" {} \;
else
    echo "BACKEND_API_URL not set — using Nginx proxy at /api"
    find /usr/share/nginx/html -name "*.js" -exec \
        sed -i "s|__BACKEND_API_URL__||g" {} \;
fi

# For Nginx proxy_pass, fall back to internal Docker service name.
# This is intentionally separate from the JS substitution above.
NGINX_BACKEND_URL="${BACKEND_API_URL:-http://backend:8080}"
export NGINX_BACKEND_URL

envsubst '${NGINX_BACKEND_URL}' < /etc/nginx/templates/default.conf.template \
    > /etc/nginx/conf.d/default.conf

echo "Starting Nginx..."
exec nginx -g "daemon off;"