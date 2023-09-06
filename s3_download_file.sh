#!/bin/bash

# Set your AWS access key and secret access key
AWS_ACCESS_KEY_ID="your-access-key"
AWS_SECRET_ACCESS_KEY="your-secret-access-key"

# Set the name of your S3 bucket
BUCKET_NAME="your-bucket-name"

# Set the path where you want to download the file
DOWNLOAD_PATH="./downloads"

# Configure your AWS CLI
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY

# List the files in the S3 bucket
aws s3 ls s3://$BUCKET_NAME

# Prompt user to enter the name of the file to download
read -p "Enter the name of the file you want to download: " FILE_NAME

# Download the selected file from the S3 bucket
aws s3 cp s3://$BUCKET_NAME/$FILE_NAME $DOWNLOAD_PATH/$FILE_NAME
To get a list of files from an S3 bucket based on a specific pattern and filter them by the recent date using Boto3, you can follow this example:

```python
import boto3
from botocore.exceptions import NoCredentialsError
from datetime import datetime

# Replace 'bucket-name' with the actual name of your S3 bucket
bucket_name = 'bucket-name'
# Replace 'file-pattern' with the pattern you want to match for file names
file_pattern = 'file-pattern'

s3 = boto3.client('s3')

try:
    # List all objects in the bucket
    response = s3.list_objects_v2(Bucket=bucket_name)

    # Filter the objects based on the file pattern
    objects = [obj['Key'] for obj in response['Contents'] if file_pattern in obj['Key']]

    # Sort the objects based on the most recent modified date
    objects.sort(key=lambda x: s3.head_object(Bucket=bucket_name, Key=x)['LastModified'], reverse=True)

    # Get the most recent file
    most_recent_file = objects[0]
    print(f"The most recent file matching the pattern {file_pattern} is: {most_recent_file}")
except NoCredentialsError:
    print('No AWS credentials found. Make sure you have configured your AWS credentials.')
except Exception as e:
    print(f"An error occurred: {str(e)}")
```

Make sure to replace `'bucket-name'` with the actual name of your S3 bucket and `'file-pattern'` with the pattern you want to match for the file names.

This script first lists all objects in the S3 bucket using the `list_objects_v2` API. It then filters the objects based on the specified file pattern. The filtered objects are sorted based on the most recent modified date using the `LastModified` property obtained from the `head_object` API call. Finally, the script prints the most recent file that matches the file pattern.