#!/usr/bin/env bash
create_user () {
    if [ -e /var/tmp/firstrun ]; then
	echo "Waiting for PostgreSQL to start"
	while [ ! -e /var/run/postgresql/9.3-main.pid ]; do
            inotifywait -q -q -e create /var/run/postgresql/
        done

	# We sleep here for 2 seconds to allow clean output, and speration from postgres startup messages
	sleep 2
        echo "Below are your configured options."
        echo -e "================\nUSER: $USER\nPASSWORD: $PASSWORD\nSCHEMA: $SCHEMA\n================"
        if [ $USER == "postgres" ]; then
            echo "ALTER USER :user WITH PASSWORD :'password' ;" | psql --set user=$USER --set password=$PASSWORD
            if [ $SCHEMA != "postgres" ]; then
                createdb $SCHEMA
            fi
        else
            echo "CREATE USER :user WITH SUPERUSER PASSWORD :'password' ;" | psql --set user=$USER --set password=$PASSWORD && createdb $SCHEMA 
        fi
        rm /var/tmp/firstrun
    fi
}
create_user &
exec /usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf


