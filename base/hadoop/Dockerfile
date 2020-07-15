FROM rcompute_base:18.04

ENV POSTGRES_VERSION 9.6
ENV HADOOP_VERSION 2.9.2

RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
    apt-get update && \
    apt-get install -y postgresql-client-${POSTGRES_VERSION} libpq-dev libpostgresql-jdbc-java && \
    cd /usr/local && \
    wget --quiet http://archive.apache.org/dist/hadoop/core/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
	tar zxf hadoop-${HADOOP_VERSION}.tar.gz && \
	ln -s hadoop-${HADOOP_VERSION} hadoop && \
	rm hadoop-${HADOOP_VERSION}.tar.gz && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# RUN cd /usr/local && ln -s ./hadoop-${HADOOP_VERSION} hadoop
#RUN curl -s http://apache.mirrors.hoobly.com/hadoop/common/hadoop-${hadoopversion}/hadoop-${HADOOP_VERSION}.tar.gz | tar -xz -C /usr/local

ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

COPY bootstrap.sh /etc/
COPY core-site.xml hdfs-site.xml /usr/local/hadoop/etc/hadoop/
COPY log4j.properties /usr/local/hadoop/etc/hadoop/

RUN mkdir -p /scripts /opt/hadoop
COPY waitfor.sh /scripts/
RUN chmod 777 /scripts/waitfor.sh && \
    echo "StrictHostKeyChecking no\nPasswordAuthentication yes\n" >> /etc/ssh/ssh_config && \
    ssh-keygen -t rsa -P ""  -f $HOME/.ssh/id_rsa && \
    cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys && \
    echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/profile && \
    echo "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

VOLUME ["/data"]

RUN useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio

CMD ["/etc/bootstrap.sh", "-d"]
