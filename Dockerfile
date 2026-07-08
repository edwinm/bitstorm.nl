FROM georgjung/nginx-brotli:mainline-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY . /usr/share/nginx/html/
EXPOSE 80