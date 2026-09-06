#!/bin/sh

# This script takes an existing Quake 4 copy and sort of "Linuxify"s it by applying a Linux patch, along with other things.

# Set default arguments
QUAKE_DIR="$HOME/.local/share/Steam/steamapps/common/Quake 4"
OUTPUT_DIR="$HOME/Games/Quake 4"

# Check parameters to see any objections to some arguments, or other params
while getopts "s:o:" param; do
	case "${param}" in
		s) QUAKE_DIR=$OPTARG;;
		o) OUTPUT_DIR=$OPTARG;;
	esac
done

# Check if curl is installed
which curl 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
	echo "Curl is not installed or can't be found. Please make sure it is installed. Aborting..."
	exit
fi

# Try to run ls on our path, redirect stdout and stderr to null
ls "$QUAKE_DIR" 1>/dev/null 2>/dev/null

if [ $? -ne 0 ]; then
	echo "Path $QUAKE_DIR not found. Aborting..."
	exit
fi

# I don't know where I should store this file, so I will simply host it for now. Please change if changing hosts
ARCHIVE_NAME="quake-4-linux.tar.gz"
ARCHIVE_URL="https://cdn.gurtgames.com/it266/$ARCHIVE_NAME"
ARCHIVE_CHECKSUM="b35f0eb2d3a8581a63b45f84c0dfda52b04c1e2631e5f0cca3e0ff3fdbdf7cd5"

# Curl the tarball, check sha256, abort if fail
curl $ARCHIVE_URL -o $ARCHIVE_NAME
echo "$ARCHIVE_CHECKSUM $ARCHIVE_NAME" | sha256sum -c -
if [ $? -ne 0 ]; then
	echo "Checksums don't match. Aborting..."
	exit
fi

# Create directories, we discard fails if already made
echo "Creating new directory $OUTPUT_DIR..."
mkdir -p $OUTPUT_DIR 2>/dev/null

# Move some original files. Some of these will be overridden
echo "Moving files from $QUAKE_DIR..."
mkdir $OUTPUT_DIR/q4base 2>/dev/null
mkdir $OUTPUT_DIR/q4mp 2>/dev/null
cp "$QUAKE_DIR"/q4base/*.pk4 $OUTPUT_DIR/q4base/ # We don't need -r flag since all files are first level
cp "$QUAKE_DIR"/q4mp/*.pk4 $OUTPUT_DIR/q4mp/

# Check if the key exists and copies it. If not, we skip and simply warn the user on how to get the key file
ls "$QUAKE_DIR"/q4base/quake4key 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
	echo "Key not found... Please run the game somewhere and copy the key to $OUTPUT_DIR/q4base/"
else
	cp -T "$QUAKE_DIR"/q4base/quake4key $OUTPUT_DIR/q4base/quake4key
fi

echo "Extracting tarball..."
# Extract that archive file we got earlier, then remove it
tar -xzf $ARCHIVE_NAME -C $OUTPUT_DIR
rm $ARCHIVE_NAME

echo "Creating desktop file..."
# Create desktop file for easier launch
cat <<EOF > $HOME/.local/share/applications/Quake4.desktop # This is called a heredoc, I think it's neat
[Desktop Entry]

Exec=$OUTPUT_DIR/quake4
Icon=$OUTPUT_DIR/q4icon.png
Name=Quake 4
Comment=Linux version of Quake 4
Path=$OUTPUT_DIR
Terminal=false
Type=Application
EOF

echo "Making binaries executable..."
# Make these executable
chmod +x $OUTPUT_DIR/bin/quake4.x86
chmod +x $OUTPUT_DIR/quake4

echo "Done!"
