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


python
import boto3
from datetime import datetime

def download_and_sort_s3_files(bucket_name, file_pattern):
    # Create an S3 client
    s3 = boto3.client('s3')

    # List objects in the bucket
    response = s3.list_objects_v2(Bucket=bucket_name)

    # Filter and sort the objects based on last modified date
    files = []
    for obj in response['Contents']:
        if obj['Key'].endswith(file_pattern):
            files.append(obj)

    files.sort(key=lambda x: x['LastModified'])

    # Download the selected files
    for file in files:
        file_name = file['Key']
        s3.download_file(bucket_name, file_name, file_name)
        last_modified = file['LastModified'].strftime("%Y-%m-%d %H:%M:%S")
        print(f"Downloaded file: {file_name}, Last Modified: {last_modified}")

    print("Files downloaded and sorted successfully.")

# Provide your S3 bucket name and file pattern
bucket_name = 'your_bucket_name'
file_pattern = '.txt'  # File pattern to filter files, e.g., '.txt' for text files

download_and_sort_s3_files(bucket_name, file_pattern)




python
import boto3
import fnmatch

bucket_name = 'your_bucket_name'
prefix_pattern = 'Abc*'

# Create an S3 client
s3 = boto3.client('s3')

# Set the initial parameters for pagination
paginator = s3.get_paginator('list_objects_v2')
page_iterator = paginator.paginate(Bucket=bucket_name)

# Retrieve the files matching the pattern prefix
for page in page_iterator:
    if 'Contents' in page:
        for obj in page['Contents']:
            # Get the object key
            object_key = obj['Key']
            # Check if the key matches the pattern prefix
            if fnmatch.fnmatch(object_key, prefix_pattern):
                # Download the file
                s3.download_file(bucket_name, object_key, object_key)
                print(f"Downloaded file: {object_key}")
    else:
        print("No files found with the specified pattern prefix.")


