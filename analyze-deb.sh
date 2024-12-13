#!/bin/bash
# analyze-deb.sh - Script to analyze .deb files for package name and dependencies.

# Ensure script is run with a .deb file as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path-to-deb-file>"
    exit 1
fi

DEB_FILE=$1

# Check if the file exists and has a .deb extension
if [[ ! -f "$DEB_FILE" || "${DEB_FILE##*.}" != "deb" ]]; then
    echo "Error: Please provide a valid .deb file."
    exit 1
fi

# Extract control data from the .deb file
TEMP_DIR=$(mktemp -d)
dpkg-deb -e "$DEB_FILE" "$TEMP_DIR" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error: Failed to extract .deb file metadata."
    exit 1
fi

# Read package name and dependencies from control file
CONTROL_FILE="$TEMP_DIR/control"
if [ ! -f "$CONTROL_FILE" ]; then
    echo "Error: Control file not found in .deb metadata."
    rm -rf "$TEMP_DIR"
    exit 1
fi

PACKAGE_NAME=$(grep '^Package:' "$CONTROL_FILE" | awk '{print $2}')
DEPENDENCIES=$(grep '^Depends:' "$CONTROL_FILE" | sed 's/^Depends: //')

# Display results
echo "Package Name: $PACKAGE_NAME"
echo "Dependencies:"
if [ -n "$DEPENDENCIES" ]; then
    echo "$DEPENDENCIES" | tr ',' '
' | sed 's/^/ - /'
else
    echo " - None"
fi

# Cleanup
rm -rf "$TEMP_DIR"
