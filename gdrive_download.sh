#!/bin/bash

# Check if Google Drive URL and file name are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <google_drive_link> <output_filename>"
  exit 1
fi

# Assign arguments to variables
GDRIVE_URL="$1"
OUTPUT_FILE="$2"

# Extract the file ID from the provided Google Drive link
FILE_ID=$(echo "$GDRIVE_URL" | sed -n 's#.*file/d/\([^/]*\)/.*#\1#p')

# If file ID is not found, show an error message
if [ -z "$FILE_ID" ]; then
  echo "Error: Invalid Google Drive link. Please provide a valid URL."
  exit 1
fi

# Create a temporary file to store cookies
COOKIES_FILE=$(mktemp)

# Step 1: Fetch the confirmation page to get the download confirmation token
CONFIRM=$(wget --quiet --save-cookies "$COOKIES_FILE" --keep-session-cookies \
  "https://docs.google.com/uc?export=download&id=${FILE_ID}" -O- | grep -o 'confirm=[^&]*' | sed 's/confirm=//')

# Step 2: Use the confirmation token to download the file with the desired name
DOWNLOAD_URL="https://docs.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}"

# Download the file using the confirmation token and cookies
wget --load-cookies "$COOKIES_FILE" "$DOWNLOAD_URL" -O "$OUTPUT_FILE"

# Clean up: Remove the cookies file
rm -f "$COOKIES_FILE"

echo "Download completed. File saved as '${OUTPUT_FILE}'."
