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
