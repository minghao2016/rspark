FROM hive_base:2.1.1
MAINTAINER Jim Harner <ejharner@gmail.com>

ENV HADOOP_VERSION 2.9.2
ENV HADOOP_SPARK_VERSION 2.7
ENV HIVE_VERSION 2.1.1
ENV SPARK_VERSION 2.4.4
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV HADOOP_HOME /usr/local/hadoop
ENV HIVE_HOME /usr/local/hive
ENV SPARK_HOME /usr/local/spark
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV SCALA_VERSION 2.13.3
ENV SCALA_HOME /usr/share/scala
ENV R_BASE_VERSION 3.6.3
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PATH /usr/local/hadoop/bin:/usr/local/hive/bin:/usr/local/spark/bin:/usr/share/scala/bin:/usr/local/bin:/usr/share/bin:${PATH}
RUN cd "/tmp" && \
    wget --no-verbose "https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    apt-get update && \
    mkdir -p "/usr/local/sbt" && \
    wget -qO - --no-check-certificate "https://piccolo.link/sbt-1.3.13.tgz" | tar xz -C /usr/local/sbt --strip-components=1 && \
    export PATH="/usr/local/sbt/bin:$PATH" && \
    sbt sbtVersion && \
    apt-get install -y python3 python3 python3-setuptools python3-all-dev python3-pip && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    python -m pip install py4j && \
    wget --quiet http://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz && \
    tar -xvzf ${SPARK_PACKAGE}.tgz && \
    mv ${SPARK_PACKAGE} /usr/local/spark && \
    rm ${SPARK_PACKAGE}.tgz && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add - && \
    add-apt-repository -s 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
    apt-get update && \
    apt-get install -y r-cran-littler r-base r-base-dev r-recommended && \
    echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site && \
    echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r && \
    ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r && \
    ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r && \
    ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r && \
    ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r && \
    install.r docopt && \
    apt-get clean && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/*
ENV PATH $PATH:${SPARK_HOME}/bin

WORKDIR $SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]

EXPOSE 7077
EXPOSE 8080



