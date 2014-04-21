# PostgtreSQL 9.3
#
# VERSION       1.0

FROM ubuntu
MAINTAINER James Brink, brink.james@gmail.com

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-key adv --fetch-keys http://www.postgresql.org/media/keys/ACCC4CF8.asc 
RUN apt-get update

RUN apt-get install -y postgresql-9.3
RUN apt-get install -y postgresql-contrib-9.3
RUN apt-get install -y postgresql-9.3-postgis-2.1
RUN apt-get install -y postgresql-client-9.3
RUN apt-get install -y inotify-tools


ADD ./postgres.sh /var/lib/postgresql/postgres.sh
RUN chown postgres:postgres /var/lib/postgresql/postgres.sh
RUN chmod +x /var/lib/postgresql/postgres.sh

USER postgres

# Initial default user/pass and schema
ENV ROLE postgres
ENV PASSWORD postgres
ENV SCHEMA postgres

RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

VOLUME	["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

RUN touch /var/tmp/firstrun

EXPOSE 5432
CMD ["/var/lib/postgresql/postgres.sh"]


