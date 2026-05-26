FROM caddy:2-alpine

# Copy site
COPY public/ /srv/
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 80

# Caddy starts via the base image entrypoint
