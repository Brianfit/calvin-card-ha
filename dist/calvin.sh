SAVE_DIR="/config/www/community/calvin-card-ha/"
RSS_URL="https://comiccaster.xyz/rss/calvinandhobbes"
IMAGE_FILE="${SAVE_DIR}calvin.png"
JSON_FILE="${SAVE_DIR}calvin_data.json"
SAVE_DIR=$(echo "$SAVE_DIR" | xargs)

# Fetch RSS feed
RSS_DATA=$(curl -s "$RSS_URL")

# Extract first <item> block
ITEM=$(echo "$RSS_DATA" | sed -n '/<item>/,/<\/item>/p' | head -n 20)

# Extract description and decode HTML entities
DESCRIPTION=$(echo "$ITEM" | sed -n 's:.*<description>\(.*\)</description>.*:\1:p' | head -n1)
# Decode &lt; and &gt; to < and > (works on both BSD and GNU sed)
DESCRIPTION=$(echo "$DESCRIPTION" | sed 's/&lt;/</g; s/&gt;/>/g')
# Extract image URL from decoded HTML
IMAGE_URL=$(echo "$DESCRIPTION" | sed -n 's/.*<img[^>]*src="\([^"]*\)".*/\1/p')

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
