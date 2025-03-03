#############################################
# 1. Start from Python + install dependencies
#############################################
FROM python:3.9-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

#############################################
# 2. Set working dir & install Python deps
#############################################
WORKDIR /app

COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt

#############################################
# 3. Copy source code
#############################################
COPY api /app/api
COPY etl_pipeline /app/etl_pipeline
COPY data /app/data

#############################################
# 4. Nginx config
#############################################
RUN rm /etc/nginx/sites-enabled/default
COPY api/config/nginx.conf /etc/nginx/conf.d/default.conf

#############################################
# 5. Generate a self-signed certificate
#############################################
RUN mkdir -p /etc/letsencrypt/live/venmito.ddns.net && \
    openssl req -x509 -nodes -days 365 \
      -subj "/C=US/ST=SomeState/L=SomeCity/O=SomeOrg/OU=Dev/CN=venmito.ddns.net" \
      -newkey rsa:2048 \
      -keyout /etc/letsencrypt/live/venmito.ddns.net/privkey.pem \
      -out /etc/letsencrypt/live/venmito.ddns.net/fullchain.pem

#############################################
# 6. Expose ports
#############################################
EXPOSE 80
EXPOSE 443

#############################################
# 7. Copy entrypoint script & make executable
#############################################
COPY api/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

#############################################
# 8. Run entrypoint
#############################################
ENTRYPOINT ["/entrypoint.sh"]
