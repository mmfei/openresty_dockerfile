
ARG RESTY_IMAGE_BASE="centos"
ARG RESTY_IMAGE_TAG="7"

FROM ${RESTY_IMAGE_BASE}:${RESTY_IMAGE_TAG}
LABEL maintainer="mmfei <wlfkongl@163.com>"
ARG OPENRESTY_VERSION="1.13.6.2"
ARG SOURCE_ROOT="/root/src"

ENV NGINX_HOME=/usr/local/openresty/nginx
ENV PATH=$NGINX_HOME/sbin:$PATH

RUN yum -y install readline-devel pcre pcre-devel openssl openssl-devel gcc curl GeoIP-devel wget perl

RUN mkdir -p ${SOURCE_ROOT} ; wget https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz -O ${SOURCE_ROOT}/openresty-${OPENRESTY_VERSION}.tar.gz && tar xvzf ${SOURCE_ROOT}/openresty-${OPENRESTY_VERSION}.tar.gz -C ${SOURCE_ROOT};

RUN cd ${SOURCE_ROOT}/openresty-${OPENRESTY_VERSION} && chmod +x configure && ./configure --with-luajit --with-pcre --with-http_gzip_static_module --with-http_realip_module --with-http_geoip_module --with-http_stub_status_module && make && make install

# COPY openresty/config/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
VOLUME [ "/etc/nginx/conf.d" ]

# RUN chmod +x /start.sh
# ENTRYPOINT ["nginx","-c","/usr/local/openresty/nginx/conf/nginx.conf"]
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
VOLUME [ "/etc/nginx/conf.d/" ]
EXPOSE 80
