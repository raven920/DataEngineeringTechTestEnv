#!/bin/bash

export JUPYTER_FINAL_PASS=$(python3 -c "from notebook.auth import passwd; print(passwd(\"$1\"))")
export SPARK_HOME="/opt/spark"
export PATH="$SPARK_HOME/bin:$PATH";

#echo $JUPYTER_FINAL_PASS > /home/jupyter/pass
#echo 'export SPARK_HOME="/opt/spark"; export PATH="$SPARK_HOME/bin:$PATH"; export PYSPARK_DRIVER_PYTHON="jupyter"; export PYSPARK_DRIVER_PYTHON_OPTS="notebook --NotebookApp.password=\"$JUPYTER_FINAL_PASS\" --notebook-dir=/home/jupyter/notebooks --no-browser --ip 0.0.0.0 --port=8080 --allow-root"; pyspark' > /home/jupyter/sparkexecution
cd ~/jupyter_workspace
spark-submit --master local env_setup/load_datasets.py

screen -dmS jupyter bash -c 'export SPARK_HOME="/opt/spark"; export PATH="$SPARK_HOME/bin:$PATH"; export PYSPARK_DRIVER_PYTHON="jupyter"; export PYSPARK_DRIVER_PYTHON_OPTS="notebook --NotebookApp.password=\"$JUPYTER_FINAL_PASS\" --notebook-dir=/home/jupyter/jupyter_workspace --no-browser --ip 0.0.0.0 --port=8080 --allow-root"; pyspark --master local'