#!/bin/bash

# Ensure an input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE=$1

# Check if the file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found!"
    exit 1
fi

# Get the directory and base name of the input file
INPUT_DIR=$(dirname "$INPUT_FILE")
BASE_NAME=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')

# Set output file paths in the same directory
PALETTE_FILE="$INPUT_DIR/${BASE_NAME}_palette.png"
OUTPUT_GIF="$INPUT_DIR/${BASE_NAME}.gif"

# Generate palette
echo "Generating palette from $INPUT_FILE..."
ffmpeg -i "$INPUT_FILE" \
  -vf "fps=10,scale=1280:-1:flags=lanczos,palettegen" \
  -frames:v 1 \
  "$PALETTE_FILE"

if [ $? -ne 0 ]; then
    echo "Error: Palette generation failed!"
    exit 1
fi

# Generate GIF using the palette
echo "Creating GIF from $INPUT_FILE using generated palette..."
ffmpeg -i "$INPUT_FILE" \
  -i "$PALETTE_FILE" \
  -filter_complex "fps=10,scale=1280:-1:flags=lanczos,paletteuse" \
  "$OUTPUT_GIF"

if [ $? -ne 0 ]; then
    echo "Error: GIF creation failed!"
    exit 1
fi

# Delete the palette file
echo "Deleting palette file: $PALETTE_FILE"
rm "$PALETTE_FILE"

if [ $? -ne 0 ]; then
    echo "Warning: Failed to delete palette file!"
else
    echo "Palette file deleted successfully."
fi

echo "GIF successfully created: $OUTPUT_GIF"