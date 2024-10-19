#!/bin/bash

# CloudUploader: A CLI tool to upload files to AWS S3

# Function to display usage instructions
usage() {
  echo "Usage: $0 /path/to/file [bucket-name] [target-directory]"
  exit 1
}

# Check if correct number of arguments is provided
if [ "$#" -lt 1 ]; then
  echo "Error: Missing file path"
  usage
fi

# Assign arguments to variables
FILE_PATH=$1
BUCKET_NAME=${2:-my-default-bucket}
TARGET_DIR=${3:-uploads}

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
  echo "Error: File does not exist at $FILE_PATH"
  exit 1
fi

# Upload file to S3 with progress bar
FILE_SIZE=$(stat --printf="%s" "$FILE_PATH")
echo "Uploading $FILE_NAME to s3://$BUCKET_NAME/$TARGET_DIR/ ..."
pv -s "$FILE_SIZE" "$FILE_PATH" | aws s3 cp - "s3://$BUCKET_NAME/$TARGET_DIR/$FILE_NAME" --expected-size "$FILE_SIZE"

if [ $? -eq 0 ]; then
  echo "Upload successful!"
else
  echo "Upload failed."
  exit 1
fi

