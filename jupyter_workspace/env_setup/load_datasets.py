from pyspark.sql import SparkSession
import os

spark = SparkSession.builder.master("local").appName("SAMPLE TABLES CREATION").enableHiveSupport().getOrCreate()

dataset_dir_csv = "datasets/csv"

for filename in os.listdir(dataset_dir_csv):
    file_path = "/".join([dataset_dir_csv, filename])
    table_name = filename[0:filename.rfind(".")]
    print(f"Loading {file_path} into table {table_name}")
    spark.read.option("header",True).csv(file_path).write.mode("overwrite").saveAsTable(table_name)
    
dataset_dir_json = "datasets/json"

for filename in os.listdir(dataset_dir_json):
    file_path = "/".join([dataset_dir_json, filename])
    table_name = filename[0:filename.rfind(".")]
    print(f"Loading {file_path} into table {table_name}")
    spark.read.json(file_path).write.mode("overwrite").saveAsTable(table_name)