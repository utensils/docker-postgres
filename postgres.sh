#!/usr/bin/env bash
create_user () {
    if [ -e /var/tmp/firstrun ]; then
	echo "Waiting for PostgreSQL to start"
	while [ ! -e /var/run/postgresql/9.3-main.pid ]; do
            inotifywait -q -q -e create /var/run/postgresql/
        done
        echo "Creating user: $ROLE, with password: $PASSWORD, and schema of: $SCHEMA"
        echo "CREATE USER :user WITH SUPERUSER PASSWORD :'password' ;" | psql --set user=$ROLE --set password=$PASSWORD && createdb $SCHEMA 
        rm /var/tmp/firstrun
    fi
}
create_user &
exec /usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf


