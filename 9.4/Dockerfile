# PostgtreSQL Server
#
# VERSION    9.4

FROM debian:jessie
MAINTAINER James Brink, brink.james@gmail.com
LABEL version="9.4"
LABEL decription="PostgreSQL Server"

ARG postgres_version=9.4
ARG postgis_version=2.1

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
      && sed -i -r 's/(local\s+all\s+all\s+)peer/local all all md5/' /etc/postgresql/${postgres_version}/main/pg_hba.conf \
      && sed -i "s|data_directory =.*$|data_directory = '/var/lib/postgresql/data'|g" /etc/postgresql/${postgres_version}/main/postgresql.conf \
      && rm -rf /var/lib/postgresql/* \
      && touch /var/lib/postgresql/firstrun && chmod 666 /var/lib/postgresql/firstrun

# Add our custom assets to the container.
ADD docker-assets/ /

# Set proper permissions on custom assets.
RUN chown postgres:postgres /usr/local/bin/postgres.sh /usr/local/etc/pg_backup.config \
      && chmod +x /usr/local/bin/postgres.sh \
      && chmod +x /usr/local/bin/pg_backup.sh \
      && chmod +x /usr/local/bin/log_watch.sh

# Store postgres versions
ENV POSTGRES_VERSION=$postgres_version
ENV POSTGIS_VERSION=$postgis_version

# Locale setting
ENV LOCALE=en_US.UTF-8

# Initial default user/pass and schema
ENV USER=postgres
ENV PASSWORD=postgres
ENV SCHEMA=postgres
ENV POSTGIS=false
ENV ENCODING=SQL_ASCII

# Database backup settings
ENV BACKUP_ENABLED=false
ENV BACKUP_FREQUENCY=daily

# TODO implement these
ENV BACKUP_RETENTION=7
ENV BACKUP_EMAIL=postgres
ENV ENVIRONMENT=development

VOLUME	["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql", "/var/backups"]

EXPOSE 5432
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]