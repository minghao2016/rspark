FROM library/ubuntu:bionic
MAINTAINER Mark Lilback <mark@lilback.com>

# Define Postgres Versions
#ARG pgversion=9.6
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
#ARG JAVA_VERSION=8
#ARG JAVA_VERSION_NUMBER=1.${JAVA_VERSION}.0
ENV PGDATA /opt/pg-data
ENV PGDIR /usr/lib/postgresql/${POSTGRES_VERSION}/bin/
ENV PGVERSION ${POSTGRES_VERSION}

# Add the PostgreSQL PGP key to verify their Debian packages.
# Install packages and Postgres
# Delete default cluster and create new cluster

RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - && \
    add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
    apt-get install -y python-software-properties postgresql-${POSTGRES_VERSION} postgresql-client-${POSTGRES_VERSION} postgresql-contrib-${POSTGRES_VERSION} libpq-dev && \
    mkdir -p /opt/pg-data; chown -R postgres /opt/pg-data; chmod 700 /opt/pg-data && \
    locale-gen en_US.UTF-8 && \
    pg_dropcluster ${POSTGRES_VERSION} main && \
#RUN pg_createcluster -d $PGDATA --locale=en_US.UTF-8 ${POSTGRES_VERSION} main

# Copy data file
COPY dataexpo.sql nycflights13.sql.gz init.sh /opt/

# Become user Postgres (superuser)
USER postgres

# Copy connection configuration file
COPY pg_hba.conf postgresql.conf /etc/postgresql/${POSTGRES_VERSION}/main/
COPY runpg.sh /var/lib/postgresql/runpg.sh
RUN /opt/init.sh

# Define environment variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

EXPOSE 5432

# Execute Postgres setup script "runpg.sh"
CMD ["var/lib/postgresql/runpg.sh", "${POSTGRES_VERSION}"]

# CMD ["/usr/bin/pg_ctlcluster", "9.4", "main", "start", "--foreground"]
# CMD ["/usr/lib/postgresql/${pgversion}/bin/postgres", "-D", "$PGDIR", "-c", "config_file=/etc/postgresql/${pg/main/postgresql.conf"]

