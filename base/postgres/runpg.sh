#!/bin/bash

PGDATA="/opt/pg-data"
pgversion=${POSTGRES_VERSION}
appdir=/usr/lib/postgresql/${POSTGRES_VERSION}/bin/
# When setting up the database, we need to not allow external connections 
# that assume everything is setup. We do this by running the server with
# a non-standard port during setup.
tmpport=5431

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

chown postgres /opt/pg-data
ls -ld $PGDATA
if [ ! -d "${PGDATA}/base" ]; then
	echo "$PGDATA does not exist. creating database."
	${appdir}/initdb -D $PGDATA
	${appdir}/pg_ctl -o "-p ${tmpport}" -D $PGDATA start
	#need to wait for it to start
	sleep 5;
	psql -p ${tmpport} --command "CREATE USER rstudio createdb"
	createdb -p ${tmpport} -O rstudio rstudio
	psql -p ${tmpport} --command "CREATE USER hive"
	createdb -p ${tmpport} -O hive hive
	createdb -p ${tmpport} -O rstudio dataexpo
	createdb -p ${tmpport} -O rstudio nycflights13
	createdb -p ${tmpport} -O rstudio testdb

	psql -p ${tmpport} -U rstudio dataexpo </opt/dataexpo.sql >/dev/null
	psql -p ${tmpport} -U rstudio nycflights13 </opt/nycflights.sql >/dev/null
	#just to be sure, as there were problems accessing this once
	psql -p ${tmpport} --command "GRANT ALL PRIVILEGES ON DATABASE dataexpo TO rstudio"
	psql -p ${tmpport} --command "GRANT ALL PRIVILEGES ON DATABASE nycflights13 TO rstudio"
	psql -p ${tmpport} --command "GRANT ALL PRIVILEGES ON DATABASE testdb TO rstudio"
	service postgresql stop
	cd /usr/share/postgresql/${pgversion}
fi

/usr/bin/pg_ctlcluster ${POSTGRES_VERSION} main start --foreground