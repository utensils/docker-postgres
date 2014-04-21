Docker Container for PostgreSQL 9.3
=================

This is a simple container for running PostgreSQL 9.3.
It allows for basic initial user/pass and schema configuration via ENV variables.

##Usage##
To run with default settings

```
docker run -P --name postgresql jamesbrink/postgresql
```

To run with customized settings

```
docker run -P --name postgresql -e ROLE=foo -e PASSWORD=bar -e SCHEMA=foo jamesbrink/postgresql
```
This will create a new container with the username and schema of `foo` and a passowrd of `bar`


Here is an example of the run. Take note of the user/pass and schema when you start the container as it will not be shown again. Of course you can chnage these settings and add additional users and schemas at any point.

```
james@ubuntu:~$ docker run -P --name postgres jamesbrink/postgresql
Waiting for PostgreSQL to start
Below are your configured options.
================
ROLE: postgres
PASSWORD: postgres
SCHEMA: postgres
================
2014-04-21 20:36:42 UTC LOG:  database system was shut down at 2014-04-21 04:34:43 UTC
2014-04-21 20:36:42 UTC LOG:  autovacuum launcher started
2014-04-21 20:36:42 UTC LOG:  database system is ready to accept connections
ALTER ROLE
```

##Environment Variables##
This is a list of the available enviornment variables wich can be set at runtime using -e KEY=value.
For example, to change the default password you can issue `docker run -P --name postgresql -e PASSWORD=mysecretpassword jamesbrink/postgresql`

* `ROLE`: A superuser role. default: `postgres`
* `PASSWORD`: The password for the role. default: `postgres`
* `SCHEMA`: Name of schema to create. default: `postgres`

