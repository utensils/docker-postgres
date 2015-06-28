# PostgtreSQL 9.4
#
# VERSION    1.1.0

FROM debian:jessie
MAINTAINER James Brink, brink.james@gmail.com
LABEL version="1.1.0"
LABEL decription="PostgreSQL Server 9.4"

RUN apt-get update \
  && apt-get install -y \
  inotify-tools \
  postgresql-9.4 \
  postgresql-contrib-9.4 \
  postgresql-9.4-postgis-2.1 \
  postgresql-client-9.4 \
  && rm -rf /var/lib/apt/lists/*

ADD docker-assets/ /

RUN chown postgres:postgres /usr/local/bin/postgres.sh /usr/local/etc/pg_backup.config \
  && chmod +x /usr/local/bin/postgres.sh \
  && chmod +x /usr/local/bin/pg_backup.sh \
  && chown -R postgres:postgres /var/run/postgresql /var/backups /usr/local/etc

USER postgres

# Initial default user/pass and schema
ENV USER postgres
ENV PASSWORD postgres
ENV SCHEMA postgres
ENV POSTGIS false
ENV ENCODING SQL_ASCII

# Database backup settings
ENV BACKUP_ENABLED false
ENV BACKUP_FREQUENCY daily
ENV BACKUP_RETENTION 7

RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf \
  && echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf

VOLUME	["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql", "/var/backups"]


RUN touch /var/tmp/firstrun

EXPOSE 5432
CMD ["/usr/local/bin/postgres.sh"]
