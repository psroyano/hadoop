#!/usr/bin/env bash

if [ "$HOSTNAME" = "namenode" ]; then  
	echo "INICIANDO NAMENODE"
	hdfs --daemon start namenode
	/etc/init.d/mysql start


	echo "Creando carpeta de trabajo hdfs"
	hdfs dfs -mkdir -p /user/root
	hdfs dfs -chmod 777 /user/root

	echo "Creando carpetas para hive"
	hdfs dfs -mkdir  /tmp
	hdfs dfs -chmod -R 777 /tmp
	hdfs dfs -mkdir -p /user/hive/warehouse
	hdfs dfs -chmod -R 777 /user/hive/warehouse


	echo "Iniciando hiveserver2"
	hiveserver2 &

	echo "###################### Jupyter Notebook ######################"
	jupyter notebook --port 8889 --notebook-dir='/media/notebooks' --no-browser --ip='*' --allow-root 

elif [ "$HOSTNAME" = "yarnmaster" ]; then
	echo "INICIANDO RESOURCE MANAGER"
	yarn --daemon start resourcemanager
	yarn --daemon start proxyserver
	mapred --daemon start historyserver
	
else
	echo "INICIANDO " $HOSTNAME
	hdfs --daemon start datanode
	yarn --daemon start nodemanager
fi
echo "OK"
exec bash

