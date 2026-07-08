# ---- stage 1: precompress ----
FROM alpine:3.20 AS compress
RUN apk add --no-cache brotli
WORKDIR /site
COPY . .
# strip build-only files so they don't end up in the web root
RUN rm -f Dockerfile nginx.conf .dockerignore
# create <file>.br next to each compressible file, at max level, keeping originals
RUN find . -type f \
      \( -name '*.html' -o -name '*.css' -o -name '*.js' -o -name '*.mjs' \
         -o -name '*.json' -o -name '*.svg' -o -name '*.xml' -o -name '*.txt' \
         -o -name '*.ico' -o -name '*.wasm' -o -name '*.map' \) \
      -exec brotli --best --keep --force {} \;

# ---- stage 2: runtime ----
FROM georgjung/nginx-brotli:mainline-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=compress /site /usr/share/nginx/html/
EXPOSE 80