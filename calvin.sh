#!/bin/bash

SAVE_DIR="config/www/community/calvin-card-ha/"
RSS_URL="https://www.comicsrss.com/rss/calvinandhobbes.rss"
IMAGE_FILE="${SAVE_DIR}calvin.png"
JSON_FILE="${SAVE_DIR}calvin_data.json"
SAVE_DIR=$(echo "$SAVE_DIR" | xargs)

# Fetch RSS feed
RSS_DATA=$(curl -s "$RSS_URL")

# Extract components using sed with multiline support
TITLE=$(echo "$RSS_DATA" | sed -n '/<item/,/<\/item>/p' | sed -n 's/.*<title><!\[CDATA\[\(.*\)\]\]><\/title>.*/\1/p' | head -n1)
LINK=$(echo "$RSS_DATA" | sed -n '/<item/,/<\/item>/p' | sed -n 's/.*<link>\(.*\)<\/link>.*/\1/p' | head -n1)
IMAGE_URL=$(echo "$RSS_DATA" | sed -n '/<item/,/<\/item>/p' | sed -n 's/.*<img src="\([^"]*\)".*/\1/p' | head -n1)

if [ ! -d "$SAVE_DIR" ]; then
    echo "Error: Directory $SAVE_DIR does not exist."
    exit 1
fi




if [ -z "$IMAGE_URL" ]; then
    echo "Error: No image URL found in RSS feed"
    exit 1
fi

# Download image

if ! curl -s "$IMAGE_URL" -o "$SAVE_DIR/calvin.png"; then
    echo "Error: Failed to download image"
    echo "$IMAGE_URL"
    echo "$IMAGE_FILE"
    exit 1
fi

# Create JSON file. We will force the url to ./calvin.png now to fetch the local image, not the url.
cat > "$JSON_FILE" << EOF
{
  "image_url": "$SAVE_DIR/calvin.png",
  "title": "$TITLE",
  "alt_text": "$TITLE"
}
EOF

echo "Image saved to: $IMAGE_FILE"
echo "JSON saved to: $JSON_FILE"