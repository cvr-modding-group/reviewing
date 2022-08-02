#!/bin/bash
set -e

BASEDIR="$(dirname "$0")"
CVR_PATH="$HOME/.local/share/Steam/steamapps/common/ChilloutVR"

MOD_URL="$1"
MOD_FILENAME="$(echo "$MOD_URL" | rev | cut -d/ -f1 | rev)"
MOD_VERSION="$(echo "$MOD_URL" | rev | cut -d/ -f2 | rev)"
MOD_ID="$(echo "$MOD_URL" | rev | cut -d/ -f3 | rev)"


MOD_VERSION_FOLDER="$BASEDIR/reviews/$MOD_ID/$MOD_VERSION"
mkdir -p "$MOD_VERSION_FOLDER"
MOD_FILEPATH="$MOD_VERSION_FOLDER/$MOD_FILENAME"

echo "$MOD_FILEPATH"

if [ -f "$MOD_FILEPATH" ]; then
	echo "$FILE_FILENAME exists, skipping download."
else
	curl -L "$MOD_URL" > "$MOD_FILEPATH"
fi

# Comment out the BepInEx lines if not using with compatibility layer.
ilspycmd -d --il-sequence-points -o "$MOD_VERSION_FOLDER" \
-r "$CVR_PATH/" \
-r "$CVR_PATH/ChilloutVR_Data/Managed" \
-r "$CVR_PATH/BepInEx/core" \
-r "$CVR_PATH/MelonLoader/MelonLoader" \
"$MOD_FILEPATH"

ilspycmd -d -p -o "$MOD_VERSION_FOLDER" \
-r "$CVR_PATH/" \
-r "$CVR_PATH/ChilloutVR_Data/Managed" \
-r "$CVR_PATH/BepInEx/core" \
-r "$CVR_PATH/MelonLoader/MelonLoader" \
"$MOD_FILEPATH"

echo "Done, output is at: $MOD_VERSION_FOLDER"
