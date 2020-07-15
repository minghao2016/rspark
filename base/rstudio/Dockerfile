FROM rocker/verse:3.6.3-ubuntu18.04
MAINTAINER Jim Harner <ejharner@gmail.com>

ENV JAVA_VERSION 8
ENV JAVA_VERSION_NUMBER 1.${JAVA_VERSION}.0
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ENV POSTGRES_VERSION 9.6
ENV HADOOP_VERSION 2.9.2
ENV HIVE_VERSION 2.1.1
ENV SPARK_VERSION 2.4.4

RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common tzdata gpg \
                       curl openssh-client openssh-server openjdk-${JAVA_VERSION}-jdk && \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' && \
    apt-get update && \
    apt-get install -y postgresql-client-${POSTGRES_VERSION} libpq-dev libpostgresql-jdbc-java && \
    update-java-alternatives -s /usr/lib/jvm/java-${JAVA_VERSION_NUMBER}-openjdk-amd64 && \
    echo 'JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION_NUMBER}-openjdk-amd64' >> .bashrc && \
    R CMD javareconf && \
    cd /usr/local && \
    wget --quiet http://archive.apache.org/dist/hadoop/core/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
	tar zxf hadoop-${HADOOP_VERSION}.tar.gz && \
	ln -s hadoop-${HADOOP_VERSION} hadoop && \
	rm hadoop-${HADOOP_VERSION}.tar.gz && \
	(cd /usr/local/hadoop; ln -s share/hadoop/tools/lib/hadoop-streaming-${HADOOP_VERSION}.jar hadoop-streaming.jar) && \
# 	chown -R rstudio:rstudio /usr/local/hadoop && \
	wget --quiet http://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz && \
	tar zxf apache-hive-${HIVE_VERSION}-bin.tar.gz && \
	ln -s apache-hive-${HIVE_VERSION}-bin hive && \
	rm apache-hive-${HIVE_VERSION}-bin.tar.gz && \
	ln -s /usr/share/java/postgresql-jdbc4.jar /usr/local/hive/lib/postgresql-jdbc4.jar && \
	ln -s /usr/local/hive/jdbc/hive-jdbc-${HIVE_VERSION}-standalone.jar /usr/local/hive/lib/ && \
	wget --quiet http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz && \
	tar zxf spark-${SPARK_VERSION}-bin-hadoop2.7.tgz && \
	mv spark-${SPARK_VERSION}-bin-hadoop2.7 spark && \
	cp spark/conf/spark-env.sh.template spark/conf/spark-env.sh && \
	echo "export SPARK_DIST_CLASSPATH=/usr/share/java/postgresql-jdbc4.jar:$(/usr/local/hadoop/bin/hadoop classpath)" >> spark/conf/spark-env.sh && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV HADOOP_CMD=/usr/local/hadoop/bin/hadoop
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_BIN=/usr/local/hadoop/bin
ENV HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV LD_LIBRARY_PATH $JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/server
ENV PATH /usr/local/spark/bin:/usr/local/hive/bin:/usr/local/hadoop/bin/:/usr/lib/rstudio-server/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin




####################
# R PACKAGES
####################
# Switch to rstudio CRAN mirror (untested)
# RUN R CMD options(repos = c(CRAN = "https://cran.rstudio.com"))
# Set environment variable for rJava package installation
# Install R packages
RUN Rscript -e "install.packages(c(\"rjson\", \"RJSONIO\", \"jsonlite\", \"functional\", \"caTools\", \"R.methodsS3\", \"trelliscopejs\", \"RPostgreSQL\", \"RJDBC\", \"housingData\", \"Lahman\", \"nycflights13\", \"flexdashboard\", \"sparklyr\", \"glmnet\", \"reticulate\", \"tensorflow\", \"rhbase\", \"plyrmr\"), repos = 'http://cran.rstudio.com')"
# Copy repository packages to filesystem
COPY rhdfs.tar.gz rmr.tar.gz /tmp/pkgs/
# Install repository packages
RUN cd /tmp/pkgs && \
    R CMD INSTALL rmr rhdfs

COPY protobuf-2.5.0.tar.gz Rhipe_0.75.2_hadoop-2.tar.gz /tmp/
RUN cd /tmp/protobuf-2.5.0 && ./configure --prefix=/usr && make && make install && cd .. 	&& rm -rf protobuf-* && \
	cd /tmp/Rhipe && R CMD INSTALL . && cd .. && rm -rf Rhipe

# COPY postgresql-42.2.2.jar /opt

####################
# ENVIRONMENT CONFIG
####################
# Add necessary mods to Renviron file
# ADD Renviron /usr/local/lib/R/etc/
COPY hdfs-site.xml core-site.xml log4j.properties /usr/local/hadoop/etc/hadoop/
# Create symlink to actual Rscript
RUN ln -s /usr/local/bin/Rscript /usr/bin/Rscript

# Add path to profile so commands are found if attach to the container
RUN echo "PATH='/usr/local/hadoop/bin:/usr/local/spark/bin:/usr/local/hive/bin:$PATH'" >> /etc/profile

# Install TensorFlow Package
# RUN R -e "install.packages(\"tensorflow\")"

# USER rstudio
# Install rspark test files
# ADD rspark-tests.tar.gz /home/rstudio
RUN mkdir /home/rstudio/rspark-tests && \
git clone https://github.com/jharner/rspark-tests.git /tmp/foo && \
cd /tmp/foo && \
git archive master | tar -x -C /home/rstudio/rspark-tests  && \
cd && \
rm -rf /tmp/foo
RUN mkdir /home/rstudio/rspark-tutorial && \
git clone https://github.com/jharner/rspark-tutorial.git /tmp/foo && \
cd /tmp/foo && \
git archive master | tar -x -C /home/rstudio/rspark-tutorial  && \
cd && \
rm -rf /tmp/foo
RUN chown -R rstudio:rstudio /home/rstudio

# USER root
EXPOSE 8787
EXPOSE 4040
EXPOSE 4041

CMD ["/init"]
