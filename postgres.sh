#!/usr/bin/env bash
create_user () {
  #TODO replace this sleep with someting better
  echo "Seelping for 10 seconds to create user"
  sleep 10
  echo "Creating user: $ROLE, with password: $PASSWORD , and schema of: $SCHEMA"
  echo "CREATE USER :user WITH SUPERUSER PASSWORD :'password' ;" | psql --set user=$ROLE --set password=$PASSWORD && createdb $SCHEMA 
}
create_user &
/usr/lib/postgresql/9.1/bin/postgres -D /var/lib/postgresql/9.1/main -c config_file=/etc/postgresql/9.1/main/postgresql.conf


