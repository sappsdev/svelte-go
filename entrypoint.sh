#!/bin/bash

cat <<EOF > ./dist/env.js
window.env = {}
window.env.API_URL = "$API_URL"
window.env.WEBSOCKET_URL = "$WEBSOCKET_URL"
window.env.APP_NAME = "$APP_NAME"
EOF

exec ./web