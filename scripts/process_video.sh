#!/bin/bash

# Script to process App Preview videos, as per: 
# https://developer.apple.com/help/app-store-connect/reference/app-preview-specifications/

process_video() {
    local input_video=$1
    local output_video=$2

    echo "Processing video: $input_video"
    ffmpeg -i "$input_video" \
        -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 \
        -r 30 \
        -vf "scale=1920:1080" \
        -c:v libx264 \
        -profile:v high -level:v 4.0 -b:v 12M -maxrate 12M -bufsize 24M \
        -c:a aac -b:a 256k -ar 44100 -shortest \
        "$output_video"

    echo "Video processed and saved to: $output_video"
}

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 input_video"
    exit 1
fi

input_video=$1

# Generate output filename by appending "AppPreview" before the extension
output_video="${input_video%.*}_AppPreview.${input_video##*.}"

process_video "$input_video" "$output_video"