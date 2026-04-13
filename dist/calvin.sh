SAVE_DIR="/config/www/community/calvin-card-ha/"
RSS_URL="https://comiccaster.xyz/rss/calvinandhobbes"
IMAGE_FILE="${SAVE_DIR}calvin.png"
JSON_FILE="${SAVE_DIR}calvin_data.json"
SAVE_DIR=$(echo "$SAVE_DIR" | xargs)

RSS_DATA=$(curl -s "$RSS_URL")

# Strip CDATA wrappers first
CLEAN=$(echo "$RSS_DATA" | sed 's/<!\[CDATA\[//g; s/\]\]>//g')

# Get the first item's description (collapse to single line first)
DESCRIPTION=$(echo "$CLEAN" | tr -d '\n' | grep -o '<item>.*</item>' | head -c 5000 | sed 's/.*<description>\(.*\)<\/description>.*/\1/')

# Decode HTML entities
DESCRIPTION=$(echo "$DESCRIPTION" | sed 's/&lt;/</g; s/&gt;/>/g; s/&amp;/\&/g; s/&quot;/"/g')

# Extract image URL
IMAGE_URL=$(echo "$DESCRIPTION" | sed -n 's/.*<img[^>]*src="\([^"]*\)".*/\1/p')

echo "$IMAGE_URL"

if [ ! -d "$SAVE_DIR" ]; then
    echo "Error: Directory $SAVE_DIR does not exist."
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
