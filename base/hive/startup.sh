#!/bin/bash

#while true; do sleep 1000; done

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HIVE_HOME=/usr/local/hive
export HADOOP_HOME=/usr/local/hadoop
export HADOOP=/usr/local/hadoop/bin/hadoop

sleep 25

echo "** Checking Postgres Connection **"
/scripts/waitfor.sh -h postgres -p 5432 -t 120

# Add code to more effectively wait on hadoop
sleep 50

psql -h postgres -U hive -c 'select count(*) from BUCKETING_COLS' >/dev/null 2>&1
if [ $? -gt 0 ]; then
	echo "initing hive schema"
	su -lc "/usr/local/hive/bin/schematool -initSchema -dbType postgres" rstudio
	/usr/local/hive/bin/hive -S -e "create database if not exists rstudio;"
fi

/usr/local/hadoop/bin/hdfs dfs -chown -R rstudio:rstudio /user/hive

echo "starting hiveserver2"

su -lc /usr/local/hive/bin/hiveserver2 rstudio
