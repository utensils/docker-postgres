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

