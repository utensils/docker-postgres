# PostgtreSQL Server
#
# VERSION    9.5

FROM debian:jessie

ARG VCS_REF
ARG BUILD_DATE

LABEL maintainer="James Brink, brink.james@gmail.com" \
      decription="PostgreSQL Server" \
      version="9.5" \
      org.label-schema.name="postgres" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/jamesbrink/docker-postgres" \
      org.label-schema.schema-version="1.0.0-rc1"

ENV postgres_version=9.5 \
    postgis_version=2.2

# Install all needed packages, this includes adding packages from postgresql's
# package database. Thisi repo provides postgis as well.
RUN groupadd postgres \
      && useradd -s /bin/bash -d /var/postgres -m -g postgres postgres \
      && apt-get update \
      && apt-get install -y \
      wget \
      inotify-tools \
      supervisor \
      && echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > \
      /etc/apt/sources.list.d/pgdg.list \
      && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
      && apt-get update \
      && apt-get install -y \
      postgresql-${postgres_version} \
      postgresql-contrib-${postgres_version} \
      postgresql-${postgres_version}-postgis-${postgis_version} \
      postgresql-client-${postgres_version} \
      && rm -rf /var/lib/apt/lists/* \
      && mkdir -p /var/run/supervisor \
      && chown -R postgres:postgres /var/run/supervisor \
      && chown -R postgres:postgres /var/run/postgresql /var/backups /usr/local/etc \
      && echo "listen_addresses='*'" >> /etc/postgresql/${postgres_version}/main/postgresql.conf \
      && echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/${postgres_version}/main/pg_hba.conf \
      && sed -i "s|data_directory =.*$|data_directory = '/var/lib/postgresql/data'|g" /etc/postgresql/${postgres_version}/main/postgresql.conf \
      && rm -rf /var/lib/postgresql/* \
      && touch /var/lib/postgresql/firstrun && chmod 666 /var/lib/postgresql/firstrun

# Add our custom assets to the container.
COPY docker-assets/ /

# Set proper permissions on custom assets.
RUN chown postgres:postgres /usr/local/bin/postgres.sh /usr/local/etc/pg_backup.config \
      && chmod +x /usr/local/bin/postgres.sh \
      && chmod +x /usr/local/bin/pg_backup.sh \
      && chmod +x /usr/local/bin/log_watch.sh

# Store postgres versions
ENV POSTGRES_VERSION=$postgres_version \
    POSTGIS_VERSION=$postgis_version \
    # Locale setting
    LOCALE=en_US.UTF-8 \
    # Initial default postgres settings
    USER=postgres \
    PASSWORD=postgres \
    DATABASE=postgres \
    SCHEMA=public \
    POSTGIS=false \
    ENCODING=SQL_ASCII \
    # Database backup settings
    BACKUP_ENABLED=false \
    BACKUP_FREQUENCY=daily \
    # TODO implement these
    BACKUP_RETENTION=7 \
    BACKUP_EMAIL=postgres \
    ENVIRONMENT=development

VOLUME	["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql", "/var/backups"]

EXPOSE 5432
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]