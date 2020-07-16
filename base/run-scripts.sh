#!/bin/bash

docker build -t rcompute_base:18.04 base
docker build -t postgres_base:9.6 postgres
docker build -t hadoop_base:2.9.2 hadoop
docker build -t hive_base:2.1.1 hive
docker build -t spark_base:2.4.4 spark/spark_base
docker build -t spark_master:2.4.4 spark/spark_master
docker build -t spark_worker:2.4.4 spark/spark_worker
docker build -t spark_submit:2.4.4 spark/spark_submit
docker build -t rerocker_base:3.6.3 rstudio
