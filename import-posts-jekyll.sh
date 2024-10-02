  #!/bin/bash

# Check if a directory is passed as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Assign the input directory to a variable
DIR=$1

# Step 1: Recursively find and delete files that are not .md
find "$DIR" -type f ! -name "*.md" -exec rm -f {} \;
echo "Non-.md files have been deleted from $DIR."

# Step 2: Rename remaining .md files by appending "2024-10-02-" to their filenames
find "$DIR" -type f -name "*.md" | while read -r FILE; do
  # Extract directory and filename
  DIRNAME=$(dirname "$FILE")
  BASENAME=$(basename "$FILE")

  # Create the new filename by appending the date prefix
  NEWNAME="$DIRNAME/2024-10-02-$BASENAME"

  # Rename the file
  mv "$FILE" "$NEWNAME"
done
echo "All .md files have been renamed with the prefix '2024-10-02-'."

# Step 3: Create a _posts folder and move .md files into it
find "$DIR" -type f -name "*.md" | while read -r MD_FILE; do
  # Get the directory containing the .md file
  MD_DIR=$(dirname "$MD_FILE")

  # Create _posts folder if it doesn't exist
  POSTS_DIR="$MD_DIR/_posts"
  mkdir -p "$POSTS_DIR"

  # Move the .md file to the _posts folder
  mv "$MD_FILE" "$POSTS_DIR/"
done
echo ".md files have been moved to '_posts' folders within their respective directories."
