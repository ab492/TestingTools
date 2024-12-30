#!/bin/bash

# Script to process App Store screenshots, as per:
# https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications

process_screenshot() {
    local input_screenshot=$1
    local output_screenshot=$2

    echo "Processing screenshot: $input_screenshot"
    ffmpeg -i "$input_screenshot" \
        -vf "scale=1280:800:force_original_aspect_ratio=decrease,pad=1280:800:(ow-iw)/2:(oh-ih)/2" \
        "$output_screenshot"

    echo "Screenshot processed and saved to: $output_screenshot"
}

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 input_screenshot"
    exit 1
fi

input_screenshot=$1

# Generate output filename by appending "AppScreenshot" before the extension
output_screenshot="${input_screenshot%.*}_AppScreenshot.${input_screenshot##*.}"

process_screenshot "$input_screenshot" "$output_screenshot"