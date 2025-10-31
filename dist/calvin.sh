SAVE_DIR="/config/www/community/calvin-card-ha/"
RSS_URL="https://comiccaster.xyz/rss/calvinandhobbes"
IMAGE_FILE="${SAVE_DIR}calvin.png"
JSON_FILE="${SAVE_DIR}calvin_data.json"
SAVE_DIR=$(echo "$SAVE_DIR" | xargs)

# Fetch RSS feed
RSS_DATA=$(curl -s "$RSS_URL")

# Extract first <item> block
ITEM=$(echo "$RSS_DATA" | sed -n '/<item>/,/<\/item>/p' | head -n 20)

# Extract description
DESCRIPTION=$(echo "$ITEM" | sed -n 's:.*<description>\(.*\)</description>.*:\1:p' | head -n1)

# Extract image URL from <enclosure> tag
# IMAGE_URL=$(echo "$ITEM" | sed -n 's/.*<enclosure[^>]*url="\([^"]*\)".*/\1/p' | head -n1)
IMAGE_URL=$(echo "$ITEM" | grep -oP '(?<=<img[^>]*src=")[^"]*' | head -n1)

if [ ! -d "$SAVE_DIR" ]; then
    echo "Error: Directory $SAVE_DIR does not exist."
    exit 1
fi

if [ -z "$IMAGE_URL" ]; then
    echo "Error: No image URL found in RSS feed"
    exit 1
fi

# Download image
if ! curl -s "$IMAGE_URL" -o "$IMAGE_FILE"; then
    echo "Error: Failed to download image"
    echo "$IMAGE_URL"
    echo "$IMAGE_FILE"
    exit 1
fi

# Create JSON file
cat > "$JSON_FILE" << EOF
{
  "image_url": "$IMAGE_FILE",
  "title": "$DESCRIPTION",
  "alt_text": "$DESCRIPTION"
}
EOF

echo "Image saved to: $IMAGE_FILE"
echo "JSON saved to: $JSON_FILE"
