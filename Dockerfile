# PostgtreSQL 9.3.4
#
# VERSION       1.1

FROM ubuntu:14.04
MAINTAINER James Brink, brink.james@gmail.com

RUN echo "Invalidate Cache!"

RUN apt-get install -y postgresql-9.3
RUN apt-get install -y postgresql-contrib-9.3
RUN apt-get install -y postgresql-9.3-postgis-2.1
RUN apt-get install -y postgresql-client-9.3
RUN apt-get install -y inotify-tools

ADD ./scripts/postgres.sh /var/lib/postgresql/postgres.sh
RUN chown postgres:postgres /var/lib/postgresql/postgres.sh
RUN chmod +x /var/lib/postgresql/postgres.sh

USER postgres

# Initial default user/pass and schema
ENV USER postgres
ENV PASSWORD postgres
ENV SCHEMA postgres
ENV POSTGIS false

RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

VOLUME	["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

RUN touch /var/tmp/firstrun

EXPOSE 5432
CMD ["/var/lib/postgresql/postgres.sh"]


