# PostgtreSQL 9.4
#
# VERSION    1.0.0 

FROM debian:jessie
MAINTAINER James Brink, brink.james@gmail.com

RUN apt-get update && apt-get install -y postgresql-9.4 postgresql-contrib-9.4 postgresql-9.4-postgis-2.1 postgresql-client-9.4 inotify-tools && rm -rf /var/lib/apt/lists/*

ADD ./scripts/postgres.sh /var/lib/postgresql/postgres.sh
RUN chown postgres:postgres /var/lib/postgresql/postgres.sh
RUN chmod +x /var/lib/postgresql/postgres.sh

USER postgres

# Initial default user/pass and schema
ENV USER postgres
ENV PASSWORD postgres
ENV SCHEMA postgres
ENV POSTGIS false
ENV ENCODING SQL_ASCII

RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf

VOLUME	["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

RUN touch /var/tmp/firstrun

EXPOSE 5432
CMD ["/var/lib/postgresql/postgres.sh"]
