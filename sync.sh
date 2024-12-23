#!/bin/bash

DIRECTION="${1:-forward}"

if [[ -e .config.env ]]; then
    source .config.env
fi

# BLOG_SOURCE is the upstream (obsidian)
# BLOG_DEST is the folder in this repository where the blogs should be moved/copied from
if [[ -z "$BLOG_SOURCE" || -z "$BLOG_DEST" ]]; then
    echo "BLOG_SOURCE or BLOG_DEST not set"
    exit 1
fi

if [[ "$DIRECTION" == "forward" ]]; then
    SOURCE_FOLDER="$BLOG_SOURCE"
    DEST_FOLDER="$BLOG_DEST"
else
    SOURCE_FOLDER="$BLOG_DEST"
    DEST_FOLDER="$BLOG_SOURCE"
fi
rsync -av "$SOURCE_FOLDER" "$DEST_FOLDER"

if [[ -z "$ATTACHMENT_SOURCE" || -z "$ATTACHMENT_DEST" ]]; then
    echo "ATTACHMENT_SOURCE or ATTACHMENT_DEST not set, skipping copying"
    exit 0
fi

if [[ "$DIRECTION" == "forward" ]]; then
    SOURCE_ATT="$ATTACHMENT_SOURCE"
    DEST_ATT="$ATTACHMENT_DEST"
else
    SOURCE_ATT="$ATTACHMENT_DEST"
    DEST_ATT="$ATTACHMENT_SOURCE"
fi

# Iterate through each Markdown file in the source folder
for markdown_file in "$SOURCE_FOLDER"/*.md; do
  # Skip if no markdown files are found // does this work????
  if [[ ! -e "$markdown_file" ]]; then
    echo "No Markdown files found in $SOURCE_FOLDER."
    exit 0
  fi

  # Extract filenames from image links ![imagename](link)
  grep -oP '!\[.*?\]\(.*?\)' "$markdown_file" | while read -r match; do
    # Remove ![]() to get the filename
    extracted_file=$(echo "$match" | grep -oP '\!\[.*?\]\(\K[^\)]*' | xargs basename)

    # Full path of the file to copy
    file_to_copy="$SOURCE_ATT/$extracted_file"
    file_dest="$DEST_ATT/$extracted_file"

    # Check if the file exists
    if [[ -f "$file_to_copy" ]]; then
      # Copy the file to the destination folder
      cp -p "$file_to_copy" "$DEST_ATT"
      echo "Copied $file_to_copy to $DEST_ATT"
    else
      echo "Warning: File $file_to_copy not found."
    fi
  done
done