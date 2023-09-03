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
