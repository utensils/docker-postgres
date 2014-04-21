Docker Container for PostgreSQL 9.3
=================

This is a simple container for running PostgreSQL 9.3.
It allows for basic initial user/pass and schema configuration via ENV variables.

##Extensions##
This container is preloaded with the following extensions.

* [PostgreSQL-Contrib](http://www.postgresql.org/docs/9.3/static/contrib.html)
* [PostGIS 2.1](http://postgis.net/)


##Usage##
To run with default settings

```
docker run -P --name postgresql jamesbrink/postgresql
```

To run with customized settings

```
docker run -P --name postgresql -e ROLE=foo -e PASSWORD=bar -e SCHEMA=foo jamesbrink/postgresql
```
This will create a new container with the username and schema of `foo` and a password of `bar`


Here is an example of the run. Take note of the user/pass and schema when you start the container as it will not be shown again. Of course you can change these settings and add additional users and schemas at any point.


    james@ubuntu:~$ docker run -P --name postgres jamesbrink/postgresql
    Waiting for PostgreSQL to start
    2014-04-21 20:36:42 UTC LOG:  database system was shut down at 2014-04-21 04:34:43 UTC
    2014-04-21 20:36:42 UTC LOG:  autovacuum launcher started
    2014-04-21 20:36:42 UTC LOG:  database system is ready to accept connections
    Below are your configured options.
    ================
    ROLE: postgres
    PASSWORD: postgres
    SCHEMA: postgres
    ================
    ALTER ROLE


##Container Linking##
Here are some examples of linking containers to postgresql

First we create a container, here I am using a random password generated from openssl

    james@ubuntu:~/$ docker run -P --name postgres -e PASSWORD=`openssl rand -hex 10` -e ROLE=james -e SCHEMA=test jamesbrink/postgresql
    Waiting for PostgreSQL to start
    Below are your configured options.
    ================
    ROLE: james
    PASSWORD: 5387fc737962925e2c70
    SCHEMA: test
    ================
    2014-04-21 21:07:24 UTC LOG:  database system was shut down at 2014-04-21 04:34:43 UTC
    2014-04-21 21:07:24 UTC LOG:  autovacuum launcher started
    2014-04-21 21:07:24 UTC LOG:  database system is ready to accept connections
    CREATE ROLE

With the postgres container up and running, lets create a new container and link it with an alias of `db`.

    james@ubuntu:~/$ docker run -i -t --link postgres:db ubuntu /bin/bash
    
Now from inside the container ensure you have a postgresql client installed.

    root@47b16d7d1e13:/# apt-get install postgresql-client
    
You can now connect to the database in a variety of ways. lets first inspect the environment. The variables of interest here are all prefixed with `DB_`

    root@47b16d7d1e13:/# env
    HOSTNAME=47b16d7d1e13
    DB_NAME=/cocky_babbage/db
    TERM=xterm
    DB_PORT_5432_TCP_ADDR=172.17.0.2
    DB_ENV_SCHEMA=test
    DB_PORT=tcp://172.17.0.2:5432
    DB_PORT_5432_TCP=tcp://172.17.0.2:5432
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    PWD=/
    DB_ENV_PASSWORD=5387fc737962925e2c70
    DB_PORT_5432_TCP_PORT=5432
    SHLVL=1
    HOME=/
    DB_ENV_ROLE=james
    DB_PORT_5432_TCP_PROTO=tcp
    _=/usr/bin/env

Connect manually.

    root@47b16d7d1e13:/# psql -h 172.17.0.2 -U james test
    Password for user james: 
    psql (9.1.13, server 9.3.4)
    WARNING: psql version 9.1, server version 9.3.
         Some psql features might not work.
    SSL connection (cipher: DHE-RSA-AES256-SHA, bits: 256)
    Type "help" for help.
    test=# 

Connect using ENV variables.

    root@47b16d7d1e13:/# PGPASSWORD=$DB_ENV_PASSWORD psql -h $DB_PORT_5432_TCP_ADDR -U $DB_ENV_ROLE $DB_ENV_SCHEMA
    psql (9.1.13, server 9.3.4)
    WARNING: psql version 9.1, server version 9.3.
         Some psql features might not work.
    SSL connection (cipher: DHE-RSA-AES256-SHA, bits: 256)
    Type "help" for help.
    test=# 
    
Create an application friendly URI.

    root@47b16d7d1e13:/# export DB_URI=postgres://$DB_ENV_ROLE:$DB_ENV_PASSWORD@$DB_PORT_5432_TCP_ADDR:$DB_PORT_5432_TCP_PORT/$DB_ENV_SCHEMA
    root@47b16d7d1e13:/# echo $DB_URI
    postgres://james:5387fc737962925e2c70@172.17.0.2:5432/test

    
##Environment Variables##
This is a list of the available environment variables which can be set at runtime using -e KEY=value.
For example, to change the default password you can issue `docker run -P --name postgresql -e PASSWORD=mysecretpassword jamesbrink/postgresql`

* `ROLE`: A superuser role. default: `postgres`
* `PASSWORD`: The password for the role. default: `postgres`
* `SCHEMA`: Name of schema to create. default: `postgres`

##Backups##
Be sure to run regular backups of any production databases. This can be handled in many different ways and I will not go into details here about how you should handle your backups. For additional information on backing up databases refer to the [PostgreSQL 9.3 Documentation on Backups](http://www.postgresql.org/docs/9.3/static/backup.html)

