FROM ubuntu:20.04

LABEL maintainer="Pedro Santos" \
      version="2.0"

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Instalacion de Python y java
RUN apt-get -q update && \
    apt-get -q install -y python3 python3-pip openjdk-8-jdk libbcprov-java wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin


#Instalacion Hadoop 3.3.1
RUN mkdir /app && \
    wget https://ftp.cixug.es/apache/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz && \
    tar -xvzf /hadoop-3.3.1.tar.gz -C /app && \
    rm /hadoop-3.3.1.tar.gz && \
    mkdir /app/hadoop-3.3.1/logs
ENV HADOOP_HOME /app/hadoop-3.3.1
ENV HADOOP_MAPRED_HOME $HADOOP_HOME
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

#Copiamos archivos de configuración
COPY ./hadoopconf/* /app/hadoop-3.3.1/etc/hadoop/

#Copiamos archivo de inicio de servicios
COPY ./start.sh /app/start.sh

RUN mkdir -p /hdfs/datanode

ENTRYPOINT ["/bin/bash"]
CMD ["/app/start.sh"]
