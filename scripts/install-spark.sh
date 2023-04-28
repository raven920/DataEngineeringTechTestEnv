#!/bin/bash

wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm
rpm -i jdk-17_linux-x64_bin.rpm

wget https://dlcdn.apache.org/spark/spark-3.4.0/spark-3.4.0-bin-hadoop3.tgz
tar zxvf spark-3.4.0-bin-hadoop3.tgz

mv spark-3.4.0-bin-hadoop3 /opt/spark

python3 -m ensurepip --upgrade
pip3 install jupyter
pip3 install spylon-kernel 
python3 -m spylon_kernel install
pip3 install --no-deps sparksql-magic

iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080