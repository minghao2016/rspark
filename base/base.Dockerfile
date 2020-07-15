FROM ubuntu:bionic

ENV JAVA_VERSION 8
ENV JAVA_VERSION_NUMBER 1.${JAVA_VERSION}.0
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ENV POSTGRES_VERSION 9.6
ENV HADOOP_VERSION 2.9.2
ENV HIVE_VERSION 2.1.1
ENV SPARK_VERSION 2.4.4

ENV HADOOP_HOME /opt/hadoop
ENV HIVE_HOME /opt/hive
ENV SPARK_HOME /opt/spark

RUN apt-get update && \
    apt-get install -y apt-utils apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common tzdata gpg \
                       curl openssh-client openssh-server openjdk-${JAVA_VERSION}-jdk && \
    update-java-alternatives -s /usr/lib/jvm/java-${JAVA_VERSION_NUMBER}-openjdk-amd64 && \
    JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION_NUMBER}-openjdk-amd64 && \
    echo 'JAVA_HOME=${JAVA_HOME}' >> .bashrc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


