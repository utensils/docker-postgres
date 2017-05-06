#!/bin/bash
if [ ! -e /var/log/postgresql/pg_backup.log ]; then
  touch /var/log/postgresql/pg_backup.log
  chmod 666 /var/log/postgresql/pg_backup.log
fi
tail -f /var/log/postgresql/pg_backup.log 
