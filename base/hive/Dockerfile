FROM hadoop_base:2.9.2
MAINTAINER Mark Lilback <mark@lilback.com>

ENV POSTGRES_VERSION 9.6
ENV HADOOP_VERSION 2.9.2
ENV HIVE_VERSION 2.1.1

RUN cd /usr/local && \
	wget --quiet http://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz && \
	tar zxf apache-hive-${HIVE_VERSION}-bin.tar.gz && \
	ln -s apache-hive-${HIVE_VERSION}-bin hive && \
	rm apache-hive-${HIVE_VERSION}-bin.tar.gz && \
	ln -s /usr/share/java/postgresql-jdbc4.jar /usr/local/hive/lib/postgresql-jdbc4.jar && \
	ln -s /usr/local/hive/jdbc/hive-jdbc-${HIVE_VERSION}-standalone.jar /usr/local/hive/lib/

COPY core-site.xml log4j.properties /usr/local/hadoop/etc/hadoop/
COPY startup.sh /
COPY hive-env.sh /etc/profile.d/
COPY hive-site.xml /usr/local/hive/conf/

#RUN useradd -u 1000 -s /bin/bash -m -d /home/rstudio rstudio

#RUN mkdir /scripts
COPY waitfor.sh /scripts/
RUN chmod 777 /scripts/waitfor.sh && \
    echo "export CLASSPATH=/usr/local/hive/jdbc/hive-jdbc-${HIVE_VERSION}-standalone.jar" >> /.bashrc && \
	echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /.bashrc && \
	echo "export PATH=/usr/local/hive/bin:/usr/local/hadoop/bin:$PATH" >> /.bashrc


CMD ["/startup.sh"]
