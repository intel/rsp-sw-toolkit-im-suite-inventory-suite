#/bin/sh

set -e
set -u

function createDatabases() {
    psql --set db="$1" --set user="$POSTGRES_USER" -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE DATABASE :"db" OWNER :"user";
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
    for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' ' ); do
        createDatabases $db
    done
fi

