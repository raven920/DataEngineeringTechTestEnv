#!/bin/bash

cd ~/
dnf install -y git iptables
git clone https://github.com/raven920/DataEngineeringTechTestEnv.git install_files
adduser jupyter

cp install_files/scripts/run-jupyter.sh /home/jupyter/run-jupyter.sh

chmod a+x /home/jupyter/run-jupyter.sh
sudo bash TechnicalTestEnvironment/scripts/install-spark.sh
sudo su -c "bash /home/jupyter/run-jupyter.sh ${JUPYTER_PWORD}" jupyter