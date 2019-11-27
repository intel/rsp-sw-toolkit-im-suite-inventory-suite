
#!/bin/bash

set -e
set -u

function createDataBases() {
	local dbName=$1	
    local dbUser=$POSTGRES_USER
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE DATABASE $dbName OWNER $dbUser;	    
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then	
	for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
		createDataBases $db
	done	
fi