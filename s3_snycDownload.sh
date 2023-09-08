#!/bin/bash

# Set your AWS access key and secret access key
AWS_ACCESS_KEY_ID="your-access-key"
AWS_SECRET_ACCESS_KEY="your-secret-access-key"

# Set the name of your S3 bucket
BUCKET_NAME="your-bucket-name"

# Set the path where you want to download the files
DOWNLOAD_PATH="./downloads"

# Configure your AWS CLI
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY

# List the files in the S3 bucket
aws s3 ls s3://$BUCKET_NAME

# Download all files from the S3 bucket
aws s3 sync s3://$BUCKET_NAME $DOWNLOAD_PATH

python
import boto3
from datetime import datetime

def get_file_by_date(bucket_name, desired_date):
    s3 = boto3.client('s3')
    response = s3.list_objects_v2(Bucket=bucket_name)

    desired_date = datetime.strptime(desired_date, '%Y-%m-%d').date()

    for object in response['Contents']:
        last_modified = object['LastModified'].date()
        if last_modified == desired_date:
            file_key = object['Key']
            s3.download_file(bucket_name, file_key, 'downloaded_file.txt')
            print(f"File '{file_key}' downloaded successfully.")
            break
    else:
        print("No file found for the specified date.")

# Usage example
bucket_name = 'your_bucket_name'
desired_date = '2023-09-01'
get_file_by_date(bucket_name, desired_date)



