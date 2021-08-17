FROM ubuntu:20.04

ENV NGINX_VERSION "1.20.1"
ENV NGINX_SHA256 "e462e11533d5c30baa05df7652160ff5979591d291736cfa5edb9fd2edb48c49  nginx-1.20.1.tar.gz"

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpcre3-dev \
        libssl-dev \
        zlib1g-dev \
        ca-certificates \
        curl && \
    curl -sSo /tmp/nginx-$NGINX_VERSION.tar.gz \
        "https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" && \
    cd /tmp && \
    echo $NGINX_SHA256 | sha256sum --check && \
    tar -xzf nginx-$NGINX_VERSION.tar.gz && \
    cd nginx-$NGINX_VERSION && \
    ./configure \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/run/nginx.pid \
        --lock-path=/var/lock/nginx.lock \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-http_addition_module && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/nginx-$NGINX_VERSION.tar.gz && \
    rm -rf /tmp/nginx-$NGINX_VERSION && \
    groupadd -g 2001 nginx && \
    useradd -m -g nginx -u 2001 nginx && \
    apt-get remove \
        -y --purge --allow-remove-essential \
        build-essential curl ca-certificates && \
    apt-get autoremove -y && \
    apt-get clean -y
        
USER nginx:nginx

ENTRYPOINT ["nginx"]
