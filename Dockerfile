# Pgpool2.

FROM alpine:latest

ENV PGPOOL_VERSION 4.3.1
#ENV PGPOOL_VERSION 4_3_1
ENV PG_VERSION 14

ENV LANG en_US.utf8
    
RUN apk --update --no-cache add \
    libpq \
    postgresql${PG_VERSION}-dev \
    postgresql${PG_VERSION}-client \
    libffi-dev python3 python3-dev py3-pip libffi-dev curl pgpool
#RUN    rm -rf /tmp/pgpool-II-${PGPOOL_VERSION} && \
RUN    curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.14/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu && \
    apk del postgresql${PG_VERSION}-dev curl

RUN pip install Jinja2

RUN mkdir -p /etc/pgpool2 /var/run/pgpool /var/log/pgpool /var/run/postgresql /var/log/postgresql/ && \
    chown postgres /etc/pgpool2 /var/run/pgpool /var/log/pgpool /var/run/postgresql /var/log/postgresql

# Post Install Configuration.
ADD bin/configure-pgpool2 /usr/bin/configure-pgpool2
RUN chmod +x /usr/bin/configure-pgpool2
ADD conf/pcp.conf.template /usr/share/pgpool2/pcp.conf.template
ADD conf/pgpool.conf.template /usr/share/pgpool2/pgpool.conf.template

# Start the container.
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9999 9898

CMD ["pgpool","-n", "-f", "/etc/pgpool2/pgpool.conf", "-F", "/etc/pgpool2/pcp.conf"]
