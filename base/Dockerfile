MAINTAINER Chris Grant <chrisgrant.datascience@gmail.com>

FROM ubuntu:bionic

ENV hadoopversion=2.9.2
ENV hiveversion=2.1.1
ENV sparkversion=2.4.4
ENV javaversion=8
ENV javaversion_number=1.${javaversion}.0

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

ENV JAVA_HOME /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64

ENV R_BASE_VERSION 3.6.3

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

COPY postgresKey.asc /tmp/

RUN apt-get update && \
    apt-get install -y unzip python3 python3-setuptools python3-software-properties python3-pip \
                        apt-utils apt-transport-https tzdata ca-certificates \
                        dirmngr gnupg wget curl software-properties-common && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    python -m pip install py4j && \
	apt-key add /tmp/postgresKey.asc && \
	add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
	wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
	apt-get update && \
	apt-get install -y adoptopenjdk-8-hotspot postgresql-${pgversion} postgresql-client-${pgversion} postgresql-contrib-${pgversion} libpq-dev && \
    locale-gen en_US.UTF-8 && \
	update-java-alternatives -s /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*








    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add - && \
    add-apt-repository -s 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \