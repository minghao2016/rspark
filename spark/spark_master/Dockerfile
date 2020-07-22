FROM ubuntu:bionic
MAINTAINER Jim Harner <ejharner@gmail.com>

ARG hadoopversion=2.9.2
ARG hiveversion=2.1.1
ARG sparkversion=2.4.6
ARG javaversion=8
ARG javaversion_number=1.${javaversion}.0
ARG DEBIAN_FRONTEND=noninteractive

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

ENV HADOOP_VERSION 2.9.2
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV PATH ${HADOOP_HOME}/bin:${PATH}
ENV HADOOP_CMD ${HADOOP_HOME}/bin/hadoop
ENV HADOOP_BIN ${HADOOP_HOME}/bin

ENV SPARK_VERSION 2.4.6
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /opt/spark
ENV SPARK_DIST_CLASSPATH "${HADOOP_HOME}/etc/hadoop/*:${HADOOP_HOME}/share/hadoop/common/lib/*:${HADOOP_HOME}/share/hadoop/common/*:${HADOOP_HOME}/share/hadoop/hdfs/*:${HADOOP_HOME}/share/hadoop/hdfs/lib/*:${HADOOP_HOME}/share/hadoop/hdfs/*:${HADOOP_HOME}/share/hadoop/yarn/lib/*:${HADOOP_HOME}/share/hadoop/yarn/*:${HADOOP_HOME}/share/hadoop/mapreduce/lib/*:${HADOOP_HOME}/share/hadoop/mapreduce/*:${HADOOP_HOME}/share/hadoop/tools/lib/*"
ENV PATH ${SPARK_HOME}/bin:${PATH}
ENV R_BASE_VERSION 3.6.3
ARG DEBIAN_FRONTEND=noninteractive

COPY postgresKey.asc openjdkKey.asc /tmp/
ADD postgresql-42.2.2.jar /opt

# Install Python 3
RUN apt-get update && \
    apt-get install -y unzip python3 python3-setuptools python3-software-properties python3-pip \
                        apt-utils apt-transport-https tzdata ca-certificates \
                        dirmngr gnupg wget curl software-properties-common && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    python -m pip install py4j && \
# JAVA
	apt-key add /tmp/postgresKey.asc && \
	add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
	wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
	add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add - && \
    add-apt-repository -s 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
	apt-get update && \
	apt-get install -y adoptopenjdk-8-hotspot python3-software-properties postgresql-${pgversion} postgresql-client-${pgversion} postgresql-contrib-${pgversion} libpq-dev && \
	update-java-alternatives -s /usr/lib/jvm/adoptopenjdk-8-hotspot-amd64 && \
####################
# HADOOP
####################
    cd /opt && \
    wget --quiet http://archive.apache.org/dist/hadoop/common/hadoop-${hadoopversion}/hadoop-${hadoopversion}.tar.gz && \
    tar zxf hadoop-${hadoopversion}.tar.gz && \
    ln -s hadoop-${hadoopversion} hadoop && \
    rm hadoop-${hadoopversion}.tar.gz && \
    rm -rf $HADOOP_HOME/share/doc && \
    chown -R root:root $HADOOP_HOME && \
# SPARK
    wget --quiet http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz && \
    tar zxf ${SPARK_PACKAGE}.tgz && \
    ln -s ${SPARK_PACKAGE} spark && \
	cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh && \
	echo "export SPARK_DIST_CLASSPATH=/opt/postgresql-42.2.2.jar:$(/opt/hadoop/bin/hadoop classpath)" >> spark/conf/spark-env.sh && \
    rm ${SPARK_PACKAGE}.tgz && \
    mkdir /opt/spark-data && \
    chown -R root:root /opt/spark-data && \
    chmod 700 /opt/spark-data && \
    chown -R root:root $SPARK_HOME && \
    chmod 700 ${SPARK_HOME} && \
# R
    cd / && \
###     apt-get install -y --no-install-recommends littler r-cran-littler r-base-${R_BASE_VERSION} r-base-dev-${R_BASE_VERSION} r-recommended=${R_BASE_VERSION} && \
    apt-get install -y --no-install-recommends littler r-cran-littler r-base r-base-dev r-recommended && \
    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
    echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r && \
    ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r && \
    ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r && \
    ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r && \
    ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r && \
    install.r docopt && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR $SPARK_HOME

CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]

EXPOSE 7077
EXPOSE 8080
EXPOSE 8081
EXPOSE 4040
EXPOSE 4041

#
#RUN apt-get update && \
#    apt-get install -y locales && \
#    dpkg-reconfigure -f noninteractive locales && \
#    locale-gen en_US.UTF-8 && \
#    /usr/sbin/update-locale LANG=en_US.UTF-8 && \
#    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
#    locale-gen && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*
# Users with other locales should set this in their derivative image
## HIVE ##
#    cd /opt && \
#	wget --quiet http://archive.apache.org/dist/hive/hive-${hiveversion}/apache-hive-${hiveversion}-bin.tar.gz && \
#	tar zxf apache-hive-${hiveversion}-bin.tar.gz && \
#	ln -s apache-hive-${hiveversion}-bin hive && \
#	ln -s /usr/share/java/postgresql-jdbc4.jar /opt/hive/lib/postgresql-jdbc4.jar && \
#	ln -s /opt/hive/jdbc/hive-jdbc-${hiveversion}-standalone.jar /opt/hive/lib/ && \
#	rm apache-hive-${hiveversion}-bin.tar.gz && \



## Use Debian unstable via pinning -- new style via APT::Default-Release
#RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
#    && echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default


## Now install R and littler, and create a link for littler in /usr/local/bin
## Also set a default CRAN repo, and make sure littler knows about it too