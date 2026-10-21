SAVE_DIR="/config/www/community/calvin-card-ha/"
RSS_URL="https://comiccaster.xyz/rss/calvinandhobbes"
IMAGE_FILE="${SAVE_DIR}calvin.png"
JSON_FILE="${SAVE_DIR}calvin_data.json"
SAVE_DIR=$(echo "$SAVE_DIR" | xargs)

# Set to "true" to show the caption (e.g. "Comic strip for 2026-10-21") under the comic,
# or "false" to hide it (e.g. to save vertical space on small displays).
# Note: HACS updates replace this file, so re-apply your choice after updating.
SHOW_TITLE="true"

RSS_DATA=$(curl -s "$RSS_URL")

# Strip CDATA wrappers first
CLEAN=$(echo "$RSS_DATA" | sed 's/<!\[CDATA\[//g; s/\]\]>//g')

# Isolate the FIRST (newest) item only, then take its description.
# (Collapse to a single line, drop everything after the first </item>,
# then everything up to and including the first <item>.)
FIRST_ITEM=$(echo "$CLEAN" | tr -d '\n' | sed 's/<\/item>.*//; s/.*<item>//')
DESCRIPTION=$(echo "$FIRST_ITEM" | sed -n 's/.*<description>\(.*\)<\/description>.*/\1/p')

# Decode HTML entities
DESCRIPTION=$(echo "$DESCRIPTION" | sed 's/&lt;/</g; s/&gt;/>/g; s/&quot;/"/g; s/&amp;/\&/g')

# Extract image URL
IMAGE_URL=$(echo "$DESCRIPTION" | sed -n 's/.*<img[^>]*src="\([^"]*\)".*/\1/p')

echo "$IMAGE_URL"

if [ -z "$IMAGE_URL" ]; then
    echo "Error: Could not find an image URL in the feed"
    exit 1
fi

if [ ! -d "$SAVE_DIR" ]; then
    echo "Error: Directory $SAVE_DIR does not exist."
    exit 1
fi

# Download image (-f makes HTTP errors count as failures)
if ! curl -sfL "$IMAGE_URL" -o "$IMAGE_FILE"; then
    echo "Error: Failed to download image"
    echo "$IMAGE_URL"
    echo "$IMAGE_FILE"
    exit 1
fi

# Extract just the plain-text caption (e.g. "Comic strip for 2026-10-21"),
# not the full HTML gallery block, so the card doesn't render a second image
TITLE_TEXT=$(echo "$DESCRIPTION" | sed -n 's/.*<p[^>]*>\([^<]*\)<\/p>.*/\1/p')
if [ -z "$TITLE_TEXT" ]; then
    TITLE_TEXT="Calvin and Hobbes"
fi
ALT_TEXT="$TITLE_TEXT"

# Respect the SHOW_TITLE toggle (alt text is always kept for accessibility)
if [ "$SHOW_TITLE" = "false" ]; then
    TITLE_TEXT=""
fi

# Escape backslashes and double quotes so the values embed safely inside JSON
TITLE_JSON=$(printf '%s' "$TITLE_TEXT" | sed 's/\\/\\\\/g; s/"/\\"/g')
ALT_JSON=$(printf '%s' "$ALT_TEXT" | sed 's/\\/\\\\/g; s/"/\\"/g')

# Timestamp of this download; the card uses it to spot a new comic
UPDATED=$(date +%s)

# Create JSON file
cat > "$JSON_FILE" << EOF
{
  "image_url": "$IMAGE_FILE",
  "updated": $UPDATED,
  "title": "$TITLE_JSON",
  "alt_text": "$ALT_JSON"
}
EOF

echo "Image saved to: $IMAGE_FILE"
echo "JSON saved to: $JSON_FILE"
