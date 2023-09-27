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


dockerfile
FROM ubuntu:latest

# Install SSH server
RUN apt-get update && apt-get install -y openssh-server

# Enable copy-paste functionality
RUN echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config
RUN echo "X11UseLocalhost no" >> /etc/ssh/sshd_config
RUN echo "X11Forwarding yes" >> /etc/ssh/sshd_config

# Set up user for SSH access
RUN useradd -m testuser && echo "testuser:testpassword" | chpasswd
RUN usermod --shell /bin/bash testuser

# Expose SSH port
EXPOSE 22

# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]



Sure, here's a brief introduction to CI/CD (Continuous Integration/Continuous Deployment) that you can include in a slide presentation:

Slide Title: Introduction to CI/CD

Slide Content:
- CI/CD stands for Continuous Integration/Continuous Deployment.
- It is a software development practice that aims to automate the build, test, and deployment of applications.
- The primary goal of CI/CD is to deliver software changes to production quickly and reliably.
- Continuous Integration focuses on merging code changes from multiple developers into a shared repository frequently.
- It involves automating the process of building and testing the application to catch integration issues early.
- Continuous Deployment takes CI a step further by automatically deploying the application to production after successful testing.
- With CI/CD, teams can release new features, bug fixes, and improvements more frequently, reducing time-to-market.
- It enhances collaboration, as developers can work on different features simultaneously, knowing that their changes will integrate smoothly.
- CI/CD also promotes a culture of automation, quality assurance, and rapid feedback loops.
- It relies on the use of various tools and technologies such as version control systems, build servers, and deployment pipelines.
- By adopting CI/CD, organizations can achieve faster development cycles, improved software quality, and increased customer satisfaction.

Feel free to customize the content and design of the slide according to your needs.


python
import gzip
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import boto3

def unzip_and_convert_to_parquet(gz_file_path, s3_bucket, s3_key):
    # Unzip .gz file and read contents as text
    with gzip.open(gz_file_path, 'rb') as gz_file:
        text_data = gz_file.read().decode('utf-8')

    # Create a DataFrame from the text data
    df = pd.DataFrame({'data': [text_data]})

    # Convert DataFrame to Parquet file
    table = pa.Table.from_pandas(df)
    pq.write_table(table, 'temp.parquet')

    # Upload Parquet file to S3
    s3_client = boto3.client('s3')
    s3_client.upload_file('temp.parquet', s3_bucket, s3_key)

    # Remove the temporary Parquet file
    os.remove('temp.parquet')

# Example usage
gz_file_path = 'your-file.gz'
s3_bucket = 'your-s3-bucket'
s3_key = 'your-s3-key.parquet'

unzip_and_convert_to_parquet(gz_file_path, s3_bucket, s3_key)


python
import boto3

def create_subfolders(bucket_name, subfolder_path):
    s3_client = boto3.client('s3')
    
    # Append a trailing slash to the subfolder path if it doesn't exist
    if not subfolder_path.endswith('/'):
        subfolder_path += '/'
    
    # Create a placeholder object to represent the subfolder
    s3_client.put_object(Bucket=bucket_name, Key=subfolder_path)
    
# Example usage
bucket_name = 'your-bucket-name'
subfolder_path = 'your/subfolder/path/'

create_subfolders(bucket_name, subfolder_path)



python
import boto3

def create_subfolders(bucket_name, subfolder_paths):
    s3_client = boto3.client('s3')
    
    for subfolder_path in subfolder_paths:
        # Append a trailing slash to the subfolder path if it doesn't exist
        if not subfolder_path.endswith('/'):
            subfolder_path += '/'
        
        # Create a placeholder object to represent the subfolder
        s3_client.put_object(Bucket=bucket_name, Key=subfolder_path)
    
# Example usage
bucket_name = 'your-bucket-name'
subfolder_paths = ['subfolder1/', 'subfolder2/', 'subfolder3/']

create_subfolders(bucket_name, subfolder_paths)


